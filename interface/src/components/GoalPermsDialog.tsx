import React, { useEffect, useState } from "react";

import Button from "@mui/material/Button";
import TextField from "@mui/material/TextField";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogContentText from "@mui/material/DialogContentText";
import DialogTitle from "@mui/material/DialogTitle";
import Autocomplete from "@mui/material/Autocomplete";
import Stack from "@mui/material/Stack";
import { log, shipName } from "../helpers";
import Chips from "./Chips";
import InputLabel from "@mui/material/InputLabel";
import MenuItem from "@mui/material/MenuItem";
import FormControl from "@mui/material/FormControl";
import Typography from "@mui/material/Typography";
import IconButton from "@mui/material/IconButton";
import AddIcon from "@mui/icons-material/Add";
import LoadingButton from "@mui/lab/LoadingButton";
import Checkbox from "@mui/material/Checkbox";

import FormControlLabel from "@mui/material/FormControlLabel";
import Select, { SelectChangeEvent } from "@mui/material/Select";
import useStore from "../store";
import api from "../api";
const ob = require("urbit-ob");

//TODO: add suggestion ship input includes all the viewers and relevant ships
interface ChipData {
  key: string;
  label: string;
  canDelete: boolean;
}
const ChipsGroup = ({
  title,
  data,
  onDelete,
}: {
  title: string;
  data: ChipData[];
  onDelete: Function;
}) => {
  if (data.length === 0) return null;
  return (
    <Stack flexDirection={"column"} marginTop={1}>
      <Typography variant="subtitle2" fontWeight={"bold"}>
        {title}
      </Typography>
      <Chips
        keyRole={title}
        chipData={data}
        canDelete={true}
        onDelete={onDelete}
      />
    </Stack>
  );
};
const Inputs = ({
  handleAdd,
  canEditChief,
  trying,
}: {
  handleAdd: Function;
  canEditChief: boolean;
  trying: boolean;
}) => {
  const [inputValue, setInputValue] = useState<string>("~");
  const [value, setValue] = useState<string>("~");

  const [role, setRole] = useState("Spawn");
  const [pathErrorMessage, setPathErrorMessage] = useState<string>("");
  const [pathError, setPathError] = useState<boolean>(false);
  const handleRoleChange = (event: SelectChangeEvent) => {
    setRole(event.target.value as string);
  };
  const keyHandler = (event: any) => {
    if (event.keyCode === 13) {
      onAdd();
    }
  };
  const validateShipName = (value: string) => {
    try {
      const isValid = ob.isValidPatp(value);

      if (!isValid) {
        setPathErrorMessage("Make sure the ship you entered exists");
        setPathError(true);
        throw Error("ship name not valid");
      }
      setPathErrorMessage("");
      setPathError(false);
      //it's valid, go ahead and try to share this
    } catch (e) {
      throw Error("ship name not valid");
    }
  };
  const onAdd = () => {
    handleAdd(
      inputValue,
      setInputValue,
      role,
      setPathError,
      setPathErrorMessage,
      validateShipName
    );
  };
  return (
    <Stack flexDirection="row" alignItems="center" justifyContent="center">
      <Autocomplete
        sx={{ flex: 1, marginTop: 1, marginBottom: 1 }}
        freeSolo
        id="pals-autocomplete"
        disableClearable
        options={[]}
        value={value}
        onChange={(event, value) => {
          setValue(value);
        }}
        inputValue={inputValue}
        onInputChange={(event, value) => {
          setInputValue(value);
        }}
        renderInput={(params) => (
          <TextField
            {...params}
            sx={{
              "& .MuiFormHelperText-root": {
                position: "absolute",
                bottom: "-1.2rem",
              },
            }}
            spellCheck="false"
            error={pathError}
            helperText={pathErrorMessage}
            size="small"
            id="name"
            label="@p"
            type="text"
            autoFocus
            fullWidth
            onKeyUp={keyHandler}
          />
        )}
      />
      <FormControl sx={{ width: 110 }}>
        <InputLabel id="role-select-label">Role</InputLabel>
        <Select
          size="small"
          labelId="role-select-label"
          id="role-select"
          value={role}
          label="Role"
          onChange={handleRoleChange}
        >
          <MenuItem value={"Spawn"}>Spawn</MenuItem>
          {canEditChief && <MenuItem value={"Chief"}>Chief</MenuItem>}
        </Select>
      </FormControl>
      <IconButton
        aria-label="add ship to pool"
        size="small"
        onClick={onAdd}
        disabled={trying}
      >
        <AddIcon />
      </IconButton>
    </Stack>
  );
};
export default function GoalPermsDialog() {
  const open = useStore((store: any) => store.goalPermsDialogOpen);
  const toggleGoalPermsDialog = useStore(
    (store: any) => store.toggleGoalPermsDialog
  );
  const goalPermsDialogData = useStore(
    (store: any) => store.goalPermsDialogData
  );
  const toggleSnackBar = useStore((store) => store.toggleSnackBar);
  const roleMap = useStore((store: any) => store.roleMap);
  //can edit chief => in ranks
  //chief chips group
  //spawn chips group
  //roles => chief/spawn
  //spawnList
  //chiefList
  //is admin/owner?
  const [chief, setChief] = useState<ChipData[]>([]);
  const [spawnList, setSpawnList] = useState<ChipData[]>([]);
  const [applyRecursively, setApplyRecursively] = useState<boolean>(false);
  const [trying, setTrying] = useState<boolean>(false);
  const [canEditChief, setCanEditChief] = useState<boolean>(true);

  const onClose = () => {
    toggleGoalPermsDialog(false, null);
    //reset our lists
    setChief([]);
    setSpawnList([]);
    setCanEditChief(false);
    setApplyRecursively(false);
  };

  const hanldeUpdateGoalPerms = async () => {
    setTrying(true);
    try {
      const newChief = chief[0].label;
      const newSpawnList = spawnList.map((chipItem: any) => {
        return chipItem.label;
      });
      const result = await api.updateGoalPermissions(
        goalPermsDialogData.id,
        newChief,
        newSpawnList,
        applyRecursively
      );
      handleClose();
      toggleSnackBar(true, {
        message: "successfully updated goal permissions",
        severity: "success",
      });
      log("hanldeUpdateGoalPerms result => ", result);
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to update goal permissions",
        severity: "error",
      });
      log("hanldeUpdateGoalPerms error => ", e);
    }
    setTrying(false);
  };
  const handleDeleteSpawn = (chipToDelete: ChipData) => {
    if (trying) return;

    setSpawnList((chips) =>
      chips.filter((chip) => chip.label !== chipToDelete.label)
    );
  };
  const handleDeleteChief = (chipToDelete: ChipData) => {
    if (trying) return;

    setChief([]);
  };

  const handleAdd = (
    inputValue: any,
    setInputValue: any,
    role: any,
    setPathError: any,
    setPathErrorMessage: any,
    validateShipName: Function
  ) => {
    if (trying) return;
    //make sure the entered p is for real for real
    try {
      validateShipName(inputValue);
    } catch (e) {
      log("e", e);
      return;
    }
    //we remove white space around the text
    let label = inputValue.trim();
    //we remove the ~
    label = label.substring(1);
    //if no text, we abort
    if (label.length === 0) return;
    const checkForShip = (obj: any) => obj.label === label;

    if (role === "Spawn") {
      const spawnExists = spawnList.some(checkForShip);
      const chiefExists = chief.some(checkForShip);

      if (spawnExists) {
        setPathErrorMessage("This ship aready in spawn");
        setPathError(true);
        return;
      }
      if (chiefExists) {
        setPathErrorMessage("This ship is a chief");
        setPathError(true);
        return;
      }

      const newSpawnList = [
        ...spawnList,
        { key: "spawn-" + spawnList.length + 1, label, canDelete: true },
      ];

      setSpawnList(newSpawnList);
    } else if (role === "Chief") {
      const spawnExists = spawnList.some(checkForShip);
      if (spawnExists) {
        setPathErrorMessage("This ship is in spawn");
        setPathError(true);
        return;
      }
      //we only manage one chief, so crush the existing one
      const newChief = [{ key: "chief-0", label, canDelete: false }];
      setChief(newChief);
    }
    setInputValue("~");
  };
  const handleClose = () => {
    onClose();
  };
  const handleApplyRecursivelyChange = () => {
    setApplyRecursively(!applyRecursively);
  };
  useEffect(() => {
    if (!goalPermsDialogData) return;
    const roleInPool = roleMap.get(goalPermsDialogData.pin.birth);
    //if current ship exists in ranks, it can edit the chief
    const canEditChief =
      goalPermsDialogData.ranks.filter(
        (rankItem: any) => rankItem.ship === shipName()
      ).length > 0 ||
      roleInPool === "admin" ||
      roleInPool === "owner";
    const chief = [
      {
        key: "chief-0",
        label: goalPermsDialogData.chief,
        canDelete: false,
      },
    ];
    const newSpawnList = goalPermsDialogData.spawn.map(
      (item: any, index: number) => {
        return { key: "spawn-" + index, label: item, canDelete: true };
      }
    );
    setCanEditChief(canEditChief);
    setChief(chief);
    setSpawnList(newSpawnList);
  }, [open, goalPermsDialogData]);
  //if we dont have data we dont render
  if (!goalPermsDialogData) return null;
  return (
    <Dialog
      open={open}
      onClose={handleClose}
      onClick={(event) => event.stopPropagation()}
      maxWidth={"sm"}
      fullWidth
    >
      <DialogTitle fontWeight={"bold"}>
        Goal Permissions ({goalPermsDialogData.title})
      </DialogTitle>
      <DialogContent>
        <DialogContentText sx={{ color: "text.primary" }}>
          Enter the ship and assign it a role
        </DialogContentText>
        <Inputs
          handleAdd={handleAdd}
          canEditChief={canEditChief}
          trying={trying}
        />
        <ChipsGroup title={"Chief"} data={chief} onDelete={handleDeleteChief} />
        <FormControlLabel
          sx={{ height: 36.5 }}
          label="Apply chief to all sub-goals"
          control={
            <Checkbox
              sx={{ padding: 0.75 }}
              checked={applyRecursively}
              onChange={handleApplyRecursivelyChange}
            />
          }
        />
        <ChipsGroup
          title={"Spawn"}
          data={spawnList}
          onDelete={handleDeleteSpawn}
        />
      </DialogContent>
      <DialogActions>
        <Button
          disabled={trying}
          sx={{ color: "text.primary" }}
          onClick={handleClose}
        >
          Cancel
        </Button>
        <LoadingButton
          variant="contained"
          loading={trying}
          onClick={hanldeUpdateGoalPerms}
        >
          Save
        </LoadingButton>
      </DialogActions>
    </Dialog>
  );
}
