import React, { useEffect, useState } from "react";
import { styled, useTheme } from "@mui/material/styles";
import Box from "@mui/material/Box";
import Drawer from "@mui/material/Drawer";
import Stack from "@mui/material/Stack";

import Typography from "@mui/material/Typography";
import Divider from "@mui/material/Divider";
import IconButton from "@mui/material/IconButton";
import MenuIcon from "@mui/icons-material/Menu";
import ChevronLeftIcon from "@mui/icons-material/ChevronLeft";
import ChevronRightIcon from "@mui/icons-material/ChevronRight";

import useStore from "../store";
import { GoalItem } from "./";
import { log } from "../helpers";
import AgricultureIcon from "@mui/icons-material/Agriculture";
import api from "../api";

const drawerWidth = 300;

export default function HarvestPanel() {
  const theme = useTheme();
  const [open, setOpen] = useState(false);
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
  const handleDrawerOpen = () => {
    setOpen(true);
  };

  const handleDrawerClose = () => {
    setOpen(false);
  };
  const handleHarvestGoal = async () => {
    const { pin, role } = harvestData;
    const id = harvestData.startGoalId;

    try {
      const result = await api.harvest(id.owner, id.birth);
      //update the harvest data in our store
      setHarvestData({
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
    <Box sx={{ display: "flex" }}>
      <IconButton
        color="inherit"
        aria-label="open drawer"
        onClick={handleDrawerOpen}
        edge="start"
        sx={{ mr: 2, ...(open && { display: "none" }) }}
      >
        <MenuIcon />
      </IconButton>

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
            {theme.direction === "ltr" ? (
              <ChevronLeftIcon />
            ) : (
              <ChevronRightIcon />
            )}
          </IconButton>
        </Stack>

        <Divider />
        <Stack direction="row" alignItems={"center"} margin={1}>
          <Typography color={"text.primary"} variant="h6">
            Harvesting: ({startGoalTile})
          </Typography>
          <IconButton onClick={() => handleHarvestGoal()}>
            <AgricultureIcon />
          </IconButton>
        </Stack>
        <Divider />
        <Stack margin={1}>
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
        </Stack>
        <Divider />
      </Drawer>
    </Box>
  );
}
