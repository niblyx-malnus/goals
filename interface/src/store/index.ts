import { CreateCssVarsProviderResult } from "@mui/system";
import create from "zustand";
import { log } from "../helpers";
import {
  FilterGoals,
  GoalId,
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
  toggleShowArchived: (newStatus: boolean) => void;

  groupsMap: Map<string, any>; // a map of group names to their data
  groupsList: any; //an array of groups name and their member count
  setGroupsData: (newGroupsMap: any, newGroupsList: any) => void;
  groupsShareDialogOpen: boolean;
  groupsShareDialogData: any;
  toggleGroupsShareDialog: (
    newStatus: boolean,
    newGroupsShareDialogData: any
  ) => void;

  harvestPanelOpen: boolean;
  harvestData: any;
  setHarvestData: (newHarvestPanelState: boolean, newHarvestData: any) => void;

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

  order: "dsc",
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
  toggleShowArchived: (newStatus: boolean) => {
    //toggle showArchived and copy cached pools/goals to the live goals
    //newStatus => true => add the cached goals/pools
    //newStatus => false => remove the cached goals/pools if any
    let pools: any = get().pools;
    let archivedPools: any = get().archivedPools;
    log("archivedPools", archivedPools);
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

  harvestPanelOpen: false,
  harvestData: {},
  setHarvestData: (newHarvestPanelState: boolean, newHarvestData: any) =>
    set(() => ({
      harvestData: newHarvestData,
      harvestPanelOpen: newHarvestPanelState,
    })),
  pals: [],
  setPals: (newPals: any) => set(() => ({ pals: newPals })),
  joinPoolDialogOpen: false,
  toggleJoinPoolDialogOpen: (newStatus: boolean) =>
    set(() => ({ joinPoolDialogOpen: newStatus })),
}));

export default useStore;
