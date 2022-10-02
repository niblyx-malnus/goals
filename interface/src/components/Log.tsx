import React, { useState } from "react";
import Box from "@mui/material/Box";

import useStore from "../store";
import { log } from "../helpers";
import Typography from "@mui/material/Typography";
import ModeCommentIcon from "@mui/icons-material/ModeComment";

import Stack from "@mui/material/Stack";

import Paper from "@mui/material/Paper";
import Fab from "@mui/material/Fab";
//TODO: update log icon to something more fititng
export default function Log({}) {
  const [open, setOpen] = useState<boolean>(false);
  const logList = useStore((store: any) => store.logList);

  return (
    <Box sx={{ position: "fixed", bottom: 40, right: 40 }}>
      <Stack flexDirection="column" alignItems="flex-end">
        <Box
          sx={{
            display: "flex",
            flexWrap: "wrap",

            "& > :not(style)": {
              m: 1,
              width: 350,
              height: 400,
              padding: 2,
            },
          }}
        >
          <Paper
            elevation={3}
            sx={{ overflow: "auto", display: open ? "auto" : "none" }}
          >
            {logList.map((log: any, index: number) => {
              return (
                <Stack
                  flex={1}
                  flexDirection={"row"}
                  alignItems="center"
                  justifyContent="flex-start"
                  key={"log-item-" + index}
                  flexWrap="nowrap"
                >
                  <Typography variant="subtitle1" sx={{ whiteSpace: "nowrap" }}>
                    [{log.date}]
                  </Typography>
                  <Typography
                    variant="subtitle1"
                    fontWeight="bold"
                    color={"primary"}
                    sx={{ whiteSpace: "nowrap" }}
                  >
                    [~{log.ship}]
                  </Typography>
                  <Typography
                    variant="subtitle1"
                    marginLeft={1}
                    paddingRight={2}
                    sx={{ whiteSpace: "nowrap" }}
                  >
                    {log.actionName}
                  </Typography>
                </Stack>
              );
            })}
          </Paper>
        </Box>
        <Fab color="primary" aria-label="add" onClick={() => setOpen(!open)}>
          <ModeCommentIcon />
        </Fab>
      </Stack>
    </Box>
  );
}
