import React from "react";
import Button from "@mui/material/Button";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogContentText from "@mui/material/DialogContentText";
import DialogTitle from "@mui/material/DialogTitle";
import useStore from "../store";

export default function LeaveDialog() {
  const open = useStore((store: any) => store.leaveDialogOpen);
  const leaveDialogData = useStore((store: any) => store.leaveDialogData);
  const toggleLeaveDialog = useStore((store: any) => store.toggleLeaveDialog);

  const handleClose = () => {
    toggleLeaveDialog(false, null);
  };
  const handleConfirm = () => {
    handleClose();
    leaveDialogData.callback();
  };
  if (!leaveDialogData) return null;
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
        Leave Pool ({leaveDialogData.title})
      </DialogTitle>
      <DialogContent>
        <DialogContentText
          id="alert-dialog-description"
          sx={{ color: "text.primary" }}
        >
          Are you sure you want to leave this pool? as this action is
          irreversible
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        <Button sx={{ color: "text.primary" }} onClick={handleClose}>
          cancel
        </Button>
        <Button variant="contained" color="error" onClick={handleConfirm}>
          leave
        </Button>
      </DialogActions>
    </Dialog>
  );
}
