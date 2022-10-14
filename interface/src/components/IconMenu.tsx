import * as React from "react";
import { styled, alpha } from "@mui/material/styles";
import Button from "@mui/material/Button";
import Menu, { MenuProps } from "@mui/material/Menu";
import MenuItem from "@mui/material/MenuItem";
import EditIcon from "@mui/icons-material/Edit";
import MoreHorizIcon from "@mui/icons-material/MoreHoriz";
import IconButton from "@mui/material/IconButton";
import CheckIcon from "@mui/icons-material/Check";
import DeleteIcon from "@mui/icons-material/Delete";
import ClearIcon from "@mui/icons-material/Clear";
import LogoutIcon from "@mui/icons-material/Logout";
import PeopleAltIcon from "@mui/icons-material/PeopleAlt";
import PlayForWorkIcon from "@mui/icons-material/PlayForWork";
import CalendarMonthIcon from "@mui/icons-material/CalendarMonth";
import FolderCopyIcon from "@mui/icons-material/FolderCopy";
import Box from "@mui/material/Box";
import { GoalId, PinId } from "../types/types";
import { log } from "../helpers";
import api from "../api";

import useStore from "../store";
//TODO: hook up enter button to dialog confirm button everywhere
const StyledMenu = styled((props: MenuProps) => (
  <Menu
    elevation={1}
    anchorOrigin={{
      vertical: "bottom",
      horizontal: "right",
    }}
    transformOrigin={{
      vertical: "top",
      horizontal: "right",
    }}
    {...props}
  />
))(({ theme }) => ({
  "& .MuiPaper-root": {
    borderRadius: 6,
    marginTop: theme.spacing(0.6),

    minWidth: 140,
    color:
      theme.palette.mode === "light"
        ? "rgb(55, 65, 81)"
        : theme.palette.grey[300],
    boxShadow:
      "rgb(255, 255, 255) 0px 0px 0px 0px, rgba(0, 0, 0, 0.05) 0px 0px 0px 1px, rgba(0, 0, 0, 0.1) 0px 10px 15px -3px, rgba(0, 0, 0, 0.05) 0px 4px 6px -2px",
    "& .MuiMenu-list": {
      padding: "4px 0",
    },
    "& .MuiMenuItem-root": {
      "& .MuiSvgIcon-root": {
        fontSize: 22,
        color: theme.palette.text.secondary,
        marginRight: theme.spacing(1.5),
      },
      "&:active": {
        backgroundColor: alpha(
          theme.palette.primary.main,
          theme.palette.action.selectedOpacity
        ),
      },
    },
  },
}));

export default function IconMenu({
  complete = false,
  goalId,
  pin,
  type,
  setParentTrying,
  poolData,
  actionable,
  isVirtual = false,
  virtualId,
  currentGoal,
}: {
  actionable?: any;
  complete?: boolean;
  goalId?: GoalId;
  virtualId?: GoalId;
  isVirtual?: boolean;

  pin?: PinId;
  type: "pool" | "goal";
  setParentTrying: Function;
  poolData?: any;
  currentGoal?: any;
}) {
  const id = isVirtual ? virtualId : goalId;
  const [anchorEl, setAnchorEl] = React.useState<null | HTMLElement>(null);
  const open = Boolean(anchorEl);
  const toggleShareDialog = useStore((store: any) => store.toggleShareDialog);
  const toggleDeleteDialog = useStore((store: any) => store.toggleDeleteDialog);
  const toggleLeaveDialog = useStore((store: any) => store.toggleLeaveDialog);
  const toggleSnackBar = useStore((store) => store.toggleSnackBar);
  const toggleTimelineDialog = useStore(
    (store: any) => store.toggleTimelineDialog
  );
  const toggleCopyPoolDialog = useStore(
    (store: any) => store.toggleCopyPoolDialog
  );
  const toggleSelectionMode = useStore(
    (store: any) => store.toggleSelectionMode
  );
  const setSelectedGoals = useStore((store: any) => store.setSelectedGoals);
  const roleMap = useStore((store: any) => store.roleMap);
  const role = roleMap.get(pin?.birth);

  const handleClick = (event: React.MouseEvent<HTMLElement>) => {
    setAnchorEl(event.currentTarget);
  };
  const handleClose = () => {
    setAnchorEl(null);
  };
  const markComplete = async () => {
    handleClose();
    setParentTrying(true);
    try {
      const result = await api.markComplete(id);
      log("markComplete result => ", result);
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to mark goal complete",
        severity: "error",
      });
      log("markComplete error => ", e);
    }
    setParentTrying(false);
  };
  const unmarkComplete = async () => {
    handleClose();
    setParentTrying(true);
    try {
      const result = await api.unmarkComplete(id);
      log("unmarkComplete result => ", result);
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to mark goal incomplete",
        severity: "error",
      });
      log("unmarkComplete error => ", e);
    }
    setParentTrying(false);
  };
  const deletePool = async () => {
    handleClose();
    setParentTrying(true);

    try {
      const result = await api.deletePool(pin);
      log("deletePool result => ", result);
      toggleSnackBar(true, {
        message: "successfully deleted pool",
        severity: "success",
      });
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to delete pool",
        severity: "error",
      });
      log("deletePool error => ", e);
    }
    setParentTrying(false);
  };
  const leavePool = async () => {
    handleClose();
    setParentTrying(true);

    try {
      const result = await api.leavePool(pin);
      log("leavePool result => ", result);
      toggleSnackBar(true, {
        message: "successfully left pool",
        severity: "success",
      });
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to leave pool",
        severity: "error",
      });
      log("leavePool error => ", e);
    }
    setParentTrying(false);
  };
  const deleteGoal = async () => {
    handleClose();
    setParentTrying(true);

    try {
      const result = await api.deleteGoal(id);
      log("deleteGoal result => ", result);
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to delete goal",
        severity: "error",
      });
      log("deleteGoal error => ", e);
    }
    setParentTrying(false);
  };
  const markActionable = async () => {
    handleClose();
    setParentTrying(true);
    try {
      const result = await api.markActionable(id);
      log("markActionable result => ", result);
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to make goal actionable",
        severity: "error",
      });
      log("markActionable error => ", e);
    }
    setParentTrying(false);
  };
  const unmarkActionable = async () => {
    handleClose();
    setParentTrying(true);
    try {
      const result = await api.unmarkActionable(id);
      log("unmarkActionable result => ", result);
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to remove goal actionable",
        severity: "error",
      });
      log("unmarkActionable error => ", e);
    }
    setParentTrying(false);
  };
  const handleTimeline = () => {
    handleClose();
    toggleTimelineDialog(true);
  };
  const handleMove = () => {
    handleClose();
    toggleSelectionMode(true, { goalId: id, poolId: pin, yokeType: "move" });
  };
  const handlePriortize = () => {
    handleClose();
    const startingConnections = currentGoal.nexus["prio-ryte"];

    toggleSelectionMode(true, {
      goalId: id,
      poolId: pin,
      yokeType: "prioritize",
      startingConnections: startingConnections,

      yokeName: "prio",
    });
  };
  const handlePrecede = () => {
    handleClose();
    const startingConnections = currentGoal.nexus["prec-ryte"];

    toggleSelectionMode(true, {
      goalId: id,
      poolId: pin,
      yokeType: "precede",
      startingConnections: startingConnections,
      yokeName: "prec",
    });
  };
  const handleNest = () => {
    handleClose();
    //we find all [yoke]-ryte connection here and update selectedGoals
    const startingConnections = currentGoal.nexus["nest-ryte"];
    setSelectedGoals(startingConnections);
    toggleSelectionMode(true, {
      goalId: id,
      poolId: pin,
      startingConnections: startingConnections,
      yokeType: "nest",
      yokeName: "nest",
    });
  };

  const moveGoalToRoot = async () => {
    handleClose();
    try {
      const result = await api.moveGoal(pin, id, null);
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
  return (
    <Box className="show-on-hover" sx={{ opacity: open ? 1 : 0 }}>
      <IconButton
        className="menu-button"
        aria-label="menu button"
        size="small"
        aria-controls={open ? "icon-menu-id" : undefined}
        aria-haspopup="true"
        aria-expanded={open ? "true" : undefined}
        onClick={handleClick}
      >
        <MoreHorizIcon />
      </IconButton>

      <StyledMenu
        anchorOrigin={{
          vertical: "top",
          horizontal: "right",
        }}
        transformOrigin={{
          vertical: "top",
          horizontal: "left",
        }}
        id="icon-menu-id"
        MenuListProps={{
          "aria-labelledby": "demo-customized-button",
        }}
        anchorEl={anchorEl}
        open={open}
        onClose={handleClose}
      >
        {type === "goal" ? (
          <div>
            {complete ? (
              <MenuItem onClick={unmarkComplete} disableRipple>
                <ClearIcon fontSize="small" />
                incomplete
              </MenuItem>
            ) : (
              <MenuItem onClick={markComplete} disableRipple>
                <CheckIcon fontSize="small" />
                complete
              </MenuItem>
            )}
            {actionable ? (
              <MenuItem onClick={unmarkActionable} disableRipple>
                <PlayForWorkIcon fontSize="small" />
                remove actionable
              </MenuItem>
            ) : (
              <MenuItem onClick={markActionable} disableRipple>
                <PlayForWorkIcon fontSize="small" />
                make actionable
              </MenuItem>
            )}
            <MenuItem onClick={handleTimeline} disableRipple>
              <CalendarMonthIcon fontSize="small" />
              timeline
            </MenuItem>
            <MenuItem onClick={handleMove} disableRipple>
              <CalendarMonthIcon fontSize="small" />
              move
            </MenuItem>
            <MenuItem onClick={moveGoalToRoot} disableRipple>
              <CalendarMonthIcon fontSize="small" />
              move to root
            </MenuItem>
            <MenuItem onClick={handlePriortize} disableRipple>
              <CalendarMonthIcon fontSize="small" />
              prioritize
            </MenuItem>
            <MenuItem onClick={handleNest} disableRipple>
              <CalendarMonthIcon fontSize="small" />
              virtually nest
            </MenuItem>
            <MenuItem onClick={handlePrecede} disableRipple>
              <CalendarMonthIcon fontSize="small" />
              precede
            </MenuItem>
            <MenuItem onClick={deleteGoal} disableRipple>
              <DeleteIcon fontSize="small" />
              delete
            </MenuItem>
          </div>
        ) : (
          <div>
            {(role === "owner" || role === "admin") && (
              <MenuItem
                onClick={() => {
                  handleClose();
                  toggleShareDialog(true, poolData);
                }}
                disableRipple
              >
                <PeopleAltIcon fontSize="small" />
                manage participants
              </MenuItem>
            )}
            {role !== "owner" && (
              <MenuItem
                onClick={() => {
                  handleClose();
                  toggleLeaveDialog(true, {
                    title: poolData.title,
                    callback: leavePool,
                  });
                }}
                disableRipple
              >
                <LogoutIcon fontSize="small" />
                leave project
              </MenuItem>
            )}
            <MenuItem
              onClick={() => {
                handleClose();
                toggleCopyPoolDialog(true, {
                  title: poolData.title,
                  pin,
                });
              }}
              disableRipple
            >
              <FolderCopyIcon fontSize="small" />
              make a copy
            </MenuItem>
            {role === "owner" && (
              <MenuItem
                onClick={() => {
                  handleClose();
                  toggleDeleteDialog(true, {
                    title: poolData.title,
                    callback: deletePool,
                  });
                }}
                disableRipple
              >
                <DeleteIcon fontSize="small" />
                delete
              </MenuItem>
            )}
          </div>
        )}
      </StyledMenu>
    </Box>
  );
}
