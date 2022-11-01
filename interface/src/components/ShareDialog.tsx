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
  key: string;
  label: string;
  canDelete: boolean;
}
const ChipsGroup = ({
  title,
  data,
  onDelete,
}: {
  title: string;
  data: ChipData[];
  onDelete: Function;
}) => {
  if (data.length === 0) return null;
  return (
    <Stack flexDirection={"column"} marginTop={1}>
      <Typography variant="subtitle2" fontWeight={"bold"}>
        {title}
      </Typography>
      <Chips
        keyRole={title}
        chipData={data}
        canDelete={true}
        onDelete={onDelete}
      />
    </Stack>
  );
};
const ShareDialogInputs = ({
  handleAdd,
  canEditAdmins,
  trying,
}: {
  handleAdd: Function;
  canEditAdmins: boolean;
  trying: boolean;
}) => {
  const pals = useStore((store) => store.pals);
  const [inputValue, setInputValue] = useState<string>("~");
  const [role, setRole] = useState("Viewer");
  const [pathErrorMessage, setPathErrorMessage] = useState<string>("");
  const [pathError, setPathError] = useState<boolean>(false);
  const handleRoleChange = (event: SelectChangeEvent) => {
    setRole(event.target.value as string);
  };
  const keyHandler = (event: any) => {
    if (event.keyCode === 13) {
      onAdd();
    }
  };
  const validateShipName = (value: string) => {
    try {
      const isValid = ob.isValidPatp(value);

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
  const onAdd = () => {
    handleAdd(
      inputValue,
      setInputValue,
      role,
      setPathError,
      setPathErrorMessage,
      validateShipName
    );
  };
  return (
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
          log("value====>", value);
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
            autoFocus
            fullWidth
            onKeyUp={keyHandler}
          />
        )}
      />
      <FormControl sx={{ width: 110 }}>
        <InputLabel id="role-select-label">Role</InputLabel>
        <Select
          size="small"
          labelId="role-select-label"
          id="role-select"
          value={role}
          label="Role"
          onChange={handleRoleChange}
        >
          <MenuItem value={"Viewer"}>Viewer</MenuItem>
          <MenuItem value={"Captain"}>Captain</MenuItem>
          {canEditAdmins && <MenuItem value={"Admin"}>Admin</MenuItem>}
        </Select>
      </FormControl>
      <IconButton
        aria-label="add ship to pool"
        size="small"
        onClick={onAdd}
        disabled={trying}
      >
        <AddIcon />
      </IconButton>
    </Stack>
  );
};
const ob = require("urbit-ob");
export default function ShareDialog() {
  const open = useStore((store: any) => store.shareDialogOpen);
  const toggleShareDialog = useStore((store: any) => store.toggleShareDialog);
  const shareDialogData = useStore((store: any) => store.shareDialogData);
  const toggleSnackBar = useStore((store) => store.toggleSnackBar);
  const roleMap = useStore((store: any) => store.roleMap);

  const [viewerList, setViewerList] = useState<ChipData[]>([]);
  const [captainList, setCaptainList] = useState<ChipData[]>([]);
  const [adminList, setAdminList] = useState<ChipData[]>([]);
  const [trying, setTrying] = useState<boolean>(false);
  const [canEditAdmins, setCanEditAdmins] = useState<boolean>(true);

  const onClose = () => {
    toggleShareDialog(false, null);
    //reset our lists
    setViewerList([]);
    setCaptainList([]);
    setAdminList([]);
  };
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
  };
  const handleDeleteAdmin = (chipToDelete: ChipData) => {
    if (trying) return;

    setAdminList((chips) =>
      chips.filter((chip) => chip.label !== chipToDelete.label)
    );
  };

  const handleAdd = (
    inputValue: any,
    setInputValue: any,
    role: any,
    setPathError: any,
    setPathErrorMessage: any,
    validateShipName: Function
  ) => {
    if (trying) return;
    //validate @p
    //TODO: fix getting input value on enter new text
    try {
      validateShipName(inputValue);
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
      const capExists = captainList.some(checkForShip);
      const adminExists = adminList.some(checkForShip);

      if (capExists) {
        setPathErrorMessage("This ship is a captain");
        setPathError(true);
        return;
      }
      if (adminExists) {
        setPathErrorMessage("This ship is an admin");
        setPathError(true);
        return;
      }
      if (viewerExists) {
        setPathErrorMessage("This viewer already exists");
        setPathError(true);
        return;
      }
      const newViewerList = [
        ...viewerList,
        { key: "viewer-" + viewerList.length + 1, label, canDelete: true },
      ];
      log("newViewerList", newViewerList);
      setViewerList(newViewerList);
    } else if (role === "Captain") {
      const capExists = captainList.some(checkForShip);
      const adminExists = adminList.some(checkForShip);
      const viewerExists = viewerList.some(checkForShip);

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
      if (viewerExists) {
        setPathErrorMessage("This ship is a viewer");
        setPathError(true);
        return;
      }
      const newCaptainList = [
        ...captainList,
        { key: "captain-" + captainList.length + 1, label, canDelete: true },
      ];
      setCaptainList(newCaptainList);
    } else {
      const capExists = captainList.some(checkForShip);
      const adminExists = adminList.some(checkForShip);
      const viewerExists = viewerList.some(checkForShip);
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
      if (viewerExists) {
        setPathErrorMessage("This ship is a viewer");
        setPathError(true);
        return;
      }
      const newAdminList = [
        ...adminList,
        { key: "admin-" + adminList.length + 1, label, canDelete: true },
      ];
      setAdminList(newAdminList);
    }
    setInputValue("~");
  };

  const handleClose = () => {
    onClose();
  };

  const updatePoolPerms = async () => {
    setTrying(true);
    try {
      const newRoleList: any = [];
      //create our new role list to send
      adminList.forEach((item) => {
        newRoleList.push({ role: "admin", ship: item.label });
      });
      captainList.forEach((item) => {
        newRoleList.push({ role: "spawn", ship: item.label });
      });
      viewerList.forEach((item) => {
        newRoleList.push({ role: null, ship: item.label });
      });
      const result = await api.updatePoolPermissions(
        shareDialogData.pin,
        newRoleList
      );
      toggleSnackBar(true, {
        message: "successfully updated pool permissions",
        severity: "success",
      });
      handleClose();
      log("updatePoolPerms result =>", result);
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to update pool permissions",
        severity: "error",
      });
      log("updatePoolPerms error =>", e);
    }
    setTrying(false);
  };
  useEffect(() => {
    if (!shareDialogData) return;

    let adminList: string[] = [];
    let captainList: string[] = [];
    let viewerList: string[] = [];
    //contains at least the owner ship, we ignore it
    //we break down the map of role to ship into it's own list of ships
    shareDialogData.permList.forEach((perm: any) => {
      if (perm.role === "admin") {
        adminList.push(perm.ship);
      } else if (perm.role === "captain") {
        captainList.push(perm.ship);
      } else if (perm.role === null) {
        viewerList.push(perm.ship);
      }
    });
    //get the current role related to this ship
    const myRole = roleMap.get(shareDialogData.pin.birth);
    const canEditAdmins = myRole !== "admin";
    //construct our chips from the permlist
    const viewerChips = viewerList.map((item: any, index: any) => {
      return { key: "viewer-" + index, label: item, canDelete: true };
    });
    const captainChips = captainList.map((item: any, index: any) => {
      return { key: "captain-" + index, label: item, canDelete: true };
    });
    const adminChips = adminList.map((item: any, index: any) => {
      return { key: "admin-" + index, label: item, canDelete: canEditAdmins };
    });
    setViewerList(viewerChips);
    setCaptainList(captainChips);
    setAdminList(adminChips);
    setCanEditAdmins(canEditAdmins);
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
        <ShareDialogInputs
          handleAdd={handleAdd}
          canEditAdmins={canEditAdmins}
          trying={trying}
        />
        <ChipsGroup
          title={"Admins"}
          data={adminList}
          onDelete={handleDeleteAdmin}
        />
        <ChipsGroup
          title={"Captains"}
          data={captainList}
          onDelete={handleDeleteCaptain}
        />
        <ChipsGroup
          title={"Viewers"}
          data={viewerList}
          onDelete={handleDeleteViewer}
        />
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
