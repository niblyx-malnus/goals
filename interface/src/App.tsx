import React, { useEffect, useState, memo } from "react";
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
import { log, shipName } from "./helpers";
import Typography from "@mui/material/Typography";
import CircularProgress from "@mui/material/CircularProgress";
import { Order, PinId } from "./types/types";
import Avatar from "@mui/material/Avatar";
import KeyboardDoubleArrowDownIcon from "@mui/icons-material/KeyboardDoubleArrowDown";
import KeyboardDoubleArrowUpIcon from "@mui/icons-material/KeyboardDoubleArrowUp";
import { orderPools, orderPoolsAction } from "./store/actions";
import Stack from "@mui/material/Stack";
import Button from "@mui/material/Button";
import Checkbox from "@mui/material/Checkbox";
import FormControlLabel from "@mui/material/FormControlLabel";
import Alert from "@mui/material/Alert";
import Chip from "@mui/material/Chip";
import Divider from "@mui/material/Divider";
import ArrowDropDownIcon from "@mui/icons-material/ArrowDropDown";
import ArrowDropUpIcon from "@mui/icons-material/ArrowDropUp";
import {
  ShareDialog,
  DeletionDialog,
  LeaveDialog,
  Snackie,
  Log,
  TimelineDialog,
  CopyPoolDialog,
  YokingActionBar,
} from "./components";
import { v4 as uuidv4 } from "uuid";

declare const window: Window &
  typeof globalThis & {
    scry: any;
    poke: any;
    ship: any;
  };

//TODO: add pals integration
//TODO: add pals integration
//TODO: add pals integration(easy)
//TODO: handle sub kick/error

interface Loading {
  trying: boolean;
  success: boolean;
  error: boolean;
}
function App() {
  const order = useStore((store) => store.order);
  const setRoleMap = useStore((store) => store.setRoleMap);
  const fetchedPools = useStore((store) => store.pools);
  const setFetchedPools = useStore((store) => store.setPools);

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
            const newId = uuidv4();
            //update parent id to be reflect virtualisation
            //update id to avoid duplication and
            //add an id to refer to the original goal for actions
            const virtualGoal = {
              id: { ...saGoal.id, birth: newId },
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
            virtualChildren.push(virtualGoal);
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
      const result = await api.getData();
      log("fetchInitial result => ", result);
      const resultProjects = result.initial.store.pools;
      //here we enforce asc order for pool to not confuse the users
      const preOrderedPools = resultProjects.sort((aey: any, bee: any) => {
        return aey.pool.froze.birth - bee.pool.froze.birth;
      });
      const orderedPools = orderPools(preOrderedPools, order);

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
    window["scry"] = api.scry;
    window["poke"] = api.poke;
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
            >
              <RecursiveTree
                goalList={goalList}
                onSelectCallback={onSelect}
                pin={pool.pin}
                poolRole={role}
                inSelectionMode={inSelectionMode}
                disabled={disabled}
                yokingGoalId={selectionModeYokeData?.goalId.birth}
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
  }: {
    title: string;
    pin: PinId;
    children: any;
    goalsLength: number;
    permList: any;
    poolOwner: string;
    role: string;
  }) => {
    //TODO: add the store type
    const collapseAll = useStore((store: any) => store.collapseAll);
    const [isOpen, toggleItemOpen] = useState<boolean | null>(null);
    const [addingGoal, setAddingGoal] = useState<boolean>(false);
    const [editingTitle, setEditingTitle] = useState<boolean>(false);
    const [trying, setTrying] = useState<boolean>(false);
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
          />
        );
      }
    };
    const renderTitle = () => {
      if (role === "viewer" || role === "captain") {
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
              !disableActions && setEditingTitle(true);
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
      if (role === "viewer") return;
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

          {/*TODO: make this into it's own component(so we don't have to rerender the children)*/}
          {renderIconMenu()}
          {renderAddButton()}
          {!editingTitle && (
            <Stack
              flexDirection={"row"}
              alignItems="center"
              className="show-on-hover"
              sx={{ opacity: 0 }}
            >
              <Chip
                sx={{ marginLeft: 1 }}
                avatar={<Avatar>O</Avatar>}
                size="small"
                label={<Typography fontWeight={"bold"}>{poolOwner}</Typography>}
                color="primary"
                variant="outlined"
              />
              <Chip
                sx={{ marginLeft: 1 }}
                size="small"
                label={<Typography fontWeight={"bold"}>{role}</Typography>}
                color="secondary"
                variant="outlined"
              />
            </Stack>
          )}
        </StyledTreeItem>

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
function Header() {
  const [newProjectTitle, setNewProjectTitle] = useState<string>("");
  const [trying, setTrying] = useState<boolean>(false);
  const order = useStore((store) => store.order);
  const selectionMode = useStore((store) => store.selectionMode);

  const setFilterGoals = useStore((store) => store.setFilterGoals);

  const setCollapseAll = useStore((store) => store.setCollapseAll);

  const toggleSnackBar = useStore((store) => store.toggleSnackBar);

  const [filterCompleteChecked, setFilterCompleteChecked] =
    useState<boolean>(false);
  const [filterIncompleteChecked, setFilterIncompleteChecked] =
    useState<boolean>(false);
  const handleFilterCompleteChange = (
    event: React.ChangeEvent<HTMLInputElement>
  ) => {
    const checked = event.target.checked;
    setFilterCompleteChecked(event.target.checked);
    if (filterIncompleteChecked) setFilterIncompleteChecked(false);
    if (checked) {
      setFilterGoals("complete");
    } else {
      setFilterGoals(null);
    }
  };
  const handleFilterIncompleteChange = (
    event: React.ChangeEvent<HTMLInputElement>
  ) => {
    const checked = event.target.checked;
    setFilterIncompleteChecked(event.target.checked);
    if (filterCompleteChecked) setFilterCompleteChecked(false);

    if (checked) {
      setFilterGoals("incomplete");
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
        toggleSnackBar(true, {
          message: "successfully added pool",
          severity: "success",
        });
      } catch (e) {
        toggleSnackBar(true, {
          message: "failed to add pool",
          severity: "error",
        });
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
      {selectionMode ? <YokingActionBar /> : <Log />}

      <DeletionDialog />
      <LeaveDialog />
      <TimelineDialog />
      <CopyPoolDialog />
      <Snackie />
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
          flexDirection="column"
          alignItems="center"
          justifyContent="center"
        >
          <FormControlLabel
            sx={{ height: 36.5 }}
            label="Filter Completed Goals"
            control={
              <Checkbox
                checked={filterCompleteChecked}
                onChange={handleFilterCompleteChange}
              />
            }
          />
          <FormControlLabel
            sx={{ height: 36.5 }}
            label="Filter Incomplete Goals"
            control={
              <Checkbox
                checked={filterIncompleteChecked}
                onChange={handleFilterIncompleteChange}
              />
            }
          />
        </Stack>
        <Stack
          flexDirection="column"
          //alignItems="center"
          justifyContent="flex-start"
        >
          <Button
            sx={{ fontWeight: "bold", justifyContent: " flex-start" }}
            variant="text"
            startIcon={<KeyboardDoubleArrowDownIcon />}
            onClick={() => setCollapseAll(true)}
          >
            uncollapse all
          </Button>
          <Button
            sx={{ fontWeight: "bold", justifyContent: " flex-start" }}
            variant="text"
            startIcon={<KeyboardDoubleArrowUpIcon />}
            onClick={() => setCollapseAll(false)}
          >
            collapse all
          </Button>
        </Stack>

        {order === "asc" ? (
          <Button
            sx={{ fontWeight: "bold", justifyContent: " flex-start" }}
            variant="text"
            startIcon={<ArrowDropDownIcon />}
            onClick={() => {
              return orderPoolsAction("dsc");
            }}
          >
            dsc order
          </Button>
        ) : (
          <Button
            sx={{ fontWeight: "bold", justifyContent: " flex-start" }}
            variant="text"
            startIcon={<ArrowDropUpIcon />}
            onClick={() => {
              return orderPoolsAction("asc");
            }}
          >
            asc order
          </Button>
        )}
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

const StyledLabel = styled(Box)({
  fontSize: 24,
  /*  height: "24px",*/
});
