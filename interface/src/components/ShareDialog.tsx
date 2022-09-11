import React, { useState } from "react";

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

import Select, { SelectChangeEvent } from "@mui/material/Select";
import { chipClasses } from "@mui/material";
import useStore from "../store";
interface ChipData {
  key: number;
  label: string;
}
const ob = require("urbit-ob");
export default function ShareDialog({ pals }: { pals: any }) {
  const [inputValue, setInputValue] = useState<string>("~");
  const [role, setRole] = useState("Viewer");
  const open = useStore((store: any) => store.shareDialogOpen);
  const toggleShareDialog = useStore((store: any) => store.toggleShareDialog);
  const onConfirm = () => null;
  const onClose = () => {
    toggleShareDialog(false);
  };
  const handleRoleChange = (event: SelectChangeEvent) => {
    setRole(event.target.value as string);
  };
  const [pathError, setPathError] = useState<boolean>(false);
  const [pathErrorMessage, setPathErrorMessage] = useState<string>("");
  const [chipData, setChipData] = useState<readonly ChipData[]>([]);
  const [viewerList, setViewerList] = useState<ChipData[]>([]);
  const [captainList, setCaptainList] = useState<ChipData[]>([]);
  const [adminList, setAdminList] = useState<ChipData[]>([]);
  const handleDeleteViewer = (chipToDelete: ChipData) => {
    setViewerList((chips) =>
      chips.filter((chip) => chip.key !== chipToDelete.key)
    );
  };
  const handleDeleteCaptain = (chipToDelete: ChipData) => {
    setCaptainList((chips) =>
      chips.filter((chip) => chip.key !== chipToDelete.key)
    );
  };
  const handleDeleteAdmin = (chipToDelete: ChipData) => {
    setAdminList((chips) =>
      chips.filter((chip) => chip.key !== chipToDelete.key)
    );
  };

  const handleAdd = () => {
    //make sure the entered p is for real for real
    try {
      validateShipName();
    } catch (e) {
      log("e", e);
      return;
    }
    //we remove white space around the text
    const label = inputValue.trim();
    //if no text, we abort
    if (label.length === 0) return;

    if (role === "Viewer") {
      const newChipData = [
        ...viewerList,
        { key: viewerList.length + 1, label },
      ];
      setViewerList(newChipData);
    } else if (role === "Captain") {
      const newChipData = [
        ...captainList,
        { key: captainList.length + 1, label },
      ];
      setCaptainList(newChipData);
    } else {
      const newChipData = [...adminList, { key: adminList.length + 1, label }];
      setAdminList(newChipData);
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
      log("isValid", isValid);
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
      <Stack
        flexDirection={"column"}
        marginTop={1}
      >
        <Typography variant="subtitle2" fontWeight={"bold"}>
          {title}{" "}
        </Typography>
        <Chips chipData={data} canDelete={true} onDelete={onDelete} />
      </Stack>
    );
  };
  return (
    <Dialog
      open={open}
      onClose={handleClose}
      onClick={(event) => event.stopPropagation()}
      maxWidth={"sm"}
      fullWidth
    >
      <DialogTitle>Manage Participants (x pool)</DialogTitle>
      <DialogContent>
        <DialogContentText>
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
          >
            <AddIcon />
          </IconButton>
        </Stack>
        {chipsGroup("Admins", adminList, handleDeleteAdmin)}
        {chipsGroup("Captains", captainList, handleDeleteCaptain)}
        {chipsGroup("Viewers", viewerList, handleDeleteViewer)}
      </DialogContent>
      <DialogActions>
        <Button sx={{ color: "text.primary" }} onClick={handleClose}>
          Cancel
        </Button>
        <Button
          variant="contained"
          //disabled={!inputValue}
          onClick={handleClose}
        >
          Save
        </Button>
      </DialogActions>
    </Dialog>
  );
}
