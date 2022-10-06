import React, { useState } from "react";
import Box from "@mui/material/Box";

import useStore from "../store";
import { log } from "../helpers";
import Typography from "@mui/material/Typography";
import ModeCommentIcon from "@mui/icons-material/ModeComment";

import Stack from "@mui/material/Stack";

import Paper from "@mui/material/Paper";
import Fab from "@mui/material/Fab";
import Button from "@mui/material/Button";
export default function YokingActionBar({}) {
  const selectionModeYokeData = useStore(
    (store) => store.selectionModeYokeData
  );
  const toggleSelectionMode = useStore(
    (store: any) => store.toggleSelectionMode
  );
  //TODO: add paper for elevation
  return (
    <Box>
      <Stack
        direction="row"
        spacing={2}
        sx={{
          position: "fixed",
          bottom: 40,
          right: 40,
          backgroundColor: "#fff",
          padding: 2,
          borderRadius: "4px",
        }}
      >
        <Button
          variant="contained"
          onClick={() => {
            toggleSelectionMode(false, null);
            log("calling some API or other");
          }}
        >
          Confirm {selectionModeYokeData?.yokeType} yoke
        </Button>
        <Button
          onClick={() => {
            toggleSelectionMode(false, null);
          }}
          variant="outlined"
        >
          cancel
        </Button>
      </Stack>
      {/*<Box
        sx={{
          position: "fixed",
          bottom: 40,
          left: 40,
    
          backgroundColor: "#fff",
          padding: 2,
          borderRadius: '4px',
        }}
      >
        <Typography>hello world</Typography>
      </Box>*/}
    </Box>
  );
}
