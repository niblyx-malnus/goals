import React, { useEffect, useState } from "react";
import { styled, useTheme } from "@mui/material/styles";
import Box from "@mui/material/Box";
import Drawer from "@mui/material/Drawer";
import Stack from "@mui/material/Stack";

import Typography from "@mui/material/Typography";
import Divider from "@mui/material/Divider";
import IconButton from "@mui/material/IconButton";
import ClearIcon from "@mui/icons-material/Clear";

import useStore from "../store";
import { GoalItem } from "./";
import { log } from "../helpers";
import AgricultureIcon from "@mui/icons-material/Agriculture";
import api from "../api";
import Tooltip from "@mui/material/Tooltip";

const drawerWidth = 300;

export default function HarvestPanel() {
  const open = useStore((store: any) => store.harvestPanelOpen);
  const [harvestGoals, setHarvestGoals] = useState([]);
  const [startGoalTile, setStartGoalTitle] = useState<string>("");
  const fetchedPools = useStore((store) => store.pools);
  const harvestData = useStore((store) => store.harvestData);
  const setHarvestData = useStore((store) => store.setHarvestData);

  useEffect(() => {
    if (open && harvestData.goals) {
      log("harvestData", harvestData);
      //we use our main tree as the single source of truth, so we use the ids to locate the goals we need
      const harvestGoals: any = [];
      let startGoalDesc: any; //the harvestee, we seek this everytime in case of changes...
      fetchedPools.forEach((poolItem: any) => {
        if (poolItem.pin.birth === harvestData.pin.birth) {
          poolItem.pool.nexus.goals.forEach((goalItem: any) => {
            //find the harvested goals
            if (harvestData.idList.includes(goalItem.id.birth)) {
              harvestGoals.push(goalItem);
            }
            //find the harvestee goal
            if (goalItem.id.birth === harvestData.startGoalId.birth) {
              startGoalDesc = goalItem.goal.hitch.desc;
            }
          });
        }
      });
      log("harvestGoals", harvestGoals);
      log("startGoalDesc", startGoalDesc);
      setStartGoalTitle(startGoalDesc);
      setHarvestGoals(harvestGoals);
    }
  }, [fetchedPools, harvestData]);

  const handleDrawerClose = () => {
    setHarvestData(false, {});
  };
  const handleHarvestGoal = async () => {
    const { pin, role } = harvestData;
    const id = harvestData.startGoalId;

    try {
      const result = await api.harvest(id.owner, id.birth);
      //update the harvest data in our store
      setHarvestData(true, {
        startGoalId: id,
        goals: result["full-harvest"],
        pin,
        role,
        idList: result["full-harvest"]?.map(
          (goalItem: any) => goalItem.id.birth
        ),
      });

      log("handleHarvestGoal result =>", result);
    } catch (e) {
      log("handleHarvestGoal error =>", e);
    }
  };
  return (
    <Box
      sx={{
        display: "flex",
      }}
    >
      <Drawer
        sx={{
          width: drawerWidth,
          flexShrink: 0,

          "& .MuiDrawer-paper": {
            width: drawerWidth,
            boxSizing: "border-box",
          },
        }}
        variant="persistent"
        anchor="left"
        open={open}
      >
        <Stack
          direction="row"
          alignItems={"center"}
          justifyContent="space-between"
          margin={1}
        >
          <Typography color={"text.primary"} variant="h6">
            Harvest Panel
          </Typography>
          <IconButton onClick={handleDrawerClose}>
            <ClearIcon />
          </IconButton>
        </Stack>
        <Divider />
        <Stack
          direction="row"
          alignItems={"center"}
          padding={1}
          flexWrap="wrap"
        >
          <Typography
            color={"text.primary"}
            variant="h6"
            sx={{
              wordWrap: "break-word",
              width: "100%",
            }}
          >
            {startGoalTile}
            <Tooltip
              title="Click to refresh harvested goals"
              placement="right"
              arrow
            >
              <IconButton onClick={() => handleHarvestGoal()} color="primary">
                <AgricultureIcon />
              </IconButton>
            </Tooltip>
          </Typography>
        </Stack>
        <Divider />
        <Stack margin={1} direction={"column"}>
          {harvestGoals?.map((goal: any) => {
            const currentGoal = goal.goal;
            const currentGoalId = goal.id.birth;
            return (
              <GoalItem
                children={[]}
                goal={currentGoal}
                poolRole={harvestData.role}
                id={currentGoalId}
                onSelectCallback={(id: number) => {
                  log("onSelectCallback", id);
                }}
                isSelected={currentGoal.selected}
                key={"harvest-" + currentGoalId}
                idObject={goal.id}
                label={currentGoal.hitch.desc}
                disabled={true}
                inSelectionMode={false}
                pin={harvestData.pin}
                harvestGoal={true}
                yokingGoalId={"not in selection mode, so I wont use this"}
              />
            );
          })}
          {harvestGoals?.length === 0 && (
            <Typography color={"text.primary"} variant="h6">
              Nothing to harvest
            </Typography>
          )}
        </Stack>
        <Divider />
      </Drawer>
    </Box>
  );
}
