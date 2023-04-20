import { cloneDeep } from "lodash";
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
  archiveGoalAction,
  archivePoolAction,
  renewGoalAction,
  deleteArchivedGoalAction,
  renewPoolAction,
  deleteArchivedPoolAction,
  nexusListAction,
  updatePoolPax,
  updateGoalYoung
} from "../store/actions";
const setLogList = useStore.getState().setLogList;

const updateHandler = (update: any) => {
  log("update", update);
  //check if the given update contains a id we can use to toggle loading state false (poke relay)
  if (update.hed.pid) {
    const tryingMap = useStore.getState().tryingMap;
    const setTrying = useStore.getState().setTrying;

    if (tryingMap.has(update.hed.pid)) {
      setTrying(update.hed.pid, false);
    }
  }
  const actionName: any = Object.keys(update.tel)[0];

  //add this update to our logList
  setLogList({
    actionName,
    ship: update.hed?.mod,
  });

  if (actionName) {
    switch (actionName) {
      case "spawn-goal": {
        const { goal, id, nex, pex }: any = update.tel[actionName];
        const hed: any = update.hed;
        newGoalAction(id, hed.pin, goal, nex);
        updatePoolPax(hed.pin, pex);
        break;
      }
      case "spawn-pool": {
        let { pool, pin }: any = update.tel[actionName];
        const hed: any = update.hed;

        newPoolAction({ pool, pin: hed.pin });
        break;
      }
      case "waste-goal": {
        let { waz, nex, pex }: any = update.tel[actionName];
        const hed: any = update.hed;

        deleteGoalAction(waz, nex, hed.pin);
        updatePoolPax(hed.pin, pex);

        break;
      }
      case "cache-goal": {
        let { cas, nex, pex }: any = update.tel[actionName];
        const hed: any = update.hed;

        archiveGoalAction(cas, nex, hed.pin);
        updatePoolPax(hed.pin, pex);

        break;
      }
      case "renew-goal": {
        let { ren, pex }: any = update.tel[actionName];
        const hed: any = update.hed;

        renewGoalAction(ren, hed.pin);
        updatePoolPax(hed.pin, pex);

        break;
      }
      case "trash-goal": {
        let { tas, pex }: any = update.tel[actionName];
        const hed: any = update.hed;

        deleteArchivedGoalAction(tas, hed.pin);
        updatePoolPax(hed.pin, pex);

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
        //TODO: get this working with note

        updatePoolTitleAction(hed.pin, update.tel[actionName]);
        break;
      }
      case "goal-hitch": {
        const hed: any = update.hed;
        let { id }: any = update.tel[actionName];

        let newHitch = cloneDeep(update.tel[actionName]);
        delete newHitch.id;

        updateGoalDescAction(id, hed.pin, update.tel[actionName]);
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
        let { pex }: any = update.tel[actionName];

        updatePoolPermsAction(hed.pin, update.tel[actionName]);
        updatePoolPax(hed.pin, pex);

        break;
      }
      case "goal-perms": {
        const hed: any = update.hed;
        let { nex, pex }: any = update.tel[actionName];

        nexusListAction(hed.pin, nex);
        updatePoolPax(hed.pin, pex);

        break;
      }
      case "pool-nexus": {
        const hed: any = update.hed;
        let { yoke, pex }: any = update.tel[actionName];

        nexusListAction(hed.pin, yoke.nex);
        updatePoolPax(hed.pin, pex);

        break;
      }
      case "goal-dates": {
        const hed: any = update.hed;
        let { nex, pex }: any = update.tel[actionName];

        nexusListAction(hed.pin, nex);
        updatePoolPax(hed.pin, pex);

        break;
      }
      case "goal-roots": {
        const hed: any = update.hed;
        let { pex }: any = update.tel[actionName];

        updatePoolPax(hed.pin, pex);

        break;
      }
      case "goal-young": {
        const hed: any = update.hed;
        let { young, id }: any = update.tel[actionName];

        updateGoalYoung(hed.pin, id, young);

        break;
      }
      /* case "goal-nexus": {
        const hed: any = update.hed;
        let { yoke }: any = update.tel[actionName];
        handleYoke(hed.pin, yoke.nex);
        break;
      }*/
    }
  }
};
const apiApp = process.env.REACT_APP_APP;

const updates = {
  app: apiApp,
  path: "/goals",
  event: updateHandler,
  //TODO: handle sub death/kick/err
  err: () => log("Subscription rejected"),
  quit: () => log("Kicked from subscription"),
};
export default updates;
