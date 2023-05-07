import React, { useEffect, useState } from "react";
import { styled, useTheme } from "@mui/material/styles";
import Box from "@mui/material/Box";
import Drawer from "@mui/material/Drawer";
import Stack from "@mui/material/Stack";

import Typography from "@mui/material/Typography";
import Button from "@mui/material/Button";
import { PageType } from "../types/types";
import useStore from "../store";
import { GoalItem } from ".";
import { log } from "../helpers";

import Tooltip from "@mui/material/Tooltip";
import { harvestAskAction } from "../store/actions";

function HarvestView({
  pageType,
  pageId,
}: {
  pageType: PageType;
  pageId: any;
}) {
  const harvestGoals = useStore((store) => store.harvestGoals);
  const tagFilterArray = useStore((store) => store.tagFilterArray);
  useEffect(() => {
    //everytime we get a new filter set we ask for new data
    if (pageId !== "main" && !pageId) return;
    harvestAskAction(pageType, pageId);
  }, [tagFilterArray, pageType, pageId]);
  return (
    <Stack direction={"column"}>
      <Stack direction="row" alignItems={"center"} flexWrap="wrap">
        <Tooltip
          title="Click to refresh harvested goals"
          placement="right"
          arrow
        >
          <Button
            onClick={() => {
              harvestAskAction(pageType, pageId);
            }}
            sx={{ fontWeight: "bold" }}
          >
            Refresh
          </Button>
        </Tooltip>
      </Stack>
      <Stack direction={"column"}>
        {harvestGoals?.map((goal: any) => {
          const currentGoal = goal.goal;
          const currentGoalId = goal.id.birth;
          return (
            <GoalItem
              parentId=""
              children={[]}
              goal={currentGoal}
              poolRole={harvestGoals.role}
              id={currentGoalId}
              isSelected={currentGoal.selected}
              key={"harvest-" + currentGoalId}
              idObject={goal.id}
              label={currentGoal.hitch.desc}
              disabled={true}
              inSelectionMode={false}
              pin={harvestGoals.pin}
              harvestGoal={true}
              yokingGoalId={"not in selection mode, so I wont use this"}
              note={currentGoal.hitch.note}
              tags={currentGoal.hitch.tags}
              view="harvest"
            />
          );
        })}
        {harvestGoals?.length === 0 && (
          <Typography color={"text.primary"} variant="h6">
            Nothing to harvest
          </Typography>
        )}
      </Stack>
    </Stack>
  );
}
export default HarvestView;