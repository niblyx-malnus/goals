import React, { useEffect, useState } from "react";

import api from "../api";

import InputBase from "@mui/material/InputBase";

import { log } from "../helpers";
import Typography from "@mui/material/Typography";
import { PinId, GoalId } from "../types/types";
import { updatePoolTitleAction, updateGoalDescAction } from "../store/actions";
//TODO: handle error states
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
  const [trying, setTrying] = useState<boolean>(false);

  const newTitleSpanRef: any = React.useRef(null);

  useEffect(() => {
    setValue(title);
  }, [title]);
  useEffect(() => {
    //dynamicall changes the width on the input depending on a hidden text element
    if (newTitleSpanRef.current) {
      const width = newTitleSpanRef.current.getBoundingClientRect().width;
      setNewTitleInputWidth(width + metaVars.widthIncrement);
    }
  }, [value]);
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
    //TODO: delete if no value?
    //TODO: make it so you can edit through icon menu
    setParentTrying(true);
    setTrying(true);
    try {
      const result = await api.editPoolTitle(pin, value);
      log("editPoolTitle result => ", result);
    
    } catch (e) {
      log("editPoolTitle error => ", e);
    }
    setParentTrying(false);
    setTrying(false);
    onDone();
  };
  const editGoalDesc = async () => {
    //TODO: delete if no value?
    //TODO: make it so you can edit through icon menu
    //onDone();
    setParentTrying(true);
    setTrying(true);
    try {
      const result = await api.editGoalDesc(id, value);
      log("editGoalDesc result => ", result);
   
    } catch (e) {
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
    <>
      <Typography
        variant={metaVars.typographySize}
        fontWeight="bold"
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
    </>
  );
}
export default EditInput;
