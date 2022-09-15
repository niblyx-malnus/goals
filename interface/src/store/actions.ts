/*Functions we use to generate data to enter to the store*/

import useStore from ".";
import { GoalId, Order, PinId } from "../types/types";
import cloneDeep from "lodash/cloneDeep";
import { log } from "../helpers";
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
function updatePoolTitleAction(toUpdatePin: PinId, newTitle: string) {
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;
  //go through our pools updating the title of the one matching the pin passed
  const newPools = pools.map((poolItem: any, index: number) => {
    const { pin, pool } = poolItem;
    if (pin.birth === toUpdatePin.birth) {
      return {
        ...poolItem,
        pool: { ...pool, hitch: { ...pool.hitch, title: newTitle } },
      };
    }
    return poolItem;
  });
  setPools(newPools);
}
function deleteGoalAction(toDeleteList: GoalId[], pinId: PinId) {
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;

  const toDeleteIdList = toDeleteList.map((item: GoalId) => item.birth);
  //select the project using pin, and then filter out goals using toDeleteId
  const newPools = pools.map((poolItem: any, poolIndex: number) => {
    const { pin } = poolItem;
    if (pin.birth === pinId.birth) {
      const newGoals = poolItem.pool.nexus.goals.filter(
        (goalItem: any, goalIndex: any) => {
          return !toDeleteIdList.includes(goalItem.id.birth);
        }
      );
      return {
        ...poolItem,
        pool: {
          ...poolItem.pool,
          nexus: { ...poolItem.pool.nexus, goals: newGoals },
        },
      };
    }
    return poolItem;
  });
  setPools(newPools);
}
function updateGoalDescAction(
  toUpdateId: GoalId,
  pinId: PinId,
  newDesc: string
) {
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;
  //select the project using pin, and then update the goal matching toUpdateId's desc
  const newPools = pools.map((poolItem: any, poolIndex: number) => {
    const { pin } = poolItem;
    if (pin.birth === pinId.birth) {
      const newGoals = poolItem.pool.nexus.goals.map(
        (goalItem: any, goalIndex: any) => {
          if (goalItem.id.birth === toUpdateId.birth) {
            return {
              goal: {
                ...goalItem.goal,
                hitch: {
                  ...goalItem.goal.hitch,
                  desc: newDesc,
                },
              },
              id: goalItem.id,
            };
          }
          return goalItem;
        }
      );
      return {
        ...poolItem,
        pool: {
          ...poolItem.pool,
          nexus: { ...poolItem.pool.nexus, goals: newGoals },
        },
      };
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
      const newGoals = poolItem.pool.nexus.goals.map(
        (goalItem: any, goalIndex: any) => {
          if (goalItem.id.birth === toMarkId.birth) {
            return {
              goal: {
                ...goalItem.goal,
                togls: {
                  ...goalItem.goal.togls,
                  complete: status,
                },
              },
              id: goalItem.id,
            };
          }
          return goalItem;
        }
      );
      return {
        ...poolItem,
        pool: {
          ...poolItem.pool,
          nexus: { ...poolItem.pool.nexus, goals: newGoals },
        },
      };
    }
    return poolItem;
  });

  setPools(newPools);
}
//called form subscription events
function newGoalAction(
  newGoalId: GoalId,
  pinId: PinId,
  newGoal: any,
  nexus: any = null
) {
  const state = useStore.getState();
  const pools = state.pools;
  const order = state.order;
  const setPools = state.setPools;
  //select project using pinId and then add the goal to the goal list
  //if nexus(add-under(nesting)) is provided, we find the goal provided in the nexus and update it with the new data

  const newPools = pools.map((poolItem: any, poolIndex: number) => {
    const { pin } = poolItem;
    if (pin.birth === pinId.birth) {
      const newGoals = poolItem.pool.nexus.goals.map((goalItem: any) => {
        if (nexus?.length > 0 && nexus[0].id.birth === goalItem.id.birth) {
          return {
            ...goalItem,
            goal: {
              ...goalItem.goal,
              ...nexus.goal,
            },
          };
        }
        return goalItem;
      });
      if (order === "asc") {
        newGoals.push({ goal: newGoal, id: newGoalId });
      } else {
        newGoals.unshift({ goal: newGoal, id: newGoalId });
      }
      return {
        ...poolItem,
        pool: {
          ...poolItem.pool,
          nexus: { ...poolItem.pool.nexus, goals: newGoals },
        },
      };
    }

    return poolItem;
  });
  setPools(newPools);
}
function newPoolAction(newPool: any) {
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;
  //concat the new project to the pools
  const newPools = cloneDeep(pools);
  newPools.push(newPool);
  setPools(newPools);
}
function orderPoolsAction(newOrder: Order) {
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;
  const setOrder = state.setOrder;
  //reorder the goals using the helper
  const newPools = orderPools(pools, newOrder);

  setPools(newPools);
  setOrder(newOrder);
}
function updatePoolPermsAction(toUpdatePin: PinId, newPerms: any) {
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;

  //go through our poool, find the one with the toUpdatePin id and update it's perms with the new ones
  const newPools = pools.map((poolItem: any, index: number) => {
    const { pin, pool } = poolItem;
    if (pin.birth === toUpdatePin.birth) {
      return {
        ...poolItem,
        pool: { ...pool, perms: newPerms },
      };
    }
    return poolItem;
  });
  setPools(newPools);
}
//this is actually just a helper
const orderPools = (pools: any, order: Order) => {
  //reorder the pools and then the goals, returns ordered pools
  const orderedPoolsAndGoals = pools.map((poolItem: any) => {
    const reorderedGoal = poolItem.pool.nexus.goals.sort(
      (aey: any, bee: any) => {
        if (order === "asc") return aey.goal.froze.birth - bee.goal.froze.birth;
        return bee.goal.froze.birth - aey.goal.froze.birth;
      }
    );
    return {
      ...poolItem,
      pool: {
        ...poolItem.pool,
        nexus: { ...poolItem.pool.nexus, goals: reorderedGoal },
      },
    };
  });
  return orderedPoolsAndGoals;
};
export {
  deletePoolAction,
  deleteGoalAction,
  toggleCompleteAction,
  updatePoolTitleAction,
  updateGoalDescAction,
  newGoalAction,
  newPoolAction,
  orderPoolsAction,
  orderPools,
  updatePoolPermsAction,
};
