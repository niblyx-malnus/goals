import { log } from "../helpers";
import useStore from "../store";
import {
  deleteGoalAction,
  deletePoolAction,
  newGoalAction,
  newPoolAction,
  updatePoolTitleAction,
  updateGoalDescAction,
  updateToglsAction,
  updatePoolPermsAction,
  handleYoke,
  archiveGoalAction,
  archivePoolAction,
  renewGoalAction,
  deleteArchivedGoalAction,
  renewPoolAction,
  deleteArchivedPoolAction,
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
      case "waste-goal": {
        let { waz, nex }: any = update.tel[actionName];
        const hed: any = update.hed;

        deleteGoalAction(waz, nex, hed.pin);
        break;
      }
      case "cache-goal": {
        let { cas, nex }: any = update.tel[actionName];
        const hed: any = update.hed;

        archiveGoalAction(cas, nex, hed.pin);
        break;
      }
      case "renew-goal": {
        let { ren }: any = update.tel[actionName];
        const hed: any = update.hed;

        renewGoalAction(ren, hed.pin);
        break;
      }
      case "trash-goal": {
        let { tas }: any = update.tel[actionName];
        const hed: any = update.hed;

        deleteArchivedGoalAction(tas, hed.pin);
        break;
      }
      case "trash-pool": {
        const hed: any = update.hed;

        deleteArchivedPoolAction(hed.pin);
        break;
      }
      case "cache-pool": {
        const hed: any = update.hed;

        archivePoolAction(hed.pin);
        break;
      }
      case "renew-pool": {
        let { pin, pool }: any = update.tel[actionName];

        renewPoolAction(pin, pool);
        break;
      }
      case "waste-pool": {
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

        let { id }: any = update.tel[actionName];
        const toglChange = update.tel[actionName]["togls-updated"];

        updateToglsAction(id, hed.pin, toglChange);

        break;
      }
      case "pool-perms": {
        const hed: any = update.hed;

        updatePoolPermsAction(hed.pin, update.tel[actionName]);

        break;
      }
      case "pool-nexus": {
        const hed: any = update.hed;
        let { yoke }: any = update.tel[actionName];
        handleYoke(hed.pin, yoke.nex);
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
