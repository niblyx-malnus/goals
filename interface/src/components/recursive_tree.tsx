import React, { Fragment, memo } from "react";
import Box from "@mui/material/Box";
import { PinId, Tree } from "../types/types";
import useStore from "../store";
import { GoalItem } from "./";
import { useDrag, useDrop } from "react-dnd";
import { blue, orange, green, red, purple } from "@mui/material/colors";
import { log } from "../helpers";
export interface RecursiveTreeProps {
  readonly goalList: Tree;
  pin: PinId;

  readonly onSelectCallback: (id: number) => void;
}

function DropContainer({ position, goalName }: any) {
  const [{ isOver, canDrop }, drop] = useDrop(
    () => ({
      accept: "goal",
      drop: (data: any) => {
        log(position + " this goal => ", goalName);
        //perform some action
      },
      collect: (monitor: any) => ({
        isOver: !!monitor.isOver(),
        canDrop: !!monitor.canDrop(),
      }),
    }),
    []
  );
  //ref={drop}
  if (position === "after") {
    return (
      <Box
        ref={drop}
        sx={{
          height: 10,
          width: 200,
          position: "absolute",
          bottom: -5,

          left: 0,
          backgroundColor: isOver ? blue[100] : "transparent",
        }}
      ></Box>
    );
  } else
    return (
      <Box
        ref={drop}
        sx={{
          height: 10,
          width: 200,
          position: "absolute",
          top: -5,
          left: 0,
          backgroundColor: isOver ? blue[100] : "transparent",
        }}
      ></Box>
    );
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
      <Box position={"relative"}>
        <DropContainer position="before" goalName={currentGoal.hitch.desc} />
        <GoalItem
          idObject={goal.id}
          id={currentGoalId}
          key={currentGoalId}
          isSelected={currentGoal.selected}
          label={currentGoal.hitch.desc}
          goal={currentGoal}
          pin={pin}
          poolRole={poolRole}
          inSelectionMode={inSelectionMode}
          disabled={disabled}
          yokingGoalId={yokingGoalId}
          poolArchived={poolArchived}
          note={currentGoal.hitch.note}
        >
          {childGoals.map((goal: any) => {
            const currentChildGoalId = goal.id.birth;
            return (
              <Fragment key={currentChildGoalId}>{createTree(goal)}</Fragment>
            );
          })}
        </GoalItem>
        <DropContainer position="after" goalName={currentGoal.hitch.desc} />
      </Box>
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
