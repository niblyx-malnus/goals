import React, { useEffect, useState } from "react";
import RecursiveTree from "./recursive_tree";
import api from "../api";
import Container from "@mui/material/Container";
import useStore from "../store";
import { log, shipName } from "../helpers";
import Typography from "@mui/material/Typography";
import CircularProgress from "@mui/material/CircularProgress";
import { orderPools } from "../store/actions";
import Stack from "@mui/material/Stack";
import Button from "@mui/material/Button";
import Alert from "@mui/material/Alert";
import { Header, Project } from "./";
import { v4 as uuidv4 } from "uuid";
import { DndProvider } from "react-dnd";
import { HTML5Backend } from "react-dnd-html5-backend";
declare const window: Window &
  typeof globalThis & {
    scry: any;
    poke: any;
    ship: any;
  };
//TODO: handle sub kick/error
//TODO: order the virtual children
//TODO: add relay to edit inputs also and test the other pokes
//TODO: Don't allow to drop goal over itself
//TODO: add API to ordering goals among themselves and related frontend logic
//TODO: make the highlighting grey?(drag and drop)
interface Loading {
  trying: boolean;
  success: boolean;
  error: boolean;
}
function Main() {
  const order = useStore((store) => store.order);
  const setRoleMap = useStore((store) => store.setRoleMap);
  const fetchedPools = useStore((store) => store.pools);
  const setFetchedPools = useStore((store) => store.setPools);
  const setGroupsData = useStore((store) => store.setGroupsData);
  const setPals = useStore((store) => store.setPals);

  const tryingMap: any = useStore((store) => store.tryingMap);
  const setTryingMap = useStore((store) => store.setTryingMap);

  const setArchivedPools = useStore((store) => store.setArchivedPools);
  const [pools, setPools] = useState([]);
  const [loading, setLoading] = useState<Loading>({
    trying: true,
    success: false,
    error: false,
  });
  const currShip = shipName();

  const onSelect = (id: number) => {
    // You can put whatever here
    log("you clicked: " + id);
  };
  useEffect(() => {
    //convert flat goals into nested goals for each pool
    //make our role map
    const roleMap = new Map();
    const newTryingMap: any = new Map();
    const newProjects = fetchedPools.map((poolItem: any, id: any) => {
      //update the perms here, in case they do change
      const { pin, pool } = poolItem;
      if (pin.owner === currShip) {
        //check if this ship is the owner
        roleMap.set(pin.birth, "owner");
      }
      //loop through perm list to look for the curnt ship and update the rolemap
      for (const permElement of pool.perms) {
        if (permElement.ship === currShip) {
          roleMap.set(pin.birth, permElement.role);
          break;
        }
      }
      //add this pool to the trying map
      newTryingMap.set(pin.birth, {
        trying: tryingMap.has(pin.birth) //make sure to check the previous tryingMap for this value
          ? tryingMap.get(pin.birth).trying
          : false,
      });
      //create a map of goal to id(birth)
      const goalsMap = new Map();
      pool.nexus.goals.forEach((item: any) => {
        goalsMap.set(item.id.birth, item);

        newTryingMap.set(item.id.birth, {
          trying: tryingMap.has(item.id.birth) //make sure to check the previous tryingMap for this value
            ? tryingMap.get(item.id.birth).trying
            : false,
        });
      });
      const virtualChildren: any = [];

      function connect(goal: any, parentId: any) {
        //recursively build virtual children connections
        //flushing them out to the flat pool.nexus.goals
        [...goal.goal.nexus.kids, ...goal.goal.nexus["nest-left"]].forEach(
          (virtualChildId: any) => {
            const newId = uuidv4();
            //update parent id to be reflect virtualisation
            //update id to avoid duplication and
            //add an id to refer to the original goal for actions
            const virtualChildGoal = goalsMap.get(virtualChildId.birth);
            if (!virtualChildGoal) return;
            const newVirtualChildGoal = {
              id: { ...virtualChildGoal.id, birth: newId },
              goal: {
                ...virtualChildGoal.goal,
                isVirtual: true,
                virtualId: virtualChildGoal.id,
                nexus: {
                  ...virtualChildGoal.goal.nexus,
                  par: {
                    ...virtualChildGoal.goal.nexus.par,
                    birth: parentId,
                  },
                },
              },
            };
            virtualChildren.push(newVirtualChildGoal);

            connect(newVirtualChildGoal, newId);
          }
        );
      }
      pool.nexus.goals.forEach((shallowGoal: any) => {
        /**
         * if we have nest left, we have virtual children;
         * so we make a copy of the goal assicoated with them
         *  and make the needed changes to the data structure
         */
        shallowGoal.goal.nexus["nest-left"].map((item: any) => {
          //fetch the goal assosicated with this id from our map
          const saGoal = goalsMap.get(item.birth);
          if (saGoal) {
            log("saGoal", saGoal.goal);
            const parentId = uuidv4();
            //update parent id to be reflect virtualisation
            //update id to avoid duplication and
            //add an id to refer to the original goal for actions
            const parentVirtualGoal = {
              id: { ...saGoal.id, birth: parentId },
              goal: {
                ...saGoal.goal,
                isVirtual: true,
                virtualId: saGoal.id,
                nexus: {
                  ...saGoal.goal.nexus,
                  par: {
                    ...saGoal.goal.nexus.par,
                    birth: shallowGoal.id.birth,
                  },
                },
              },
            };
            virtualChildren.push(parentVirtualGoal);

            connect(parentVirtualGoal, parentId);
            log("virtualChildren", virtualChildren);
          }
        });
      });
      //create our nested data structure we use for rendering (createDataTree)
      //merge the current pool's goals with virtual children if any
      const newNestedGoals = createDataTree([
        ...pool.nexus.goals,
        ...virtualChildren,
      ]);
      return {
        ...poolItem,
        pool: { ...pool, nexus: { goals: newNestedGoals } },
      };
    });
    setTryingMap(newTryingMap);
    setPools(newProjects);
    setRoleMap(roleMap);
  }, [fetchedPools]);

  const fetchInitial = async () => {
    setLoading({ trying: true, success: false, error: false });
    try {
      const result = await api.getData();
      log("fetchInitial result => ", result);
      const resultProjects = result.initial.store.pools;
      //here we enforce asc order for pool to not confuse the users
      const preOrderedPools = resultProjects.sort((aey: any, bee: any) => {
        return aey.pool.froze.birth - bee.pool.froze.birth;
      });
      const orderedPools = orderPools(preOrderedPools, order);
      //save the cached pools also in a seperate list
      setArchivedPools(
        result.initial.store.cache.map((poolItem: any) => {
          return { ...poolItem, pool: { ...poolItem.pool, isArchived: true } };
        })
      );
      setFetchedPools(orderedPools);
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
  const createDataTree = (dataset: any) => {
    const hashTable = Object.create(null);
    dataset.forEach((aData: any) => {
      const ID = aData.id.birth;
      hashTable[ID] = { ...aData, childNodes: [] };
    });

    const dataTree: any = [];
    dataset.forEach((aData: any) => {
      const parentID = aData.goal.nexus?.par?.birth;
      const ID = aData.id.birth;
      if (parentID) {
        hashTable[parentID].childNodes.push(hashTable[ID]);
      } else dataTree.push(hashTable[ID]);
    });
    return dataTree;
  };
  useEffect(() => {
    fetchInitial();
    fetchGroups();
    fetchPals();
    window["scry"] = api.scry;
    window["poke"] = api.poke;
  }, []);
  const setCtrlPressed = useStore((store) => store.setCtrlPressed);

  const onKeyDown = (event: any) => {
    if (event.key === "Control") {
      setCtrlPressed(true);
    }
  };
  const onKeyUp = (event: any) => {
    if (event.key === "Control") {
      setCtrlPressed(false);
    }
  };
  const onWindowBlur = (event: any) => {
    setCtrlPressed(false);
  };
  useEffect(() => {
    document.addEventListener("keydown", onKeyDown);
    document.addEventListener("keyup", onKeyUp);
    window.addEventListener("blur", onWindowBlur);

    return () => {
      document.removeEventListener("keyup", onKeyDown);
      document.addEventListener("keyup", onKeyUp);
      window.addEventListener("blur", onWindowBlur);
    };
  }, []);
  const roleMap = useStore((store: any) => store.roleMap);
  const selectionMode = useStore((store) => store.selectionMode);
  const selectionModeYokeData = useStore(
    (store) => store.selectionModeYokeData
  );

  return (
    <Container sx={{ paddingBottom: 10 }}>
      <Header />
      {loading.trying && (
        <Stack flexDirection="row" alignItems="center">
          <CircularProgress size={28} />
          <Typography sx={{ marginLeft: 2 }} variant="h6" fontWeight={"bold"}>
            Loading pools...
          </Typography>
        </Stack>
      )}
      <DndProvider backend={HTML5Backend}>
        {loading.success && pools.length === 0 ? (
          <Typography variant="h6" fontWeight={"bold"}>
            Add a pool to get started
          </Typography>
        ) : (
          pools.map((pool: any, index: any) => {
            const poolTitle = pool.pool.hitch.title;
            const poolNote = pool.pool.hitch.note;
            const poolId = pool.pin.birth;
            const poolOwner = pool.pin.owner;
            const goalList = pool.pool.nexus.goals;
            const permList = pool.pool.perms;
            const role = roleMap?.get(poolId);
            let inSelectionMode = false;
            let disabled = false;
            //we toggle into selection mode or disable the pool (disabling is a TODO)
            if (selectionMode) {
              //does the yoke selection stem from one of my goals?
              if (selectionModeYokeData?.poolId.birth === poolId) {
                inSelectionMode = true;
              } else {
                disabled = true;
              }
            }
            return (
              <Project
                title={poolTitle}
                note={poolNote}
                poolOwner={poolOwner}
                key={poolId}
                pin={pool.pin}
                goalsLength={goalList?.length}
                permList={permList}
                role={role}
                isArchived={pool.pool.isArchived}
              >
                <RecursiveTree
                  goalList={goalList}
                  onSelectCallback={onSelect}
                  pin={pool.pin}
                  poolRole={role}
                  inSelectionMode={inSelectionMode}
                  disabled={disabled}
                  yokingGoalId={selectionModeYokeData?.goalId.birth}
                  poolArchived={pool.pool.isArchived}
                />
              </Project>
            );
          })
        )}
      </DndProvider>

      {loading.error && <ErrorAlert onRetry={fetchInitial} />}
    </Container>
  );
}

function ErrorAlert({ onRetry }: { onRetry: Function }) {
  return (
    <Alert
      variant="filled"
      severity="error"
      action={
        <Button onClick={() => onRetry()} color="inherit" size="small">
          try again
        </Button>
      }
    >
      We couldn't get you the pools, sorry
    </Alert>
  );
}

export default Main;