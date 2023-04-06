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
export type Yoke = "move" | "prioritize" | "precede";
export type SnackBarData = { message: string; severity: string } | null;
export type FilterGoals = null | "complete" | "incomplete" | "actionable";
export type Order = "asc" | "dsc" | "prio";

export type Tree = ReadonlyArray<TreeBranch>;

export interface ChipData {
  key: string;
  label: string;
  canDelete: boolean;
}