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

    try {
      const targetGoalId = [...selectedGoals.values()][0];

      const goalId = selectionModeYokeData?.goalId;
      const pin = selectionModeYokeData?.poolId;
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

    const goalId = selectionModeYokeData?.goalId;
    const pin = selectionModeYokeData?.poolId;
    const yokeType = selectionModeYokeData?.yokeType;
    const yokeName = selectionModeYokeData?.yokeName;

    const startingConnectionsMap = new Map();
    selectionModeYokeData?.startingConnections.map((item: any) => {
      startingConnectionsMap.set(item.id, item);
    });
    //create our yokes (yoke(create-maintain)-rend(remove))
    const yokeList: any = [];

    //intersections between selected goals and  starting connections  (yokes)
    selectedGoals.forEach((id: any) => {
      if (startingConnectionsMap.has(id.birth)) {
        yokeList.push({
          yoke: yokeName + "-yoke",
          lid: goalId,
          rid: id,
        });
      }
    });
    //goals that exists in starting connections but doesn't exist in selecedGoals (rends)
    startingConnectionsMap.forEach((id: any) => {
      if (!selectedGoals.has(id.birth)) {
        yokeList.push({
          yoke: yokeName + "-rend",
          lid: goalId,
          rid: id,
        });
      }
    });
    //goals that doesn't exist in starting connections but got added to selected goals (yokes)
    selectedGoals.forEach((id: any) => {
      if (!startingConnectionsMap.has(id.birth)) {
        yokeList.push({
          yoke: yokeName + "-yoke",
          lid: goalId,
          rid: id,
        });
      }
    });

    log("yokeList", yokeList);

    try {
      const result = await api.yoke(pin, yokeList);
      toggleSnackBar(true, {
        message: yokeType + " successful",
        severity: "success",
      });

      closeActionBar();
      log("yoke result =>", result);
    } catch (e) {
      log("yoke error =>", e);
      toggleSnackBar(true, {
        message: yokeType + " failed",
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
    <Paper
      sx={{
        position: "fixed",
        bottom: 40,
        right: 40,
        padding: 2,
        borderRadius: "4px",
      }}
      elevation={3}
    >
      <Stack direction="row" spacing={2}>
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
          {selectionModeYokeData?.yokeType}
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
