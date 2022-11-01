import React, { useEffect, useState } from "react";
import Button from "@mui/material/Button";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogContentText from "@mui/material/DialogContentText";
import DialogTitle from "@mui/material/DialogTitle";
import Stack from "@mui/material/Stack";
import useStore from "../store";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";

import TextField from "@mui/material/TextField";
import IconButton from "@mui/material/IconButton";
import ClearIcon from "@mui/icons-material/Clear";
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";
import { DesktopDatePicker } from "@mui/x-date-pickers/DesktopDatePicker";
import { MobileDatePicker } from "@mui/x-date-pickers/MobileDatePicker";
import dayjs, { Dayjs } from "dayjs";
import api from "../api";
import { log } from "../helpers";
import LoadingButton from "@mui/lab/LoadingButton";

//TODO: get the mobile picker working https://mui.com/x/react-date-pickers/getting-started/
//TODO: update all the aria here and elsewhere

export default function TimelineDialog() {
  const open = useStore((store: any) => store.timelineDialogOpen);

  const toggleTimelineDialog = useStore(
    (store: any) => store.toggleTimelineDialog
  );
  const timelineDialogData = useStore((store: any) => store.timelineDialogData);

  const [trying, setTrying] = useState<boolean>(false);
  const [kickoffValue, setKickoffValue] = React.useState<Dayjs | null>(null);
  const [deadlineValue, setDeadlineValue] = React.useState<Dayjs | null>(null);
  const toggleSnackBar = useStore((store) => store.toggleSnackBar);

  useEffect(() => {
    if (timelineDialogData) {
      const { kickoff, deadline } = timelineDialogData;
      setKickoffValue(kickoff ? dayjs(kickoff) : null);
      setDeadlineValue(deadline ? dayjs(deadline) : null);
    }
  }, [timelineDialogData]);
  const handleKickoffChange = (newValue: Dayjs | null) => {
    setKickoffValue(newValue);
  };
  const handleDeadlineChange = (newValue: Dayjs | null) => {
    setDeadlineValue(newValue);
  };

  const handleClose = () => {
    toggleTimelineDialog(false, null);
  };
  const handleConfirm = () => {
    updateTimeline();
  };
  const updateTimeline = async () => {
    setTrying(true);
    try {
      const kickoffResult = await api.setKickoff(
        timelineDialogData.goalId,
        kickoffValue?.valueOf() || null
      );
      const deadlineResult = await api.setDeadline(
        timelineDialogData.goalId,
        deadlineValue?.valueOf() || null
      );
      toggleSnackBar(true, {
        message: "successfuly updated timeline",
        severity: "success",
      });
      log("setDeadline result =>", deadlineResult);
      log("setKickoff result =>", kickoffResult);
      handleClose();
    } catch (e) {
      log("updateTimeline error =>", e);
      toggleSnackBar(true, {
        message: "failed to update timeline",
        severity: "error",
      });
    }
    setTrying(false);
  };

  if (!timelineDialogData) return null;
  return (
    <LocalizationProvider dateAdapter={AdapterDayjs}>
      <Dialog
        open={open}
        onClose={handleClose}
        onClick={(event) => event.stopPropagation()}
        aria-labelledby="timeline-dialog-title"
        aria-describedby="timeline-dialog-description"
        fullWidth
      >
        <DialogTitle id="timeline-dialog-title" fontWeight={"bold"}>
          Manage Timeline ({timelineDialogData.title})
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
                aria-label="clear kickoff input"
                size="small"
                onClick={() => {
                  setKickoffValue(null);
                }}
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
                aria-label="clear deadline input"
                size="small"
                onClick={() => {
                  setDeadlineValue(null);
                }}
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
          <LoadingButton
            variant="contained"
            loading={trying}
            onClick={handleConfirm}
          >
            save
          </LoadingButton>
        </DialogActions>
      </Dialog>
    </LocalizationProvider>
  );
}
