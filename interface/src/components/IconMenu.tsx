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
import Box from "@mui/material/Box";
import { GoalId, PinId } from "../types/types";
import { log } from "../helpers";
import api from "../api";
import {
  deletePoolAction,
  deleteGoalAction,
  toggleCompleteAction,
} from "../store/actions";
import useStore from "../store";

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
  id,
  pin,
  type,
  setParentTrying,
  poolData,
}: {
  complete?: boolean;
  id?: GoalId;
  pin?: PinId;
  type: "pool" | "goal";
  setParentTrying: Function;
  poolData?: any;
}) {
  const [anchorEl, setAnchorEl] = React.useState<null | HTMLElement>(null);
  const open = Boolean(anchorEl);
  const toggleShareDialog = useStore((store: any) => store.toggleShareDialog);
  const toggleDeleteDialog = useStore((store: any) => store.toggleDeleteDialog);
  const toggleLeaveDialog = useStore((store: any) => store.toggleLeaveDialog);
  const toggleSnackBar = useStore((store) => store.toggleSnackBar);

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
  return (
    <Box
      className="show-on-hover"
      sx={{ opacity: open ? 1 : 0, position: "absolute", left: -30 }}
    >
      <IconButton
        className="menu-button"
        //sx={{ position: "absolute", left: -35 }}
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
          horizontal: "left",
        }}
        transformOrigin={{
          vertical: "top",
          horizontal: "right",
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
