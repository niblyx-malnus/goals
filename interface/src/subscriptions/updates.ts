import { log } from "../helpers";
import useStore from "../store";
import {
  deleteGoalAction,
  deletePoolAction,
  newGoalAction,
  newPoolAction,
  updatePoolTitleAction,
  updateGoalDescAction,
  toggleCompleteAction,
  updatePoolPermsAction,
} from "../store/actions";
const setLogList = useStore.getState().setLogList;

const updateHandler = (update: any) => {
  log("update", update);
  const actionName: any = Object.keys(update.tel)[0];

  //add this update to our logList
  setLogList({
    actionName,
    ship: update.hed?.mod,
  });

  if (actionName) {
    switch (actionName) {
      case "spawn-goal": {
        const { goal, id, nex }: any = update.tel[actionName];
        const hed: any = update.hed;
        newGoalAction(id, hed.pin, goal, nex);
        break;
      }
      case "spawn-pool": {
        let { pool, pin }: any = update.tel[actionName];
        const hed: any = update.hed;

        newPoolAction({ pool, pin: hed.pin });
        break;
      }
      case "trash-goal": {
        let { del }: any = update.tel[actionName];
        const hed: any = update.hed;

        deleteGoalAction(del, hed.pin);
        break;
      }
      case "trash-pool": {
        const hed: any = update.hed;

        deletePoolAction(hed.pin);
        break;
      }
      case "pool-hitch": {
        const hed: any = update.hed;
        let { title }: any = update.tel[actionName];

        updatePoolTitleAction(hed.pin, title);
        break;
      }
      case "goal-hitch": {
        const hed: any = update.hed;
        let { desc, id }: any = update.tel[actionName];

        updateGoalDescAction(id, hed.pin, desc);
        break;
      }
      case "goal-togls": {
        const hed: any = update.hed;
        let { complete, id }: any = update.tel[actionName];

        toggleCompleteAction(id, hed.pin, complete);

        break;
      }
      case "pool-perms": {
        const hed: any = update.hed;

        updatePoolPermsAction(hed.pin, update.tel[actionName]);

        break;
      }
    }
  }
};
const updates = {
  app: "goal-store",
  path: "/goals",
  event: updateHandler,
  //TODO: handle sub death/kick/err
  err: () => log("Subscription rejected"),
  quit: () => log("Kicked from subscription"),
};
export default updates;
