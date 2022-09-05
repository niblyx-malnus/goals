import * as React from "react";
import { styled, alpha } from "@mui/material/styles";
import Button from "@mui/material/Button";
import Menu, { MenuProps } from "@mui/material/Menu";
import MenuItem from "@mui/material/MenuItem";
import EditIcon from "@mui/icons-material/Edit";
import Divider from "@mui/material/Divider";
import ArchiveIcon from "@mui/icons-material/Archive";
import FileCopyIcon from "@mui/icons-material/FileCopy";
import MoreHorizIcon from "@mui/icons-material/MoreHoriz";
import KeyboardArrowDownIcon from "@mui/icons-material/KeyboardArrowDown";
import IconButton from "@mui/material/IconButton";
import CheckIcon from "@mui/icons-material/Check";
import DeleteIcon from "@mui/icons-material/Delete";
import ClearIcon from "@mui/icons-material/Clear";
import { GoalId, PinId } from "../types/types";
import { log } from "../helpers";
import api from "../api";

const StyledMenu = styled((props: MenuProps) => (
  <Menu
    elevation={0}
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
    marginTop: theme.spacing(1),
    minWidth: 180,
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
        fontSize: 18,
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
}: {
  complete?: boolean;
  id?: GoalId;
  pin?: PinId;
  type: "pool" | "goal";
}) {
  const [anchorEl, setAnchorEl] = React.useState<null | HTMLElement>(null);
  const open = Boolean(anchorEl);
  const handleClick = (event: React.MouseEvent<HTMLElement>) => {
    setAnchorEl(event.currentTarget);
  };
  const handleClose = () => {
    setAnchorEl(null);
  };
  const markComplete = async () => {
    handleClose();

    try {
      const result = await api.markComplete(id);
      log("markComplete result => ", result);
    } catch (e) {
      log("markComplete error => ", e);
    }
  };
  const unmarkComplete = async () => {
    handleClose();
    try {
      const result = await api.unmarkComplete(id);
      log("unmarkComplete result => ", result);
    } catch (e) {
      log("unmarkComplete error => ", e);
    }
  };
  const deletePool = async () => {
    handleClose();
    try {
      const result = await api.deletePool(pin);
      log("deletePool result => ", result);
    } catch (e) {
      log("deletePool error => ", e);
    }
  };
  const deleteGoal = async () => {
    handleClose();
    try {
      const result = await api.deleteGoal(id);
      log("deleteGoal result => ", result);
    } catch (e) {
      log("deleteGoal error => ", e);
    }
  };
  //TODO: in open state it should still display the icon button
  //TODO: in trying mode it should disable the button and goal/project and show a loading element (spinner)
  return (
    <div>
      <IconButton
        className="menu-button"
        //sx={{ position: "absolute", left: -35 }}
        aria-label="menu button"
        size="small"
        aria-controls={open ? "demo-customized-menu" : undefined}
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
          horizontal: "left",
        }}
        id="demo-customized-menu"
        MenuListProps={{
          "aria-labelledby": "demo-customized-button",
        }}
        anchorEl={anchorEl}
        open={open}
        onClose={handleClose}
      >
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
        <MenuItem
          onClick={type === "pool" ? deletePool : deleteGoal}
          disableRipple
        >
          <DeleteIcon fontSize="small" color="error" />
          delete
        </MenuItem>
      </StyledMenu>
    </div>
  );
}
