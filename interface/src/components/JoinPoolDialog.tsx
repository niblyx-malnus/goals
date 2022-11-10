import React, { useEffect, useState } from "react";
import Button from "@mui/material/Button";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogContentText from "@mui/material/DialogContentText";
import DialogTitle from "@mui/material/DialogTitle";
import TextField from "@mui/material/TextField";
import useStore from "../store";
import api from "../api";
import { log } from "../helpers";
import LoadingButton from "@mui/lab/LoadingButton";

export default function JoinPoolDialog() {
  const [inputValue, setInputValue] = useState<string>("");
  const [trying, setTrying] = useState<boolean>(false);
  const [pathErrorMessage, setPathErrorMessage] = useState<string>("");
  const [pathError, setPathError] = useState<boolean>(false);

  const open = useStore((store: any) => store.joinPoolDialogOpen);
  const toggleJoinPoolDialogOpen = useStore(
    (store: any) => store.toggleJoinPoolDialogOpen
  );

  const toggleSnackBar = useStore((store) => store.toggleSnackBar);

  const handleClose = () => {
    setInputValue("");
    toggleJoinPoolDialogOpen(false);
  };

  const handleConfirm = () => {
    joinPool();
  };
  const joinPool = async () => {
    setTrying(true);
    setPathErrorMessage("");
    setPathError(false);
    //extract the pin
    const splitInput = inputValue.split("/");
    const owner = splitInput[1];
    const birth = splitInput[2];
    //display an error if we don't have either owner or birth
    if (!owner || !birth) {
      setPathErrorMessage("Make sure you entered a valid link");
      setPathError(true);
    } else {
      try {
        const pin = { owner, birth };

        const result = await api.subscribePool(pin);
        log("joinPool result => ", result);
        toggleSnackBar(true, {
          message: "successfuly joined pool",
          severity: "success",
        });
        handleClose();
      } catch (e) {
        log("joinPool error => ", e);
        toggleSnackBar(true, {
          message: "failed to join pool",
          severity: "error",
        });
      }
    }
    setTrying(false);
  };
  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setInputValue(event.target.value);
  };

  return (
    <Dialog
      open={open}
      onClose={handleClose}
      aria-labelledby="join-pool-dialog-title"
      aria-describedby="join-pool-dialog-description"
      maxWidth={"sm"}
      fullWidth
    >
      <DialogTitle id="join-pool-dialog-title" fontWeight={"bold"}>
        Join a pool
      </DialogTitle>
      <DialogContent>
        <DialogContentText sx={{ color: "text.primary" }}>
          Enter the link to the pool
        </DialogContentText>
        <TextField
          sx={{ marginTop: 1 }}
          spellCheck="false"
          size="small"
          id="name"
          label="Link"
          placeholder="/~zod/~2000.1.1"
          type="text"
          value={inputValue}
          onChange={handleChange}
          autoFocus
          fullWidth
          error={pathError}
          helperText={pathErrorMessage}
        />
      </DialogContent>
      <DialogActions>
        <Button sx={{ color: "text.primary" }} onClick={handleClose}>
          cancel
        </Button>
        <LoadingButton
          variant="contained"
          disabled={inputValue.length === 0}
          onClick={handleConfirm}
          loading={trying}
        >
          join
        </LoadingButton>
      </DialogActions>
    </Dialog>
  );
}
