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
function archivePoolAction(toCachePin: PinId) {
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;

  const showArchived = state.showArchived;
  const archivedPools = state.archivedPools;
  const setArchivedPools = state.setArchivedPools;

  let newArchivedPool: any = []; //holds one element
  //filter out the pools using pin.birth
  const newPools = pools.filter((poolItem: any, index: number) => {
    const { pin } = poolItem;
    if (pin.birth === toCachePin.birth) {
      //make sure to include isArchived flag
      newArchivedPool.push({
        ...poolItem,
        pool: { ...poolItem.pool, isArchived: true },
      });
    }
    return pin.birth !== toCachePin.birth;
  });
  //if we are showing the archived we update the newPools to include the new archived pool
  if (showArchived) {
    newPools.push(newArchivedPool[0]);
  }
  //add the newly cached pool to our cached pools list
  setArchivedPools([...archivedPools, ...newArchivedPool]);
  setPools(newPools);
}
function updatePoolTitleAction(toUpdatePin: PinId, newHitch: any) {
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;
  //go through our pools updating the title of the one matching the pin passed
  const newPools = pools.map((poolItem: any, index: number) => {
    const { pin, pool } = poolItem;
    if (pin.birth === toUpdatePin.birth) {
      return {
        ...poolItem,
        pool: { ...pool, hitch: { ...pool.hitch, ...newHitch } },
      };
    }
    return poolItem;
  });
  setPools(newPools);
}
function deleteGoalAction(
  toDeleteList: GoalId[],
  toUpdateNexusList: any,
  pinId: PinId
) {
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;

  const toDeleteIdList = toDeleteList.map((item: GoalId) => item.birth);
  const toUpdateNexusMap = new Map();
  toUpdateNexusList.forEach((item: any) => {
    toUpdateNexusMap.set(item.id.birth, item.goal);
  });
  //select the project using pin, and then filter out goals using toDeleteId
  const newPools = pools.map((poolItem: any, poolIndex: number) => {
    const { pin } = poolItem;
    if (pin.birth === pinId.birth) {
      //filter out the goals that exist in toDeleteIdList
      let newGoals = poolItem.pool.nexus.goals.filter(
        (goalItem: any, goalIndex: any) => {
          return !toDeleteIdList.includes(goalItem.id.birth);
        }
      );
      //update the goal's nexus with the given nexus list(when you delete one or more of a goal's children)
      newGoals = newGoals.map((goalItem: any) => {
        if (toUpdateNexusMap.has(goalItem.id.birth)) {
          return {
            ...goalItem,
            goal: {
              ...goalItem.goal,
              nexus: {
                ...goalItem.goal.nexus,
                ...toUpdateNexusMap.get(goalItem.id.birth),
              },
            },
          };
        }
        return goalItem;
      });
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
function deleteArchivedGoalAction(toDeleteList: GoalId[], pinId: PinId) {
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;

  const toDeleteIdList = toDeleteList.map((item: GoalId) => item.birth);

  //select the project using pin, and then filter out goals from goals/cache using toDeleteId
  const newPools = pools.map((poolItem: any, poolIndex: number) => {
    const { pin } = poolItem;
    if (pin.birth === pinId.birth) {
      //filter out the goals that exist in nexus => goals/cache
      let newGoals = poolItem.pool.nexus.goals.filter((goalItem: any) => {
        return !toDeleteIdList.includes(goalItem.id.birth);
      });
      let newCachedGoals = poolItem.pool.nexus.cache.filter((goalItem: any) => {
        return !toDeleteIdList.includes(goalItem.id.birth);
      });

      return {
        ...poolItem,
        pool: {
          ...poolItem.pool,
          nexus: {
            ...poolItem.pool.nexus,
            goals: newGoals,
            cache: newCachedGoals,
          },
        },
      };
    }
    return poolItem;
  });
  setPools(newPools);
}
function renewGoalAction(toRenewList: GoalId[], pinId: PinId) {
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;

  const renewGoalsMap = new Map();
  toRenewList.forEach((goalItem: any) => {
    renewGoalsMap.set(goalItem.id.birth, goalItem);
  });
  //select the project using pin
  //remove from cached list and goals list and add back to goal list fresh (in case we are showing archived)

  const newPools = pools.map((poolItem: any, poolIndex: number) => {
    const { pin } = poolItem;
    if (pin.birth === pinId.birth) {
      //filter our existing cached goals in goals (in case of showing archive => true)
      let newGoals = poolItem.pool.nexus.goals.filter((goalItem: any) => {
        return !renewGoalsMap.has(goalItem.id.birth);
      });
      const newCache = poolItem.pool.nexus.cache.filter((goalItem: any) => {
        return !renewGoalsMap.has(goalItem.id.birth);
      });
      //add back the renewed goals to the goals list
      newGoals = [...newGoals, ...toRenewList];
      return {
        ...poolItem,
        pool: {
          ...poolItem.pool,
          nexus: { ...poolItem.pool.nexus, goals: newGoals, cache: newCache },
        },
      };
    }
    return poolItem;
  });
  setPools(newPools);
}
function deleteArchivedPoolAction(poolToDelete: PinId) {
  //remove from poolList and from the cachedPools(store)
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;

  const archivedPools = state.archivedPools;
  const setArchivedPools = state.setArchivedPools;

  //filter our the poolToDelete from the pools (active) list
  const newPools = pools.filter((poolItem: any) => {
    const { pin } = poolItem;
    return pin.birth !== poolToDelete.birth;
  });
  //filter out the poolToDelete from the cached pools list
  const newArchivedPools = archivedPools.filter((poolItem: any) => {
    const { pin } = poolItem;
    return pin.birth !== poolToDelete.birth;
  });
  log("newArchivedPools", newArchivedPools);
  setArchivedPools(newArchivedPools);
  setPools(newPools);
}
function renewPoolAction(poolToRenew: PinId, poolData: any) {
  //remove from cachedPools(store) and remove it from the pools and add it back  (in case we are showing archived)
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;

  const archivedPools = state.archivedPools;
  const setArchivedPools = state.setArchivedPools;

  //filter our the poolToRenew and add back in after this
  const newPools = pools.filter((poolItem: any) => {
    const { pin } = poolItem;
    return pin.birth !== poolToRenew.birth;
  });
  newPools.push({ pin: poolToRenew, pool: poolData });
  //filter out the poolToRenew from the cached pools list
  const newArchivedPools = archivedPools.filter((poolItem: any) => {
    const { pin } = poolItem;
    return pin.birth !== poolToRenew.birth;
  });
  //add the newly cached pool to our cached pools list
  //TODO
  setArchivedPools(newArchivedPools);
  setPools(newPools);
}
function archiveGoalAction(
  toCacheGoals: GoalId[],
  toUpdateNexusList: any,
  pinId: PinId
) {
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;
  const showArchived = state.showArchived;

  const toCacheIdList = toCacheGoals.map((item: GoalId) => item.birth);
  const toUpdateNexusMap = new Map();
  toUpdateNexusList.forEach((item: any) => {
    toUpdateNexusMap.set(item.id.birth, item.goal);
  });
  //select the project using pin, update the nexus from the given map and move the cachedGoals to the cache array
  const newPools = pools.map((poolItem: any, poolIndex: number) => {
    const { pin } = poolItem;
    if (pin.birth === pinId.birth) {
      //update the goal's nexus with the given nexus list(when you delete one or more of a goal's children)
      //we hold on to this for other operations
      const nexUpdatedGoals = poolItem.pool.nexus.goals.map((goalItem: any) => {
        if (toUpdateNexusMap.has(goalItem.id.birth)) {
          return {
            ...goalItem,
            goal: {
              ...goalItem.goal,
              nexus: {
                ...goalItem.goal.nexus,
                ...toUpdateNexusMap.get(goalItem.id.birth),
              },
            },
          };
        }
        return goalItem;
      });
      //remove the toCache items from newGoals
      let newGoals = nexUpdatedGoals.filter((goalItem: any, goalIndex: any) => {
        return !toCacheIdList.includes(goalItem.id.birth);
      });
      //create our new cached goals to be added to the existing cache list
      const incomingCachedGoals = nexUpdatedGoals.filter(
        (goalItem: any, goalIndex: any) => {
          return !!toCacheIdList.includes(goalItem.id.birth);
        }
      );

      //if we happen to be in showing the archives to the user, we add the new incoming cache goals to the live goals
      if (showArchived) {
        newGoals = [
          ...newGoals,
          //make sure to include isArchived for the new cache goals to be displayed correctly
          ...incomingCachedGoals.map((goalItem: any) => {
            return {
              ...goalItem,
              goal: {
                ...goalItem.goal,
                isArchived: true,
              },
            };
          }),
        ];
      }
      // add the incoming cache items to our cacheList and add back the existing items (merge incoming cache with previous cache)
      const newCache = [...poolItem.pool.nexus.cache, ...incomingCachedGoals];
      return {
        ...poolItem,
        pool: {
          ...poolItem.pool,
          nexus: { ...poolItem.pool.nexus, goals: newGoals, cache: newCache },
        },
      };
    }
    return poolItem;
  });
  setPools(newPools);
}
function updateGoalDescAction(toUpdateId: GoalId, pinId: PinId, newHitch: any) {
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
                  ...newHitch,
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
function updateToglsAction(goalId: GoalId, pinId: PinId, toglChange: any) {
  log("toglChange", toglChange);

  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;
  //select the project using pin, and then merge in the incoming togls change
  const newPools = pools.map((poolItem: any, poolIndex: number) => {
    const { pin } = poolItem;
    if (pin.birth === pinId.birth) {
      const newGoals = poolItem.pool.nexus.goals.map(
        (goalItem: any, goalIndex: any) => {
          if (goalItem.id.birth === goalId.birth) {
            return {
              goal: {
                ...goalItem.goal,
                nexus: {
                  ...goalItem.goal.nexus,
                  ...toglChange,
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
  nexusList: any = null
) {
  const state = useStore.getState();
  const pools = state.pools;
  const order = state.order;
  const setPools = state.setPools;
  //select project using pinId and then add the goal to the goal list, we also update all the goal's in the given nexus list
  const nexusMap = new Map();
  nexusList.forEach((nex: any) => {
    nexusMap.set(nex.id.birth, nex.goal);
  });
  const newPools = pools.map((poolItem: any, poolIndex: number) => {
    const { pin } = poolItem;
    if (pin.birth === pinId.birth) {
      const newGoals = poolItem.pool.nexus.goals.map((goalItem: any) => {
        if (nexusMap.has(goalItem.id.birth)) {
          return {
            ...goalItem,
            goal: {
              ...goalItem.goal,
              nexus: {
                ...goalItem.goal.nexus,
                ...nexusMap.get(goalItem.id.birth),
              },
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

function nexusListAction(pinId: PinId, nexusList: any) {
  //given a pin and a nexus list, affect the nexus changes to the goal's that correspond
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;
  const order = state.order;
  //go through pools select our pool, and update the goals (their nexus) that need to be update
  //create a map for ease of interaction
  const nexusMap = new Map();
  nexusList.forEach((nex: any) => {
    nexusMap.set(nex.id.birth, nex.goal);
  });
  let newPools = pools.map((poolItem: any, poolIndex: number) => {
    const { pin } = poolItem;
    if (pin.birth === pinId.birth) {
      const newGoals = poolItem.pool.nexus.goals.map(
        (goalItem: any, goalIndex: any) => {
          if (nexusMap.has(goalItem.id.birth)) {
            return {
              ...goalItem,
              goal: {
                ...goalItem.goal,
                nexus: {
                  ...goalItem.goal.nexus,
                  ...nexusMap.get(goalItem.id.birth),
                },
              },
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
  //since left-plumb changes, we have to reoreder the goals (if sorting prio)
  //TODO: this could happen everytime a list of nexus patches in (add elsewhere, maybe actions?)
  if (order === "prio") {
    newPools = orderPools(newPools, order);
  }
  setPools(newPools);
}

//this is actually just a helper
const orderPools = (pools: any, order: Order) => {
  //reorder the pools and then the goals, returns ordered pools
  function prioCompare(aey: any, bee: any) {
    const plumbLeftA = aey.goal.nexus.kickoff["left-plumb"];
    const plumbLeftB = bee.goal.nexus.kickoff["left-plumb"];

    if (plumbLeftA < plumbLeftB) {
      return -1;
    }
    var order = "asc";
    //will order youngest (higher birth) first
    return birthCompare(aey, bee);
  }
  function birthCompare(aey: any, bee: any) {
    const birthA = aey.goal.froze.birth;
    const birthB = bee.goal.froze.birth;

    if (order === "asc") return birthA - birthB;
    return birthB - birthA;
  }
  const compareFoo = order === "prio" ? prioCompare : birthCompare;
  const orderedPoolsAndGoals = pools.map((poolItem: any) => {
    const reorderedGoal = poolItem.pool.nexus.goals.sort(compareFoo);
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
  updateToglsAction,
  updatePoolTitleAction,
  updateGoalDescAction,
  newGoalAction,
  newPoolAction,
  orderPoolsAction,
  orderPools,
  updatePoolPermsAction,
  archiveGoalAction,
  archivePoolAction,
  renewGoalAction,
  deleteArchivedGoalAction,
  renewPoolAction,
  deleteArchivedPoolAction,
  nexusListAction,
};
