import React, { Fragment, memo } from "react";
import Box from "@mui/material/Box";
import { PinId, Tree } from "../types/types";
import useStore from "../store";
import { GoalItem } from "./";
import { useDrag, useDrop } from "react-dnd";
import { blue, orange, green, red, purple } from "@mui/material/colors";
import { log } from "../helpers";
import { reorderGoalsAction } from "../store/actions";
export interface RecursiveTreeProps {
  readonly goalList: Tree;
  pin: PinId;

  readonly onSelectCallback: (id: number) => void;
}

function DropContainer({ position, relativeGoalId, parentId, pin }: any) {
  const draggingParentId = useStore((store) => store.draggingParentId);

  const [{ isOver, canDrop }, drop] = useDrop(
    () => ({
      accept: "goal",
      drop: (data: any) => {
        /**
         * #1: the id of the goal we're moving
         * #2: the id of the goal we're moving next to (reference goal)
         * #3: the positiong (before or after)
         * #4: parent goal Id
         */
        reorderGoalsAction(
          data.goalId,
          relativeGoalId,
          parentId,
          position,
          pin
        );
      },
      collect: (monitor: any) => ({
        isOver: !!monitor.isOver(),
        canDrop: !!monitor.canDrop(),
      }),
    }),
    []
  );
  //if we aren't both direct children of this, don't render the drop box
  if (draggingParentId !== parentId?.birth) return null;
  if (position === "after") {
    return (
      <Box
        ref={drop}
        sx={{
          height: 10,
          width: 200,
          position: "absolute",
          bottom: -5,
          zIndex: 1,
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
      <Box position={"relative"} key={currentGoalId}>
        <DropContainer
          position="before"
          relativeGoalId={
            currentGoal.isVirtual ? currentGoal.virtualId.birth : currentGoalId
          }
          parentId={currentGoal.nexus.par}
          pin={pin}
        />
        <GoalItem
          idObject={goal.id}
          id={currentGoalId}
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
          tags={currentGoal.hitch.tags}
          parentId={currentGoal.nexus.par?.birth}
          virtualId={currentGoal.virtualId?.birth} //we use this for actions if our goal is virtual
        >
          {childGoals.map((goal: any) => {
            const currentChildGoalId = goal.id.birth;
            return (
              <Fragment key={currentChildGoalId}>{createTree(goal)}</Fragment>
            );
          })}
        </GoalItem>
        <DropContainer
          position="after"
          relativeGoalId={
            currentGoal.isVirtual ? currentGoal.virtualId.birth : currentGoalId
          }
          parentId={currentGoal.nexus.par}
          pin={pin}
        />
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
