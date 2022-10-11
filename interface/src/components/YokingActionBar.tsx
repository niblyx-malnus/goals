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
import api from "../api";
import LoadingButton from "@mui/lab/LoadingButton";

export default function YokingActionBar({}) {
  const [trying, setTrying] = useState<boolean>(false);
  const selectionModeYokeData = useStore(
    (store) => store.selectionModeYokeData
  );
  const toggleSelectionMode = useStore(
    (store: any) => store.toggleSelectionMode
  );
  const toggleSnackBar = useStore((store) => store.toggleSnackBar);
  const resetSelectedGoals = useStore((store: any) => store.resetSelectedGoals);
  const selectedGoals = useStore((store: any) => store.selectedGoals);
  //TODO: add paper for elevation
  //TODO: call this component something else?
  const moveGoal = async () => {
    setTrying(true);
    const targetGoalId = selectedGoals[0];
    const goalId = selectionModeYokeData?.goalId;
    const pin = selectionModeYokeData?.poolId;
    try {
      const result = await api.moveGoal(pin, goalId, targetGoalId);
      toggleSnackBar(true, {
        message: "successfully moved goal",
        severity: "success",
      });

      closeActionBar();
      log("moveGoal result =>", result);
    } catch (e) {
      log("moveGoal error =>", e);
      toggleSnackBar(true, {
        message: "failed to move goal",
        severity: "error",
      });
    }
    setTrying(false);
  };
  const yoke = async () => {
    setTrying(true);
    //TODO: finish generalising this for use with all the other yokes
    //TODO: include rending
    //for now, we make an array of yokes over selectedGoals
    //list where lid is goalId and rid is in item of selectedGoals

    const goalId = selectionModeYokeData?.goalId;
    const pin = selectionModeYokeData?.poolId;
    const yokeType = selectionModeYokeData?.yokeType;
    const yokeList = selectedGoals.map((selectedGoalId: any) => {
      return {
        yoke: "prio-yoke",
        lid: goalId,
        rid: selectedGoalId,
      };
    });
    try {
      const result = await api.yoke(pin, yokeList);
      toggleSnackBar(true, {
        message: "successfully " + yokeType,
        severity: "success",
      });

      //closeActionBar();
      log("yoke result =>", result);
    } catch (e) {
      log("yoke error =>", e);
      toggleSnackBar(true, {
        message: "failed to " + yokeType,
        severity: "error",
      });
    }
    setTrying(false);
  };
  const closeActionBar = () => {
    toggleSelectionMode(false, null);
    resetSelectedGoals([]);
  };
  return (
    <Paper elevation={3}>
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
        <LoadingButton
          variant="contained"
          onClick={() => {
            //depending on the yoke type, we fire off some APIs
            const yokeType = selectionModeYokeData?.yokeType;
            log("yokeType", yokeType);
            switch (yokeType) {
              case "move": {
                moveGoal();
                break;
              }
              default: {
                yoke();
              }
            }
            return;
          }}
          loading={trying}
        >
          Confirm {selectionModeYokeData?.yokeType}
        </LoadingButton>
        <Button
          onClick={() => {
            closeActionBar();
          }}
          variant="outlined"
        >
          cancel
        </Button>
      </Stack>
    </Paper>
  );
}
