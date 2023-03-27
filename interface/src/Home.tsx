import React, { useEffect, useState, memo } from "react";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";

import RecursiveTree from "./components/recursive_tree";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import ChevronRightIcon from "@mui/icons-material/ChevronRight";
import Box from "@mui/material/Box";
import api from "./api";
import styled from "@emotion/styled/macro";
import Container from "@mui/material/Container";
import IconButton from "@mui/material/IconButton";
import AddIcon from "@mui/icons-material/Add";
import NewGoalInput from "./components/NewGoalInput";
import EditInput from "./components/EditInput";
import IconMenu from "./components/IconMenu";
import useStore from "./store";
import { log, shipName, getRoleTitle } from "./helpers";
import Typography from "@mui/material/Typography";
import CircularProgress from "@mui/material/CircularProgress";
import { Order, PinId } from "./types/types";
import Badge from "@mui/material/Badge";
import { orderPools, orderPoolsAction } from "./store/actions";
import Stack from "@mui/material/Stack";
import Button from "@mui/material/Button";
import Alert from "@mui/material/Alert";
import Chip from "@mui/material/Chip";
import { Header } from "./components";
import { v4 as uuidv4 } from "uuid";
import TextField from "@mui/material/TextField";

declare const window: Window &
  typeof globalThis & {
    scry: any;
    poke: any;
    ship: any;
  };
//TODO: handle sub kick/error
//TODO: order the virtual children
interface Loading {
  trying: boolean;
  success: boolean;
  error: boolean;
}
function Home() {
  const order = useStore((store) => store.order);
  const setRoleMap = useStore((store) => store.setRoleMap);
  const fetchedPools = useStore((store) => store.pools);
  const setFetchedPools = useStore((store) => store.setPools);
  const setGroupsData = useStore((store) => store.setGroupsData);
  const setPals = useStore((store) => store.setPals);

  const space = useStore((store) => store.space);

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
      //create a map of goal to id(birth)
      const goalsMap = new Map();
      pool.nexus.goals.forEach((item: any) => {
        goalsMap.set(item.id.birth, item);
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
    setPools(newProjects);
    setRoleMap(roleMap);
  }, [fetchedPools]);

  const fetchInitial = async () => {
    setLoading({ trying: true, success: false, error: false });
    try {
      const result = await api.getSpaceData(space);
      log("fetchInitial result => ", result);
      const resultProjects = result;
      //here we enforce asc order for pool to not confuse the users
      const preOrderedPools = resultProjects.sort((aey: any, bee: any) => {
        return aey.pool.froze.birth - bee.pool.froze.birth;
      });
      const orderedPools = orderPools(preOrderedPools, order);
      //save the cached pools also in a seperate list
      setArchivedPools([]);
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
    if (space) {
      fetchInitial();
    }
    fetchGroups();
    fetchPals();
    window["scry"] = api.scry;
    window["poke"] = api.poke;
  }, [space]);
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
      {loading.success && pools.length === 0 ? (
        <Typography variant="h6" fontWeight={"bold"}>
          Add a pool to get started
        </Typography>
      ) : (
        pools.map((pool: any, index: any) => {
          const poolTitle = pool.pool.hitch.title;
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
const Project = memo(
  ({
    title,
    children,
    pin,
    goalsLength,
    permList,
    poolOwner,
    role,
    isArchived = false,
  }: {
    title: string;
    pin: PinId;
    children: any;
    goalsLength: number;
    permList: any;
    poolOwner: string;
    role: string;
    isArchived?: boolean;
  }) => {
    //TODO: add the store type
    const collapseAll = useStore((store: any) => store.collapseAll);
    const [isOpen, toggleItemOpen] = useState<boolean | null>(null);
    const [addingGoal, setAddingGoal] = useState<boolean>(false);
    const [editingTitle, setEditingTitle] = useState<boolean>(false);
    const [trying, setTrying] = useState<boolean>(false);
    const [noteValue, setNoteValue] = useState<string>("");
    const [editingNote, setEditingNote] = useState<boolean>(false);
    const onNoteChange = (event: React.ChangeEvent<HTMLInputElement>) => {
      setNoteValue(event.target.value);
    };
    const handleNoteKeyDown = (
      event: React.KeyboardEvent<HTMLInputElement>
    ) => {
      //call api
      if (event.key === "Enter") {
        api.editPoolNote(pin, noteValue);
        setEditingNote(false);
      }
      //close the input
      if (event.key === "Escape") {
        setEditingNote(false);
      }
    };
    const disableActions = trying || editingTitle || addingGoal;

    const handleAdd = () => {
      toggleItemOpen(true);
      setAddingGoal(true);
    };
    useEffect(() => {
      //everytime collapse all changes, we force isOpen value to comply
      toggleItemOpen(collapseAll.status);
    }, [collapseAll.count]);
    const renderIconMenu = () => {
      if (trying) {
        return (
          <CircularProgress
            size={24}
            sx={{ position: "absolute", left: -24 }}
          />
        );
      }
      if (!disableActions) {
        return (
          <IconMenu
            poolData={{ title, permList, pin }}
            type="pool"
            pin={pin}
            setParentTrying={setTrying}
            isArchived={isArchived}
            onEditPoolNote={() => setEditingNote(!editingNote)}
          />
        );
      }
    };
    const renderArchivedTag = () => {
      return (
        isArchived && (
          <Chip
            sx={{ marginLeft: 1 }}
            size="small"
            label={
              <Typography fontWeight={"bold"} color="text.secondary">
                archived
              </Typography>
            }
          />
        )
      );
    };
    const renderTitle = () => {
      if (role === null || role === "spawn") {
        return (
          <Box
            sx={{
              padding: 0.2,
              paddingLeft: 1,
              paddingRight: 1,
              borderRadius: 1,
            }}
          >
            <Typography color={"text.primary"} variant="h5" fontWeight={"bold"}>
              {title}
            </Typography>
          </Box>
        );
      }
      return !editingTitle ? (
        <Box
          sx={{
            padding: 0.2,
            paddingLeft: 1,
            paddingRight: 1,
            borderRadius: 1,
          }}
        >
          <Typography
            color={trying ? "text.disabled" : "text.primary"}
            variant="h5"
            fontWeight={"bold"}
            onDoubleClick={() => {
              !disableActions && !isArchived && setEditingTitle(true);
            }}
          >
            {title}
          </Typography>
        </Box>
      ) : (
        <EditInput
          type="pool"
          title={title}
          onDone={() => {
            setEditingTitle(false);
          }}
          setParentTrying={setTrying}
          pin={pin}
        />
      );
    };

    const renderAddButton = () => {
      if (role === null) return;
      if (isArchived) return;
      return (
        !disableActions && (
          <IconButton
            sx={{ opacity: 0 }}
            className="show-on-hover"
            // sx={{ position: "absolute", right: 35 }}
            aria-label="add goal button"
            size="small"
            onClick={handleAdd}
          >
            <AddIcon />
          </IconButton>
        )
      );
    };
    return (
      <Box sx={{ marginBottom: 1 }}>
        <StyledTreeItem
          sx={{
            "&:hover": {
              cursor: "pointer",
              "& .show-on-hover": {
                opacity: 1,
              },
            },
          }}
        >
          {!trying && (
            <Box
              sx={{
                position: "absolute",
                left: -24,
                display: "flex",
                flexDirection: "row",
              }}
            >
              {goalsLength > 0 && (
                <Box
                  sx={{
                    display: "flex",
                    justifyContent: "center",
                    alignItems: "center",
                  }}
                  className="icon-container"
                  onClick={() => toggleItemOpen(!isOpen)}
                >
                  {isOpen ? <ExpandMoreIcon /> : <ChevronRightIcon />}
                </Box>
              )}
            </Box>
          )}
          {renderTitle()}
          {renderArchivedTag()}
          {renderIconMenu()}
          {renderAddButton()}
          {!editingTitle && (
            <Stack
              flexDirection={"row"}
              alignItems="center"
              justifyContent={"center"}
              className="show-on-hover"
              sx={{ opacity: 0 }}
            >
              <Chip
                avatar={
                  <Badge
                    style={{
                      borderRadius: 10,
                      height: 18,
                      width: 18,
                      display: "flex",

                      alignItems: "center",
                      justifyContent: "center",
                    }}
                  >
                    <Typography
                      variant="subtitle2"
                      style={{
                        textAlign: "center",
                        lineHeight: "18px",
                      }}
                    >
                      O
                    </Typography>
                  </Badge>
                }
                size="small"
                label={<Typography fontWeight={"bold"}>{poolOwner}</Typography>}
                color="primary"
                variant="outlined"
              />
              <Chip
                sx={{ marginLeft: 1 }}
                size="small"
                label={
                  <Typography fontWeight={"bold"}>
                    {getRoleTitle(role)}
                  </Typography>
                }
                color="secondary"
                variant="outlined"
              />
            </Stack>
          )}
        </StyledTreeItem>
        {editingNote && (
          <TextField
            sx={{ marginTop: 1 }}
            spellCheck="true"
            error={false}
            size="small"
            id="note"
            label="note"
            type="text"
            multiline
            value={noteValue}
            onChange={onNoteChange}
            onKeyDown={handleNoteKeyDown}
            autoFocus
            fullWidth
          />
        )}
        <Box
          sx={{ paddingLeft: 4 }}
          style={{
            height: !isOpen ? "0px" : "auto",
            overflow: !isOpen ? "hidden" : "visible",
          }}
        >
          {addingGoal && (
            <NewGoalInput
              pin={pin}
              under={false}
              callback={() => setAddingGoal(false)}
            />
          )}
          {children}
        </Box>
      </Box>
    );
  }
);

export default Home;
const StyledMenuButton = styled(IconButton)({
  opacity: 0,
  "&:hover": {
    opacity: 1,
  },
});
const StyledMenuButtonContainer = styled(Box)({
  /* opacity: 0,
  "&:hover": {
    opacity: 1,
  },*/
});
const StyledTreeItem = styled(Box)({
  display: "flex",
  flexDirection: "row",
  alignItems: "center",
  position: "relative",
  "&:hover": {
    cursor: "pointer",
    [`${StyledMenuButton}`]: {
      opacity: 1,
    },
    [`${StyledMenuButtonContainer}`]: {
      opacity: 1,
    },
  },
});

const StyledLabel = styled(Box)({
  fontSize: 24,
  /*  height: "24px",*/
});
