import React from "react";
import Button from "@mui/material/Button";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogContentText from "@mui/material/DialogContentText";
import DialogTitle from "@mui/material/DialogTitle";
import useStore from "../store";

export default function DeletionDialog() {
  const open = useStore((store: any) => store.deleteDialogOpen);
  const deleteDialogData = useStore((store: any) => store.deleteDialogData);
  const toggleDeleteDialog = useStore((store: any) => store.toggleDeleteDialog);

  const handleClose = () => {
    toggleDeleteDialog(false, null);
  };
  const handleConfirm = () => {
    handleClose();
    deleteDialogData.callback();
  };
  if (!deleteDialogData) return null;
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
        Delete Pool ({deleteDialogData.title})
      </DialogTitle>
      <DialogContent>
        <DialogContentText
          id="alert-dialog-description"
          sx={{ color: "text.primary" }}
        >
          Are you sure you want to delete this pool? as this action is
          irreversible
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        <Button sx={{ color: "text.primary" }} onClick={handleClose}>
          cancel
        </Button>
        <Button variant="contained" color="error" onClick={handleConfirm}>
          delete
        </Button>
      </DialogActions>
    </Dialog>
  );
}
