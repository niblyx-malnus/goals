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
import { log } from "../helpers";

import IconButton from "@mui/material/IconButton";
import AddIcon from "@mui/icons-material/Add";
import LoadingButton from "@mui/lab/LoadingButton";

import useStore from "../store";
import api from "../api";
import ChipsGroup from "./ChipsGroup";
import { ChipData } from "../types/types";
import Select, { SelectChangeEvent } from "@mui/material/Select";
import InputLabel from "@mui/material/InputLabel";
import MenuItem from "@mui/material/MenuItem";
import FormControl from "@mui/material/FormControl";

export default function GoalTagsDialog() {
  const open = useStore((store: any) => store.goalTagsDialogOpen);
  const toggleGoalTagsDialog = useStore(
    (store: any) => store.toggleGoalTagsDialog
  );
  const goalTagsDialogData = useStore((store: any) => store.goalTagsDialogData);
  const toggleSnackBar = useStore((store) => store.toggleSnackBar);

  const [trying, setTrying] = useState<boolean>(false);

  const [inputValue, setInputValue] = useState<string>("");
  const [value, setValue] = useState<string>("");

  const [tags, setTags] = useState<ChipData[]>([]);
  const [privateTags, setPrivateTags] = useState<ChipData[]>([]);

  const [pathErrorMessage, setPathErrorMessage] = useState<string>("");
  const [pathError, setPathError] = useState<boolean>(false);

  const [tagType, setTagType] = useState("public");

  const handleTagTypeChange = (event: SelectChangeEvent) => {
    setTagType(event.target.value as string);
  };
  const onClose = () => {
    toggleGoalTagsDialog(false, null);
    setInputValue("");
    setTags([]);
  };

  const hanldeUpdateGoalTags = async () => {
    setTrying(true);

    try {
      //create tags for our api from our chips
      const apiPublicTags = tags.map((tag: any) => {
        return { text: tag.label, color: "", private: false };
      });
      const apiPrivateTags = privateTags.map((tag: any) => {
        return { text: tag.label, color: "", private: true };
      });
      await api.putGoalTags(goalTagsDialogData.id, apiPublicTags);
      await api.putGoalPrivateTags(goalTagsDialogData.id, apiPrivateTags);
      toggleSnackBar(true, {
        message: "successfully updated goal's tags",
        severity: "success",
      });

      handleClose();
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to update goal's tags",
        severity: "error",
      });
      log("hanldeUpdateGoalTags error => ", e);
    }
    setTrying(false);
  };
  const handleDeleteTag = (chipToDelete: ChipData) => {
    if (trying) return;

    setTags((tags) => tags.filter((tag) => tag.label !== chipToDelete.label));
  };
  const handleDeletePrivateTag = (chipToDelete: ChipData) => {
    if (trying) return;

    setPrivateTags((tags) =>
      tags.filter((tag) => tag.label !== chipToDelete.label)
    );
  };

  const handleAdd = () => {
    if (trying) return;
    //reset error state
    setPathErrorMessage("");
    setPathError(false);
    //we either select public or private tags depending on the selected tag type
    let selectTagType = tagType === "public" ? tags : privateTags;
    //check for duplication in both private and public tags
    const tagsMatchPublic = tags.filter((tag: any) => tag.label === inputValue);
    const tagsMatchPrivate = privateTags.filter(
      (tag: any) => tag.label === inputValue
    );
    if (tagsMatchPrivate.length !== 0 || tagsMatchPublic.length !== 0) {
      //throw duplication error
      setPathErrorMessage("This tag already exists");
      setPathError(true);
      return;
    }
    const newTags: ChipData[] = [...selectTagType];
    //add new tag
    newTags.push({
      key: newTags.length + "",
      label: inputValue,
      canDelete: true,
    });
    //we update either public or private tags
    tagType === "public" ? setTags(newTags) : setPrivateTags(newTags);
    setInputValue("");
  };
  const handleClose = () => {
    onClose();
  };
  useEffect(() => {
    if (goalTagsDialogData) {
      const newPrivateTags: any = [];
      const newPublicTags: any = [];

      goalTagsDialogData.tags?.forEach((item: any, index: number) => {
        if (item.private) {
          newPrivateTags.push({
            key: index.toString() + "-private",
            label: item.text,
            canDelete: true,
          });
        } else {
          newPublicTags.push({
            key: index.toString() + "-public",
            label: item.text,
            canDelete: true,
          });
        }
      });

      setTags(newPublicTags);
      setPrivateTags(newPrivateTags);
    }
  }, [goalTagsDialogData]);
  //if we dont have data we dont render
  if (!goalTagsDialogData) return null;

  return (
    <Dialog
      open={open}
      onClose={handleClose}
      onClick={(event) => event.stopPropagation()}
      maxWidth={"sm"}
      fullWidth
    >
      <DialogTitle fontWeight={"bold"}>
        Goal Tags ({goalTagsDialogData.title})
      </DialogTitle>
      <DialogContent>
        <DialogContentText sx={{ color: "text.primary" }}>
          Enter the tag
        </DialogContentText>
        <Stack
          direction={"row"}
          alignItems="center"
          justifyContent="center"
          spacing={1}
        >
          <Autocomplete
            sx={{ flex: 1, marginTop: 1, marginBottom: 1 }}
            freeSolo
            id="tags-autocomplete"
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
                label="tag"
                type="text"
                autoFocus
                fullWidth
                // onKeyUp={keyHandler}
              />
            )}
          />
          <FormControl sx={{ width: 110 }}>
            <InputLabel id="tag-type-select-label">Type</InputLabel>
            <Select
              size="small"
              labelId="tag-type-select-label"
              id="tag-select"
              value={tagType}
              label="Type"
              onChange={handleTagTypeChange}
            >
              <MenuItem value={"public"}>Public</MenuItem>
              <MenuItem value={"private"}>Private</MenuItem>
            </Select>
          </FormControl>

          <IconButton
            aria-label="add tag"
            size="small"
            onClick={handleAdd}
            disabled={trying}
          >
            <AddIcon />
          </IconButton>
        </Stack>
        <ChipsGroup
          title={"Public Tags"}
          data={tags}
          onDelete={handleDeleteTag}
        />
        <ChipsGroup
          title={"Private Tags"}
          data={privateTags}
          onDelete={handleDeletePrivateTag}
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
          onClick={hanldeUpdateGoalTags}
        >
          Save
        </LoadingButton>
      </DialogActions>
    </Dialog>
  );
}
