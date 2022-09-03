import React, { Fragment, useState, memo } from "react";
import styled from "@emotion/styled/macro";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import ChevronRightIcon from "@mui/icons-material/ChevronRight";
import Box from "@mui/material/Box";
import { Tree } from "../types/types";
import MoreHorizIcon from "@mui/icons-material/MoreHoriz";
import IconButton from "@mui/material/IconButton";

interface TreeItemProps {
  readonly id: number;
  readonly onSelectCallback: (id: number) => void;
  readonly label: string;
  readonly isSelected: boolean | undefined;
  readonly children: ReadonlyArray<JSX.Element>;
}

export interface RecursiveTreeProps {
  readonly goalList: Tree;
  readonly onSelectCallback: (id: number) => void;
}

const TreeItem = memo(
  ({ onSelectCallback, label, isSelected, children, id }: TreeItemProps) => {
    const [isOpen, toggleItemOpen] = useState<boolean | null>(null);
    const [selected, setSelected] = useState(isSelected);

    return (
      <div>
        <StyledTreeItem>
          <StyledMenuButton
            className="menu-button"
            sx={{ position: "absolute", left: -30 }}
            aria-label="fingerprint"
            size="small"
          >
            <MoreHorizIcon />
          </StyledMenuButton>
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
            }}
          >
            {label}
          </StyledLabel>
        </StyledTreeItem>
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
          id={currentGoalId}
          key={currentGoalId}
          onSelectCallback={(id: number) => {
            onSelectCallback(id);
          }}
          isSelected={currentGoal.selected}
          label={currentGoal.desc}
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
  },
});
const StyledTreeChildren = styled(Box)({
  paddingLeft: "10px",
});
