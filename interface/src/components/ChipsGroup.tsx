import React, { useEffect, useState } from "react";

import Stack from "@mui/material/Stack";
import Chips from "./Chips";

import Typography from "@mui/material/Typography";

import { ChipData } from "../types/types";
const ChipsGroup = ({
  title,
  data,
  onDelete,
}: {
  title: string;
  data: ChipData[];
  onDelete: Function;
}) => {
  if (data.length === 0) return null;
  return (
    <Stack flexDirection={"column"} marginTop={1}>
      <Typography variant="subtitle2" fontWeight={"bold"}>
        {title}
      </Typography>
      <Chips
        keyRole={title}
        chipData={data}
        canDelete={true}
        onDelete={onDelete}
      />
    </Stack>
  );
};
export default ChipsGroup;
