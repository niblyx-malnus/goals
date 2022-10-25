import React, { useState } from "react";

import Button from "@mui/material/Button";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogContentText from "@mui/material/DialogContentText";
import DialogTitle from "@mui/material/DialogTitle";
import Stack from "@mui/material/Stack";
import { log, shipName } from "../helpers";
import InputLabel from "@mui/material/InputLabel";
import MenuItem from "@mui/material/MenuItem";
import FormControl from "@mui/material/FormControl";

import LoadingButton from "@mui/lab/LoadingButton";
import Alert from "@mui/material/Alert";

import Select, { SelectChangeEvent } from "@mui/material/Select";
import useStore from "../store";
import api from "../api";

export default function GroupsShareDialog() {
  const [groupName, setGroupName] = useState<string>("");

  const [role, setRole] = useState("Viewer");
  const open = useStore((store: any) => store.groupsShareDialogOpen);
  const toggleGroupsShareDialog = useStore(
    (store: any) => store.toggleGroupsShareDialog
  );
  const groupsShareDialogData = useStore(
    (store: any) => store.groupsShareDialogData
  );
  const groupsMap = useStore((store: any) => store.groupsMap);
  const groupsList = useStore((store: any) => store.groupsList);

  const toggleSnackBar = useStore((store) => store.toggleSnackBar);

  const handleRoleChange = (event: SelectChangeEvent) => {
    setRole(event.target.value as string);
  };
  const handleGroupNameCange = (event: SelectChangeEvent) => {
    setGroupName(event.target.value as string);
  };

  const [trying, setTrying] = useState<boolean>(false);

  const handleClose = () => {
    //reset select to have viewer
    setRole("Viewer");
    setGroupName("");
    toggleGroupsShareDialog(false, null);
  };

  const inviteGroupMembers = async () => {
    //we combine the new @p with the existing ones from this pool to construct our new permision lists
    //get the @ps related to the selected group name
    setTrying(true);
    try {
      const group: any = groupsMap.get(groupName);
      const members = group?.members;
      log("group", group);
      log("members", members);

      //create the new invites
      const invites = members
        .map((ship: string) => {
          if (role === "Admin") {
            return { role: "admin", ship };
          } else if (role === "Chef") {
            return { role: "spawn", ship };
          } else if (role === "Viewer") {
            return { role: null, ship };
          }
        })
        //make sure the current ship is removed from the invites
        .filter((invite: any) => {
          return shipName() !== invite.ship;
        });
        log('invites',invites)
      //combine invites and the existing perms
      const newRoleList = [
        ...groupsShareDialogData.participants.permList,
        ...invites,
      ];

      const result = await api.updatePoolPermissions(
        groupsShareDialogData.pin,
        newRoleList
      );
      toggleSnackBar(true, {
        message: "successfully sent invites",
        severity: "success",
      });
      handleClose();
      log("updatePoolPerms result =>", result);
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to send invites",
        severity: "error",
      });
      log("updatePoolPerms error =>", e);
    }
    setTrying(false);
    handleClose();
  };
  //TODO: we fetch if no groups data
  //if we dont have data we dont render
  if (!groupsShareDialogData) return null;
  return (
    <Dialog
      open={open}
      onClose={handleClose}
      onClick={(event) => event.stopPropagation()}
      maxWidth={"sm"}
      fullWidth
    >
      <DialogTitle fontWeight={"bold"}>
        Share ({groupsShareDialogData.title}) with a group
      </DialogTitle>
      <DialogContent>
        <DialogContentText sx={{ color: "text.primary" }}>
          Select one of your groups
        </DialogContentText>

        <Stack
          flexDirection="row"
          alignItems="center"
          justifyContent="center"
          marginBottom={1}
          marginTop={1}
        >
          <FormControl sx={{ width: "100%" }}>
            <InputLabel id="group-name-select-label" size="small">
              Group
            </InputLabel>
            <Select
              size="small"
              labelId="group-name-select-label"
              id="group-name-select"
              value={groupName}
              label="group"
              onChange={handleGroupNameCange}
            >
              {groupsList.map((group: any, index: number) => {
                return (
                  <MenuItem key={"group-element-" + index} value={group.name}>
                    {group.name} ({group.memberCount})
                  </MenuItem>
                );
              })}
            </Select>
          </FormControl>
          <FormControl sx={{ width: 150 }}>
            <InputLabel id="demo-simple-select-label" size="small">
              Role
            </InputLabel>
            <Select
              size="small"
              labelId="demo-simple-select-label"
              id="demo-simple-select"
              value={role}
              label="Role"
              onChange={handleRoleChange}
            >
              <MenuItem value={"Viewer"}>Viewer</MenuItem>
              <MenuItem value={"Chef"}>Chef</MenuItem>
              <MenuItem value={"Admin"}>Admin</MenuItem>
            </Select>
          </FormControl>
        </Stack>
        <Alert severity="warning">
          Be aware that inviting too many ships (100+) could take a while
        </Alert>
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
          onClick={inviteGroupMembers}
          disabled={!groupName}
        >
          Send
        </LoadingButton>
      </DialogActions>
    </Dialog>
  );
}
