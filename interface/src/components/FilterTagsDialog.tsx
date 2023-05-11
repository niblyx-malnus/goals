import React, { useEffect, useState } from "react";

import Button from "@mui/material/Button";
import TextField from "@mui/material/TextField";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogTitle from "@mui/material/DialogTitle";
import Autocomplete from "@mui/material/Autocomplete";
import Stack from "@mui/material/Stack";
import useStore from "../store";
import { log } from "../helpers";
import { harvestAskAction, listAskAction } from "../store/actions";

export default function FilterTagsDialog({ pageType, pageId }: any) {
  const open = useStore((store: any) => store.filterTagsDialogOpen);
  const toggleFilterTagsDialog = useStore(
    (store: any) => store.toggleFilterTagsDialog
  );

  const goalTagsDialogData = useStore((store: any) => store.goalTagsDialogData);
  const setTagFilterArray = useStore((store) => store.setTagFilterArray);
  const tagFilterArray = useStore((store) => store.tagFilterArray);

  const allTags = useStore((store) => store.allTags);

  const [filterValues, setFilterValues] = useState<any>([]);

  const [tags, setTags] = useState<any>([]);

  const onClose = () => {
    toggleFilterTagsDialog(false, null);
    setTags([]);
  };

  const handleUpdateFilterTags = async () => {
    const newfilterValues = filterValues.map((item: any) => {
      return { text: item.text, private: item.private, color: item.color };
    });

    setTagFilterArray(newfilterValues);
    if (pageType !== "main" && pageId) {
      harvestAskAction(pageType, pageId);
      listAskAction(pageType, pageId);
      handleClose();

      return;
    } else if (pageType === "main") {
      harvestAskAction(pageType, pageId);
      listAskAction(pageType, pageId);
      handleClose();

      return;
    }
  };

  const handleClose = () => {
    onClose();
  };
  useEffect(() => {
    if (open) {
      //make the list of chips ready tags
      const newTags = allTags.map((item: any, index: number) => {
        return {
          key: index.toString(),
          title: item.text,
          ...item,
        };
      });

      //make sure the selected values reflect the values in the store
      const newfilterValues = tagFilterArray.map((item: any, index: number) => {
        return { key: index.toString(), title: item.text, ...item };
      });
      setTags(newTags);
      setFilterValues(newfilterValues);
    }
  }, [open, allTags, tagFilterArray]);

  return (
    <Dialog
      open={open}
      onClose={handleClose}
      onClick={(event) => event.stopPropagation()}
      maxWidth={"sm"}
      fullWidth
    >
      <DialogTitle fontWeight={"bold"}>Filter Goals by Tags</DialogTitle>
      <DialogContent>
        <Stack
          direction={"row"}
          alignItems="center"
          justifyContent="center"
          spacing={1}
        >
          <Autocomplete
            fullWidth
            multiple
            isOptionEqualToValue={(option: any, value: any) => {
              return option.title === value.title;
            }}
            id="filter-goals-tags-standard"
            options={tags}
            value={filterValues}
            onChange={(event: any, newValues: any) => {
              setFilterValues(newValues);
            }}
            getOptionLabel={(option: any) => {
              return option.title;
            }}
            renderInput={(params) => (
              <TextField
                {...params}
                variant="standard"
                label="Tags"
                placeholder="Search for your tag"
              />
            )}
          />
        </Stack>
      </DialogContent>
      <DialogActions>
        <Button sx={{ color: "text.primary" }} onClick={handleClose}>
          Cancel
        </Button>
        <Button variant="contained" onClick={handleUpdateFilterTags}>
          Save
        </Button>
      </DialogActions>
    </Dialog>
  );
}
