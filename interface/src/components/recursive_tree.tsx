import React, { Fragment, useState, memo, useEffect } from "react";
import Box from "@mui/material/Box";
import { PinId, Tree } from "../types/types";
import useStore from "../store";
import { log, shipName } from "../helpers";
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
}: any) => {
  const filterGoals = useStore((store) => store.filterGoals);
  const ship = shipName();
  const createTree = (goal: any) => {
    const currentGoal = goal.goal;
    const currentGoalId = goal.id.birth;
    const childGoals = goal.childNodes;
    //filter out complete or incomplete goals if store says so
    if (
      (currentGoal.nexus.complete && filterGoals === "complete") ||
      (!currentGoal.nexus.complete && filterGoals === "incomplete")
    )
      return null;

    //we need to know if the current ship is a captain on this goal
    //TODO: update this to work with the new stuff, should probably be a captainMap
    const isCaptain = true; // currentGoal.perms.captains.includes(ship);

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
        isCaptain={isCaptain}
        inSelectionMode={inSelectionMode}
        disabled={disabled}
        yokingGoalId={yokingGoalId}
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
