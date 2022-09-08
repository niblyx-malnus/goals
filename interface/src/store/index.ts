import create from "zustand";
import { FilterGoals } from "../types/types";

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
  setFilterGoals: (state: any) => void;
}

const useStore = create<Store>((set, get) => ({
  pools: [],
  setPools: (newPools: any) => set(() => ({ pools: newPools })),

  filterGoals: null,
  setFilterGoals: (newStatus: FilterGoals) =>
    set(() => ({ filterGoals: newStatus })),
}));

export default useStore;
