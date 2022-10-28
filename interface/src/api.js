import memoize from "lodash/memoize";
import Urbit from "@urbit/http-api";
import { isDev, log } from "./helpers";
import updates from "./subscriptions/updates";

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
    //sub to our frontend updates
    urb.subscribe(updates);
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
  poke: async ({
    app = "cell",
    mark = "sheet",
    json = JSON.stringify([["test"]]),
  }) => {
    try {
      const relay = { pid: 1, pok: json };
      log("relay", relay);
      log("app", app);
      log("mark", mark);
      const response = await api.createApi().poke({
        app,
        mark,
        json: relay,
      });
      log("poke response: ", response);
    } catch (e) {
      log("poke error: ", e);
    }
  },
  getGroupData: async () => {
    return api.createApi().scry({ app: "goal-store", path: "/groups" });
  },
  getData: async () => {
    //gets our main data we display (pools/goals)
    return api.createApi().scry({ app: "goal-store", path: "/initial" });
  },
  addPool: async (title) => {
    const newPool = {
      "spawn-pool": {
        title,
        captains: [],
        admins: [],
        viewers: [],
      },
    };
    return api.poke({ app: "goal-store", mark: "goal-action", json: newPool });
  },
  editPoolTitle: async (pin, newTitle) => {
    const poolToEdit = {
      "edit-pool-title": {
        pin,
        title: newTitle,
      },
    };

    return api.poke({
      app: "goal-store",
      mark: "goal-action",
      json: poolToEdit,
    });
  },
  deletePool: async (pin) => {
    const poolToDelete = {
      "trash-pool": {
        pin,
      },
    };
    return api.poke({
      app: "goal-store",
      mark: "goal-action",
      json: poolToDelete,
    });
  },
  renewPool: async (pin) => {
    const poolToRenew = {
      "renew-pool": {
        pin,
      },
    };
    return api.poke({
      app: "goal-store",
      mark: "goal-action",
      json: poolToRenew,
    });
  },
  archivePool: async (pin) => {
    const poolToArchive = {
      "cache-pool": {
        pin,
      },
    };
    return api.poke({
      app: "goal-store",
      mark: "goal-action",
      json: poolToArchive,
    });
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
    return api.poke({ app: "goal-store", mark: "goal-action", json: newGoal });
  },
  deleteGoal: async (id) => {
    const goalToDelete = {
      "trash-goal": {
        id,
      },
    };
    return api.poke({
      app: "goal-store",
      mark: "goal-action",
      json: goalToDelete,
    });
  },
  renewGoal: async (id) => {
    const goalToRenew = {
      "renew-goal": {
        id,
      },
    };
    return api.poke({
      app: "goal-store",
      mark: "goal-action",
      json: goalToRenew,
    });
  },
  archiveGoal: async (id) => {
    const goalToArchive = {
      "cache-goal": {
        id,
      },
    };
    return api.poke({
      app: "goal-store",
      mark: "goal-action",
      json: goalToArchive,
    });
  },
  editGoalDesc: async (id, newDesc) => {
    const goalToEdit = {
      "edit-goal-desc": {
        id,
        desc: newDesc,
      },
    };
    return api.poke({
      app: "goal-store",
      mark: "goal-action",
      json: goalToEdit,
    });
  },

  markComplete: async (id) => {
    const goalToMark = {
      "mark-complete": {
        id,
      },
    };
    return api.poke({
      app: "goal-store",
      mark: "goal-action",
      json: goalToMark,
    });
  },
  unmarkComplete: async (id) => {
    const goalToMark = {
      "unmark-complete": {
        id,
      },
    };
    return api.poke({
      app: "goal-store",
      mark: "goal-action",
      json: goalToMark,
    });
  },
  updatePoolPermissions: async (pin, newRoleList) => {
    const newPoolPerms = {
      "update-pool-perms": {
        pin,
        new: newRoleList,
      },
    };
    return api.poke({
      app: "goal-store",
      mark: "goal-action",
      json: newPoolPerms,
    });
  },
  leavePool: async (pin) => {
    const poolToLeave = {
      unsubscribe: {
        pin,
      },
    };
    return api.poke({
      app: "goal-store",
      mark: "goal-action",
      json: poolToLeave,
    });
  },
  markActionable: async (id) => {
    const goalToMark = {
      "mark-actionable": {
        id,
      },
    };
    return api.poke({
      app: "goal-store",
      mark: "goal-action",
      json: goalToMark,
    });
  },
  unmarkActionable: async (id) => {
    const goalToMark = {
      "unmark-actionable": {
        id,
      },
    };
    return api.poke({
      app: "goal-store",
      mark: "goal-action",
      json: goalToMark,
    });
  },
  setKickoff: async (id, date) => {
    const newKickoff = {
      "set-kickoff": {
        id,
        kickoff: date, //null or date
      },
    };
    return api.poke({
      app: "goal-store",
      mark: "goal-action",
      json: newKickoff,
    });
  },
  setDeadline: async (id, date) => {
    const newDeadline = {
      "set-deadline": {
        id,
        deadline: date, //null or date
      },
    };
    return api.poke({
      app: "goal-store",
      mark: "goal-action",
      json: newDeadline,
    });
  },
  copyPool: async (oldPin, title) => {
    const poolToCopy = {
      "clone-pool": {
        pin: oldPin,
        title,
      },
    };
    return api.poke({
      app: "goal-store",
      mark: "goal-action",
      json: poolToCopy,
    });
  },
  moveGoal: async (pin, goalId, targetGoalId) => {
    const goalMove = {
      move: {
        pin,
        cid: goalId,
        upid: targetGoalId,
      },
    };
    return api.poke({ app: "goal-store", mark: "goal-action", json: goalMove });
  },
  yoke: async (pin, yokeList) => {
    const yokeSequence = {
      yoke: {
        pin,
        yoks: yokeList,
      },
    };
    return api.poke({
      app: "goal-store",
      mark: "goal-action",
      json: yokeSequence,
    });
  },
  harvest: async (owner, birth) => {
    return api
      .createApi()
      .scry({
        app: "goal-store",
        path: `/goal/~${owner}/${birth}/full-harvest`,
      });
  },
  getPals: async () => {
    return api.createApi().scry({ app: "pals", path: "/json" });
  },
};
export default api;
