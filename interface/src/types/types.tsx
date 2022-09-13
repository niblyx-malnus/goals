export interface TreeBranch {
  readonly id: string;
  readonly label: string;
  branches?: Tree;
  readonly selected?: boolean;
}
export interface GoalId {
  birth: string;
  owner: string;
}
export interface PinId {
  birth: string;
  owner: string;
}

export type FilterGoals = null | "complete" | "incomplete";
export type Order =  "asc" | "dsc";

export type Tree = ReadonlyArray<TreeBranch>;
