import React, { useEffect, useState } from "react";
import RecursiveTree from "./components/recursive_tree";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import ChevronRightIcon from "@mui/icons-material/ChevronRight";
import Box from "@mui/material/Box";
import api from "./api";
import styled from "@emotion/styled/macro";
import OutlinedInput from "@mui/material/OutlinedInput";
import Container from "@mui/material/Container";
import InputAdornment from "@mui/material/InputAdornment";
import IconButton from "@mui/material/IconButton";
import AddIcon from "@mui/icons-material/Add";
import NewGoalInput from "./components/NewGoalInput";
import EditInput from "./components/EditInput";
import IconMenu from "./components/IconMenu";
import useStore from "./store";
import { log } from "./helpers";
import Typography from "@mui/material/Typography";
import CircularProgress from "@mui/material/CircularProgress";
import { PinId } from "./types/types";
import {
  deleteGoalAction,
  deletePoolAction,
  newGoalAction,
  newPoolAction,
  updatePoolTitleAction,
} from "./store/actions";
import Stack from "@mui/material/Stack";
import Button from "@mui/material/Button";
import Checkbox from "@mui/material/Checkbox";
import FormControlLabel from "@mui/material/FormControlLabel";
import Alert from "@mui/material/Alert";

import Divider from "@mui/material/Divider";
import { ShareDialog, DeletionDialog } from "./components";
declare const window: Window &
  typeof globalThis & {
    scry: any;
    poke: any;
  };

//TODO: disable the actions until subscription is setup/have any pools
//TODO: display a "to get started add a pool"
//TODO: add sharing projects, add pals integration, add @p validation, display currently added @p
//TODO: once you are using add input, hide the add button
//TODO: UI cleanup
//TODO: add filter incomplete goals
//TODO: handle error messages
//TODO: migrate the actions to the subscription
//TODO: add success/error alert (bottom left) for the manage perms dialog
interface Loading {
  trying: boolean;
  success: boolean;
  error: boolean;
}
function App() {
  const fetchedPools = useStore((store) => store.pools);
  const setFetchedPools = useStore((store) => store.setPools);
  const [channel, setChannel] = useState<null | number>(null);
  const [pools, setPools] = useState([]);
  const [loading, setLoading] = useState<Loading>({
    trying: true,
    success: false,
    error: false,
  });
  console.log("pools", pools);
  const onSelect = (id: number) => {
    // You can put whatever here
    console.log("you clicked: " + id);
    //look for goal with given id and change it's desc to "hello world"
    const newfetchedPools = fetchedPools.map((pool: any, index: any) => {
      //look through each pools goals to find the one we seek, the one who rules them all, the one ring of power!
      const newGoals = pool.pool.goals.map((goalItem: any, goalIndex: any) => {
        const goalId = goalItem.id.birth;
        if (goalId === id) {
          return {
            goal: {
              ...goalItem.goal,
              desc: "hello world, I just changed you",
            },
            id: goalItem.id,
          };
        }
        return goalItem;
      });
      return { ...pool, pool: { ...pool.pool, goals: newGoals } };
    });
    setFetchedPools(newfetchedPools);
  };
  useEffect(() => {
    //convert flat goals into nested goals for each pool
    const newProjects = fetchedPools.map((pool: any, id: any) => {
      const newNestedGoals = createDataTree(pool.pool.nexus.goals);
      return {
        ...pool,
        pool: { ...pool.pool, nexus: { goals: newNestedGoals } },
      };
    });
    setPools(newProjects);
  }, [fetchedPools]);
  const fetchInitial = async () => {
    setLoading({ trying: true, success: false, error: false });
    try {
      const result = await api.getData();
      log("fetchInitial result => ", result);
      const resultProjects = result.initial.store.pools;
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
  const updateHandler = (update: any) => {
    log("update", update);
    const actionName: any = Object.keys(update)[1];
    log("actionName", actionName);
    if (actionName) {
      switch (actionName) {
        case "spawn-goal": {
          const { goal, id, nex }: any = update[actionName];
          const hed: any = update.hed;
          newGoalAction(id, hed.pin, goal, nex);
          break;
        }
        case "spawn-pool": {
          let { pool, pin }: any = update[actionName];
          const hed: any = update.hed;

          newPoolAction({ pool, pin: hed.pin });
          break;
        }
        case "trash-goal": {
          let { del }: any = update[actionName];
          const hed: any = update.hed;

          deleteGoalAction(del, hed.pin);
          break;
        }
        case "trash-pool": {
          const hed: any = update.hed;

          deletePoolAction(hed.pin);
          break;
        }
        case "pool-hitch": {
          const hed: any = update.hed;
          let { title }: any = update[actionName];

          updatePoolTitleAction(hed.pin, title);
          break;
        }
      }
    }
  };
  const subToUpdates = async () => {
    //we sub to updates here
    //we only try to sub if we don't already have a channel already
    if (channel === null) {
      try {
        const channelValue = await api.createApi().subscribe({
          app: "goal-store",
          path: "/goals",
          event: updateHandler,
          //TODO: handle sub death/kick/err
          err: () => console.log("Subscription rejected"),
          quit: () => console.log("Kicked from subscription"),
        });
        setChannel(channelValue);
      } catch (e) {
        log("subToUpdates error => ", e);
      }
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
    subToUpdates();
    window["scry"] = api.scry;
    window["poke"] = api.poke;
  }, []);

  return (
    <Container>
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
          const goalList = pool.pool.nexus.goals;
          const permList = pool.pool.perms;
          return (
            <Project
              title={poolTitle}
              key={poolId}
              pin={pool.pin}
              goalsLength={goalList?.length}
              permList={permList}
            >
              <RecursiveTree
                goalList={goalList}
                onSelectCallback={onSelect}
                pin={pool.pin}
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
function Project({
  title,
  children,
  pin,
  goalsLength,
  permList,
}: {
  title: string;
  pin: PinId;
  children: any;
  goalsLength: number;
  permList: any;
}) {
  //TODO: add the store type
  const collapseAll = useStore((store: any) => store.collapseAll);

  const [isOpen, toggleItemOpen] = useState<boolean | null>(null);
  const [addingGoal, setAddingGoal] = useState<boolean>(false);
  const [editingTitle, setEditingTitle] = useState<boolean>(false);
  const [trying, setTrying] = useState<boolean>(false);

  const handleAdd = () => {
    toggleItemOpen(true);
    setAddingGoal(true);
  };
  useEffect(() => {
    //everytime collapse all changes, we force isOpen value to comply
    toggleItemOpen(collapseAll.status);
  }, [collapseAll.count]);
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
        {trying ? (
          <CircularProgress
            size={24}
            sx={{ position: "absolute", left: -35 }}
          />
        ) : (
          <IconMenu
            poolData={{ title, permList, pin }}
            type="pool"
            pin={pin}
            setParentTrying={setTrying}
          />
        )}
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
        {!editingTitle ? (
          <Typography
            color={trying ? "text.disabled" : "text.primary"}
            variant="h5"
            fontWeight={"bold"}
            onDoubleClick={() => {
              !trying && setEditingTitle(true);
            }}
          >
            {title}
          </Typography>
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
        )}

        {/*TODO: make this into it's own component(so we don't have to rerender the children)*/}
        {!trying && (
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
        )}
      </StyledTreeItem>
      {addingGoal && (
        <NewGoalInput
          pin={pin}
          under={false}
          callback={() => setAddingGoal(false)}
        />
      )}
      <StyledTreeChildren
        style={{
          // backgroundColor:"orange",
          height: !isOpen ? "0px" : "auto",
          overflow: !isOpen ? "hidden" : "visible",
        }}
      >
        {children}
      </StyledTreeChildren>
    </Box>
  );
}
function Header() {
  const [newProjectTitle, setNewProjectTitle] = useState<string>("");
  const [trying, setTrying] = useState<boolean>(false);

  const setFilterGoals = useStore((store) => store.setFilterGoals);
  const filterGoals = useStore((store) => store.filterGoals);

  const setCollapseAll = useStore((store) => store.setCollapseAll);
  const collapseAll = useStore((store) => store.collapseAll);

  const [filterCompleteChecked, setFilterCompleteChecked] =
    useState<boolean>(false);
  const handleFilterCompleteChange = (
    event: React.ChangeEvent<HTMLInputElement>
  ) => {
    const checked = event.target.checked;
    setFilterCompleteChecked(event.target.checked);
    if (checked) {
      setFilterGoals("complete");
    } else {
      setFilterGoals(null);
    }
  };
  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setNewProjectTitle(event.target.value);
  };
  const handleKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    if (event.key === "Enter") {
      addNewPool();
    }
  };
  const addNewPool = async () => {
    if (newProjectTitle?.length > 0) {
      setTrying(true);
      try {
        const result = await api.addPool(newProjectTitle);
        log("addNewPool result => ", result);
      } catch (e) {
        log("addNewPool error =>", e);
      }
      setNewProjectTitle("");
      setTrying(false);
    }
  };
  return (
    <Box
      sx={{
        position: "sticky",
        top: 0,
        paddingTop: 2,
        backgroundColor: "#eedfc9",
        marginBottom: 2,
      }}
      zIndex={1}
    >
      <ShareDialog pals={[]} />
      <DeletionDialog />
      <Stack flexDirection="row" alignItems="center">
        <OutlinedInput
          id="add-new-pool"
          placeholder="Add Pool"
          value={newProjectTitle}
          onChange={handleChange}
          size={"small"}
          type={"text"}
          disabled={trying}
          onKeyDown={handleKeyDown}
          endAdornment={
            <InputAdornment position="end">
              <IconButton
                aria-label="toggle password visibility"
                onClick={addNewPool}
                edge="end"
                disabled={trying || newProjectTitle?.length === 0}
              >
                {trying ? (
                  <CircularProgress size={24} style={{ padding: 1 }} />
                ) : (
                  <AddIcon />
                )}
              </IconButton>
            </InputAdornment>
          }
        />
        <Stack
          sx={{ marginLeft: 3 }}
          flexDirection="row"
          alignItems="center"
          justifyContent="center"
        >
          <FormControlLabel
            label="Filter Completed Goals"
            control={
              <Checkbox
                checked={filterCompleteChecked}
                onChange={handleFilterCompleteChange}
              />
            }
          />
        </Stack>
        <Button
          sx={{ fontWeight: "bold", marginRight: 1 }}
          variant="outlined"
          onClick={() => setCollapseAll(true)}
        >
          uncollapse all
        </Button>
        <Button
          sx={{ fontWeight: "bold" }}
          variant="outlined"
          onClick={() => setCollapseAll(false)}
        >
          collapse all
        </Button>
      </Stack>
      <Divider sx={{ paddingTop: 2 }} />
    </Box>
  );
}

export default App;
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
const StyledTreeChildren = styled(Box)({
  paddingLeft: "20px",
});

const StyledLabel = styled(Box)({
  fontSize: 24,
  /*  height: "24px",*/
});
