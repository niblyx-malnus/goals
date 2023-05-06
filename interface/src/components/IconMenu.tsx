import * as React from "react";
import { styled, alpha } from "@mui/material/styles";
import Menu, { MenuProps } from "@mui/material/Menu";
import MenuItem from "@mui/material/MenuItem";
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
import RestoreOutlinedIcon from "@mui/icons-material/RestoreOutlined";
import ContentCopyOutlinedIcon from "@mui/icons-material/ContentCopyOutlined";
import { useNavigate } from "react-router-dom";
import Divider from "@mui/material/Divider";
import Box from "@mui/material/Box";
import { GoalId, PinId } from "../types/types";
import { log, uuid } from "../helpers";
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
  onEditPoolNote,
  onEditGoalNote,
  view = "main",
  editTitleCb,
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

  onEditPoolNote?: Function;
  onEditGoalNote?: Function;

  view?: "main" | "harvest" | "list";
  editTitleCb?: Function | undefined;
}) {
  const navigate = useNavigate();
  const setPools = useStore((store: any) => store.setPools);

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
  const toggleGoalPermsDialog = useStore(
    (store: any) => store.toggleGoalPermsDialog
  );
  const toggleGoalTagsDialog = useStore(
    (store: any) => store.toggleGoalTagsDialog
  );

  const setSelectedGoals = useStore((store: any) => store.setSelectedGoals);
  const roleMap = useStore((store: any) => store.roleMap);
  const role = roleMap.get(pin?.birth);

  const setHarvestGoals = useStore((store: any) => store.setHarvestGoals);

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
      setParentTrying(false);
    }
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
      setParentTrying(false);
    }
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
      setParentTrying(false);
    }
  };
  const archivePool = async () => {
    handleClose();
    setParentTrying(true);

    try {
      const result = await api.archivePool(pin);
      log("archivePool result => ", result);
      toggleSnackBar(true, {
        message: "successfully archived pool",
        severity: "success",
      });
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to archive pool",
        severity: "error",
      });
      log("archivePool error => ", e);
      setParentTrying(false);
    }
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
      setParentTrying(false);
    }
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
      setParentTrying(false);
    }
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
      setParentTrying(false);
    }
  };
  const archiveGoal = async () => {
    handleClose();
    setParentTrying(true);

    try {
      const result = await api.archiveGoal(id);
      log("archiveGoal result => ", result);
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to archive goal",
        severity: "error",
      });
      log("archiveGoal error => ", e);
      setParentTrying(false);
    }
  };
  const renewGoal = async () => {
    handleClose();
    setParentTrying(true);

    try {
      const result = await api.renewGoal(id);
      log("renewGoal result => ", result);
      toggleSnackBar(true, {
        message: "successfully renewed goal",
        severity: "success",
      });
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to renew goal",
        severity: "error",
      });
      log("archiveGoal error => ", e);
      setParentTrying(false);
    }
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
      setParentTrying(false);
    }
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
      setParentTrying(false);
    }
  };
  const handleTimeline = () => {
    handleClose();
    const kickoff = currentGoal.nexus.kickoff?.moment;
    const deadline = currentGoal.nexus.deadline?.moment;
    log("kickoff", kickoff);
    log("deadline", deadline);

    toggleTimelineDialog(true, {
      title: currentGoal.hitch.desc,
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
    setSelectedGoals(startingConnections);
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
    setSelectedGoals(startingConnections);
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
      setParentTrying(false);
    }
  };
  const goTo = (destination: string) => {
    navigate(destination);
  };
  const renderTreeGoalMenu = () => {
    if (isArchived)
      return (
        <div>
          <MenuItem onClick={renewGoal} disableRipple>
            <RestoreOutlinedIcon fontSize="small" />
            renew
          </MenuItem>
          <MenuItem onClick={deleteGoal} disableRipple>
            <DeleteOutlineOutlinedIcon fontSize="small" />
            delete
          </MenuItem>
        </div>
      );

    return (
      <div>
        <MenuItem
          onClick={() => {
            handleClose();
            goTo("/apps/gol-cli/goal/~" + id?.owner + "/" + id?.birth);
          }}
          disableRipple
        >
          go to page
        </MenuItem>
        <MenuItem
          onClick={() => {
            handleClose();
            editTitleCb && setTimeout(() => editTitleCb(), 200);
          }}
          disableRipple
        >
          edit
        </MenuItem>
        <MenuItem
          onClick={() => {
            handleClose();
            toggleGoalTagsDialog(true, {
              title: currentGoal.hitch.desc,
              id,
              tags: currentGoal.hitch.tags,
            });
          }}
          disableRipple
        >
          Manage Tags
        </MenuItem>
        <MenuItem
          onClick={() => {
            handleClose();
            onEditGoalNote && onEditGoalNote();
          }}
          disableRipple
        >
          note
        </MenuItem>
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
        <Divider />
        <MenuItem
          onClick={() => {
            handleClose();
            toggleGoalPermsDialog(true, {
              pin,
              id,
              title: currentGoal.hitch.desc,
              chief: currentGoal.nexus.chief,
              ranks: currentGoal.nexus.ranks,
              spawn: currentGoal.nexus.spawn,
            });
          }}
          disableRipple
        >
          <PeopleAltOutlinedIcon fontSize="small" />
          manage participants
        </MenuItem>
        <MenuItem onClick={handleTimeline} disableRipple>
          <CalendarMonthOutlinedIcon fontSize="small" />
          timeline
        </MenuItem>

        {/* We hide these from harvest panel */}
        {!harvestGoal && (
          <>
            <Divider />
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
        {(role === "owner" || role === "admin") && (
          <MenuItem onClick={deleteGoal} disableRipple>
            <DeleteOutlineOutlinedIcon fontSize="small" />
            delete
          </MenuItem>
        )}
      </div>
    );
  };
  const renderAltViewGoalMenu = () => {
    return (
      <div>
        {currentGoal?.nexus.par && (
          <MenuItem
            onClick={() => {
              //navigate to parent goal if any
              goTo(
                "/apps/gol-cli/goal/~" +
                  currentGoal?.nexus.par?.owner +
                  "/" +
                  currentGoal?.nexus.par?.birth
              );
            }}
            disableRipple
          >
            go to parent goal
          </MenuItem>
        )}

        <MenuItem
          onClick={() => {
            handleClose();
            goTo("/apps/gol-cli/goal/~" + id?.owner + "/" + id?.birth);
          }}
          disableRipple
        >
          go to page
        </MenuItem>
        <Divider />

        <MenuItem
          onClick={() => {
            handleClose();
            toggleGoalTagsDialog(true, {
              title: currentGoal.hitch.desc,
              id,
              tags: currentGoal.hitch.tags,
            });
          }}
          disableRipple
        >
          manage tags
        </MenuItem>
        <Divider />

        {complete ? (
          <MenuItem onClick={unmarkComplete} disableRipple>
            incomplete
          </MenuItem>
        ) : (
          <MenuItem onClick={markComplete} disableRipple>
            complete
          </MenuItem>
        )}
        {actionable ? (
          <MenuItem onClick={unmarkActionable} disableRipple>
            remove actionable
          </MenuItem>
        ) : (
          <MenuItem onClick={markActionable} disableRipple>
            make actionable
          </MenuItem>
        )}
        <Divider />
        <MenuItem onClick={archiveGoal} disableRipple>
          archive
        </MenuItem>
        {(role === "owner" || role === "admin") && (
          <MenuItem onClick={deleteGoal} disableRipple>
            delete
          </MenuItem>
        )}
      </div>
    );
  };
  const renderGoalMenu = () => {
    if (view === "main") return renderTreeGoalMenu();
    else if (view === "harvest" || view === "list")
      return renderAltViewGoalMenu();
  };
  const renderPoolMenu = () => {
    if (isArchived) {
      return (
        <div>
          <MenuItem onClick={renewPool} disableRipple>
            <RestoreOutlinedIcon fontSize="small" />
            renew
          </MenuItem>
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
        </div>
      );
    }

    return (
      <div>
        {(role === "owner" || role === "admin") && (
          <>
            <MenuItem
              onClick={() => {
                handleClose();
                goTo("/apps/gol-cli/pool/~" + pin?.owner + "/" + pin?.birth);
              }}
              disableRipple
            >
              <PeopleAltOutlinedIcon fontSize="small" />
              go to page{" "}
            </MenuItem>
            <MenuItem
              onClick={() => {
                handleClose();
                editTitleCb && setTimeout(() => editTitleCb(), 200);
              }}
              disableRipple
            >
              edit
            </MenuItem>
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
            leave pool
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
          duplicate pool
        </MenuItem>
        <MenuItem
          onClick={async () => {
            handleClose();
            const link = `/${pin?.owner}/${pin?.birth}`;

            if (navigator.clipboard) {
              try {
                await navigator.clipboard.writeText(link);
                log("copied link to clipboard");
              } catch (err) {
                log("failed  to copy link to clipboard", err);
              }
            } else {
              alert(link);
            }
          }}
          disableRipple
        >
          <ContentCopyOutlinedIcon fontSize="small" />
          link
        </MenuItem>
        {role === "owner" && (
          <>
            <Divider />

            <MenuItem
              onClick={() => {
                handleClose();
                onEditPoolNote && onEditPoolNote();
              }}
              disableRipple
            >
              Note
            </MenuItem>
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
    );
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
        {type === "goal" ? renderGoalMenu() : renderPoolMenu()}
      </StyledMenu>
    </Box>
  );
}
