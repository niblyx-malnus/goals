import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import { log } from "../helpers";
import api from "../api";
import Recursive_tree from "../components/recursive_tree";
import useStore from "../store";
import { Main } from "../components";
import { harvestAskAction, listAskAction } from "../store/actions";
export default function Details({}) {
  let { type, owner, birth }: any = useParams();
  const [id, setId] = useState<null | { birth: string; owner: string }>(null);
  const setFetchedPools = useStore((store) => store.setPools);
  const setMainLoading = useStore((store) => store.setMainLoading);
  log("id", id);
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
    // setMainLoading({ trying: true, success: false, error: false });

    try {
      harvestAskAction(type, id);
      listAskAction(type, id);
      api.treeAsk(type, id);
    } catch (e) {
      log("getDetailsData error => ", e);
      // setMainLoading({ trying: false, success: false, error: true });
    }
  };

  return (
    <Main
      fetchInitialCallback={getDetailsData}
      displayPools={type === "pool"}
      disableAddPool={true}
      //we need these for the ask (page type and id if any)
      pageType={type}
      pageId={id}
    />
  );
}
