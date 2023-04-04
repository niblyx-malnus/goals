import React from "react";
import Button from "@mui/material/Button";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogContentText from "@mui/material/DialogContentText";
import DialogTitle from "@mui/material/DialogTitle";
import useStore from "../store";

export default function ArchiveDialog() {
  const open = useStore((store: any) => store.archiveDialogOpen);
  const archiveDialogData = useStore((store: any) => store.archiveDialogData);
  const toggleArchiveDialog = useStore(
    (store: any) => store.toggleArchiveDialog
  );

  const handleClose = () => {
    toggleArchiveDialog(false, null);
  };
  const handleConfirm = () => {
    handleClose();
    archiveDialogData.callback();
  };
  if (!archiveDialogData) return null;
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
        Archive Pool ({archiveDialogData.title})
      </DialogTitle>
      <DialogContent>
        <DialogContentText
          id="alert-dialog-description"
          sx={{ color: "text.primary" }}
        >
          This is not permanent. You can restore this pool from archives
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        <Button sx={{ color: "text.primary" }} onClick={handleClose}>
          cancel
        </Button>
        <Button variant="contained" color="warning" onClick={handleConfirm}>
          archive
        </Button>
      </DialogActions>
    </Dialog>
  );
}

