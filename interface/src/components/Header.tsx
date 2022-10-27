import React, { useState } from "react";
import Box from "@mui/material/Box";
import api from "../api";
import OutlinedInput from "@mui/material/OutlinedInput";
import InputAdornment from "@mui/material/InputAdornment";
import IconButton from "@mui/material/IconButton";
import AddIcon from "@mui/icons-material/Add";

import useStore from "../store";
import { log } from "../helpers";
import CircularProgress from "@mui/material/CircularProgress";
import { Order } from "../types/types";
import KeyboardDoubleArrowDownIcon from "@mui/icons-material/KeyboardDoubleArrowDown";
import KeyboardDoubleArrowUpIcon from "@mui/icons-material/KeyboardDoubleArrowUp";
import { orderPoolsAction } from "../store/actions";
import Stack from "@mui/material/Stack";
import Checkbox from "@mui/material/Checkbox";
import FormControlLabel from "@mui/material/FormControlLabel";
import Divider from "@mui/material/Divider";
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
  ArchiveDialog
} from "./";

import MenuItem from "@mui/material/MenuItem";
import FormControl from "@mui/material/FormControl";
import InputLabel from "@mui/material/InputLabel";
import Select, { SelectChangeEvent } from "@mui/material/Select";
import TextField from "@mui/material/TextField";
import Autocomplete from "@mui/material/Autocomplete";
const filterOptions = () => ["Complete", "Incomplete", "Actionable"];
export default function Header() {
  const [newProjectTitle, setNewProjectTitle] = useState<string>("");
  const [trying, setTrying] = useState<boolean>(false);
  const [filterValue, setFilterValue] = React.useState<string | null>(null);

  const order = useStore((store) => store.order);
  const selectionMode = useStore((store) => store.selectionMode);

  const setFilterGoals = useStore((store) => store.setFilterGoals);

  const setCollapseAll = useStore((store) => store.setCollapseAll);

  const toggleSnackBar = useStore((store) => store.toggleSnackBar);

  const toggleShowArchived = useStore((store) => store.toggleShowArchived);
  const showArchived = useStore((store) => store.showArchived);

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
    toggleShowArchived(!showArchived);
  };
  const handleFilterUpdate = (newValue: string | null) => {
    log("newValue", newValue);
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
  return (
    <Box
      sx={{
        position: "sticky",
        top: 0,
        paddingTop: 2,
        backgroundColor: "#eedfc9",
        marginBottom: 2,
      }}
      zIndex={1}
    >
      <ShareDialog pals={[]} />
      {selectionMode ? <YokingActionBar /> : <Log />}
      <HarvestPanel />
      <DeletionDialog />
      <LeaveDialog />
      <TimelineDialog />
      <CopyPoolDialog />
      <ArchiveDialog />
      <GroupsShareDialog />
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
              <MenuItem value={"prio"}>By Priortiy</MenuItem>
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
      </Stack>

      <Divider sx={{ paddingTop: 2 }} />
    </Box>
  );
}
