import memoize from "lodash/memoize";
import Urbit from "@urbit/http-api";
import { isDev, log } from "./helpers";

const api = {
  createApi: memoize(() => {
    /*
    Connect to urbit and return the urbit instance
    returns urbit instance
  */
    //ropnys-batwyd-nossyt-mapwet => nec
    //lidlut-tabwed-pillex-ridrup => zod
    const urb = isDev()
      ? new Urbit(
          process.env.REACT_APP_SHIP_URL,
          process.env.REACT_APP_SHIP_CODE
        )
      : new Urbit("");
    urb.ship = isDev() ? process.env.REACT_APP_SHIP_NAME : window.ship;
    // Just log errors if we get any
    urb.onError = (message) => log("onError: ", message);
    urb.onOpen = () => log("urbit onOpen");
    urb.onRetry = () => log("urbit onRetry");
    //not sure this is needed in release build
    urb.connect();

    return urb;
  }),
  scry: async (app = "cell", path = "/pull") => {
    try {
      const response = await api.createApi().scry({ app, path });
      log("scry response: ", response);
    } catch (e) {
      log("scry error: ", e);
    }
  },
  poke: async (
    app = "cell",
    mark = "sheet",
    json = JSON.stringify([["test"]])
  ) => {
    try {
      const response = await api.createApi().poke({
        app,
        mark,
        json,
      });
      log("poke response: ", response);
    } catch (e) {
      log("poke error: ", e);
    }
  },
  getData: async () => {
    //gets our main data we display (pools/goals)
    return api.createApi().scry({ app: "goal-store", path: "/initial" });
  },
  addPool: async (title) => {
    const newPool = {
      "new-pool": {
        title,
        captains: [],
        admins: [],
        viewers: [],
      },
    };
    return api
      .createApi()
      .poke({ app: "goal-store", mark: "goal-action", json: newPool });
  },
  editPoolTitle: async (pin, newTitle) => {
    const poolToEdit = {
      "edit-pool-title": {
        pin,
        title: newTitle,
      },
    };

    return api
      .createApi()
      .poke({ app: "goal-store", mark: "goal-action", json: poolToEdit });
  },
  deletePool: async (pin) => {
    const poolToDelete = {
      "delete-pool": {
        pin,
      },
    };
    return api
      .createApi()
      .poke({ app: "goal-store", mark: "goal-action", json: poolToDelete });
  },
  addGoal: async (desc, pin, parentId) => {
    //parent id => add under
    const newGoal = {
      "spawn-goal": {
        pin,
        upid: parentId ? parentId : null,
        desc,
        captains: [],
        peons: [],
        deadline: null,
        actionable: false,
      },
    };
    return api
      .createApi()
      .poke({ app: "goal-store", mark: "goal-action", json: newGoal });
  },
  deleteGoal: async (id) => {
    const goalToDelete = {
      "delete-goal": {
        id,
      },
    };
    return api
      .createApi()
      .poke({ app: "goal-store", mark: "goal-action", json: goalToDelete });
  },
  editGoalDesc: async (id, newDesc) => {
    const goalToEdit = {
      "edit-goal-desc": {
        id,
        desc: newDesc,
      },
    };
    return api
      .createApi()
      .poke({ app: "goal-store", mark: "goal-action", json: goalToEdit });
  },

  markComplete: async (id) => {
    const goalToMark = {
      "mark-complete": {
        id,
      },
    };
    return api
      .createApi()
      .poke({ app: "goal-store", mark: "goal-action", json: goalToMark });
  },
  unmarkComplete: async (id) => {
    const goalToMark = {
      "unmark-complete": {
        id,
      },
    };
    return api
      .createApi()
      .poke({ app: "goal-store", mark: "goal-action", json: goalToMark });
  },
  updatePoolPermissions: async (pin, viewers, captains, admins) => {
    const newPoolPerms = {
      invite: {
        pin,
        admins,
        captains,
        viewers,
      },
    };
    return api
      .createApi()
      .poke({ app: "goal-store", mark: "goal-action", json: newPoolPerms });
  },
  leavePool: async (pin) => {
    const poolToLeave = {
      unsubscribe: {
        pin,
      },
    };
    return api
      .createApi()
      .poke({ app: "goal-store", mark: "goal-action", json: poolToLeave });
  },
  markActionable: async (id) => {
    const goalToMark = {
      "mark-actionable": {
        id,
      },
    };
    return api
      .createApi()
      .poke({ app: "goal-store", mark: "goal-action", json: goalToMark });
  },
  unmarkActionable: async (id) => {
    const goalToMark = {
      "unmark-actionable": {
        id,
      },
    };
    return api
      .createApi()
      .poke({ app: "goal-store", mark: "goal-action", json: goalToMark });
  },
  setKickoff: async (id, date) => {
    const newKickoff = {
      "set-deadline": {
        id,
        deadline: date, //null or date
      },
    };
    return api
      .createApi()
      .poke({ app: "goal-store", mark: "goal-action", json: newKickoff });
  },
  setDeadline: async (id, date) => {
    const newDeadline = {
      "set-deadline": {
        id,
        deadline: date, //null or date
      },
    };
    return api
      .createApi()
      .poke({ app: "goal-store", mark: "goal-action", json: newDeadline });
  },
};
export default api;
