import React, { useEffect, useState } from "react";
import RecursiveTree from "./recursive_tree";
import api from "../api";
import Container from "@mui/material/Container";
import useStore from "../store";
import { log, shipName, selectOrderList, createDataTree } from "../helpers";
import Typography from "@mui/material/Typography";
import CircularProgress from "@mui/material/CircularProgress";
import Stack from "@mui/material/Stack";
import Button from "@mui/material/Button";
import Alert from "@mui/material/Alert";
import { HarvestView, Header, Project, ListView } from "./";
import { v4 as uuidv4 } from "uuid";
import { DndProvider } from "react-dnd";
import { HTML5Backend } from "react-dnd-html5-backend";
import { Loading } from "../types/types";
import { useNavigate, useLocation } from "react-router-dom";
import Tabs from "@mui/material/Tabs";
import Tab from "@mui/material/Tab";
import Box from "@mui/material/Box";
import { cloneDeep } from "lodash";

//TODO: handle sub kick/error
//TODO: add relay to edit inputs also and test the other pokes
//TODO: Don't allow to drop goal over itself
//TODO: add tooltips to header buttons
//TODO: fix groups scry
//TODO: add loading state to reordering
//TODO: fix virtual kids rerendering
//TODO: move click navigation to ctrl + click
//TODO: quick actions should contain complete(if applicable)/archive/go to page
//TODO: Important: reduce render load by adding a programtic on hover event to projects/goals (quick action render gate)
//TODO: display loading/error states in harvest/list views
//TODO: move scrollbar inside views?
//Waiting on Thomas:
//TODO: fix perm issues in harvest/list views (pool perm not found)
//TODO: reordering goals doesn't work in goals on account of no poolid... (we should have this data now)
//TODO: go to parent goal | go to parent pool buttons next to nacvigate home
function Main({
  fetchInitialCallback,
  displayPools,
  disableAddPool,
  pageType,
  pageId,
}: any) {
  const [value, setValue] = React.useState(0);

  const handleChange = (event: React.SyntheticEvent, newValue: number) => {
    setValue(newValue);
  };

  const location = useLocation();
  useEffect(() => {
    //clear the pools in the store to prevent flickering when navigating
    setPoolStore([]);
  }, [location.pathname]);

  const order = useStore((store) => store.order);
  const setRoleMap = useStore((store) => store.setRoleMap);
  const fetchedPools = useStore((store) => store.pools);
  const setPoolStore = useStore((store: any) => store.setPools);
  const filterGoals = useStore((store) => store.filterGoals);

  const setGroupsData = useStore((store) => store.setGroupsData);
  const setPals = useStore((store) => store.setPals);

  const tryingMap: any = useStore((store) => store.tryingMap);
  const setTryingMap = useStore((store) => store.setTryingMap);

  const setAllTags = useStore((store) => store.setAllTags);

  const pageInfo = useStore((store) => store.pageInfo);

  const [pools, setPools] = useState([]);

  const mainLoading = useStore((store) => store.mainLoading);

  const currShip = shipName();

  const onSelect = (id: number) => {
    // You can put whatever here
    log("you clicked: " + id);
  };

  useEffect(() => {
    if (pageType !== "main" && !pageId) return; //
    //convert flat goals into nested goals for each pool
    //make our role map
    const roleMap = new Map();
    const newTryingMap: any = new Map();
    const allTags: any = [];
    const allTagsSet: Set<string> = new Set(); // use this to keep track of the tags to prevent duplication in all tags array

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
      //apply filters if any
      const newGoals = poolItem.pool.nexus.goals.filter(
        (goalItem: any, goalIndex: any) => {
          if (
            (goalItem.goal.nexus.complete && filterGoals === "complete") ||
            (!goalItem.goal.nexus.complete && filterGoals === "incomplete")
          ) {
            return false;
          }
          return true;
        }
      );

      let newRoots = {}; //sometimes empty, sometimes full with replacement youngs
      if (pageType === "goal") {
        //#1 find goal we want for it's youngs...
        const goalWeWant = newGoals.filter((goalItem: any) => {
          if (goalItem.id.birth === pageId.birth) {
            return true;
          }
          return false;
        });
        if (goalWeWant.length > 0) {
          //we found something, create a replacement map
          const goalWeWantNexus = cloneDeep(goalWeWant[0].goal.nexus);
          //#3 we have to remove our root elements nexus.par to work correctly
          goalWeWant[0].goal.nexus.par = null;
          //#2 we have to include the current goal in the following listtts
          goalWeWantNexus.young.unshift({
            virtual: false,
            id: goalWeWant[0].id,
          });
          goalWeWantNexus["young-by-deadline"].unshift({
            virtual: false,
            id: goalWeWant[0].id,
          });
          goalWeWantNexus["young-by-kickoff"].unshift({
            virtual: false,
            id: goalWeWant[0].id,
          });
          goalWeWantNexus["young-by-precedence"].unshift({
            virtual: false,
            id: goalWeWant[0].id,
          });
          newRoots = {
            roots: goalWeWantNexus.young,
            "roots-by-deadline": goalWeWantNexus["young-by-deadline"],
            "roots-by-kickoff": goalWeWantNexus["young-by-kickoff"],
            "roots-by-precedence": goalWeWantNexus["young-by-precedence"],
          };
        }
      }
      //depending on what type of page, we build rootings differently
      let rootins =
        pageType === "goal"
          ? selectOrderList(order, newRoots, true)?.map((item: any) => {
              return item.id.birth;
            })
          : selectOrderList(order, poolItem.pool.trace, true)?.map(
              (item: any) => {
                return item.birth;
              }
            );
      log("newRoots", newRoots);
      newGoals.forEach((item: any) => {
        goalsMap.set(item.id.birth, item);
        item.goal.hitch.tags?.forEach((element: any) => {
          if (!allTagsSet.has(element.text)) {
            //don't allow for duplication
            allTagsSet.add(element.text);
            allTags.push(element);
          }
        });
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
      newGoals.forEach((shallowGoal: any) => {
        /**
         * if we have nest left, we have virtual children;
         * so we make a copy of the goal assicoated with them
         *  and make the needed changes to the data structure
         */

        shallowGoal.goal.nexus["nest-left"].map((item: any) => {
          //fetch the goal assosicated with this id from our map
          const saGoal = goalsMap.get(item.birth);
          if (saGoal) {
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
                    ...shallowGoal.id,
                  },
                },
              },
            };
            virtualChildren.push(parentVirtualGoal);

            connect(parentVirtualGoal, parentId);
          }
        });
      });

      //create our nested data structure we use for rendering (createDataTree)
      //merge the current pool's goals with virtual children if any

      const newNestedGoals = createDataTree(
        [...newGoals, ...virtualChildren],
        rootins,
        order
      );
      return {
        ...poolItem,
        pool: {
          ...pool,
          nexus: { goals: newNestedGoals },
          trace: { ...poolItem.pool.trace, ...newRoots }, // replace the current pool's roots... with the appropriate goal's youngs if any given, an extra useless step for now
        },
      };
    });
    setTryingMap(newTryingMap);
    setPools(newProjects);
    setRoleMap(roleMap);
    setAllTags(allTags);
  }, [fetchedPools, order, filterGoals]);

  const roleMap = useStore((store: any) => store.roleMap);
  const selectionMode = useStore((store) => store.selectionMode);
  const selectionModeYokeData = useStore(
    (store) => store.selectionModeYokeData
  );
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
    fetchGroups();
    fetchPals();
  }, []);
  const navigate = useNavigate();
  log("pageInfo", pageInfo);
  return (
    <Container sx={{ paddingBottom: 10 }}>
      <DndProvider backend={HTML5Backend}>
        <Header
          disableAddPool={disableAddPool}
          pageId={pageId}
          pageType={pageType}
        />
        {pageType !== "main" && (
          <Button
            onClick={() => {
              navigate("/apps/gol-cli");
            }}
            sx={{ fontWeight: "bold" }}
          >
            Home
          </Button>
        )}
        {pageInfo.goal?.["par-pool"] && (
          <Button
            onClick={() => {
              navigate(
                "/apps/gol-cli/pool/" +
                  pageInfo.goal?.["par-pool"]?.owner +
                  "/" +
                  pageInfo.goal?.["par-pool"]?.birth
              );
            }}
            sx={{ fontWeight: "bold" }}
          >
            parent pool
          </Button>
        )}
        {pageInfo.goal?.["par-goal"] && (
          <Button
            onClick={() => {
              navigate(
                "/apps/gol-cli/goal/" +
                  pageInfo.goal?.["par-goal"]?.owner +
                  "/" +
                  pageInfo.goal?.["par-goal"]?.birth
              );
            }}
            sx={{ fontWeight: "bold" }}
          >
            parent goal
          </Button>
        )}

        <Box>
          <Tabs
            value={value}
            onChange={handleChange}
            aria-label="basic tabs example"
          >
            <Tab sx={{ fontWeight: "bold" }} label="Tree" {...a11yProps(0)} />
            <Tab
              sx={{ fontWeight: "bold" }}
              label="Harvest"
              {...a11yProps(1)}
            />
            <Tab sx={{ fontWeight: "bold" }} label="List" {...a11yProps(2)} />
          </Tabs>
        </Box>

        <TabPanel value={value} index={1}>
          <HarvestView pageType={pageType} pageId={pageId} />
        </TabPanel>
        <TabPanel value={value} index={2}>
          <ListView pageType={pageType} pageId={pageId} />
        </TabPanel>
        <TabPanel value={value} index={0} key={0}>
          {mainLoading.trying && (
            <Stack flexDirection="row" alignItems="center">
              <CircularProgress size={28} />
              <Typography
                sx={{ marginLeft: 2 }}
                variant="h6"
                fontWeight={"bold"}
              >
                Loading pools...
              </Typography>
            </Stack>
          )}
          {mainLoading.success && pools.length === 0 ? (
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
              if (displayPools) {
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
              } else {
                return (
                  <RecursiveTree
                    goalList={goalList}
                    onSelectCallback={onSelect}
                    pin={pool.pin}
                    poolRole={role}
                    key={"recursive-tree-" + index}
                    inSelectionMode={inSelectionMode}
                    disabled={disabled}
                    yokingGoalId={selectionModeYokeData?.goalId.birth}
                    poolArchived={pool.pool.isArchived}
                  />
                );
              }
            })
          )}

          {mainLoading.error && <ErrorAlert onRetry={fetchInitialCallback} />}
        </TabPanel>
      </DndProvider>
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

interface TabPanelProps {
  children?: React.ReactNode;
  index: number;
  value: number;
}

function TabPanel(props: TabPanelProps) {
  const { children, value, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
      style={{ display: value === index ? "inline-block" : "none" }}
    >
      <Box sx={{ p: 3 }}>{children}</Box>
    </div>
  );
}

function a11yProps(index: number) {
  return {
    id: `simple-tab-${index}`,
    "aria-controls": `simple-tabpanel-${index}`,
  };
}
export default Main;
