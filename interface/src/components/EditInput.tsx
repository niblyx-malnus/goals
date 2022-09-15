import React, { useEffect, useState } from "react";

import api from "../api";

import InputBase from "@mui/material/InputBase";

import { log } from "../helpers";
import { PinId, GoalId } from "../types/types";
import useStore from "../store";
function EditInput({
  title,
  onDone,
  setParentTrying,
  pin,
  id,
  type,
}: {
  title: string;
  onDone: Function;
  setParentTrying: Function;
  pin?: PinId;
  id?: GoalId;
  type: "pool" | "goal";
}) {
  const [value, setValue] = useState<string>("");
  const [metaVars, setMetaVars] = useState<any>({
    inputTextStyle: {
      fontWeight: 500,
      fontSize: "1.25rem",
      lineHeight: 1.6,
      letterSpacing: "0.0075em",
    },
    typographySize: "h6",
    inputMinWidth: 50,
    ariaLabel: "update goal description",
    widthIncrement: 10,
  });
  const [trying, setTrying] = useState<boolean>(false);

  const toggleSnackBar = useStore((store) => store.toggleSnackBar);

  useEffect(() => {
    setValue(title);
  }, [title]);

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setValue(event.target.value);
  };
  const handleKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    //call api
    if (event.key === "Enter") {
      if (value.length > 0) {
        //must have a value to call the api
        //must call like this to use state values, see meta vars
        type === "pool" ? editPoolTitle() : editGoalDesc();
      }
    }
    //close the input
    if (event.key === "Escape") {
      onDone();
    }
  };
  const editPoolTitle = async () => {
    setParentTrying(true);
    setTrying(true);
    try {
      const result = await api.editPoolTitle(pin, value);
      log("editPoolTitle result => ", result);
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to edit pool title",
        severity: "error",
      });
      log("editPoolTitle error => ", e);
    }
    setParentTrying(false);
    setTrying(false);
    onDone();
  };
  const editGoalDesc = async () => {
    setParentTrying(true);
    setTrying(true);
    try {
      const result = await api.editGoalDesc(id, value);
      log("editGoalDesc result => ", result);
    } catch (e) {
      toggleSnackBar(true, {
        message: "failed to edit goal description",
        severity: "error",
      });
      log("editGoalDesc error => ", e);
    }
    setParentTrying(false);
    setTrying(false);
    onDone();
  };
  useEffect(() => {
    //set meta variables according to type here
    if (type === "pool") {
      setMetaVars({
        inputTextStyle: {
          fontWeight: 700,
          fontSize: "1.5rem",
          lineHeight: 1.334,
          letterSpacing: "0em",
        },
        typographySize: "h5",
        inputMinWidth: 75,
        ariaLabel: "update pool title",
        widthIncrement: 20,
      });
    }
    if (type === "goal") {
      setMetaVars({
        inputTextStyle: {
          fontWeight: 500,
          fontSize: "1.25rem",
          lineHeight: 1.6,
          letterSpacing: "0.0075em",
        },
        typographySize: "h6",
        inputMinWidth: 50,
        ariaLabel: "update goal title",
        widthIncrement: 10,
      });
    }
  }, [type]);
  return (
    <InputBase
      sx={{
        flex: 1,
        display: "inline-block",
        minWidth: metaVars.inputMinWidth,
        padding: 0,
        width: "100%",
      }}
      style={{
        //intention here is to match the original typography (before double clicking)
        //CONSIDERATION: can we do better on this?
        ...metaVars.inputTextStyle,
      }}
      placeholder="title"
      inputProps={{ "aria-label": metaVars.ariaLabel }}
      autoFocus={true}
      // multiline
      disabled={trying}
      onBlur={() => !trying && onDone()}
      value={value}
      onKeyDown={handleKeyDown}
      onChange={handleChange}
    />
  );
}
export default EditInput;
