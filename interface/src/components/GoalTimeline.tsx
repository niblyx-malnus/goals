import React, { useEffect, useState } from "react";

import Typography from "@mui/material/Typography";
import dayjs, { Dayjs } from "dayjs";

import CalendarMonthOutlinedIcon from "@mui/icons-material/CalendarMonthOutlined";
import Popover from "@mui/material/Popover";
import Box from "@mui/material/Box";
import Stack from "@mui/material/Stack";
import { log } from "../helpers";

export default function GoalTimeline({ kickoff, deadline }: any) {
  const [anchorEl, setAnchorEl] = useState<HTMLElement | null>(null);
  const [kickoffDate, setKickoffDate] = useState<string | null>(null);
  const [deadlineDate, setDeadlineDate] = useState<string | null>(null);
  const [inherited, setInhertied] = useState<boolean>(false);
  const handlePopoverOpen = (event: React.MouseEvent<HTMLElement>) => {
    setAnchorEl(event.currentTarget);
  };
  const open = Boolean(anchorEl);

  const handlePopoverClose = () => {
    setAnchorEl(null);
  };
  const momentToDateString = (moment: number): string => {
    return dayjs(moment).format("MM/DD/YYYY");
  };
  useEffect(() => {
    //deadline => moment if it exists; else ryte-bound if it exists; else whatever
    //kickoff => just the moment
    if (kickoff.moment) {
      log("kickoff.moment", kickoff.moment);

      setKickoffDate(momentToDateString(kickoff.moment));
    } else {
      setKickoffDate(null);
    }
    if (deadline.moment) {
      setDeadlineDate(momentToDateString(deadline.moment));
      setInhertied(false);
    } else if (deadline["ryte-bound"]?.moment) {
      setDeadlineDate(momentToDateString(deadline["ryte-bound"].moment));
      setInhertied(true);
    } else {
      setDeadlineDate(null);
    }
  }, [kickoff, deadline]);

  if (!kickoffDate && !deadlineDate) return null;
  return (
    <Box sx={{ opacity: 0 }} className="show-on-hover">
      <Box
        aria-owns={open ? "goal-timeline-popover" : undefined}
        aria-haspopup="true"
        onMouseEnter={handlePopoverOpen}
        onMouseLeave={handlePopoverClose}
      >
        <CalendarMonthOutlinedIcon color={inherited ? "disabled" : "primary"} />
      </Box>

      <Popover
        id="goal-timeline-popover"
        sx={{
          pointerEvents: "none",
        }}
        open={open}
        anchorEl={anchorEl}
        anchorOrigin={{
          vertical: "bottom",
          horizontal: "right",
        }}
        transformOrigin={{
          vertical: "top",
          horizontal: "left",
        }}
        onClose={handlePopoverClose}
        disableRestoreFocus
      >
        <Stack direction="column" spacing={0.5} padding={1}>
          {kickoffDate && (
            <Stack direction="row" spacing={0.7} alignItems="center">
              <Typography fontWeight={"bold"}>K</Typography>
              <Typography>{kickoffDate}</Typography>
            </Stack>
          )}
          {deadlineDate && (
            <Stack direction="row" spacing={0.7} alignItems="center">
              <Typography fontWeight={"bold"}>D</Typography>

              <Typography>{deadlineDate}</Typography>
            </Stack>
          )}
        </Stack>
      </Popover>
    </Box>
  );
}
