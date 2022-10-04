import React from "react";
import Button from "@mui/material/Button";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogContentText from "@mui/material/DialogContentText";
import DialogTitle from "@mui/material/DialogTitle";
import Stack from "@mui/material/Stack";
import useStore from "../store";
import { AdapterMoment } from "@mui/x-date-pickers/AdapterMoment";
import TextField from "@mui/material/TextField";
import IconButton from "@mui/material/IconButton";
import ClearIcon from "@mui/icons-material/Clear";
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";
import { DesktopDatePicker } from "@mui/x-date-pickers/DesktopDatePicker";
import { MobileDatePicker } from "@mui/x-date-pickers/MobileDatePicker";
import dayjs, { Dayjs } from "dayjs";
//TODO: get the mobile picker working https://mui.com/x/react-date-pickers/getting-started/
//TODO: update all the aria here and elsewhere

export default function TimelineDialog() {
  const open = useStore((store: any) => store.timelineDialogOpen);

  const toggleTimelineDialog = useStore(
    (store: any) => store.toggleTimelineDialog
  );

  const [kickoffValue, setKickoffValue] = React.useState<Dayjs | null>(null);
  const [deadlineValue, setDeadlineValue] = React.useState<Dayjs | null>(null);

  const handleKickoffChange = (newValue: Dayjs | null) => {
    setKickoffValue(newValue);
  };
  const handleDeadlineChange = (newValue: Dayjs | null) => {
    setDeadlineValue(newValue);
  };

  const handleClose = () => {
    toggleTimelineDialog(false);
  };
  const handleConfirm = () => {
    handleClose();
  };
  return (
    <LocalizationProvider dateAdapter={AdapterMoment}>
      <Dialog
        open={open}
        onClose={handleClose}
        onClick={(event) => event.stopPropagation()}
        aria-labelledby="timeline-dialog-title"
        aria-describedby="timeline-dialog-description"
        fullWidth
      >
        <DialogTitle id="timeline-dialog-title" fontWeight={"bold"}>
          Manage Timeline
        </DialogTitle>
        <DialogContent>
          <Stack
            //TODO: updated stacks across the app to use direction
            direction={"column"}
            spacing={2}
            paddingTop={1}
          >
            <Stack
              //TODO: updated stacks across the app to use direction
              direction={"row"}
              spacing={1}
              alignItems="center"
              justifyContent="center"
            >
              <DesktopDatePicker
                label="Kickoff"
                value={kickoffValue}
                inputFormat="MM/DD/YYYY"
                onChange={handleKickoffChange}
                renderInput={(params) => <TextField {...params} fullWidth />}
              />
              <IconButton
                aria-label="add ship to pool"
                size="small"
                onClick={() => null}
                //  disabled={trying}
              >
                <ClearIcon />
              </IconButton>
            </Stack>
            <Stack
              //TODO: updated stacks across the app to use direction
              direction={"row"}
              spacing={1}
              alignItems="center"
              justifyContent="center"
            >
              <DesktopDatePicker
                label="Deadline"
                value={deadlineValue}
                inputFormat="MM/DD/YYYY"
                onChange={handleDeadlineChange}
                renderInput={(params) => <TextField {...params} fullWidth />}
              />
              <IconButton
                aria-label="add ship to pool"
                size="small"
                //onClick={handleAdd}
                //disabled={trying}
              >
                <ClearIcon />
              </IconButton>
            </Stack>
          </Stack>
        </DialogContent>
        <DialogActions>
          <Button sx={{ color: "text.primary" }} onClick={handleClose}>
            cancel
          </Button>
          <Button variant="contained" onClick={handleConfirm}>
            save
          </Button>
        </DialogActions>
      </Dialog>
    </LocalizationProvider>
  );
}
