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
const log = () => {
  //do the isDev console log stuff
};

//TODO: hovering elements also bring a + icon button to nest structure
//TODO: add the contect menu
//TODO: make memo work for our structure

function App() {
  const [fetchedPools, setFetchedPools] = useState<any>([]);
  const [pools, setPools] = useState([]);
  console.log("fetchedPools", fetchedPools);
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
  }, []);

  return (
    <Container sx={{ marginTop: 2 }} maxWidth="sm">
      <Header />
      {pools.map((pool: any, index: any) => {
        const poolTitle = pool.pool.title;
        const poolId = pool.pin.birth;
        const goalList = pool.pool.goals;
        return (
          <Project title={poolTitle} key={poolId}>
            <RecursiveTree goalList={goalList} onSelectCallback={onSelect} />
          </Project>
        );
      })}
    </Container>
  );
}
function Project({ title, children }: any) {
  //isOpen && children is probably not goin to work forever
  const [isOpen, toggleItemOpen] = useState<boolean | null>(null);

  return (
    <div>
      <StyledTreeItem>
        <StyledMenuButton
          className="menu-button"
          sx={{ position: "absolute", left: -35 }}
          aria-label="fingerprint"
          size="small"
        >
          <MoreHorizIcon />
        </StyledMenuButton>
        <StyledLabel
          className="label"
          /* onClick={(e: React.MouseEvent<HTMLInputElement>) => {
            onSelectCallback(id);
          }}*/
          style={{
            marginLeft: `${children && children.length === 0 ? "24px" : ""}`,
            //  background: `${selected ? "#d5d5d5" : ""}`,
          }}
        >
          {title}
        </StyledLabel>
        <Box className="icon-container" onClick={() => toggleItemOpen(!isOpen)}>
          {isOpen ? <ExpandMoreIcon /> : <ChevronRightIcon />}
        </Box>
      </StyledTreeItem>
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
  },
});
const StyledTreeChildren = styled(Box)({
  paddingLeft: "10px",
});

const StyledLabel = styled(Box)({
  fontSize: 24,
  /*  height: "24px",*/
});
