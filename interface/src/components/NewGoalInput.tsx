import React, { useEffect, useState } from "react";
import api from "../api";
import { log } from "../helpers";
import InputBase from "@mui/material/InputBase";
import Stack from "@mui/material/Stack";
import Box from "@mui/material/Box";
import CircularProgress from "@mui/material/CircularProgress";
import { GoalId, PinId } from "../types/types";
import useStore from "../store";

function NewGoalInput({
  callback,
  parentId,
  pin,
  under = false,
  isVirtual = false,
  virtualParentId,
}: {
  callback: Function;
  parentId?: GoalId;
  pin: PinId;
  under: boolean;
  virtualParentId?: GoalId;
  isVirtual?: boolean;
}) {

  const [value, setValue] = useState<string>("");
  const [trying, setTrying] = useState<boolean>(false);

  const toggleSnackBar = useStore((store) => store.toggleSnackBar);

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setValue(event.target.value);
  };
  const handleKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    //call api
    if (event.key === "Enter") {
      if (value.length > 0) {
        //must have a value to call the api
        onSubmit();
      }
    }
    //close input
    if (event.key === "Escape") {
      callback();
    }
  };
  const onSubmit = async () => {
    // callback();
    setTrying(true);

    try {
      const result = await api.addGoal(
        value,
        pin,
        isVirtual ? virtualParentId : parentId
      );
      log("addGoal result =>", result);
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to add goal",
        severity: "error",
      });
      log("addGoal error =>", e);
    }
    callback();
    setTrying(false);
  };
  return (
    <Box>
      <Stack
        flexDirection="row"
        justifyContent="center"
        alignItems="center"
        sx={{
          position: "relative",
          padding: 0.2,
          paddingLeft: 1,
          paddingRight: 1,
        }}
      >
        {trying && (
          <CircularProgress
            size={22}
            sx={{ position: "absolute", left: -30 }}
          />
        )}
        <InputBase
          sx={{ flex: 1 }}
          placeholder="new goal"
          inputProps={{ "aria-label": "add new goal input" }}
          autoFocus={true}
          disabled={trying}
          value={value}
          onKeyDown={handleKeyDown}
          onChange={handleChange}
          onBlur={() => !trying && callback()}
          style={{
            fontWeight: 500,
            fontSize: "1.25rem",
            lineHeight: 1.6,
            letterSpacing: "0.0075em",
          }}
        />
      </Stack>
    </Box>
  );
}
export default NewGoalInput;
