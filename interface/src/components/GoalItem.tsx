import React, { useState, memo, useEffect } from "react";
import styled from "@emotion/styled/macro";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import ChevronRightIcon from "@mui/icons-material/ChevronRight";
import Box from "@mui/material/Box";
import { PinId } from "../types/types";
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
import Badge from "@mui/material/Badge";
import TextField from "@mui/material/TextField";
import { log, shipName, getRoleTitle } from "../helpers";
import { blue, orange, green, red, purple } from "@mui/material/colors";
import api from "../api";
import { useDrag, useDrop } from "react-dnd";
import QuickActions from "./QuickActions";
import { useNavigate } from "react-router-dom";

//TODO: make some components to simplify the logic of this component
interface GoalItemProps {
  readonly id: string;
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
  note: string;
  tags?: any;
  parentId: string | null;
  virtualId?: string;
}

const GoalItem = memo(
  ({
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
    note = "this is a note",
    tags = [],
    parentId,
    virtualId,
  }: //inSelectMode
  GoalItemProps) => {
    const [{ isDragging }, drag] = useDrag(() => ({
      type: "goal",
      item: { goalId: virtualId ? virtualId : id },
      collect: (monitor: any) => ({
        isDragging: !!monitor.isDragging(),
      }),
    }));
    const setDraggingParentId = useStore((store) => store.setDraggingParentId);
    const navigate = useNavigate();
    useEffect(() => {
      if (isDragging) {
        setDraggingParentId(parentId);
      } else {
        setDraggingParentId(null);
      }
    }, [isDragging]);
    const [isOpen, toggleItemOpen] = useState<boolean | null>(null);
    const [selected, setSelected] = useState(isSelected);
    const [yoking, setYoking] = useState<boolean>(false);
    const [addingGoal, setAddingGoal] = useState<boolean>(false);
    const [editingTitle, setEditingTitle] = useState<boolean>(false);
    const setTrying = useStore((store) => store.setTrying);

    const getTrying: any = useStore((store) => store.getTrying);
    const trying: any = getTrying(id);
    const [isChief, setIsChief] = useState<boolean>(false);
    const [disableActions, setDisableActions] = useState<boolean>(false);
    const collapseAll = useStore((store) => store.collapseAll);

    const selectedGoals = useStore((store) => store.selectedGoals);
    const updateSelectedGoal = useStore((store) => store.updateSelectedGoal);
    const [goalRole, setGoalRole] = useState<"spawn" | "chief" | null>(null);

    const [noteValue, setNoteValue] = useState<string>("");
    const [editingNote, setEditingNote] = useState<boolean>(false);
    const onNoteChange = (event: React.ChangeEvent<HTMLInputElement>) => {
      setNoteValue(event.target.value);
    };
    const ctrlPressed = useStore((store) => store.ctrlPressed);

    const handleNoteKeyDown = (
      event: React.KeyboardEvent<HTMLInputElement>
    ) => {
      //call api
      if (event.key === "Enter") {
        editGoalNote();
      }
      //close the input
      if (event.key === "Escape") {
        setEditingNote(false);
      }
    };
    const editGoalNote = async () => {
      setTrying(id, true);
      try {
        const result = await api.editGoalNote(idObject, noteValue);
        log("editGoalNote result => ", result);
      } catch (e) {
        log("editGoalNote error => ", e);
      }
      setEditingNote(false);
      setTrying(id, false);
    };
    useEffect(() => {
      //we check at first render/everytime ranks changes(or just goal)
      //does the current ship have chief/spawn perms on this goal?
      for (const rank of goal.nexus.ranks) {
        if (rank.ship === shipName()) {
          setIsChief(true);
          setGoalRole("chief");
          return;
        }
      }
      goal.nexus.spawn.includes(shipName()) && setGoalRole("spawn");
    }, [goal.nexus.ranks, goal.nexus.spawn]);
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
      if ((poolRole === "spawn" || poolRole === null) && !isChief) return;
      if (poolRole !== "owner" && poolRole !== "admin" && goal.isArchived)
        return;
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
            setParentTrying={(value: boolean) => setTrying(id, value)}
            isVirtual={goal.isVirtual}
            virtualId={goal.virtualId} //refers to the original goal(none-virtualised counterpart of this one)
            isArchived={goal.isArchived}
            harvestGoal={harvestGoal}
            onEditGoalNote={() => {
              setEditingNote(!editingNote);
              setNoteValue("note");
            }}
          />
        );
      }
    };
    const renderQuickActions = () => {
      if (!ctrlPressed) return;
      if ((poolRole === "spawn" || poolRole === null) && !isChief) return;
      if (poolRole !== "owner" && poolRole !== "admin" && goal.isArchived)
        return;
      if (trying) return;

      if (!disableActions) {
        return (
          <QuickActions
            type="goal"
            //TODO: just pass togls entirely to this
            actionable={goal.nexus.actionable}
            complete={goal.nexus.complete}
            goalId={idObject}
            pin={pin}
            currentGoal={goal}
            setParentTrying={(value: boolean) => setTrying(id, value)}
            isVirtual={goal.isVirtual}
            virtualId={goal.virtualId} //refers to the original goal(none-virtualised counterpart of this one)
            isArchived={goal.isArchived}
            harvestGoal={harvestGoal}
            onEditGoalNote={() => {
              setEditingNote(!editingNote);
              setNoteValue("note");
            }}
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
      if (goal.nexus.actionable) return "auto"; //orange[50];
      return "auto";
    };
    const renderArchivedTag = () => {
      return (
        goal.isArchived &&
        !goal.nexus.par && (
          <Chip
            sx={{ marginLeft: 1, marginRight: 1 }}
            size="small"
            label={
              <Typography fontWeight={"bold"} color="text.secondary">
                Archived
              </Typography>
            }
          />
        )
      );
    };
    const renderVirtualTag = () => {
      return (
        goal.isVirtual && (
          <Chip
            sx={{ marginLeft: 1, marginRight: 1 }}
            size="small"
            variant="outlined"
            color="primary"
            label={
              <Typography fontWeight={"bold"} color="primary">
                Virtual
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
          {label}
        </Typography>
      </Box>
    );
    const renderTitle = () => {
      if ((poolRole === "spawn" || poolRole === null) && !isChief)
        return noEditPermTitle;
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
            setParentTrying={(value: boolean) => setTrying(id, value)}
            isVirtual={goal.isVirtual}
            virtualGoalId={goal.virtualId} //refers to the original goal(none-virtualised counterpart of this one)
          />
        </div>
      );
    };
    const renderAddButton = () => {
      if (
        (poolRole === "spawn" || poolRole === null) &&
        !isChief &&
        goalRole !== "spawn"
      )
        return;
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
          direction={"row"}
          flexWrap={"wrap"}
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
            <Box
              ref={drag}
              onClick={() => {
                navigate(
                  "/apps/gol-cli/goal/~" +
                    idObject?.owner +
                    "/" +
                    idObject?.birth
                );
              }}
            >
              {renderTitle()}
            </Box>
            {tags.map((tag: any) => {
              return (
                <Chip
                  size="small"
                  label={
                    <Typography fontWeight={"bold"}>{tag.text}</Typography>
                  }
                  variant="outlined"
                />
              );
            })}
            {renderArchivedTag()}

            {renderVirtualTag()}
            {renderTimeline()}
            {renderIconMenu()}
            {renderAddButton()}
            {renderQuickActions()}
          </>
          {!editingTitle && !harvestGoal && (
            <>
              <Chip
                className="show-on-hover"
                sx={{ opacity: 0 }}
                size="small"
                avatar={
                  <Badge
                    style={{
                      borderRadius: 10,
                      height: 18,
                      width: 18,
                      display: "flex",
                      alignItems: "center",
                      justifyContent: "center",
                    }}
                  >
                    <Typography
                      variant="subtitle2"
                      style={{
                        textAlign: "center",
                        lineHeight: "18px",
                      }}
                    >
                      C
                    </Typography>
                  </Badge>
                }
                label={
                  <Typography fontWeight={"bold"}>
                    {goal.nexus.chief}
                  </Typography>
                }
                color="primary"
                variant="outlined"
              />
              {/*current ship's role on goal*/}
              {goalRole && (
                <Chip
                  className="show-on-hover"
                  sx={{ opacity: 0 }}
                  size="small"
                  label={
                    <Typography fontWeight={"bold"}>{goalRole}</Typography>
                  }
                  color="secondary"
                  variant="outlined"
                />
              )}
            </>
          )}
        </StyledTreeItem>
        {editingNote && (
          <TextField
            sx={{ marginTop: 1 }}
            spellCheck="true"
            error={false}
            size="small"
            id="note"
            label="note"
            type="text"
            multiline
            value={noteValue}
            onChange={onNoteChange}
            onKeyDown={handleNoteKeyDown}
            autoFocus
            fullWidth
            disabled={trying}
          />
        )}
        {!editingNote && note && (
          <Stack direction={"row"}>
            <Typography
              variant="subtitle2"
              fontWeight={"bold"}
              color={"text.secondary"}
              marginLeft={1.2}
            >
              Note: {note}
            </Typography>
          </Stack>
        )}
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
const StyledTreeItem = styled(Stack)({
  display: "flex",
  flexDirection: "row",
  alignItems: "center",
  position: "relative",
});
const StyledTreeChildren = styled(Box)({
  paddingLeft: "10px",
});
