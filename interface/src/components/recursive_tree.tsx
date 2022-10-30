import React, { Fragment, memo } from "react";
import Box from "@mui/material/Box";
import { PinId, Tree } from "../types/types";
import useStore from "../store";
import { GoalItem } from "./";
export interface RecursiveTreeProps {
  readonly goalList: Tree;
  pin: PinId;

  readonly onSelectCallback: (id: number) => void;
}

const RecursiveTree = ({
  goalList,
  pin,
  onSelectCallback,
  poolRole,
  inSelectionMode,
  disabled,
  yokingGoalId,
  poolArchived, 
}: any) => {
  const filterGoals = useStore((store) => store.filterGoals);
  const createTree = (goal: any) => {
    const currentGoal = goal.goal;
    const currentGoalId = goal.id.birth;
    const childGoals = goal.childNodes;
    //filter out goals based on fitlerGoals value
    if (
      (!currentGoal.nexus.actionable && filterGoals === "actionable") ||
      (currentGoal.nexus.complete && filterGoals === "complete") ||
      (!currentGoal.nexus.complete && filterGoals === "incomplete")
    )
      return null;

    return (
      <GoalItem
        idObject={goal.id}
        id={currentGoalId}
        key={currentGoalId}
        onSelectCallback={(id: number) => {
          onSelectCallback(id);
        }}
        isSelected={currentGoal.selected}
        label={currentGoal.hitch.desc}
        goal={currentGoal}
        pin={pin}
        poolRole={poolRole}
        inSelectionMode={inSelectionMode}
        disabled={disabled}
        yokingGoalId={yokingGoalId}
        poolArchived={poolArchived}
      >
        {childGoals.map((goal: any) => {
          const currentChildGoalId = goal.id.birth;
          return (
            <Fragment key={currentChildGoalId}>{createTree(goal)}</Fragment>
          );
        })}
      </GoalItem>
    );
  };
  return (
    <Box>
      {goalList.map((goal: any, index: number) => {
        return createTree(goal);
      })}
    </Box>
  );
};

export default memo(RecursiveTree);
