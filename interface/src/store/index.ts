import create from "zustand";

interface Store {
  /*
   * Pools is a list of projects(projects contain goals)
   * this is our main data for the whole app
   * a structure for displaying the interface is derived from this (nestedPools (TODO: change name))
   * incoming changes happen in pools which triggers a change in our "display" structure
   */
  pools: any;
  setPools: (state: any) => void;
}

const useStore = create<Store>((set, get) => ({
  pools: [],
  setPools: (newPools: any) => set(() => ({ pools: newPools })),
}));

export default useStore;
