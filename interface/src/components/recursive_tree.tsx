import React, { Fragment, useState, memo } from "react";
import styled from "@emotion/styled/macro";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import ChevronRightIcon from "@mui/icons-material/ChevronRight";
import Box from "@mui/material/Box";
import { Tree } from "../types/types";
import MoreHorizIcon from "@mui/icons-material/MoreHoriz";
import IconButton from "@mui/material/IconButton";
import NewGoalInput from "./NewGoalInput";
import IconMenu from "./IconMenu";
import AddIcon from "@mui/icons-material/Add";

interface TreeItemProps {
  readonly id: number;
  readonly onSelectCallback: (id: number) => void;
  readonly label: string;
  readonly isSelected: boolean | undefined;
  readonly children: ReadonlyArray<JSX.Element>;
  readonly idObject: any;
  readonly goal: any;
}

export interface RecursiveTreeProps {
  readonly goalList: Tree;
  readonly onSelectCallback: (id: number) => void;
}

const TreeItem = memo(
  ({
    onSelectCallback,
    label,
    isSelected,
    children,
    id,
    idObject,
    goal,
  }: TreeItemProps) => {
    const [isOpen, toggleItemOpen] = useState<boolean | null>(null);
    const [selected, setSelected] = useState(isSelected);
    const [addingGoal, setAddingGoal] = useState<boolean>(false);

    return (
      <div>
        <StyledTreeItem>
          <StyledMenuButtonContainer sx={{ position: "absolute", left: -30 }}>
            <IconMenu type="goal" complete={goal.complete} id={idObject} />
          </StyledMenuButtonContainer>
          {children && children.length > 0 && (
            <Box
              className="icon-container"
              onClick={() => toggleItemOpen(!isOpen)}
            >
              {isOpen ? <ExpandMoreIcon /> : <ChevronRightIcon />}
            </Box>
          )}
          <StyledLabel
            className="label"
            onClick={(e: React.MouseEvent<HTMLInputElement>) => {
              setSelected(!selected);
              onSelectCallback(id);
            }}
            style={{
              marginLeft: `${children && children.length === 0 ? "24px" : ""}`,
              background: `${selected ? "#d5d5d5" : ""}`,
              textDecoration: goal.complete ? "line-through" : "auto",
            }}
          >
            {label}
            {/*TODO: make this into it's own component(so we don't have to rerender the children)*/}
          </StyledLabel>
          <StyledMenuButton
            className="add-goal-button"
            // sx={{ position: "absolute", right: 35 }}
            aria-label="add goal button"
            size="small"
            onClick={() => setAddingGoal(true)}
          >
            <AddIcon />
          </StyledMenuButton>
        </StyledTreeItem>
        {addingGoal && (
          <NewGoalInput
            id={idObject}
            under={true}
            callback={() => console.log("lol")}
          />
        )}
        <StyledTreeChildren
          style={{
            height: !isOpen ? "0px" : "auto",
            overflow: !isOpen ? "hidden" : "visible",
          }}
        >
          {children}
        </StyledTreeChildren>{" "}
      </div>
    );
  }
);

const RecursiveTree = ({ goalList, onSelectCallback }: any) => {
  const createTree = (goal: any) => {
    const currentGoal = goal.goal;
    const currentGoalId = goal.id.birth;
    const childGoals = goal.childNodes;
    return (
      childGoals && (
        <TreeItem
          idObject={goal.id}
          id={currentGoalId}
          key={currentGoalId}
          onSelectCallback={(id: number) => {
            onSelectCallback(id);
          }}
          isSelected={currentGoal.selected}
          label={currentGoal.desc}
          goal={currentGoal}
        >
          {childGoals.map((goal: any) => {
            const currentChildGoalId = goal.id.birth;
            return (
              <Fragment key={currentChildGoalId}>{createTree(goal)}</Fragment>
            );
          })}
        </TreeItem>
      )
    );
  };
  return (
    <Box>
      {goalList.map((goal: any, i: any) => (
        <Box key={i}>{createTree(goal)}</Box>
      ))}
    </Box>
  );
};

export default RecursiveTree;

// styles
const StyledMenuButton = styled(IconButton)({
  opacity: 0,
  "&:hover": {
    opacity: 1,
  },
});
const StyledMenuButtonContainer = styled(Box)({
  opacity: 0,
  "&:hover": {
    opacity: 1,
  },
});
const StyledLabel = styled(Box)({
  height: "24px",
  "&:hover": {
    cursor: "pointer",
  },
});
const StyledTreeItem = styled(Box)({
  display: "flex",
  flexDirection: "row",
  alignItems: "center",
  position: "relative",
  "&:hover": {
    cursor: "pointer",
    [`${StyledMenuButton}`]: {
      opacity: 1,
    },
    [`${StyledMenuButtonContainer}`]: {
      opacity: 1,
    },
  },
});
const StyledTreeChildren = styled(Box)({
  paddingLeft: "10px",
});
