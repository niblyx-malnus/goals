import { cloneDeep } from "lodash";
import { log } from "../helpers";
import useStore from "../store";
import {
  newGoalAction,
  updatePoolPax,
  subToViewAction,
} from "../store/actions";
import api from "../api";
const store = useStore.getState();
const setListGoals = store.setListGoals;
const setHarvestGoals = store.setHarvestGoals;
const setPoolStore = store.setPools;

const updateHandler = (update: any) => {
  const actionName: any = Object.keys(update)[0];
  log("ask update => ", update);
  if (update[actionName].path) {
    //update the active sub map with the incoming paths we sub to
    subToViewAction(actionName, update[actionName].path);
  }
  log("actionName", actionName);

  if (actionName) {
    switch (actionName) {
      case "harvest": {
        setHarvestGoals(update[actionName].data);
        break;
      }
      case "list-view": {
        setListGoals(update[actionName].data);
        break;
      }
      case "tree": {
        setPoolStore(update[actionName].data.pools);
        break;
      }
    }
  }
};
const apiApp = process.env.REACT_APP_APP;

const askUpdates = {
  app: apiApp,
  path: "/ask",
  event: updateHandler,
  //TODO: handle sub death/kick/err
  err: () => log("Subscription rejected"),
  quit: () => log("Kicked from subscription"),
};
export default askUpdates;
