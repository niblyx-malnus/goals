import React, { useState, useEffect } from "react";
import Box from "@mui/material/Box";
import api from "../api";
import OutlinedInput from "@mui/material/OutlinedInput";
import InputAdornment from "@mui/material/InputAdornment";
import IconButton from "@mui/material/IconButton";
import AddIcon from "@mui/icons-material/Add";
import LoginOutlinedIcon from "@mui/icons-material/LoginOutlined";
import useStore from "../store";
import { log } from "../helpers";
import CircularProgress from "@mui/material/CircularProgress";
import { ChipData, Order } from "../types/types";
import KeyboardDoubleArrowDownIcon from "@mui/icons-material/KeyboardDoubleArrowDown";
import KeyboardDoubleArrowUpIcon from "@mui/icons-material/KeyboardDoubleArrowUp";
import { orderPoolsAction } from "../store/actions";
import Stack from "@mui/material/Stack";
import Checkbox from "@mui/material/Checkbox";
import FormControlLabel from "@mui/material/FormControlLabel";
import Divider from "@mui/material/Divider";
import Typography from "@mui/material/Typography";
import FilterAltOutlinedIcon from "@mui/icons-material/FilterAltOutlined";
import Chip from "@mui/material/Chip";
import {
  ShareDialog,
  DeletionDialog,
  LeaveDialog,
  Snackie,
  Log,
  TimelineDialog,
  CopyPoolDialog,
  YokingActionBar,
  GroupsShareDialog,
  HarvestPanel,
  ArchiveDialog,
  GoalPermsDialog,
  JoinPoolDialog,
  GoalTagsDialog,
  FilterTagsDialog,
} from "./";
import Tooltip from "@mui/material/Tooltip";

import MenuItem from "@mui/material/MenuItem";
import FormControl from "@mui/material/FormControl";
import InputLabel from "@mui/material/InputLabel";
import Select, { SelectChangeEvent } from "@mui/material/Select";
import TextField from "@mui/material/TextField";
import Autocomplete from "@mui/material/Autocomplete";
import { useTheme } from "@mui/material/styles";
import Brightness4Icon from "@mui/icons-material/Brightness4";
import Brightness7Icon from "@mui/icons-material/Brightness7";

const filterOptions = () => ["Complete", "Incomplete", "Actionable"];

export default function Header() {
  const theme = useTheme();
  const setColorMode = useStore((store) => store.setColorMode);

  const [newProjectTitle, setNewProjectTitle] = useState<string>("");
  const [trying, setTrying] = useState<boolean>(false);
  const [filterValue, setFilterValue] = React.useState<string | null>(null);

  const order = useStore((store) => store.order);
  const selectionMode = useStore((store) => store.selectionMode);

  const setFilterGoals = useStore((store) => store.setFilterGoals);

  const setCollapseAll = useStore((store) => store.setCollapseAll);

  const toggleSnackBar = useStore((store) => store.toggleSnackBar);

  const toggleShowArchived = useStore((store) => store.toggleShowArchived);

  const toggleFilterTagsDialog = useStore(
    (store) => store.toggleFilterTagsDialog
  );

  const showArchived = useStore((store) => store.showArchived);

  const toggleJoinPoolDialogOpen = useStore(
    (store: any) => store.toggleJoinPoolDialogOpen
  );

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setNewProjectTitle(event.target.value);
  };
  const handleKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    if (event.key === "Enter") {
      addNewPool();
    }
  };
  const addNewPool = async () => {
    if (newProjectTitle?.length > 0) {
      setTrying(true);
      try {
        const result = await api.addPool(newProjectTitle);
        log("addNewPool result => ", result);
        toggleSnackBar(true, {
          message: "successfully added pool",
          severity: "success",
        });
      } catch (e) {
        toggleSnackBar(true, {
          message: "failed to add pool",
          severity: "error",
        });
        log("addNewPool error =>", e);
      }
      setNewProjectTitle("");
      setTrying(false);
    }
  };

  const handleOrderChange = (event: SelectChangeEvent) => {
    orderPoolsAction(event.target.value as Order);
  };
  const handleShowArchived = () => {
    toggleShowArchived();
  };
  const handleFilterUpdate = (newValue: string | null) => {
    setFilterValue(newValue);
    if (newValue === null) {
      //clear filter
      setFilterGoals(null);
    } else if (newValue === "Complete") {
      //activate the complete filter
      setFilterGoals("incomplete");
    } else if (newValue === "Incomplete") {
      //activate the incomplete filter
      setFilterGoals("complete");
    } else if (newValue === "Actionable") {
      //activate the actionable filter
      setFilterGoals("actionable");
    }
  };

  const setCtrlPressed = useStore((store) => store.setCtrlPressed);

  const onKeyDown = (event: any) => {
    if (event.ctrlKey && event.shiftKey && event.key === "Y") {
      // ctrl + ship + Y
      setCollapseAll(true);
    } else if (event.ctrlKey && event.shiftKey && event.key === "U") {
      // ctrl + ship + U
      setCollapseAll(false);
    } else if (event.ctrlKey && event.shiftKey && event.key === "P") {
      // ctrl + ship + P
      toggleShowArchived();
    } else if (event.key === "Control") {
      //this will display shortcut actions on our goals/pools
      setCtrlPressed(true);
    }
  };
  const onKeyUp = (event: any) => {
    if (event.key === "Control") {
      setCtrlPressed(false);
    }
  };
  const onWindowBlur = (event: any) => {
    setCtrlPressed(false);
  };
  useEffect(() => {
    document.addEventListener("keydown", onKeyDown);
    document.addEventListener("keyup", onKeyUp);
    window.addEventListener("blur", onWindowBlur);

    return () => {
      document.removeEventListener("keyup", onKeyDown);
      document.addEventListener("keyup", onKeyUp);
      window.addEventListener("blur", onWindowBlur);
    };
  }, []);
  return (
    <Stack
      sx={{
        position: "sticky",
        top: 0,
        paddingTop: 2,
        marginBottom: 2,
      }}
      zIndex={1}
    >
      <ShareDialog />
      {selectionMode ? <YokingActionBar /> : <Log />}
      <HarvestPanel />
      <DeletionDialog />
      <LeaveDialog />
      <TimelineDialog />
      <CopyPoolDialog />
      <ArchiveDialog />
      <GoalPermsDialog />
      <GroupsShareDialog />
      <JoinPoolDialog />
      <GoalTagsDialog />
      <FilterTagsDialog />
      <Snackie />
      <Stack direction="row" alignItems="center" spacing={1}>
        <OutlinedInput
          id="add-new-pool"
          placeholder="Add Pool"
          value={newProjectTitle}
          onChange={handleChange}
          size={"small"}
          type={"text"}
          disabled={trying}
          onKeyDown={handleKeyDown}
          endAdornment={
            <InputAdornment position="end">
              <IconButton
                aria-label="toggle password visibility"
                onClick={addNewPool}
                edge="end"
                disabled={trying || newProjectTitle?.length === 0}
              >
                {trying ? (
                  <CircularProgress size={24} style={{ padding: 1 }} />
                ) : (
                  <AddIcon />
                )}
              </IconButton>
            </InputAdornment>
          }
        />
        <Box sx={{ width: 160 }}>
          <FormControl fullWidth>
            <InputLabel id="demo-simple-select-label">Sorting</InputLabel>
            <Select
              size="small"
              labelId="demo-simple-select-label"
              id="demo-simple-select"
              value={order}
              label="Sorting"
              onChange={handleOrderChange}
            >
              <MenuItem value={"dsc"}>Newest First </MenuItem>
              <MenuItem value={"asc"}>Oldest First</MenuItem>
              {/* <MenuItem value={"prio"}>By Priority</MenuItem> */}
            </Select>
          </FormControl>
        </Box>
        <Box sx={{ width: 160 }}>
          <Autocomplete
            size="small"
            disablePortal
            value={filterValue}
            onChange={(event: any, newValue: string | null) => {
              handleFilterUpdate(newValue);
            }}
            id="filter-goals-autocomplete-select"
            options={filterOptions()}
            renderInput={(params) => (
              <TextField {...params} label="Filter By" />
            )}
          />
        </Box>
        <FormControlLabel
          sx={{ height: 36.5 }}
          label="Show Archived"
          control={
            <Checkbox
              sx={{ padding: 0.75 }}
              checked={showArchived}
              onChange={handleShowArchived}
            />
          }
        />
        <Stack flexDirection="row" justifyContent="flex-start">
          <IconButton onClick={() => setCollapseAll(true)}>
            <KeyboardDoubleArrowDownIcon />
          </IconButton>
          <IconButton onClick={() => setCollapseAll(false)}>
            <KeyboardDoubleArrowUpIcon />
          </IconButton>
        </Stack>
        <Tooltip title="Join a pool using a link" placement="right" arrow>
          <IconButton
            aria-label="toggle password visibility"
            onClick={() => {
              toggleJoinPoolDialogOpen(true);
            }}
            edge="end"
          >
            <LoginOutlinedIcon />
          </IconButton>
        </Tooltip>
        <Box
          sx={{
            bgcolor: "background.default",
            color: "text.primary",
          }}
        >
          <IconButton
            onClick={() => {
              setColorMode(theme.palette.mode === "dark" ? "light" : "dark");
              log("hehehehe");
            }}
            color="inherit"
          >
            {theme.palette.mode === "dark" ? (
              <Brightness7Icon />
            ) : (
              <Brightness4Icon />
            )}
          </IconButton>
        </Box>
        <IconButton
          onClick={() => {
            toggleFilterTagsDialog(true);
          }}
        >
          <FilterAltOutlinedIcon />
        </IconButton>
      </Stack>
      <FilterChips />
      <Divider sx={{ paddingTop: 2 }} />
    </Stack>
  );
}
function FilterChips() {
  const [chips, setChips] = useState<ChipData[]>([]);
  const tagFilterArray = useStore((store) => store.tagFilterArray);
  useEffect(() => {
    const newChips: ChipData[] = tagFilterArray.map(
      (item: any, index: number) => {
        return { key: index.toString(), label: item, canDelete: false };
      }
    );
    setChips(newChips);
  }, [tagFilterArray]);
  if (tagFilterArray.length === 0) return null;
  return (
    <Stack direction={"row"} spacing={1} marginTop={2}>
      <Typography variant="body1">Filtering Harvested Goals By: </Typography>
      {chips.map((tag: any) => {
        return (
          <Chip
            size="small"
            label={<Typography fontWeight={"bold"}>{tag.label}</Typography>}
            variant="outlined"
          />
        );
      })}
    </Stack>
  );
}
