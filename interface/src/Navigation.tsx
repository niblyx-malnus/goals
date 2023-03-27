import React, { useEffect, useState } from "react";
import {
  useParams,
  useNavigate,
  Outlet,
  useSearchParams,
} from "react-router-dom";
import Stack from "@mui/material/Stack";
import { log } from "./helpers";
import useStore from "./store";
const Navigation = () => {
  const [searchParams] = useSearchParams();
  const { ship, group, word } = useParams();
  const space = useStore((store) => store.space);
  const setSpace = useStore((store) => store.setSpace);

  //presisted space data for filtering search correctly
  log("space", space);
  const navigate = useNavigate();
  useEffect(() => {
    const spaceId = searchParams.get("spaceId");
    if (spaceId) {
      navigate("/apps/goals-test" + spaceId);
    }
  }, [searchParams.get("spaceId")]);

  useEffect(() => {
    //We care about knowing the space id, either through params {ship}/{group} or space id which is the same thing
    if (!ship || !group) {
      setSpace(null);
      //keep the state up to date with spaces
      //isAdminScry(space);
    } else {
      const space = `${ship}/${group}`;
      setSpace(space);
    }
  }, [ship, group]);

  return (
    <>
      <Outlet />
    </>
  );
};

export default Navigation;
