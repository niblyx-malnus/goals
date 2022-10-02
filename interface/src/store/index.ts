import create from "zustand";
import { FilterGoals, Order, SnackBarData } from "../types/types";

interface Store {
  /*
   * Pools is a list of projects(projects contain goals)
   * this is our main data for the whole app
   * a structure for displaying the interface is derived from this (nestedPools (TODO: change name))
   * incoming changes happen in pools which triggers a change in our "display" structure
   */
  pools: any;
  setPools: (state: any) => void;

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
  toggleTimelineDialog: (newStatus: boolean) => void;
}

const useStore = create<Store>((set, get) => ({
  pools: [],
  setPools: (newPools: any) => set(() => ({ pools: newPools })),

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

  order: "asc",
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
  setLogList: (newItem) => {
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
  toggleTimelineDialog: (newStatus: boolean) =>
    set(() => ({
      timelineDialogOpen: newStatus,
    })),
}));

export default useStore;
