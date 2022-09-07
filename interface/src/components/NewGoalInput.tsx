import React, { useEffect, useState } from "react";
import api from "../api";
import { log } from "../helpers";
import InputBase from "@mui/material/InputBase";
import { Box } from "@mui/material";
//TODO: blur/ESCP button close this component
//TODO: get this to grow like the pool title input
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
      log("result", result);
      setTrying(false);
    } catch (e) {
      setTrying(false);
    }
  };
  return (
    <Box style={{ paddingLeft: 44 }}>
      <InputBase
        sx={{ flex: 1 }}
        placeholder="new goal"
        inputProps={{ "aria-label": "add new goal input" }}
        autoFocus={true}
        disabled={trying}
        value={value}
        onKeyDown={handleKeyDown}
        onChange={handleChange}
        style={{
          fontWeight: 500,
          fontSize: "1.25rem",
          lineHeight: 1.6,
          letterSpacing: "0.0075em",
        }}
      />
    </Box>
  );
}
export default NewGoalInput;
