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

export default function CopyPoolDialog() {
  const [inputValue, setInputValue] = useState<string>("~");

  const open = useStore((store: any) => store.copyPoolDialogOpen);
  const copyPoolDialogData = useStore((store: any) => store.copyPoolDialogData);
  const toggleCopyPoolDialog = useStore(
    (store: any) => store.toggleCopyPoolDialog
  );
  const toggleSnackBar = useStore((store) => store.toggleSnackBar);

  const handleClose = () => {
    toggleCopyPoolDialog(false, null);
  };

  const handleConfirm = () => {
    handleClose();
    copyPool();
  };
  const copyPool = async () => {
    try {
      const result = await api.copyPool(copyPoolDialogData.pin, inputValue);
      log("copyPool result => ", result);
      toggleSnackBar(true, {
        message: "successfuly copied pool",
        severity: "success",
      });
    } catch (e) {
      log("copyPool error => ", e);
      toggleSnackBar(true, {
        message: "failed to copy pool",
        severity: "error",
      });
    }
  };
  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setInputValue(event.target.value);
  };
  useEffect(() => {
    if (copyPoolDialogData && copyPoolDialogData.title) {
      setInputValue(copyPoolDialogData.title);
    }
  }, [copyPoolDialogData]);
  if (!copyPoolDialogData) return null;
  return (
    <Dialog
      open={open}
      onClose={handleClose}
      aria-labelledby="alert-dialog-title"
      aria-describedby="alert-dialog-description"
      maxWidth={"sm"}
      fullWidth
    >
      <DialogTitle id="alert-dialog-title" fontWeight={"bold"}>
        Copy Pool ({copyPoolDialogData.title})
      </DialogTitle>
      <DialogContent>
        <TextField
          sx={{ marginTop: 1 }}
          spellCheck="true"
          error={false}
          size="small"
          id="name"
          label="New Title"
          type="text"
          value={inputValue}
          onChange={handleChange}
          autoFocus
          fullWidth
        />
      </DialogContent>
      <DialogActions>
        <Button sx={{ color: "text.primary" }} onClick={handleClose}>
          cancel
        </Button>
        <Button
          variant="contained"
          disabled={inputValue.length === 0}
          onClick={handleConfirm}
        >
          copy
        </Button>
      </DialogActions>
    </Dialog>
  );
}
