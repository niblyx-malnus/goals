import React, { Fragment, useState, memo, useEffect } from "react";
import styled from "@emotion/styled/macro";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import ChevronRightIcon from "@mui/icons-material/ChevronRight";
import Box from "@mui/material/Box";
import { PinId, Tree } from "../types/types";
import MoreHorizIcon from "@mui/icons-material/MoreHoriz";
import IconButton from "@mui/material/IconButton";
import Typography from "@mui/material/Typography";
import NewGoalInput from "./NewGoalInput";
import IconMenu from "./IconMenu";
import EditInput from "./EditInput";
import AddIcon from "@mui/icons-material/Add";
import useStore from "../store";
import CircularProgress from "@mui/material/CircularProgress";

interface TreeItemProps {
  readonly id: number;
  readonly onSelectCallback: (id: number) => void;
  readonly label: string;
  readonly isSelected: boolean | undefined;
  readonly children: ReadonlyArray<JSX.Element>;
  readonly idObject: any;
  readonly goal: any;

  pin: PinId;
}

export interface RecursiveTreeProps {
  readonly goalList: Tree;
  pin: PinId;

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
    pin,
  }: TreeItemProps) => {
    const [isOpen, toggleItemOpen] = useState<boolean | null>(null);
    const [selected, setSelected] = useState(isSelected);
    const [addingGoal, setAddingGoal] = useState<boolean>(false);
    const [editingTitle, setEditingTitle] = useState(false);
    const [trying, setTrying] = useState<boolean>(false);
    const collapseAll = useStore((store) => store.collapseAll);

    useEffect(() => {
      //everytime collapse all changes, we force isOpen value to comply
      toggleItemOpen(collapseAll);
    }, [collapseAll]);
    const handleAdd = () => {
      toggleItemOpen(true);
      setAddingGoal(true);
    };
    return (
      <div>
        <StyledTreeItem>
          {trying ? (
            <CircularProgress
              size={24}
              sx={{ position: "absolute", left: -30 }}
            />
          ) : (
            <StyledMenuButtonContainer sx={{ position: "absolute", left: -30 }}>
              <IconMenu
                type="goal"
                complete={goal.complete}
                id={idObject}
                pin={pin}
              />
            </StyledMenuButtonContainer>
          )}
          {children && children.length > 0 && (
            <Box
              className="icon-container"
              onClick={() => toggleItemOpen(!isOpen)}
            >
              {isOpen ? <ExpandMoreIcon /> : <ChevronRightIcon />}
            </Box>
          )}
          {!editingTitle ? (
            <Typography
              variant="h6"
              onDoubleClick={() => {
                setEditingTitle(true);
              }}
              style={{
                marginLeft: children && children.length === 0 ? "24px" : "",
                background: `${selected ? "#d5d5d5" : ""}`,
                textDecoration: goal.complete ? "line-through" : "auto",
              }}
            >
              {label}
            </Typography>
          ) : (
            <div
              style={{
                marginLeft: children && children.length === 0 ? "24px" : "",
              }}
            >
              <EditInput
                type="goal"
                title={label}
                onDone={() => {
                  setEditingTitle(false);
                }}
                pin={pin}
                id={idObject}
                setParentTrying={setTrying}
              />
            </div>
          )}
          {!trying && (
            <StyledMenuButton
              className="add-goal-button"
              // sx={{ position: "absolute", right: 35 }}
              aria-label="add goal button"
              size="small"
              onClick={handleAdd}
            >
              <AddIcon />
            </StyledMenuButton>
          )}
        </StyledTreeItem>
        {addingGoal && (
          <NewGoalInput
            id={idObject}
            under={true}
            callback={() => setAddingGoal(false)}
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

const RecursiveTree = ({ goalList, pin, onSelectCallback }: any) => {
  //TODO: move these up to before mapping over projects (App.tsx currently)
  const filterGoals = useStore((store) => store.filterGoals);

  const createTree = (goal: any) => {
    const currentGoal = goal.goal;
    const currentGoalId = goal.id.birth;
    const childGoals = goal.childNodes;
    //filter out complete if store says so
    if (currentGoal.complete && filterGoals === "complete") return null;
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
          pin={pin}
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
