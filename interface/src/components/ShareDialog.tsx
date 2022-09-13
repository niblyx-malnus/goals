import React, { useEffect, useState } from "react";

import Button from "@mui/material/Button";
import TextField from "@mui/material/TextField";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogContentText from "@mui/material/DialogContentText";
import DialogTitle from "@mui/material/DialogTitle";
import Autocomplete from "@mui/material/Autocomplete";
import Stack from "@mui/material/Stack";
import { log } from "../helpers";
import Chips from "./Chips";
import InputLabel from "@mui/material/InputLabel";
import MenuItem from "@mui/material/MenuItem";
import FormControl from "@mui/material/FormControl";
import Typography from "@mui/material/Typography";
import IconButton from "@mui/material/IconButton";
import AddIcon from "@mui/icons-material/Add";
import LoadingButton from "@mui/lab/LoadingButton";

import Select, { SelectChangeEvent } from "@mui/material/Select";
import useStore from "../store";
import api from "../api";
interface ChipData {
  key: number;
  label: string;
  canDelete: boolean;
}
const ob = require("urbit-ob");
export default function ShareDialog({ pals }: { pals: any }) {
  const [inputValue, setInputValue] = useState<string>("~");
  const [role, setRole] = useState("Viewer");
  const open = useStore((store: any) => store.shareDialogOpen);
  const toggleShareDialog = useStore((store: any) => store.toggleShareDialog);
  const shareDialogData = useStore((store: any) => store.shareDialogData);

  const onClose = () => {
    toggleShareDialog(false, null);
  };
  const handleRoleChange = (event: SelectChangeEvent) => {
    setRole(event.target.value as string);
  };
  const [pathError, setPathError] = useState<boolean>(false);
  const [pathErrorMessage, setPathErrorMessage] = useState<string>("");
  const [viewerList, setViewerList] = useState<ChipData[]>([]);
  const [captainList, setCaptainList] = useState<ChipData[]>([]);
  const [adminList, setAdminList] = useState<ChipData[]>([]);
  const [trying, setTrying] = useState<boolean>(false);
  const handleDeleteViewer = (chipToDelete: ChipData) => {
    if (trying) return;

    setViewerList((chips) =>
      chips.filter((chip) => chip.label !== chipToDelete.label)
    );
  };
  const handleDeleteCaptain = (chipToDelete: ChipData) => {
    if (trying) return;

    setCaptainList((chips) =>
      chips.filter((chip) => chip.label !== chipToDelete.label)
    );
    //delete corrospoding ship in viewerList
    handleDeleteViewer(chipToDelete);
  };
  const handleDeleteAdmin = (chipToDelete: ChipData) => {
    if (trying) return;

    setAdminList((chips) =>
      chips.filter((chip) => chip.label !== chipToDelete.label)
    );
    //delete corrospoding ship in viewerList
    handleDeleteViewer(chipToDelete);
  };

  const handleAdd = () => {
    if (trying) return;
    //make sure the entered p is for real for real
    try {
      validateShipName();
    } catch (e) {
      log("e", e);
      return;
    }
    //we remove white space around the text
    let label = inputValue.trim();
    //we remove the ~
    label = label.substring(1);
    //if no text, we abort
    if (label.length === 0) return;
    const checkForShip = (obj: any) => obj.label === label;

    if (role === "Viewer") {
      const viewerExists = viewerList.some(checkForShip);

      if (viewerExists) {
        setPathErrorMessage("This viewer already exists");
        setPathError(true);
        return;
      }
      const newViewerList = [
        ...viewerList,
        { key: viewerList.length + 1, label, canDelete: true },
      ];
      setViewerList(newViewerList);
    } else if (role === "Captain") {
      const capExists = captainList.some(checkForShip);
      const adminExists = adminList.some(checkForShip);

      if (capExists) {
        setPathErrorMessage("This captain already exists");
        setPathError(true);
        return;
      }
      if (adminExists) {
        setPathErrorMessage("This ship is an admin");
        setPathError(true);
        return;
      }
      const newCaptainList = [
        ...captainList,
        { key: captainList.length + 1, label, canDelete: true },
      ];
      setCaptainList(newCaptainList);
      //if a cap  is added, we'll also add it the viewerList list
      const viewerExists = viewerList.some(checkForShip);
      let newViewerList;
      if (viewerExists) {
        newViewerList = viewerList.map((item: any) => {
          if (item.label === label) {
            return { ...item, canDelete: false };
          }
          return item;
        });
      } else {
        newViewerList = [
          ...viewerList,
          { key: viewerList.length + 1, label, canDelete: false },
        ];
      }
      setViewerList(newViewerList);
    } else {
      const capExists = captainList.some(checkForShip);
      const adminExists = adminList.some(checkForShip);

      if (capExists) {
        setPathErrorMessage("This captain already exists");
        setPathError(true);
        return;
      }
      if (adminExists) {
        setPathErrorMessage("This ship is an admin");
        setPathError(true);
        return;
      }
      const newAdminList = [
        ...adminList,
        { key: adminList.length + 1, label, canDelete: true },
      ];
      setAdminList(newAdminList);

      const viewerExists = viewerList.some(checkForShip);
      let newViewerList;
      if (viewerExists) {
        newViewerList = viewerList.map((item: any) => {
          if (item.label === label) {
            return { ...item, canDelete: false };
          }
          return item;
        });
      } else {
        newViewerList = [
          ...viewerList,
          { key: viewerList.length + 1, label, canDelete: false },
        ];
      }
      setViewerList(newViewerList);
    }
    setInputValue("~");
  };
  const keyHandler = (event: any) => {
    if (event.keyCode === 13) {
      handleAdd();
    }
  };
  const handleClose = () => {
    onClose();
  };
  const validateShipName = () => {
    try {
      const isValid = ob.isValidPatp(inputValue);

      if (!isValid) {
        setPathErrorMessage("Make sure the ship you entered exists");
        setPathError(true);
        throw Error("ship name not valid");
      }
      setPathErrorMessage("");
      setPathError(false);
      //it's valid, go ahead and try to share this
    } catch (e) {
      throw Error("ship name not valid");
    }
  };
  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setInputValue(event.target.value);
  };
  const chipsGroup = (title: string, data: ChipData[], onDelete: Function) => {
    if (data.length === 0) return;
    return (
      <Stack flexDirection={"column"} marginTop={1}>
        <Typography variant="subtitle2" fontWeight={"bold"}>
          {title}
        </Typography>
        <Chips chipData={data} canDelete={true} onDelete={onDelete} />
      </Stack>
    );
  };
  const updatePoolPerms = async () => {
    setTrying(true);
    try {
      //convert chips to a data list
      const viewers = viewerList.map((item) => item.label);
      const captains = captainList.map((item) => item.label);
      const admins = adminList.map((item) => item.label);
      const result = await api.updatePoolPermissions(
        shareDialogData.pin,
        viewers,
        captains,
        admins
      );
      log("updatePoolPerms result =>", result);
    } catch (e) {
      log("updatePoolPerms error =>", e);
    }
    setTrying(false);
  };
  useEffect(() => {
    if (!shareDialogData) return;
    //construct our chips from the permlist, everytime we display this
    const permList = shareDialogData.permList; //TODO: handle not having this?
    let viewerChips = permList.viewers.map((item: any, index: any) => {
      return { key: index, label: item, canDelete: true };
    });
    const captainChips = permList.captains.map((item: any, index: any) => {
      return { key: index, label: item, canDelete: true };
    });
    const adminChips = permList.admins.map((item: any, index: any) => {
      return { key: index, label: item, canDelete: true };
    });
    //create links beetween caps/admins and viewers
    viewerChips = viewerChips.map((item: any) => {
      if (
        permList.captains.includes(item.label) ||
        permList.admins.includes(item.label)
      ) {
        return { ...item, canDelete: false };
      }
      return item;
    });
    setViewerList(viewerChips);
    setCaptainList(captainChips);
    setAdminList(adminChips);
  }, [open, shareDialogData]);
  //if we dont have data we dont render
  if (!shareDialogData) return null;

  return (
    <Dialog
      open={open}
      onClose={handleClose}
      onClick={(event) => event.stopPropagation()}
      maxWidth={"sm"}
      fullWidth
    >
      <DialogTitle fontWeight={"bold"}>
        Manage Participants ({shareDialogData.title})
      </DialogTitle>
      <DialogContent>
        <DialogContentText sx={{ color: "text.primary" }}>
          Enter the ship and assign it a role
        </DialogContentText>
        <Stack flexDirection="row" alignItems="center" justifyContent="center">
          <Autocomplete
            sx={{ flex: 1, marginTop: 1, marginBottom: 1 }}
            freeSolo
            id="pals-autocomplete"
            disableClearable
            options={pals}
            value={inputValue}
            onChange={(event, value) => {
              //we handle this a little different from a standard input
              setInputValue(value);
            }}
            renderInput={(params) => (
              <TextField
                {...params}
                sx={{
                  "& .MuiFormHelperText-root": {
                    position: "absolute",
                    bottom: "-1.2rem",
                  },
                }}
                spellCheck="false"
                error={pathError}
                helperText={pathErrorMessage}
                size="small"
                id="name"
                label="@p"
                type="text"
                value={inputValue}
                onChange={handleChange}
                autoFocus
                fullWidth
                onKeyUp={keyHandler}
              />
            )}
          />
          <FormControl sx={{ width: 110 }}>
            <InputLabel id="demo-simple-select-label">Role</InputLabel>
            <Select
              size="small"
              labelId="demo-simple-select-label"
              id="demo-simple-select"
              value={role}
              label="Role"
              onChange={handleRoleChange}
            >
              <MenuItem value={"Viewer"}>Viewer</MenuItem>
              <MenuItem value={"Captain"}>Captain</MenuItem>
              <MenuItem value={"Admin"}>Admin</MenuItem>
            </Select>
          </FormControl>
          <IconButton
            aria-label="add ship to pool"
            size="small"
            onClick={handleAdd}
            disabled={trying}
          >
            <AddIcon />
          </IconButton>
        </Stack>
        {chipsGroup("Admins", adminList, handleDeleteAdmin)}
        {chipsGroup("Captains", captainList, handleDeleteCaptain)}
        {chipsGroup("Viewers", viewerList, handleDeleteViewer)}
      </DialogContent>
      <DialogActions>
        <Button
          disabled={trying}
          sx={{ color: "text.primary" }}
          onClick={handleClose}
        >
          Cancel
        </Button>
        <LoadingButton
          variant="contained"
          loading={trying}
          onClick={updatePoolPerms}
        >
          Save
        </LoadingButton>
      </DialogActions>
    </Dialog>
  );
}
