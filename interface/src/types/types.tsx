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
export interface Loading {
  trying: boolean;
  success: boolean;
  error: boolean;
}
export interface ChipData {
  key: string;
  label: string;
  canDelete: boolean;
}

export type PageType = "main" | "pool" | "goal";
export type Yoke = "move" | "prioritize" | "precede";
export type SnackBarData = { message: string; severity: string } | null;
export type FilterGoals = null | "complete" | "incomplete" | "actionable";
export type Order = "default" | "by-kickoff" | "by-deadline" | "by-precedence";

export type Tree = ReadonlyArray<TreeBranch>;
