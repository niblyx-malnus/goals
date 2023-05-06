//this is our pool Component
import React, { useEffect, useState, memo } from "react";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import ChevronRightIcon from "@mui/icons-material/ChevronRight";
import Box from "@mui/material/Box";
import api from "../api";
import styled from "@emotion/styled/macro";
import IconButton from "@mui/material/IconButton";
import AddIcon from "@mui/icons-material/Add";
import NewGoalInput from "./NewGoalInput";
import EditInput from "./EditInput";
import IconMenu from "./IconMenu";
import useStore from "../store";
import { log, shipName, getRoleTitle } from "../helpers";
import Typography from "@mui/material/Typography";
import CircularProgress from "@mui/material/CircularProgress";
import { Order, PinId } from "../types/types";
import Badge from "@mui/material/Badge";
import Stack from "@mui/material/Stack";
import Chip from "@mui/material/Chip";
import TextField from "@mui/material/TextField";
import QuickActions from "./QuickActions";
import { useNavigate } from "react-router-dom";
import { useDrag, useDrop } from "react-dnd";
import { grey } from "@mui/material/colors";

const Project = memo(
  ({
    title,
    children,
    pin,
    goalsLength,
    permList,
    poolOwner,
    role,
    isArchived = false,
    note,
  }: {
    title: string;
    pin: PinId;
    children: any;
    goalsLength: number;
    permList: any;
    poolOwner: string;
    role: string;
    isArchived?: boolean;
    note: string;
  }) => {
    //TODO: add the store type
    const navigate = useNavigate();

    const collapseAll = useStore((store: any) => store.collapseAll);
    const [isOpen, toggleItemOpen] = useState<boolean | null>(null);
    const [addingGoal, setAddingGoal] = useState<boolean>(false);
    const [editingTitle, setEditingTitle] = useState<boolean>(false);

    const getTrying: any = useStore((store) => store.getTrying);
    const trying: any = getTrying(pin.birth);
    const setTrying = useStore((store) => store.setTrying);
    const toggleSnackBar = useStore((store) => store.toggleSnackBar);

    const moveGoal = async (targetGoalId: any) => {
      try {
        const result = await api.moveGoal(pin, targetGoalId, null);
        toggleSnackBar(true, {
          message: "successfully moved goal",
          severity: "success",
        });

        log("moveGoal result =>", result);
      } catch (e) {
        log("moveGoal error =>", e);
        toggleSnackBar(true, {
          message: "failed to move goal",
          severity: "error",
        });
      }
    };
    const [{ isOver, canDrop }, drop] = useDrop(
      () => ({
        accept: "goal",
        drop: async (data: any) => {
          const incomingId = data.fullGoalId;
          moveGoal(incomingId);
        },
        collect: (monitor: any) => ({
          isOver: !!monitor.isOver(),
          canDrop: !!monitor.canDrop(),
        }),
      }),
      []
    );

    const [hovering, setHovering] = useState<boolean>(false);

    const [noteValue, setNoteValue] = useState<string>("");
    const [editingNote, setEditingNote] = useState<boolean>(false);
    const onNoteChange = (event: React.ChangeEvent<HTMLInputElement>) => {
      setNoteValue(event.target.value);
    };
    const handleNoteKeyDown = (
      event: React.KeyboardEvent<HTMLInputElement>
    ) => {
      //call api
      if (event.key === "Enter") {
        editPoolNote();
      }
      //close the input
      if (event.key === "Escape") {
        setEditingNote(false);
      }
    };
    const editPoolNote = async () => {
      setTrying(pin.birth, true);
      try {
        const result = await api.editPoolNote(pin, noteValue);
        log("editPoolNote result => ", result);
      } catch (e) {
        log("editPoolNote error => ", e);
      }
      setEditingNote(false);
    };
    const disableActions = trying || editingTitle || addingGoal;

    const handleAdd = () => {
      toggleItemOpen(true);
      setAddingGoal(true);
    };
    useEffect(() => {
      //everytime collapse all changes, we force isOpen value to comply
      toggleItemOpen(collapseAll.status);
    }, [collapseAll.count]);

    const renderIconMenu = () => {
      if (trying) {
        return (
          <CircularProgress
            size={24}
            sx={{ position: "absolute", left: -24 }}
          />
        );
      }
      if (!disableActions) {
        return (
          <IconMenu
            poolData={{ title, permList, pin }}
            type="pool"
            pin={pin}
            setParentTrying={(value: boolean) => setTrying(pin.birth, value)}
            isArchived={isArchived}
            onEditPoolNote={() => {
              setEditingNote(!editingNote);
              setNoteValue(note);
            }}
            editTitleCb={() => setEditingTitle(true)}
          />
        );
      }
    };
    const ctrlPressed = useStore((store) => store.ctrlPressed);

    const renderQuickActions = () => {
      if (trying) return;
      if (!disableActions && ctrlPressed && hovering) {
        return (
          <QuickActions
            poolData={{ title, permList, pin }}
            type="pool"
            pin={pin}
            setParentTrying={(value: boolean) => setTrying(pin.birth, value)}
            isArchived={isArchived}
            onEditPoolNote={() => {
              setEditingNote(!editingNote);
              setNoteValue(note);
            }}
          />
        );
      }
    };
    const renderArchivedTag = () => {
      return (
        isArchived && (
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
    const renderTitle = () => {
      if (role === null || role === "spawn") {
        return (
          <Box
            sx={{
              padding: 0.2,
              paddingLeft: 1,
              paddingRight: 1,
              borderRadius: 1,
            }}
          >
            <Typography color={"text.primary"} variant="h5" fontWeight={"bold"}>
              {title}
            </Typography>
          </Box>
        );
      }
      return !editingTitle ? (
        <Box
          sx={{
            padding: 0.2,
            paddingLeft: 1,
            paddingRight: 1,
            borderRadius: 1,
          }}
        >
          <Typography
            color={trying ? "text.disabled" : "text.primary"}
            variant="h5"
            fontWeight={"bold"}
            onDoubleClick={() => {
              !disableActions && !isArchived && setEditingTitle(true);
            }}
          >
            {title}
          </Typography>
        </Box>
      ) : (
        <EditInput
          type="pool"
          title={title}
          onDone={() => {
            setEditingTitle(false);
          }}
          setParentTrying={(value: boolean) => setTrying(pin.birth, value)}
          pin={pin}
        />
      );
    };

    const renderAddButton = () => {
      if (role === null) return;
      if (isArchived) return;
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
      <Box sx={{ marginBottom: 1 }}>
        <StyledTreeItem
          onMouseOver={() => setHovering(true)}
          onMouseOut={() => setHovering(false)}
          sx={{
            "&:hover": {
              cursor: "pointer",
              "& .show-on-hover": {
                opacity: 1,
              },
            },
          }}
          ref={drop}
        >
          {!trying && (
            <Box
              sx={{
                position: "absolute",
                left: -24,
                display: "flex",
                flexDirection: "row",
              }}
            >
              {goalsLength > 0 && (
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
          <Box sx={{ backgroundColor: isOver ? grey[400] : "transparent" }}>
            {renderTitle()}
          </Box>
          {renderArchivedTag()}
          {renderIconMenu()}
          {renderAddButton()}
          {renderQuickActions()}
          {!editingTitle && (
            <Stack
              flexDirection={"row"}
              alignItems="center"
              justifyContent={"center"}
              className="show-on-hover"
              sx={{ opacity: 0 }}
            >
              <Chip
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
                      O
                    </Typography>
                  </Badge>
                }
                size="small"
                label={<Typography fontWeight={"bold"}>{poolOwner}</Typography>}
                color="primary"
                variant="outlined"
              />
              <Chip
                sx={{ marginLeft: 1 }}
                size="small"
                label={
                  <Typography fontWeight={"bold"}>
                    {getRoleTitle(role)}
                  </Typography>
                }
                color="secondary"
                variant="outlined"
              />
            </Stack>
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
          sx={{ paddingLeft: { xs: "18px", sm: "24px", md: "24px" } }}
          style={{
            height: !isOpen ? "0px" : "auto",
            overflow: !isOpen ? "hidden" : "visible",
          }}
        >
          {addingGoal && (
            <NewGoalInput
              pin={pin}
              under={false}
              callback={() => setAddingGoal(false)}
            />
          )}
          {children}
        </Box>
      </Box>
    );
  }
);
export default Project;

const StyledMenuButton = styled(IconButton)({
  opacity: 0,
  "&:hover": {
    opacity: 1,
  },
});
const StyledMenuButtonContainer = styled(Box)({
  /* opacity: 0,
    "&:hover": {
      opacity: 1,
    },*/
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

const StyledLabel = styled(Box)({
  fontSize: 24,
  /*  height: "24px",*/
});
