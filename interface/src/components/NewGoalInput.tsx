import React, { useEffect, useState } from "react";
import api from "../api";
import { log } from "../helpers";
import InputBase from "@mui/material/InputBase";

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
    if (event.key === "Enter") {
      onSubmit();
    }
  };
  const onSubmit = async () => {
    callback();
    try {
      setTrying(true);
      //we switch between addGoal(add goal to pool) and addGoalUnderGoal (add goal under another goal)
      const result = under
        ? await api.addGoalUnderGoal(value, id)
        : await api.addGoal(value, id);
      console.log("result", result);
      setTrying(false);
    } catch (e) {
      setTrying(false);
    }
  };
  return (
    <div>
      <InputBase
        sx={{ flex: 1 }}
        style={{ marginLeft: 10 }}
        placeholder="new goal"
        inputProps={{ "aria-label": "add new goal input" }}
        autoFocus={true}
        disabled={trying}
        value={value}
        onKeyDown={handleKeyDown}
        onChange={handleChange}
      />
      {/* <IconButton
          aria-label="add goal input"
          size="small"
          onClick={onSubmit}
          disabled={trying}
        >
          <AddIcon />
        </IconButton>*/}
    </div>
  );
}
export default NewGoalInput;
