import React, { useState, useEffect } from "react";

import { Main } from "../components";
import useStore from "../store";
import api from "../api";
import { log } from "../helpers";
interface Loading {
  trying: boolean;
  success: boolean;
  error: boolean;
}
declare const window: Window &
  typeof globalThis & {
    scry: any;
    poke: any;
    ship: any;
  };
export default function Home({}) {
  const setFetchedPools = useStore((store) => store.setPools);
  const setGroupsData = useStore((store) => store.setGroupsData);
  const setPals = useStore((store) => store.setPals);
  const setArchivedPools = useStore((store) => store.setArchivedPools);
  const [loading, setLoading] = useState<Loading>({
    trying: true,
    success: false,
    error: false,
  });
  const fetchInitial = async () => {
    setLoading({ trying: true, success: false, error: false });
    try {
      const result = await api.getData();
      // {author: 'zod', birth: 1682115616821, owner: 'zod'}

      log("fetchInitial result => ", result);
      const resultProjects = result.initial.store.pools;
      //add an alternate step (if selected, should be the default setting) order is decided
      //here we enforce asc order for pool to not confuse the users
      /*   const preOrderedPools = resultProjects.sort((aey: any, bee: any) => {
        return aey.pool.froze.birth - bee.pool.froze.birth;
      });
      const orderedPools = orderPools(preOrderedPools, order);
      */
      //save the cached pools also in a seperate list
      setArchivedPools(
        result.initial.store.cache.map((poolItem: any) => {
          return { ...poolItem, pool: { ...poolItem.pool, isArchived: true } };
        })
      );
      setFetchedPools(resultProjects);
      if (result) {
        setLoading({ trying: false, success: true, error: false });
      } else {
        setLoading({ trying: false, success: false, error: true });
      }
    } catch (e) {
      log("fetchInitial error => ", e);
      setLoading({ trying: false, success: false, error: true });
    }
  };
  const fetchGroups = async () => {
    try {
      const results = await api.getGroupData();
      const groupsMap = new Map(Object.entries(results.groups));
      const groupsList = Object.entries(results.groups).map((group: any) => {
        return { name: group[0], memberCount: group[1].members.length };
      });

      setGroupsData(groupsMap, groupsList);
    } catch (e) {
      log("fetchGroups error => ", e);
    }
  };
  const fetchPals = async () => {
    try {
      const results = await api.getPals();
      log("fetchPals results =>", results);
      if (results) {
        const newPals = Object.entries(results.outgoing).map(
          (item) => "~" + item[0]
        );
        setPals(newPals);
      }
    } catch (e) {
      log("fetchPals error => ", e);
    }
  };

  useEffect(() => {
    fetchInitial();
    fetchGroups();
    fetchPals();
    window["scry"] = api.scry;
    window["poke"] = api.poke;
  }, []);

  return <Main />;
}
