import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import { log } from "../helpers";
import api from "../api";
import Recursive_tree from "../components/recursive_tree";
import useStore from "../store";
import { Main } from "../components";
export default function Details({}) {
  let { type, owner, birth } = useParams();
  const [id, setId] = useState<null | { birth: string; owner: string }>(null);
  const [goalList, setGoalList] = useState<any>([]);
  const setFetchedPools = useStore((store) => store.setPools);

  useEffect(() => {
    if (type && owner && birth) {
      setId({ birth, owner });
    } else {
      setId(null);
    }
  }, [type, owner, birth]);

  useEffect(() => {
    if (id) {
      //call API to get our data here
      getDetailsData();
    }
  }, [id]);
  const getDetailsData = async () => {
    //either fetch goal or pool data depending on type
    try {
      const result =
        type === "pool" ? await api.getPool(id) : await api.getGoal(id);
      log("getDetailsData result => ", result);
      setFetchedPools([{ pool: result, id: result.id }]);
    } catch (e) {
      log("getDetailsData error => ", e);
    }
  };

  return <Main />;
}
