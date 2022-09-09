import React, { useEffect, useState } from "react";
import api from "../api";
import { log } from "../helpers";
import InputBase from "@mui/material/InputBase";
import Stack from "@mui/material/Stack";
import Box from "@mui/material/Box";
import CircularProgress from "@mui/material/CircularProgress";
//TODO: padding left  34 for add goal 44 for add under(me thinks), maybe a better way to do this
//TODO: handle empty input

function NewGoalInput({
  callback,
  id,
  under = false,
}: {
  callback: Function;
  id: { owner: string; birth: string };
  under: boolean;
}) {
  const [value, setValue] = useState<string>("");
  const [trying, setTrying] = useState<boolean>(false);
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
      //we switch between addGoal(add goal to pool) and addGoalUnderGoal (add goal under another goal)
      const result = under
        ? await api.addGoalUnderGoal(value, id)
        : await api.addGoal(value, id);
      log("result", result);
    } catch (e) {}
    callback();
    setTrying(false);
  };
  return (
    <Box style={{ paddingLeft: 44 }}>
      <Stack
        flexDirection="row"
        justifyContent="center"
        alignItems="center"
        sx={{ position: "relative" }}
      >
        {trying && (
          <CircularProgress
            size={22}
            //style={{ padding: 1 }}
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
