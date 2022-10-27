import * as React from "react";
import { styled, alpha } from "@mui/material/styles";
import Menu, { MenuProps } from "@mui/material/Menu";
import MenuItem from "@mui/material/MenuItem";
import Avatar from "@mui/material/Avatar";
import MoreHorizIcon from "@mui/icons-material/MoreHoriz";
import IconButton from "@mui/material/IconButton";
import CheckIcon from "@mui/icons-material/Check";

import DeleteOutlineOutlinedIcon from "@mui/icons-material/DeleteOutlineOutlined";
import ClearIcon from "@mui/icons-material/Clear";
import LogoutIcon from "@mui/icons-material/Logout";
import PeopleAltOutlinedIcon from "@mui/icons-material/PeopleAltOutlined";
import PlayForWorkIcon from "@mui/icons-material/PlayForWork";
import CalendarMonthOutlinedIcon from "@mui/icons-material/CalendarMonthOutlined";
import FolderCopyOutlinedIcon from "@mui/icons-material/FolderCopyOutlined";
import AgricultureOutlinedIcon from "@mui/icons-material/AgricultureOutlined";
import OpenWithOutlinedIcon from "@mui/icons-material/OpenWithOutlined";
import LinkOutlinedIcon from "@mui/icons-material/LinkOutlined";

import Divider from "@mui/material/Divider";
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
  isArchived = false,
  harvestGoal = false,
}: {
  actionable?: any;
  complete?: boolean;
  goalId?: GoalId;
  virtualId?: GoalId;
  isVirtual?: boolean;

  isArchived?: boolean;

  pin?: PinId;
  type: "pool" | "goal";
  setParentTrying: Function;
  poolData?: any;
  currentGoal?: any;
  harvestGoal?: boolean;
}) {
  const id = isVirtual ? virtualId : goalId;
  const [anchorEl, setAnchorEl] = React.useState<null | HTMLElement>(null);
  const open = Boolean(anchorEl);
  const toggleShareDialog = useStore((store: any) => store.toggleShareDialog);
  const toggleDeleteDialog = useStore((store: any) => store.toggleDeleteDialog);
  const toggleLeaveDialog = useStore((store: any) => store.toggleLeaveDialog);
  const toggleGroupsShareDialog = useStore(
    (store: any) => store.toggleGroupsShareDialog
  );
  const toggleSnackBar = useStore((store) => store.toggleSnackBar);
  const toggleTimelineDialog = useStore(
    (store: any) => store.toggleTimelineDialog
  );
  const toggleCopyPoolDialog = useStore(
    (store: any) => store.toggleCopyPoolDialog
  );

  const toggleArchiveDialog = useStore(
    (store: any) => store.toggleArchiveDialog
  );
  const toggleSelectionMode = useStore(
    (store: any) => store.toggleSelectionMode
  );
  const setSelectedGoals = useStore((store: any) => store.setSelectedGoals);
  const roleMap = useStore((store: any) => store.roleMap);
  const role = roleMap.get(pin?.birth);

  const setHarvestData = useStore((store: any) => store.setHarvestData);

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
  const archivePool = async () => {
    handleClose();
    setParentTrying(true);

    try {
      const result = await api.archivePool(pin);
      log("archivePool result => ", result);
      toggleSnackBar(true, {
        message: "successfully deleted pool",
        severity: "success",
      });
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to delete pool",
        severity: "error",
      });
      log("archivePool error => ", e);
    }
    setParentTrying(false);
  };
  const renewPool = async () => {
    handleClose();
    setParentTrying(true);

    try {
      const result = await api.renewPool(pin);
      log("renewPool result => ", result);
      toggleSnackBar(true, {
        message: "successfully renewed pool",
        severity: "success",
      });
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to renew pool",
        severity: "error",
      });
      log("renewPool error => ", e);
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
  const archiveGoal = async () => {
    handleClose();
    setParentTrying(true);

    try {
      const result = await api.archiveGoal(id);
      log("archiveGoal result => ", result);
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to delete goal",
        severity: "error",
      });
      log("archiveGoal error => ", e);
    }
    setParentTrying(false);
  };
  const renewGoal = async () => {
    handleClose();
    setParentTrying(true);

    try {
      const result = await api.renewGoal(id);
      log("renewGoal result => ", result);
      toggleSnackBar(true, {
        message: "successfully renewd goal",
        severity: "success",
      });
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to renew goal",
        severity: "error",
      });
      log("archiveGoal error => ", e);
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
    const kickoff = currentGoal.nexus.kickoff?.moment;
    const deadline = currentGoal.nexus.deadline?.moment;
    log("kickoff", kickoff);
    log("deadline", deadline);

    toggleTimelineDialog(true, {
      goalId: id,
      kickoff,
      deadline,
    });
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
  const handleHarvestGoal = async () => {
    handleClose();

    try {
      if (!id) throw Error("no id provided");
      const result = await api.harvest(id.owner, id.birth);
      //update the harvest data in our store
      setHarvestData({
        startGoalId: id,
        goals: result["full-harvest"],
        pin,
        role,
        idList: result["full-harvest"]?.map(
          (goalItem: any) => goalItem.id.birth
        ),
      });

      log("handleHarvestGoal result =>", result);
    } catch (e) {
      log("handleHarvestGoal error =>", e);
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
          //TODO: only admins/owners can delete/archive/restore a goal
          /*
          anyone with permissions on a goal can delete
          only admins or owner can renew 
          */
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
            <MenuItem onClick={handleHarvestGoal} disableRipple>
              <AgricultureOutlinedIcon fontSize="small" />
              harvest
            </MenuItem>
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

            <Divider />
            <MenuItem onClick={handleTimeline} disableRipple>
              <CalendarMonthOutlinedIcon fontSize="small" />
              timeline
            </MenuItem>
            {/* We hide these from harvest panel */}
            {!harvestGoal && (
              <>
                <Divider />
                <MenuItem onClick={handleMove} disableRipple>
                  <OpenWithOutlinedIcon fontSize="small" />
                  move
                </MenuItem>
                <MenuItem onClick={moveGoalToRoot} disableRipple>
                  <OpenWithOutlinedIcon fontSize="small" />
                  move to root
                </MenuItem>
                <Divider />
                <MenuItem onClick={handlePriortize} disableRipple>
                  <LinkOutlinedIcon fontSize="small" />
                  prioritize
                </MenuItem>
                <MenuItem onClick={handlePrecede} disableRipple>
                  <LinkOutlinedIcon fontSize="small" />
                  precede
                </MenuItem>
                <MenuItem onClick={handleNest} disableRipple>
                  <LinkOutlinedIcon fontSize="small" />
                  virtually nest
                </MenuItem>
              </>
            )}
            <Divider />
            <MenuItem onClick={archiveGoal} disableRipple>
              <DeleteOutlineOutlinedIcon fontSize="small" />
              archive
            </MenuItem>
            {isArchived && (
              <MenuItem onClick={renewGoal} disableRipple>
                <DeleteOutlineOutlinedIcon fontSize="small" />
                renew
              </MenuItem>
            )}
            <MenuItem onClick={deleteGoal} disableRipple>
              <DeleteOutlineOutlinedIcon fontSize="small" />
              delete
            </MenuItem>
          </div>
        ) : (
          <div>
            {(role === "owner" || role === "admin") && (
              <>
                <MenuItem
                  onClick={() => {
                    handleClose();
                    toggleShareDialog(true, poolData);
                  }}
                  disableRipple
                >
                  <PeopleAltOutlinedIcon fontSize="small" />
                  manage participants
                </MenuItem>
                <MenuItem
                  onClick={() => {
                    handleClose();
                    toggleGroupsShareDialog(true, {
                      title: poolData.title,
                      participants: poolData,
                      pin,
                    });
                  }}
                  disableRipple
                >
                  <PeopleAltOutlinedIcon fontSize="small" />
                  share with groups
                </MenuItem>
              </>
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
            <Divider />

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
              <FolderCopyOutlinedIcon fontSize="small" />
              make a copy
            </MenuItem>
            {role === "owner" && (
              <>
                <Divider />

                <MenuItem
                  onClick={() => {
                    handleClose();
                    toggleArchiveDialog(true, {
                      title: poolData.title,
                      callback: archivePool,
                    });
                  }}
                  disableRipple
                >
                  <DeleteOutlineOutlinedIcon fontSize="small" />
                  archive
                </MenuItem>
                {isArchived && (
                  <MenuItem onClick={renewPool} disableRipple>
                    <DeleteOutlineOutlinedIcon fontSize="small" />
                    renew
                  </MenuItem>
                )}
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
                  <DeleteOutlineOutlinedIcon fontSize="small" />
                  delete
                </MenuItem>
              </>
            )}
          </div>
        )}
      </StyledMenu>
    </Box>
  );
}
