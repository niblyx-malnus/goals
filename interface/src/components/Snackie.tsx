import React from "react";
import Stack from "@mui/material/Stack";
import Snackbar from "@mui/material/Snackbar";
import MuiAlert, { AlertProps } from "@mui/material/Alert";
import useStore from "../store";

const Alert = React.forwardRef<HTMLDivElement, AlertProps>(function Alert(
  props,
  ref
) {
  return <MuiAlert elevation={6} ref={ref} variant="filled" {...props} />;
});

export default function Snackie() {
  const toggleSnackBar = useStore((store: any) => store.toggleSnackBar);
  const snackBarData = useStore((store: any) => store.snackBarData);
  const open = useStore((store: any) => store.snackBarOpen);

  const handleClose = (
    event?: React.SyntheticEvent | Event,
    reason?: string
  ) => {
    if (reason === "clickaway") {
      return;
    }

    toggleSnackBar(false, null);
  };
  if (!snackBarData) return null;
  return (
    <Stack spacing={2} sx={{ width: "100%" }}>
      <Snackbar open={open} autoHideDuration={2000} onClose={handleClose}>
        <Alert
          onClose={handleClose}
          severity={snackBarData.severity}
          sx={{ width: "100%" }}
        >
          {snackBarData.message}
        </Alert>
      </Snackbar>

    </Stack>
  );
}
