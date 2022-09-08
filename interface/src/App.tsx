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
import { newGoalAction, newPoolAction } from "./store/actions";
import { Stack } from "@mui/material";
import Checkbox from "@mui/material/Checkbox";
import FormControlLabel from "@mui/material/FormControlLabel";

function App() {
  const fetchedPools = useStore((store) => store.pools);
  const setFetchedPools = useStore((store) => store.setPools);
  const [channel, setChannel] = useState<null | number>(null);
  const [pools, setPools] = useState([]);
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
      const newNestedGoals = createDataTree(pool.pool.goals);
      return {
        ...pool,
        pool: { ...pool.pool, goals: newNestedGoals },
      };
    });
    setPools(newProjects);
  }, [fetchedPools]);
  const getGoals = async () => {
    try {
      const result = await api.getData();
      log("getGoals result => ", result);
      const resultProjects = result.initial.store.pools;
      setFetchedPools(resultProjects);
    } catch (e) {
      log("getGoals error => ", e);
    }
  };
  const updateHandler = (update: any) => {
    const actionName: any = Object.keys(update)[0];
    if (actionName) {
      switch (actionName) {
        case "new-goal": {
          const { goal, id, pin }: any = update[actionName];
          newGoalAction(id, pin, goal);
          break;
        }
        case "add-under": {
          const { goal, cid, pid, pin }: any = update[actionName];
          newGoalAction(cid, pin, goal);
          break;
        }
        case "new-pool": {
          let { pool, pin }: any = update[actionName];
          newPoolAction({ pool, pin });
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
          path: "/updates",
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
      const parentID = aData.goal.par?.birth;
      const ID = aData.id.birth;
      if (parentID) {
        hashTable[parentID].childNodes.push(hashTable[ID]);
      } else dataTree.push(hashTable[ID]);
    });
    return dataTree;
  };
  useEffect(() => {
    getGoals();
    subToUpdates();
  }, []);

  return (
    <Container sx={{ marginTop: 2 }}>
      <Header />
      {pools.map((pool: any, index: any) => {
        const poolTitle = pool.pool.title;
        const poolId = pool.pin.birth;
        const goalList = pool.pool.goals;

        return (
          <Project
            title={poolTitle}
            key={poolId}
            pin={pool.pin}
            goalsLength={goalList?.length}
          >
            <RecursiveTree
              goalList={goalList}
              onSelectCallback={onSelect}
              pin={pool.pin}
            />
          </Project>
        );
      })}
    </Container>
  );
}

function Project({
  title,
  children,
  pin,
  goalsLength,
}: {
  title: string;
  pin: PinId;
  children: any;
  goalsLength: number;
}) {
  const [isOpen, toggleItemOpen] = useState<boolean | null>(null);
  const [addingGoal, setAddingGoal] = useState<boolean>(false);
  const [editingTitle, setEditingTitle] = useState<boolean>(false);
  const [trying, setTrying] = useState<boolean>(false);
  const handleAdd = () => {
    toggleItemOpen(true);
    setAddingGoal(true);
  };
  return (
    <Box sx={{ marginBottom: 1 }}>
      <StyledTreeItem>
        {trying ? (
          <CircularProgress
            size={24}
            sx={{ position: "absolute", left: -35 }}
          />
        ) : (
          <StyledMenuButtonContainer sx={{ position: "absolute", left: -35 }}>
            <IconMenu type="pool" pin={pin} />
          </StyledMenuButtonContainer>
        )}
        {goalsLength > 0 && (
          <Box
            sx={{
              display: "flex",
              justifyContent: "center",
              alignItems: "center",
            }}
            onClick={() => toggleItemOpen(!isOpen)}
          >
            {isOpen ? <ExpandMoreIcon /> : <ChevronRightIcon />}
          </Box>
        )}
        {!editingTitle ? (
          <Typography
            color="text.primary"
            variant="h5"
            fontWeight={"bold"}
            onDoubleClick={() => {
              setEditingTitle(true);
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
          <StyledMenuButton
            className="add-goal-button"
            // sx={{ position: "absolute", right: 35 }}
            aria-label="add goal button"
            size="small"
            onClick={handleAdd}
          >
            <AddIcon />
          </StyledMenuButton>
        )}
      </StyledTreeItem>
      {addingGoal && (
        <NewGoalInput
          id={pin}
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
    <Stack
      flexDirection="row"
      alignItems="center"
      // justifyContent="center"
      sx={{ marginBottom: 3 }}
    >
      <OutlinedInput
        id="add-new-pool"
        placeholder="Add Project"
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
              //onMouseDown={handleMouseDownPassword}
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
    </Stack>
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
  opacity: 0,
  "&:hover": {
    opacity: 1,
  },
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
