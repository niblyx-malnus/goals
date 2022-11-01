import React, { useState, memo, useEffect } from "react";
import styled from "@emotion/styled/macro";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import ChevronRightIcon from "@mui/icons-material/ChevronRight";
import Box from "@mui/material/Box";
import { PinId, Tree } from "../types/types";
import IconButton from "@mui/material/IconButton";
import Typography from "@mui/material/Typography";
import NewGoalInput from "./NewGoalInput";
import IconMenu from "./IconMenu";
import EditInput from "./EditInput";
import GoalTimeline from "./GoalTimeline";
import AddIcon from "@mui/icons-material/Add";
import useStore from "../store";
import CircularProgress from "@mui/material/CircularProgress";
import Chip from "@mui/material/Chip";
import Stack from "@mui/material/Stack";
import Avatar from "@mui/material/Avatar";

import { log, shipName } from "../helpers";
import { blue, orange, green, red, purple } from "@mui/material/colors";
//TODO: make some components to simplify the logic of this component
//TODO: do the updates for goal nexus
interface GoalItemProps {
  readonly id: number;
  readonly onSelectCallback: (id: number) => void;
  readonly label: string;
  readonly isSelected: boolean | undefined;
  readonly children: ReadonlyArray<JSX.Element>;
  readonly idObject: any;
  readonly goal: any;
  poolRole: string;
  pin: PinId;
  inSelectionMode: boolean;
  disabled: boolean;
  yokingGoalId: string;
  harvestGoal?: boolean;
  poolArchived?: boolean;
}

const GoalItem = memo(
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
    inSelectionMode,
    disabled,
    yokingGoalId,
    harvestGoal = false,
    poolArchived = false,
  }: //inSelectMode
  GoalItemProps) => {
    const [isOpen, toggleItemOpen] = useState<boolean | null>(null);
    const [selected, setSelected] = useState(isSelected);
    const [yoking, setYoking] = useState<boolean>(false);
    const [addingGoal, setAddingGoal] = useState<boolean>(false);
    const [editingTitle, setEditingTitle] = useState<boolean>(false);
    const [trying, setTrying] = useState<boolean>(false);
    const [isChief, setIsChief] = useState<boolean>(false);
    const [disableActions, setDisableActions] = useState<boolean>(false);
    const collapseAll = useStore((store) => store.collapseAll);
    const selectedGoals = useStore((store) => store.selectedGoals);
    const updateSelectedGoal = useStore((store) => store.updateSelectedGoal);
    //TODO: remove the add/edit when isArchived
    //TODO: check pool isArchived here
    useEffect(() => {
      //we check at first render/everytime ranks changes(or just goal)
      //does the current ship has chief/spawn/captain perms on this goal?
      for (const rank of goal.nexus.ranks) {
        if (rank.ship === shipName()) {
          setIsChief(true);
          return;
        }
      }
    }, [goal.nexus.ranks]);
    useEffect(() => {
      // || disabled; TODO: find a better way to do disabled (overlay?)
      const disableActions =
        poolArchived || //an override prop passed from pool defaults to false
        (goal.isArchived && goal.nexus.par) ||
        trying ||
        editingTitle ||
        addingGoal;
      setDisableActions(disableActions);
    }, [
      goal.isArchived,
      goal.nexus.par,
      trying,
      editingTitle,
      addingGoal,
      poolArchived,
    ]);

    useEffect(() => {
      //everytime collapse all changes, we force isOpen value to comply
      toggleItemOpen(collapseAll.status);
    }, [collapseAll.count]);

    useEffect(() => {
      //check if this goal is in the selected goals list
      if (selectedGoals.has(idObject.birth)) {
        setSelected(true);
      } else {
        setSelected(false);
      }
    }, [selectedGoals]);

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
      if (poolRole === "captain" && !isChief) return;
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
            actionable={goal.nexus.actionable}
            complete={goal.nexus.complete}
            goalId={idObject}
            pin={pin}
            currentGoal={goal}
            setParentTrying={setTrying}
            isVirtual={goal.isVirtual}
            virtualId={goal.virtualId} //refers to the original goal(none-virtualised counterpart of this one)
            isArchived={goal.isArchived}
            harvestGoal={harvestGoal}
          />
        );
      }
    };
    const getColor = () => {
      if (inSelectionMode) {
        if (yoking) {
          return blue[700];
        }
        if (selected) {
          return blue[200];
        }
      }
      if (goal.nexus.actionable) return orange[50];
      return "auto";
    };
    const renderArchivedTag = () => {
      return (
        goal.isArchived &&
        !goal.nexus.par && (
          <Chip
            sx={{ marginLeft: 1 }}
            size="small"
            label={
              <Typography fontWeight={"bold"} color="text.secondary">
                archived
              </Typography>
            }
          />
        )
      );
    };
    const noEditPermTitle = (
      <Box
        sx={{
          backgroundColor: goal.nexus.actionable ? orange[50] : "auto",
          margin: 0.2,
          paddingLeft: 1,
          paddingRight: 1,
          borderRadius: 1,
        }}
      >
        <Typography
          variant="h6"
          color={"text.primary"}
          style={{
            textDecoration: goal.nexus.complete ? "line-through" : "auto",
            wordBreak: "break-word",
          }}
        >
          {label} {goal.isVirtual && " (virtual) "}
        </Typography>
      </Box>
    );
    const renderTitle = () => {
      if (poolRole === "viewer") return noEditPermTitle;
      if (poolRole === "captain" && !isChief) return noEditPermTitle;
      return !editingTitle ? (
        <Box
          sx={{
            backgroundColor: getColor(),
            margin: 0.2,
            paddingLeft: 1,
            paddingRight: 1,
            borderRadius: 1,
          }}
          onClick={() => {
            updateSelectedGoal(idObject, !selected);
          }}
        >
          <Typography
            variant="h6"
            //TODO: we want adding a goal to not put on disabled text (maybe?)
            color={disableActions ? "text.disabled" : "text.primary"}
            onDoubleClick={() => {
              !disableActions && !goal.isArchived && setEditingTitle(true);
            }}
            style={{
              textDecoration: goal.nexus.complete ? "line-through" : "auto",
              wordBreak: "break-word",
            }}
          >
            {label} {goal.isVirtual && " (virtual) "}
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
            isVirtual={goal.isVirtual}
            virtualGoalId={goal.virtualId} //refers to the original goal(none-virtualised counterpart of this one)
          />
        </div>
      );
    };
    const renderAddButton = () => {
      if (poolRole === "viewer") return;
      if (poolRole === "captain" && !isChief) return;
      //hide add goal in harvest panel
      if (harvestGoal) return;
      //hide add if is archived
      if (goal.isArchived) return;

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
    const renderTimeline = () => {
      return (
        <GoalTimeline
          kickoff={goal.nexus.kickoff}
          deadline={goal.nexus.deadline}
        />
      );
    };
    return (
      <Box
        sx={{
          flex: 1,
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
            {renderTimeline()}
            {renderArchivedTag()}
            {renderIconMenu()}
            {renderAddButton()}
          </>
          {!editingTitle && !harvestGoal && (
            <Stack
              flexDirection={"row"}
              alignItems="center"
              className="show-on-hover"
              sx={{ opacity: 0 }}
            >
              <Chip
                sx={{ marginLeft: 1 }}
                avatar={<Avatar>C</Avatar>}
                size="small"
                label={
                  <Typography fontWeight={"bold"}>
                    {goal.nexus.chief}
                  </Typography>
                }
                color="primary"
                variant="outlined"
              />
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
              isVirtual={goal.isVirtual}
              virtualParentId={goal.virtualId} //refers to the original goal(none-virtualised counterpart of this one)
            />
          )}
          {children}
        </Box>
      </Box>
    );
  }
);
export default GoalItem;
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
