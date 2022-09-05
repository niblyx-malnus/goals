/*Functions we use to generate data to enter to the store*/

import useStore from ".";
import { GoalId, PinId } from "../types/types";

function deletePoolAction(toDeletePin: PinId) {
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;
  //filter out the pools using pin.birth
  const newPools = pools.filter((poolItem: any, index: number) => {
    const { pin } = poolItem;
    return pin.birth !== toDeletePin.birth;
  });

  setPools(newPools);
}
function deleteGoalAction(toDeleteId: GoalId, pinId: PinId) {
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;
  //select the project using pin, and then filter out goals using toDeleteId
  const newPools = pools.map((poolItem: any, poolIndex: number) => {
    const { pin } = poolItem;
    if (pin.birth === pinId.birth) {
      const newGoals = poolItem.pool.goals.filter(
        (goalItem: any, goalIndex: any) => {
          return goalItem.id.birth !== toDeleteId.birth;
        }
      );
      return { ...poolItem, pool: { ...poolItem.pool, goals: newGoals } };
    }
    return poolItem;
  });

  setPools(newPools);
}
function toggleCompleteAction(toMarkId: GoalId, pinId: PinId, status: boolean) {
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;
  //select the project using pin, and then update the goal matching toMarkId's complete status
  const newPools = pools.map((poolItem: any, poolIndex: number) => {
    const { pin } = poolItem;
    if (pin.birth === pinId.birth) {
      const newGoals = poolItem.pool.goals.map(
        (goalItem: any, goalIndex: any) => {
          if (goalItem.id.birth === toMarkId.birth) {
            return {
              goal: {
                ...goalItem.goal,
                complete: status,
              },
              id: goalItem.id,
            };
          }
          return goalItem;
        }
      );
      return { ...poolItem, pool: { ...poolItem.pool, goals: newGoals } };
    }
    return poolItem;
  });

  setPools(newPools);
  return;
}
export { deletePoolAction, deleteGoalAction, toggleCompleteAction };
