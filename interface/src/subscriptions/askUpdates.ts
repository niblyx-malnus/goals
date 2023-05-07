import { cloneDeep } from "lodash";
import { log } from "../helpers";
import useStore from "../store";
import { newGoalAction, updatePoolPax } from "../store/actions";
const setLogList = useStore.getState().setLogList;
const setListGoals = useStore.getState().setListGoals;
const setHarvestGoals = useStore.getState().setHarvestGoals;

const updateHandler = (update: any) => {
  log("update", update);

  const actionName: any = Object.keys(update)[0];
  log("actionName", actionName);

  if (actionName) {
    switch (actionName) {
      case "harvest": {
        setHarvestGoals(update[actionName]);
        break;
      }
      case "list-view": {
        setListGoals(update[actionName]);
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