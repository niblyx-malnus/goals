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
import Select, { SelectChangeEvent } from "@mui/material/Select";
interface ChipData {
  key: number;
  label: string;
}
const ob = require("urbit-ob");
export default function ShareDialog({
  open,
  onConfirm,
  onClose,
  pals,
}: {
  open: boolean;
  onConfirm: Function;
  onClose: Function;
  pals: any;
}) {
  const [inputValue, setInputValue] = useState<string>("~");
  const [role, setRole] = useState("Viewers");

  const handleRoleChange = (event: SelectChangeEvent) => {
    console.log("event.target.value", event.target.value);
    setRole(event.target.value as string);
  };
  const [pathError, setPathError] = useState<boolean>(false);
  const [pathErrorMessage, setPathErrorMessage] = useState<string>("");
  const [chipData, setChipData] = useState<readonly ChipData[]>([]);
  const [viewerList, setViewerList] = useState<ChipData[]>([]);
  const [captainList, setCaptainList] = useState<ChipData[]>([]);
  const [adminList, setAdminList] = useState<ChipData[]>([]);
  const handleDelete = (chipToDelete: ChipData) => {
    setChipData((chips) =>
      chips.filter((chip) => chip.key !== chipToDelete.key)
    );
  };
  const handleTagsUpdate = () => {
    //transform chipData (key/label array) into tags (array of strings)
    const newTags = chipData.map((item) => item.label);

    onConfirm(newTags);
  };
  const handleAdd = () => {
    //we remove white space around the text
    const label = inputValue.trim();
    //if no text, we abort
    if (label.length === 0) return;
    const newChipData = [
      ...chipData,
      { key: chipData.length + 1, label, role },
    ];
    log("newChipData", newChipData);
    if (role === "Viewer") {
    } else if (role === "Captain") {
    } else {
    }
    setChipData(newChipData);
    setInputValue("");
    setRole("Viewer");
  };
  const keyHandler = (event: any) => {
    if (event.keyCode === 13) {
      handleAdd();
    }
  };
  const handleClose = () => {
    onClose();
  };
  const handleShare = () => {
    try {
      const isValid = ob.isValidPatp(inputValue);
      /*if (isValid) {
        //TODO: eventually restrict moons?
        const clan = ob.clan(inputValue);
        console.log("clan", clan);
      }*/
      if (!isValid) {
        setPathErrorMessage("Make sure the ship you entered exists");
        setPathError(true);
        return;
      }
      setPathErrorMessage("");
      setPathError(false);
      //it's valid, go ahead and try to share this
    } catch (e) {
      console.log("e", e);
    }

    onConfirm(inputValue);
  };
  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setInputValue(event.target.value);
  };
  return (
    <Dialog
      open={open}
      onClose={handleClose}
      onClick={(event) => event.stopPropagation()}
      maxWidth={"sm"}
      fullWidth
    >
      <DialogTitle>Share</DialogTitle>
      <DialogContent>
        <DialogContentText>
          Enter the ship name you wish to send this sheet to
        </DialogContentText>
        <Stack flexDirection="row" alignItems="center" justifyContent="center">
          <Autocomplete
            sx={{ flex: 1 }}
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
                spellCheck="false"
                error={pathError}
                helperText={pathErrorMessage}
                margin="dense"
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
          <FormControl sx={{ width: 100 }}>
            <InputLabel id="demo-simple-select-label">Role</InputLabel>
            <Select
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
        </Stack>
        <Stack flexDirection={"row"}>
          <Typography>Viewers: </Typography>
          <Chips
            chipData={chipData}
            canDelete={true}
            onDelete={(data:any) => {
              handleDelete(data);
            }}
          />
        </Stack>
      
      </DialogContent>
      <DialogActions>
        <Button onClick={handleClose}>Cancel</Button>
        <Button disabled={!inputValue} onClick={handleShare}>
          Share
        </Button>
      </DialogActions>
    </Dialog>
  );
}
