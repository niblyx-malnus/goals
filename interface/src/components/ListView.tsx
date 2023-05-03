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
import { listAskAction } from "../store/actions";

function ListView({ pageType, pageId }: { pageType: PageType; pageId: any }) {
  const listGoals = useStore((store) => store.listGoals);
  const tagFilterArray = useStore((store) => store.tagFilterArray);
  useEffect(() => {
    //everytime we get a new filter set we ask for new data
    if (pageId !== "main" && !pageId) return;
    listAskAction(pageType, pageId);
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
              listAskAction(pageType, pageId);
            }}
            sx={{ fontWeight: "bold" }}
          >
            Refresh
          </Button>
        </Tooltip>
      </Stack>
      <Stack direction={"column"}>
        {listGoals?.map((goal: any) => {
          const currentGoal = goal.goal;
          const currentGoalId = goal.id.birth;
          return (
            <GoalItem
              parentId=""
              children={[]}
              goal={currentGoal}
              poolRole={listGoals.role}
              id={currentGoalId}
              isSelected={currentGoal.selected}
              key={"harvest-" + currentGoalId}
              idObject={goal.id}
              label={currentGoal.hitch.desc}
              disabled={true}
              inSelectionMode={false}
              pin={listGoals.pin}
              harvestGoal={true}
              yokingGoalId={"not in selection mode, so I wont use this"}
              note={currentGoal.hitch.note}
              tags={currentGoal.hitch.tags}
              view="list"
            />
          );
        })}
        {listGoals?.length === 0 && (
          <Typography color={"text.primary"} variant="h6">
            Nothing to harvest
          </Typography>
        )}
      </Stack>
    </Stack>
  );
}
export default ListView;
