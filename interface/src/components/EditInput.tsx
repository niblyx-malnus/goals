import React, { useEffect, useState } from "react";

import api from "../api";

import InputBase from "@mui/material/InputBase";

import { log } from "../helpers";
import Typography from "@mui/material/Typography";
import { PinId, GoalId } from "../types/types";
import { updatePoolTitleAction, updateGoalDescAction } from "../store/actions";
function EditInput({
  title,
  onSubmit,
  pin,
  id,
  type,
}: {
  title: string;
  onSubmit: Function;
  pin?: PinId;
  id?: GoalId;
  type: "pool" | "goal";
}) {
  //TODO: fix flickering issue
  //TODO: add edit to menu also
  //TODO: press ESCP while focusing on the input to close it
  const [value, setValue] = useState<string>("");
  const [newTitleInputWidth, setNewTitleInputWidth] = useState<number>(0);
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
  const newTitleSpanRef: any = React.useRef(null);

  useEffect(() => {
    setValue(title);
  }, [title]);
  useEffect(() => {
    if (newTitleSpanRef.current) {
      const width = newTitleSpanRef.current.getBoundingClientRect().width;
      setNewTitleInputWidth(width + metaVars.widthIncrement);
    }
  }, [value]);
  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setValue(event.target.value);
  };
  const handleKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    //TODO: hitting ESCP to close this input
    if (event.key === "Enter") {
      //must call like this to use state values
      type === "pool" ? editPoolTitle() : editGoalDesc();
    }
  };
  const editPoolTitle = async () => {
    //TODO: delete if no value?
    //TODO: make it so you can edit through icon menu
    try {
      const result = await api.editPoolTitle(pin, value);
      console.log("value", value);
      log("editPoolTitle result => ", result);
      if (result && pin && value) {
        updatePoolTitleAction(pin, value);
        onSubmit();
      }
    } catch (e) {
      log("editPoolTitle error => ", e);
    }
  };
  const editGoalDesc = async () => {
    //TODO: delete if no value?
    //TODO: make it so you can edit through icon menu
    onSubmit();
    try {
      const result = await api.editGoalDesc(id, value);
      log("editGoalDesc result => ", result);
      if (result && id && pin && value) {
        updateGoalDescAction(id, pin, value);
      }
    } catch (e) {
      log("editGoalDesc error => ", e);
    }
  };
  useEffect(() => {
    //set meta variables according to type here
    if (type === "pool") {
      setMetaVars({
        inputTextStyle: {
          fontWeight: 400,
          fontSize: "2.125rem",
          lineHeight: 1.235,
          letterSpacing: "0.00735em",
        },
        typographySize: "h4",
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
        ariaLabel: "update goal description",
        widthIncrement: 10,
      });
    }
  }, [type]);
  return (
    <>
      <Typography
        variant={metaVars.typographySize}
        ref={newTitleSpanRef}
        sx={{ visibility: "hidden", position: "absolute", left: -9999 }}
      >
        {value}
      </Typography>
      <InputBase
        sx={{
          minWidth: metaVars.inputMinWidth,
          width: newTitleInputWidth,
          display: "inline-block",
          padding: 0,
        }}
        style={{
          // marginLeft: 25,
          //intention here is to match the original typography (before double clicking)
          ...metaVars.inputTextStyle,
          //for goal
        }}
        placeholder="title"
        inputProps={{ "aria-label": metaVars.ariaLabel }}
        autoFocus={true}
        // multiline
        //disabled={trying}
        value={value}
        onKeyDown={handleKeyDown}
        onChange={handleChange}
      />
    </>
  );
}
export default EditInput;
