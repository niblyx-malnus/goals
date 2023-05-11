/*Functions we use to generate data to enter to the store*/

import useStore from ".";
import { GoalId, Order, PinId } from "../types/types";
import cloneDeep from "lodash/cloneDeep";
import { log } from "../helpers";
import api from "../api";
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
function updatePoolPax(toUpdatePin: PinId, newPax: any) {
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;
  //go through our pools updating the pax of appropriate pool
  const newPools = pools.map((poolItem: any, index: number) => {
    const { pin, pool } = poolItem;
    if (pin.birth === toUpdatePin.birth) {
      return {
        ...poolItem,
        pool: { ...pool, trace: { ...pool.trace, ...newPax } },
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
function updateGoalYoung(pinId: PinId, goalId: GoalId, young: any) {
  const state = useStore.getState();
  const pools = state.pools;
  const setPools = state.setPools;

  //select the project using pin
  //update the appropriate goal's young

  const newPools = pools.map((poolItem: any, poolIndex: number) => {
    const { pin } = poolItem;
    if (pin.birth === pinId.birth) {
      //filter our existing cached goals in goals (in case of showing archive => true)
      let newGoals = poolItem.pool.nexus.goals.map((goalItem: any) => {
        if (goalItem.id.birth === goalId.birth) {
          return {
            ...goalItem,
            goal: {
              ...goalItem.goal,
              nexus: { ...goalItem.goal.nexus, young },
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
      newGoals.push({ goal: newGoal, id: newGoalId });
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

  setPools(newPools);
}
function reorderGoalsAction(
  targetGoalId: string,
  referenceGoalId: string,
  parentGoalId: GoalId | null,
  position: "before" | "after",
  pinId: PinId
) {
  const state = useStore.getState();
  const pools = state.pools;
  let youngs: any = [];
  /*
   */
  //  #1 find the youngs of the parent
  pools.forEach((poolItem: any, poolIndex: number) => {
    const { pin } = poolItem;
    if (pin.birth === pinId.birth) {
      if (parentGoalId === null) {
        //we don't have a parent goal, we have a parent pool, so we use this pool's trace
        youngs = cloneDeep(poolItem.pool.trace.roots);
      } else {
        poolItem.pool.nexus.goals.forEach((goalItem: any, goalIndex: any) => {
          //find the right goal
          if (goalItem.id.birth === parentGoalId?.birth) {
            youngs = cloneDeep(goalItem.goal.nexus.young);
          }
        });
      }
    }
  });
  let youngsIdList = youngs?.map((item: any) => {
    return parentGoalId === null ? item.birth : item.id.birth;
  });
  //  #2 find index of target goal
  let targetIndex = youngsIdList.indexOf(targetGoalId);
  //  #3 find index of refernce goal

  let referenceIndex = youngsIdList.indexOf(referenceGoalId);
  //  #4 save target goal and remove it from the list
  const targetYoung = youngs.splice(targetIndex, 1);

  //  #5 offset position correctly
  let finalTargetIndex;

  if (position === "after") {
    finalTargetIndex = referenceIndex;
    if (targetIndex > referenceIndex) finalTargetIndex = referenceIndex + 1; //TODO: figure out why this is the case
    if (referenceIndex === 0) finalTargetIndex = 1;
  } else {
    //position before
    finalTargetIndex = referenceIndex - 1;
    if (referenceIndex === 0) finalTargetIndex = 0;
  }

  //  #6 create a new list using the removed element and the offset position

  let newYoungs = [
    ...youngs.slice(0, finalTargetIndex),
    ...targetYoung,
    ...youngs.slice(finalTargetIndex),
  ];
  if (parentGoalId === null) {
    api.reorderRoots(pinId, newYoungs);
  } else {
    api.reorderGoals(
      parentGoalId,
      newYoungs.map((item: any) => {
        return item.id;
      })
    );
  }
}
function harvestAskAction(type: "main" | "pool" | "goal", id: any) {
  const store = useStore.getState();
  const activeSubsMap = cloneDeep(store.activeSubsMap);
  log("activeSubsMap", activeSubsMap);
  if (activeSubsMap.harvest) {
    // have an active sub already, unsub before sending a new ask
    api.unsub(activeSubsMap.harvest);
    //delete it from the activeSubMap
    delete activeSubsMap.harvest;
    store.setActiveSubsMap(activeSubsMap);
  }

  //get tags if any and pass them along
  const tagFilterArray = store.tagFilterArray;
  let newId;
  if (type !== "main") {
    newId = { owner: id.owner.substring(1), birth: id.birth }; //we have to cut off the first character ~ from the owner
  }

  api.harvestAsk(type, newId, tagFilterArray);
}
function listAskAction(type: "main" | "pool" | "goal", id: any) {
  const store = useStore.getState();
  //get tags if any and pass them along
  const activeSubsMap = cloneDeep(store.activeSubsMap);
  const tagFilterArray = store.tagFilterArray;

  if (activeSubsMap["list-view"]) {
    // have an active sub already, unsub before sending a new ask
    api.unsub(activeSubsMap["list-view"]);
    //delete it from the activeSubMap
    delete activeSubsMap["list-view"];

    store.setActiveSubsMap(activeSubsMap);
  }
  let newId;
  if (type !== "main") {
    newId = { owner: id.owner.substring(1), birth: id.birth }; //we have to cut off the first character ~ from the owner
  }
  api.listAsk(type, newId, tagFilterArray);
}
async function subToViewAction(view: string, path: string) {
  const store = useStore.getState();

  try {
    const subNumber = await api.sub(path); //we use this to unsub
    const activeSubsMap = store.activeSubsMap;
    //TODO: issue with the way updates are patched in so we can not accumlate the values here, so we have to do it with side-effects

    activeSubsMap[view] = subNumber;
  } catch (e) {
    log("subToViewAction error =>", e);
  }
}
export {
  deletePoolAction,
  deleteGoalAction,
  updateToglsAction,
  updatePoolTitleAction,
  updateGoalDescAction,
  newGoalAction,
  newPoolAction,
  updatePoolPermsAction,
  archiveGoalAction,
  archivePoolAction,
  renewGoalAction,
  deleteArchivedGoalAction,
  renewPoolAction,
  deleteArchivedPoolAction,
  nexusListAction,
  reorderGoalsAction,
  updatePoolPax,
  updateGoalYoung,
  harvestAskAction,
  listAskAction,
  subToViewAction,
};
