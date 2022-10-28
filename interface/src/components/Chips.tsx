import React, { memo } from "react";

import Stack from "@mui/material/Stack";

import { styled } from "@mui/material/styles";

import Chip from "@mui/material/Chip";
import Typography from "@mui/material/Typography";

const ListItem = styled("li")(({ theme }) => ({
  margin: theme.spacing(0.5),
}));

function Chips({ chipData, onDelete = null }: any) {
  return (
    <Stack flexDirection="row" flexWrap="wrap" sx={{ listStyle: "none" }}>
      {chipData.map((data: any) => {
        return (
          <ListItem key={data.key}>
            {data.canDelete ? (
              <Chip
                variant="outlined"
                sx={{ cursor: "pointer" }}
                label={
                  <Typography variant="subtitle2">{data.label}</Typography>
                }
                onDelete={() => onDelete(data)}
              />
            ) : (
              <Chip
                sx={{ cursor: "pointer" }}
                label={
                  <Typography variant="subtitle2">{data.label}</Typography>
                }
              />
            )}
          </ListItem>
        );
      })}
    </Stack>
  );
}
export default memo(Chips);
