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
import MoreHorizIcon from "@mui/icons-material/MoreHoriz";
import InputBase from "@mui/material/InputBase";
import DoneIcon from "@mui/icons-material/Done";
import NewGoalInput from "./components/NewGoalInput";
import EditInput from "./components/EditInput";
import IconMenu from "./components/IconMenu";
import useStore from "./store";
import { log } from "./helpers";
import Typography from "@mui/material/Typography";
import { PinId } from "./types/types";
import { newGoalAction } from "./store/actions";

//TODO: hovering elements also bring a + icon button to nest structure
//TODO: add the contect menu
//TODO: make memo work for our structure

function App() {
  const fetchedPools = useStore((store) => store.pools);
  const setFetchedPools = useStore((store) => store.setPools);

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

      console.log("result", result);
      const resultProjects = result.initial.store.pools;
      setFetchedPools(resultProjects);
    } catch (e) {
      console.log("e", e);
    }
  };
  const subToUpdates = async () => {
    //we sub to updates here
    const updateHandler = (update: any) => {
      const actionName: any = Object.keys(update)[0];
      if (actionName) {
        switch (actionName) {
          case "new-goal": {
            let { goal, id, pin }: any = update[actionName];
            newGoalAction(id, pin, goal);
            break;
          }
          case "add-under": {
            let { goal, cid, pid, pin }: any = update[actionName];
            newGoalAction(cid, pin, goal);
            break;
          }
        }
      }
    };
    try {
      const value = await api.createApi().subscribe({
        app: "goal-store",
        path: "/updates",
        event: updateHandler,
        err: () => console.log("Subscription rejected"),
        quit: () => console.log("Kicked from subscription"),
      });
      console.log("value", value);
    } catch (e) {
      log("subToUpdates error => ", e);
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
          <Project title={poolTitle} key={poolId} pin={pool.pin}>
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
}: {
  title: string;
  pin: PinId;
  children: any;
}) {
  const [isOpen, toggleItemOpen] = useState<boolean | null>(null);
  const [addingGoal, setAddingGoal] = useState<boolean>(false);
  const [editingTitle, setEditingTitle] = useState(false);

  return (
    <div>
      <StyledTreeItem>
        <StyledMenuButtonContainer sx={{ position: "absolute", left: -35 }}>
          <IconMenu type="pool" pin={pin} />
        </StyledMenuButtonContainer>

        {!editingTitle ? (
          <Typography
            variant="h4"
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
            onSubmit={() => {
              setEditingTitle(false);
            }}
            pin={pin}
          />
        )}
        <Box className="icon-container" onClick={() => toggleItemOpen(!isOpen)}>
          {isOpen ? <ExpandMoreIcon /> : <ChevronRightIcon />}
        </Box>
        {/*TODO: make this into it's own component(so we don't have to rerender the children)*/}
        <StyledMenuButton
          className="add-goal-button"
          // sx={{ position: "absolute", right: 35 }}
          aria-label="add goal button"
          size="small"
          onClick={() => setAddingGoal(true)}
        >
          <AddIcon />
        </StyledMenuButton>
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
    </div>
  );
}
function Header() {
  const [newProjectTitle, setNewProjectTitle] = useState<string>("");
  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setNewProjectTitle(event.target.value);
  };
  const addNewProject = async () => {
    try {
      const result = await api.addPool(newProjectTitle);
      console.log("result", result);
    } catch (e) {
      console.log("e", e);
    }
  };
  return (
    <Box>
      <OutlinedInput
        id="add-new-pool"
        label="Project title"
        value={newProjectTitle}
        onChange={handleChange}
        size={"small"}
        type={"text"}
        endAdornment={
          <InputAdornment position="end">
            <IconButton
              aria-label="toggle password visibility"
              onClick={addNewProject}
              //onMouseDown={handleMouseDownPassword}
              edge="end"
            >
              <AddIcon />
            </IconButton>
          </InputAdornment>
        }
      />
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
  // paddingLeft: "10px",
});

const StyledLabel = styled(Box)({
  fontSize: 24,
  /*  height: "24px",*/
});
