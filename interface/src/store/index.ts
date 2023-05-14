import { CreateCssVarsProviderResult } from "@mui/system";
import cloneDeep from "lodash/cloneDeep";
import create from "zustand";
import { log } from "../helpers";
import {
  FilterGoals,
  GoalId,
  Loading,
  Order,
  PinId,
  SnackBarData,
  Yoke,
} from "../types/types";
type SelectionYokeData = null | {
  goalId: GoalId;
  poolId: PinId;
  yokeType: Yoke;
  yokeName: string;
  startingConnections: any;
};
type ColorTheme = "light" | "dark";
interface Store {
  /*
   * Pools is a list of projects(projects contain goals)
   * this is our main data for the whole app
   * a structure for displaying the interface is derived from this (nestedPools (TODO: change name))
   * incoming changes happen in pools which triggers a change in our "display" structure
   */
  pools: any;
  setPools: (state: any) => void;

  archivedPools: any;
  setArchivedPools: (state: any) => void;

  filterGoals: FilterGoals;
  setFilterGoals: (status: FilterGoals) => void;
  //number is included to allow for using the same function twice and having hooks react
  collapseAll: { status: boolean; count: number };
  setCollapseAll: (status: boolean) => void;

  shareDialogOpen: boolean;
  //data we get passed by the pool to the share dialog
  shareDialogData: any;
  toggleShareDialog: (status: boolean, poolData: any) => void;

  deleteDialogData: any;
  deleteDialogOpen: boolean;
  toggleDeleteDialog: (status: boolean, deleteDialogData: any) => void;

  leaveDialogData: any;
  leaveDialogOpen: boolean;
  toggleLeaveDialog: (status: boolean, leaveDialogData: any) => void;

  order: Order;
  setOrder: (newOrder: Order) => void;
  //roll map for the pools
  roleMap: any;
  setRoleMap: (newRoleMap: any) => void;

  snackBarOpen: boolean;
  snackBarData: SnackBarData;
  toggleSnackBar: (newStatus: boolean, newSnackBarData: SnackBarData) => void;

  logList: any;
  setLogList: (newLogList: any) => void;

  timelineDialogOpen: boolean;
  timelineDialogData: any;
  toggleTimelineDialog: (
    newStatus: boolean,
    newTimelineDialogData: any
  ) => void;

  copyPoolDialogData: any;
  copyPoolDialogOpen: boolean;
  toggleCopyPoolDialog: (newStatus: boolean, newCopyDialogData: any) => void;

  archiveDialogData: any;
  archiveDialogOpen: boolean;
  toggleArchiveDialog: (newStatus: boolean, newCopyDialogData: any) => void;

  selectionMode: boolean;
  selectionModeYokeData: SelectionYokeData;
  toggleSelectionMode: (
    newStatus: boolean,
    newSelectionModeYokeData: SelectionYokeData
  ) => void;
  selectedGoals: Map<string, GoalId>; //map of goal id to goal (selected ones)
  setSelectedGoals: (newSelectedGoals: any) => void;
  updateSelectedGoal: (newGoal: any, status: boolean) => void;
  resetSelectedGoals: () => void;

  showArchived: boolean;
  toggleShowArchived: () => void;

  groupsMap: Map<string, any>; // a map of group names to their data
  groupsList: any; //an array of groups name and their member count
  setGroupsData: (newGroupsMap: any, newGroupsList: any) => void;
  groupsShareDialogOpen: boolean;
  groupsShareDialogData: any;
  toggleGroupsShareDialog: (
    newStatus: boolean,
    newGroupsShareDialogData: any
  ) => void;

  harvestGoals: any;
  setHarvestGoals: (newHarvestGoals: any) => void;

  listGoals: any;
  setListGoals: (newListGoals: any) => void;

  pals: any;
  setPals: (newPals: any) => void;

  goalPermsDialogOpen: boolean;
  goalPermsDialogData: any;
  toggleGoalPermsDialog: (
    newStatus: boolean,
    newGoalPermsDialogData: any
  ) => void;
  joinPoolDialogOpen: boolean;
  toggleJoinPoolDialogOpen: (newStatus: boolean) => void;

  colorMode: ColorTheme;
  setColorMode: (colorMode: ColorTheme) => void;

  tryingMap: Map<string, object>;
  setTryingMap: (tryingMap: Map<string, object>) => void;
  setTrying: (id: string, value: boolean) => void;
  getTrying: (id: any) => any;

  ctrlPressed: boolean;
  setCtrlPressed: (state: boolean) => void;

  goalTagsDialogOpen: boolean;
  goalTagsDialogData: any;
  toggleGoalTagsDialog: (
    newStatus: boolean,
    newGoalTagsDialogData: any
  ) => void;

  filterTagsDialogOpen: boolean;
  toggleFilterTagsDialog: (newStatus: boolean) => void;

  allTags: any;
  setAllTags: (newAllTags: any) => void;

  tagFilterArray: Array<string>;
  setTagFilterArray: (newTagFilterArray: Array<string>) => void;

  draggingParentId: string | null; //the id if the parent's goal we're currently dragging
  setDraggingParentId: (draggingParentId: string | null) => void;

  mainLoading: Loading;
  setMainLoading: (mainLoading: Loading) => void;

  activeSubsMap: any;
  setActiveSubsMap: (newActiveSubsMap: any) => void;

  pageInfo: any; //obtained from the page ask, relavant info to pool/goal
  setPageInfo: (newPageInfo: any) => void;
}

/**
 * 
  const toggleShowArchived = useStore((store) => store.toggleShowArchived);
  const showArchived = useStore((store) => store.showArchived);
 */

const useStore = create<Store>((set, get) => ({
  pools: [],
  setPools: (newPools: any) => set(() => ({ pools: newPools })),

  archivedPools: [],
  setArchivedPools: (newArchivedPools: any) =>
    set(() => ({ archivedPools: newArchivedPools })),

  filterGoals: null,
  setFilterGoals: (newStatus: FilterGoals) =>
    set(() => ({ filterGoals: newStatus })),

  collapseAll: { status: false, count: 0 },
  setCollapseAll: (newStatus: boolean) =>
    set(() => ({
      collapseAll: { status: newStatus, count: get().collapseAll.count + 1 },
    })),

  shareDialogOpen: false,
  shareDialogData: null,
  toggleShareDialog: (newStatus: boolean, poolData: any) =>
    set(() => ({
      shareDialogOpen: newStatus,
      shareDialogData: poolData,
    })),

  deleteDialogData: null,
  deleteDialogOpen: false,
  toggleDeleteDialog: (newStatus: boolean, newDeleteDialogData: any) =>
    set(() => ({
      deleteDialogOpen: newStatus,
      deleteDialogData: newDeleteDialogData,
    })),
  leaveDialogData: null,
  leaveDialogOpen: false,
  toggleLeaveDialog: (newStatus: boolean, newLeaveDialogData: any) =>
    set(() => ({
      leaveDialogOpen: newStatus,
      leaveDialogData: newLeaveDialogData,
    })),

  order: "default",
  setOrder: (newOrder: Order) =>
    set(() => ({
      order: newOrder,
    })),

  roleMap: null,
  setRoleMap: (newRoleMap: any) =>
    set(() => ({
      roleMap: newRoleMap,
    })),

  snackBarOpen: false,
  snackBarData: null,
  toggleSnackBar: (newStatus, newSnackBarData) =>
    set(() => ({
      snackBarOpen: newStatus,
      snackBarData: newSnackBarData,
    })),

  logList: [],
  setLogList: (newItem: any) => {
    //append new log item to the log list, adding a timestamp
    const newLogList = get().logList;
    const newerItem = {
      ...newItem,
      date: new Date().toLocaleTimeString("default", {
        hour: "numeric",
        minute: "numeric",
      }),
    };

    newLogList.push(newerItem);

    set(() => ({
      logList: newLogList,
    }));
  },
  timelineDialogOpen: false,
  timelineDialogData: null,
  toggleTimelineDialog: (newStatus: boolean, newTimelineDialogData: any) =>
    set(() => ({
      timelineDialogOpen: newStatus,
      timelineDialogData: newTimelineDialogData,
    })),

  copyPoolDialogData: null,
  copyPoolDialogOpen: false,
  toggleCopyPoolDialog: (newStatus: boolean, newCopyDialogData: any) =>
    set(() => ({
      copyPoolDialogOpen: newStatus,
      copyPoolDialogData: newCopyDialogData,
    })),

  archiveDialogData: null,
  archiveDialogOpen: false,
  toggleArchiveDialog: (newStatus: boolean, newArchiveDialogData: any) =>
    set(() => ({
      archiveDialogOpen: newStatus,
      archiveDialogData: newArchiveDialogData,
    })),

  selectionMode: false,
  selectionModeYokeData: null,
  toggleSelectionMode: (
    newStatus: boolean,
    newSelectionModeYokeData: SelectionYokeData
  ) =>
    set(() => ({
      selectionMode: newStatus,
      selectionModeYokeData: newSelectionModeYokeData,
    })),
  selectedGoals: new Map(),
  resetSelectedGoals: () =>
    set(() => ({
      selectedGoals: new Map(),
    })),
  setSelectedGoals: (newSelectedGoals: any) => {
    const newSelectedGoalsMap = new Map();
    newSelectedGoals.forEach((id: any) => {
      newSelectedGoalsMap.set(id.birth, id);
    });
    set(() => ({
      selectedGoals: newSelectedGoalsMap,
    }));
  },
  updateSelectedGoal: (newGoalId: any, status: boolean) => {
    //manage list of selected goals (while yoking/moving)
    let currentSelectedGoals: any = new Map(get().selectedGoals);
    const yokeType = get().selectionModeYokeData?.yokeType;

    //status: true => add a goal
    //status: false => remove a goal
    if (status) {
      if (yokeType === "move") {
        //we clear to manage a single connection when moving
        currentSelectedGoals.clear();
      }
      currentSelectedGoals.set(newGoalId.birth, newGoalId);
    } else {
      currentSelectedGoals.delete(newGoalId.birth);
    }
    set(() => ({
      selectedGoals: currentSelectedGoals,
    }));
  },

  showArchived: false,
  toggleShowArchived: () => {
    //toggle showArchived and copy cached pools/goals to the live goals
    //newStatus => true => add the cached goals/pools
    //newStatus => false => remove the cached goals/pools if any
    let pools: any = get().pools;
    let archivedPools: any = get().archivedPools;
    let newStatus = !get().showArchived;

    let newPools: any;
    if (newStatus) {
      //go through pool (reviving) cached goals
      newPools = pools.map((poolItem: any) => {
        const newGoals = [
          ...poolItem.pool.nexus.goals,
          ...poolItem.pool.nexus.cache.map((goalItem: any) => {
            return {
              ...goalItem,
              goal: { ...goalItem.goal, isArchived: true },
            };
          }),
        ];
        //apppend archived status
        //actionable archived goals => isArchied true and no par
        return {
          ...poolItem,
          pool: {
            ...poolItem.pool,
            nexus: {
              ...poolItem.pool.nexus,
              goals: newGoals,
            },
          },
        };
      });
      //added the archived pools
      newPools = [...newPools, ...archivedPools];
    } else {
      const cachedPoolsIdList = archivedPools.map((poolItem: any) => {
        return poolItem.pin.birth;
      });
      newPools = pools.filter((poolItem: any) => {
        return !cachedPoolsIdList.includes(poolItem.pin.birth);
      });
      newPools = newPools.map((poolItem: any) => {
        const cachedGoalsIdList = poolItem.pool.nexus.cache.map(
          (goalItem: any) => {
            return goalItem.id.birth;
          }
        );
        const newGoals = poolItem.pool.nexus.goals.filter((goalItem: any) => {
          return !cachedGoalsIdList.includes(goalItem.id.birth);
        });

        return {
          ...poolItem,
          pool: {
            ...poolItem.pool,
            nexus: {
              ...poolItem.pool.nexus,
              goals: newGoals,
            },
          },
        };
      });
    }
    set(() => ({
      pools: newPools,
      showArchived: newStatus,
    }));
  },
  groupsMap: new Map(),
  groupsList: [],
  setGroupsData: (newGroupsMap: any, newGroupsList: any) =>
    set(() => ({
      groupsMap: newGroupsMap,
      groupsList: newGroupsList,
    })),
  groupsShareDialogOpen: false,
  groupsShareDialogData: null,
  toggleGroupsShareDialog: (
    newStatus: boolean,
    newGroupsShareDialogData: any
  ) =>
    set(() => ({
      groupsShareDialogOpen: newStatus,
      groupsShareDialogData: newGroupsShareDialogData,
    })),

  goalPermsDialogOpen: false,
  goalPermsDialogData: null,
  toggleGoalPermsDialog: (newStatus: boolean, newGoalPermsDialogData: any) =>
    set(() => ({
      goalPermsDialogOpen: newStatus,
      goalPermsDialogData: newGoalPermsDialogData,
    })),

  harvestGoals: [],
  setHarvestGoals: (newHarvestGoals: any) =>
    set(() => ({
      harvestGoals: newHarvestGoals,
    })),

  listGoals: [],
  setListGoals: (newListGoals: any) =>
    set(() => ({
      listGoals: newListGoals,
    })),
  pals: [],
  setPals: (newPals: any) => set(() => ({ pals: newPals })),
  joinPoolDialogOpen: false,
  toggleJoinPoolDialogOpen: (newStatus: boolean) =>
    set(() => ({ joinPoolDialogOpen: newStatus })),

  colorMode: "light",
  setColorMode: (colorMode: ColorTheme) => set(() => ({ colorMode })),

  tryingMap: new Map(),
  setTryingMap: (tryingMap: Map<string, object>) => set(() => ({ tryingMap })),
  setTrying: (id: string, value: boolean) => {
    //we set the value at the given location (id) if any
    let newTryingMap: any = new Map(get().tryingMap);

    newTryingMap.set(id, {
      trying: value,
    });
    set(() => ({
      tryingMap: newTryingMap,
    }));
  },
  getTrying: (id: string) => {
    const ha: any = get().tryingMap;
    if (ha.has(id)) return ha.get(id).trying;
    return false;
  },

  ctrlPressed: false,
  setCtrlPressed: (state: boolean) => set(() => ({ ctrlPressed: state })),

  goalTagsDialogOpen: false,
  goalTagsDialogData: null,
  toggleGoalTagsDialog: (newStatus: boolean, newGoalTagsDialogData: any) =>
    set(() => ({
      goalTagsDialogOpen: newStatus,
      goalTagsDialogData: newGoalTagsDialogData,
    })),

  filterTagsDialogOpen: false,
  filterTagsDialogData: null,
  toggleFilterTagsDialog: (newStatus: boolean) =>
    set(() => ({
      filterTagsDialogOpen: newStatus,
    })),

  allTags: [],
  setAllTags: (newAllTags: any) => set(() => ({ allTags: newAllTags })),

  tagFilterArray: [],
  setTagFilterArray: (newTagFilterArray: Array<string>) =>
    set(() => ({ tagFilterArray: newTagFilterArray })),

  draggingParentId: null,
  setDraggingParentId: (draggingParentId: string | null) =>
    set(() => ({ draggingParentId })),

  mainLoading: {
    trying: false,
    success: true,
    error: false,
  },
  setMainLoading: (mainLoading: Loading) => set(() => ({ mainLoading })),

  activeSubsMap: {},
  setActiveSubsMap: (newActiveSubsMap: Object) =>
    set(() => ({ activeSubsMap: newActiveSubsMap })),

  pageInfo: null,
  setPageInfo: (newPageInfo: any) => set(() => ({ pageInfo: newPageInfo })),
}));

export default useStore;
