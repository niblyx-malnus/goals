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

export default function FilterTagsDialog() {
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
    const newfilterValues = filterValues.map((item: any) => item.title);
    setTagFilterArray(newfilterValues);
    handleClose();
  };

  const handleClose = () => {
    onClose();
  };
  useEffect(() => {
    if (open) {
      //make the list of chips ready tags
      const newTags = Array.from(allTags)?.map((item: any, index: number) => {
        return {
          key: index.toString(),
          title: item,
        };
      });
      //make sure the selected values reflect the values in the store
      const newfilterValues = tagFilterArray.map((item: any, index: number) => {
        return { key: index.toString(), title: item };
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
