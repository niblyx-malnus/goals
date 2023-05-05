import * as React from "react";

import IconButton from "@mui/material/IconButton";
import CheckIcon from "@mui/icons-material/Check";
import Stack from "@mui/material/Stack";

import DeleteOutlineOutlinedIcon from "@mui/icons-material/DeleteOutlineOutlined";
import ClearIcon from "@mui/icons-material/Clear";
import PeopleAltOutlinedIcon from "@mui/icons-material/PeopleAltOutlined";
import RestoreOutlinedIcon from "@mui/icons-material/RestoreOutlined";
import ContentCopyOutlinedIcon from "@mui/icons-material/ContentCopyOutlined";
import LaunchIcon from "@mui/icons-material/Launch";

import { GoalId, PinId } from "../types/types";
import { log } from "../helpers";
import api from "../api";
import { useNavigate } from "react-router-dom";

import useStore from "../store";

export default function QuickActions({
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
}) {
  const navigate = useNavigate();

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

  const renderGoalMenu = () => {
    if (isArchived)
      return (
        <>
          <IconButton
            // sx={{ position: "absolute", right: 35 }}
            aria-label="renew goal"
            size="small"
            onClick={renewGoal}
          >
            <RestoreOutlinedIcon fontSize="small" />
          </IconButton>
          <IconButton
            // sx={{ position: "absolute", right: 35 }}
            aria-label="delete goal"
            size="small"
            onClick={deleteGoal}
            disableRipple
          >
            <DeleteOutlineOutlinedIcon fontSize="small" />
          </IconButton>
        </>
      );

    return (
      <>
        {complete ? (
          <IconButton
            // sx={{ position: "absolute", right: 35 }}
            aria-label="mark goal incomplete"
            size="small"
            onClick={unmarkComplete}
          >
            <ClearIcon fontSize="small" />
          </IconButton>
        ) : (
          <IconButton
            // sx={{ position: "absolute", right: 35 }}
            aria-label="mark goal incomplete"
            size="small"
            onClick={markComplete}
          >
            <CheckIcon fontSize="small" />
          </IconButton>
        )}
        <IconButton
          // sx={{ position: "absolute", right: 35 }}
          aria-label="go to goal page"
          size="small"
          onClick={() => {
            navigate(
              "/apps/gol-cli/goal/~" + goalId?.owner + "/" + goalId?.birth
            );
          }}
        >
          <LaunchIcon fontSize="small" />
        </IconButton>
        <IconButton
          // sx={{ position: "absolute", right: 35 }}
          aria-label="archive goal"
          size="small"
          onClick={archiveGoal}
        >
          <DeleteOutlineOutlinedIcon fontSize="small" />
        </IconButton>
      </>
    );
  };
  const renderPoolMenu = () => {
    if (isArchived) {
      return (
        <>
          <IconButton aria-label="renew pool" size="small" onClick={renewPool}>
            <RestoreOutlinedIcon fontSize="small" />
          </IconButton>
          <IconButton
            aria-label="delete pool"
            size="small"
            onClick={() => {
              handleClose();
              toggleDeleteDialog(true, {
                title: poolData.title,
                callback: deletePool,
              });
            }}
          >
            <DeleteOutlineOutlinedIcon fontSize="small" />
          </IconButton>
        </>
      );
    }

    return (
      <>
        {(role === "owner" || role === "admin") && (
          <>
            <IconButton
              aria-label="renew pool"
              size="small"
              onClick={() => {
                handleClose();
                toggleShareDialog(true, poolData);
              }}
            >
              <PeopleAltOutlinedIcon fontSize="small" />
            </IconButton>
          </>
        )}

        <IconButton
          aria-label="get pool's link"
          size="small"
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
          <IconButton
            aria-label="go to pool page"
            size="small"
            onClick={() => {
              navigate("/apps/gol-cli/pool/~" + pin?.owner + "/" + pin?.birth);
            }}
            disableRipple
          >
            <LaunchIcon fontSize="small" />
          </IconButton>
        </IconButton>
        {role === "owner" && (
          <>
            <IconButton
              aria-label="archive pool"
              size="small"
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
            </IconButton>
          </>
        )}
      </>
    );
  };
  return (
    <Stack direction="row" marginLeft={1}>
      {type === "goal" ? renderGoalMenu() : renderPoolMenu()}
    </Stack>
  );
}
