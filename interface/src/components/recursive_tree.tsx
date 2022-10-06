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
import Chip from "@mui/material/Chip";
import Stack from "@mui/material/Stack";
import Avatar from "@mui/material/Avatar";

import { log, shipName } from "../helpers";
import { blue, orange, yellow } from "@mui/material/colors";
interface TreeItemProps {
  readonly id: number;
  readonly onSelectCallback: (id: number) => void;
  readonly label: string;
  readonly isSelected: boolean | undefined;
  readonly children: ReadonlyArray<JSX.Element>;
  readonly idObject: any;
  readonly goal: any;
  poolRole: string;
  pin: PinId;
  isCaptain: boolean;
  inSelectionMode: boolean;
  disabled: boolean;
  yokingGoalId: string;
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
    poolRole,
    isCaptain,
    inSelectionMode,
    disabled,
    yokingGoalId,
  }: //inSelectMode
  TreeItemProps) => {
    const [isOpen, toggleItemOpen] = useState<boolean | null>(null);
    const [selected, setSelected] = useState(isSelected);
    const [yoking, setYoking] = useState<boolean>(false);
    const [addingGoal, setAddingGoal] = useState<boolean>(false);
    const [editingTitle, setEditingTitle] = useState<boolean>(false);
    const [trying, setTrying] = useState<boolean>(false);
    const collapseAll = useStore((store) => store.collapseAll);
    const disableActions = trying || editingTitle || addingGoal || disabled;
    useEffect(() => {
      //everytime collapse all changes, we force isOpen value to comply
      toggleItemOpen(collapseAll.status);
    }, [collapseAll.count]);

    useEffect(() => {
      //did yoking originated from this goal?
      if (yokingGoalId && yokingGoalId === idObject.birth) {
        setYoking(true);
      } else {
        setYoking(false);
      }
    }, [yokingGoalId]);
    const handleAdd = () => {
      toggleItemOpen(true);
      setAddingGoal(true);
    };
    const renderIconMenu = () => {
      if (poolRole === "viewer") return;
      if (poolRole === "captain" && !isCaptain) return;
      if (trying) {
        return (
          <CircularProgress
            size={24}
            sx={{
              position: "absolute",
              left: -24,
            }}
          />
        );
      }
      if (!disableActions) {
        return (
          <IconMenu
            type="goal"
            //TODO: just pass togls entirely to this
            actionable={goal.togls.actionable}
            complete={goal.togls.complete}
            id={idObject}
            pin={pin}
            setParentTrying={setTrying}
            positionLeft={0}
          />
        );
      }
    };
    const getColor = () => {
      if (inSelectionMode) {
        if (yoking) {
          return "orange";
        }
        if (selected) {
          return "purple";
        }
      }
      if (goal.togls.actionable) return orange[50];
      return "auto";
    };
    const renderTitle = () => {
      const noEditPermTitle = (
        <Box
          sx={{
            backgroundColor: goal.togls.actionable ? orange[50] : "auto",

            padding: 0.2,
            paddingLeft: 1,
            paddingRight: 1,
            borderRadius: 1,
          }}
        >
          <Typography
            variant="h6"
            color={"text.primary"}
            style={{
              textDecoration: goal.togls.complete ? "line-through" : "auto",
            }}
          >
            {label}
          </Typography>
        </Box>
      );
      if (poolRole === "viewer") return noEditPermTitle;
      if (poolRole === "captain" && !isCaptain) return noEditPermTitle;
      return !editingTitle ? (
        <Box
          sx={{
            backgroundColor: getColor(),
            padding: 0.2,
            paddingLeft: 1,
            paddingRight: 1,
            borderRadius: 1,
          }}
          onClick={() => {
            inSelectionMode && !yoking && setSelected(!selected);
          }}
        >
          <Typography
            variant="h6"
            color={trying ? "text.disabled" : "text.primary"}
            onDoubleClick={() => {
              !disableActions && setEditingTitle(true);
            }}
            style={{
              textDecoration: goal.togls.complete ? "line-through" : "auto",
            }}
          >
            {label}
          </Typography>
        </Box>
      ) : (
        <div
          style={{
            flex: 1,
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
      );
    };
    const renderAddButton = () => {
      if (poolRole === "viewer") return;
      if (poolRole === "captain" && !isCaptain) return;
      return (
        !disableActions && (
          <IconButton
            sx={{ opacity: 0 }}
            className="show-on-hover"
            // sx={{ position: "absolute", right: 35 }}
            aria-label="add goal button"
            size="small"
            onClick={handleAdd}
          >
            <AddIcon />
          </IconButton>
        )
      );
    };
    return (
      <Box
        sx={{
          "&:hover": {
            "& > div > .helper-bar ": {
              backgroundColor: blue[400],
            },
          },
        }}
      >
        <StyledTreeItem
          sx={{
            "&:hover": {
              cursor: "pointer",
              "& .show-on-hover": {
                opacity: 1,
              },
            },
          }}
        >
          <>
            {!trying && (
              <Box
                sx={{
                  position: "absolute",
                  left: -24,
                  display: "flex",
                  flexDirection: "row",
                }}
              >
                {children && children.length > 0 && (
                  <Box
                    sx={{
                      display: "flex",
                      justifyContent: "center",
                      alignItems: "center",
                    }}
                    className="icon-container"
                    onClick={() => toggleItemOpen(!isOpen)}
                  >
                    {isOpen ? <ExpandMoreIcon /> : <ChevronRightIcon />}
                  </Box>
                )}
              </Box>
            )}
            {renderTitle()}
            {renderIconMenu()}
            {renderAddButton()}
          </>
          {!editingTitle && (
            <Stack
              flexDirection={"row"}
              alignItems="center"
              className="show-on-hover"
              sx={{ opacity: 0 }}
            >
              {goal.perms.captains.map((item: any, index: number) => {
                return (
                  <Chip
                    key={item}
                    sx={{ marginLeft: 1 }}
                    avatar={<Avatar>C</Avatar>}
                    size="small"
                    label={<Typography fontWeight={"bold"}>{item}</Typography>}
                    color="primary"
                    variant="outlined"
                  />
                );
              })}
            </Stack>
          )}
        </StyledTreeItem>

        <Box
          sx={{ paddingLeft: "24px" }}
          style={{
            position: "relative",
            height: !isOpen ? "0px" : "auto",
            overflow: !isOpen ? "hidden" : "visible",
          }}
        >
          <Box
            className="helper-bar"
            sx={{
              display: "flex",
              flexDirection: "column",
              position: "absolute",
              left: -13,
              top: 0,
              width: "1.5px",
              backgroundColor: "text.secondary",
              height: "100%",
            }}
          />
          {addingGoal && (
            <NewGoalInput
              pin={pin}
              parentId={idObject}
              under={true}
              callback={() => setAddingGoal(false)}
            />
          )}
          {children}
        </Box>
      </Box>
    );
  }
);

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
      (currentGoal.togls.complete && filterGoals === "complete") ||
      (!currentGoal.togls.complete && filterGoals === "incomplete")
    )
      return null;

    //we need to know if the current ship is a captain on this goal
    const isCaptain = currentGoal.perms.captains.includes(ship);

    return (
      <TreeItem
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
      </TreeItem>
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
});
const StyledTreeChildren = styled(Box)({
  paddingLeft: "10px",
});
