import memoize from "lodash/memoize";
import Urbit from "@urbit/http-api";
import { isDev, log } from "./helpers";
import updates from "./subscriptions/updates";
import askUpdates from "./subscriptions/askUpdates";
const apiApp = process.env.REACT_APP_APP;
const apiMark = process.env.REACT_APP_MARK;
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
    urb.subscribe(askUpdates);
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
  poke: ({
    app = "cell",
    mark = "sheet",
    json = JSON.stringify([["test"]]),
    pokeId = "",
  }) => {
    try {
      const relay = { pid: pokeId, pok: json };

      return api.createApi().poke({
        app,
        mark,
        json: relay,
      });
    } catch (e) {
      log("poke error: ", e);
    }
  },
  getGroupData: async () => {
    return api.createApi().scry({ app: "groups", path: "/groups" });
  },
  getData: async () => {
    //gets our main data we display (pools/goals)
    return api.createApi().scry({ app: apiApp, path: "/initial" });
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
    return api.poke({
      app: apiApp,
      mark: "goal-action",
      json: newPool,
    });
  },
  editPoolTitle: async (pin, newTitle) => {
    const poolToEdit = {
      "edit-pool-title": {
        pin,
        title: newTitle,
      },
    };

    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: poolToEdit,
      pokeId: pin.birth,
    });
  },
  editPoolNote: async (pin, newNote) => {
    const poolToEdit = {
      "edit-pool-note": {
        pin,
        note: newNote,
      },
    };

    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: poolToEdit,
      pokeId: pin.birth,
    });
  },
  deletePool: async (pin) => {
    const poolToDelete = {
      "trash-pool": {
        pin,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: poolToDelete,
      pokeId: pin.birth,
    });
  },
  renewPool: async (pin) => {
    const poolToRenew = {
      "renew-pool": {
        pin,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: poolToRenew,
      pokeId: pin.birth,
    });
  },
  archivePool: async (pin) => {
    const poolToArchive = {
      "cache-pool": {
        pin,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: poolToArchive,
      pokeId: pin.birth,
    });
  },
  subscribePool: async (pin) => {
    const poolToJoin = {
      subscribe: {
        pin,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: poolToJoin,
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
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: newGoal,
    });
  },
  deleteGoal: async (id) => {
    const goalToDelete = {
      "trash-goal": {
        id,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: goalToDelete,
      pokeId: id.birth,
    });
  },
  renewGoal: async (id) => {
    const goalToRenew = {
      "renew-goal": {
        id,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: goalToRenew,
      pokeId: id.birth,
    });
  },
  archiveGoal: async (id, pokeId) => {
    const goalToArchive = {
      "cache-goal": {
        id,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: goalToArchive,
      pokeId: id.birth,
    });
  },
  putGoalTags: async (id, tags) => {
    const goalToEdit = {
      "put-goal-tags": {
        id,
        tags: tags /* [
            {
              "text": "this is a tag!",
              "color":"0xab.cdef"
            },
            {
              "text":"another TAG, fr",
              "color":"0x00.defc"
            }
          ]*/,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: goalToEdit,
      pokeId: id.birth,
    });
  },
  putGoalPrivateTags: async (id, tags) => {
    const goalToEdit = {
      "put-private-tags": {
        id,
        tags: tags /*[
          {
            text: "this is a tag!",
            color: "0xab.cdef",
            private: true,
          },
        ],*/,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: goalToEdit,
      pokeId: id.birth,
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
      app: apiApp,
      mark: apiMark,
      json: goalToEdit,
      pokeId: id.birth,
    });
  },
  editGoalNote: async (id, newNote) => {
    const goalToEdit = {
      "edit-goal-note": {
        id,
        note: newNote,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: goalToEdit,
      pokeId: id.birth,
    });
  },

  markComplete: async (id) => {
    const goalToMark = {
      "mark-complete": {
        id,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: goalToMark,
      pokeId: id.birth,
    });
  },
  unmarkComplete: async (id) => {
    const goalToMark = {
      "unmark-complete": {
        id,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: goalToMark,
      pokeId: id.birth,
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
      app: apiApp,
      mark: apiMark,
      json: newPoolPerms,
      pokeId: pin.birth,
    });
  },
  updateGoalPermissions: async (id, chief, spawnList, rec) => {
    const newGoalPerms = {
      "update-goal-perms": {
        id,
        chief,
        rec,
        spawn: spawnList,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: newGoalPerms,
      pokeId: id.birth,
    });
  },
  leavePool: async (pin) => {
    const poolToLeave = {
      unsubscribe: {
        pin,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: poolToLeave,
      pokeId: pin.birth,
    });
  },
  markActionable: async (id) => {
    const goalToMark = {
      "mark-actionable": {
        id,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: goalToMark,
      pokeId: id.birth,
    });
  },
  unmarkActionable: async (id) => {
    const goalToMark = {
      "unmark-actionable": {
        id,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: goalToMark,
      pokeId: id.birth,
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
      app: apiApp,
      mark: apiMark,
      json: newKickoff,
      pokeId: id.birth,
    });
  },
  reorderGoals: async (id, young) => {
    const newOrder = {
      "reorder-young": {
        id, //id of the parent of the goals
        young /*list of the new order of the sub-goals of the parent [
          {
            owner: "zod",
            birth: "~2000.1.1",
          },
          {
            owner: "zod",
            birth: "~2000.1.1",
          },
        ],*/,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: newOrder,
      pokeId: id.birth,
    });
  },
  reorderRoots: async (pin, roots) => {
    //same as reorder goals but for root goals
    const newOrder = {
      "reorder-roots": {
        pin,
        roots /*[
          {
            owner: "zod",
            birth: "~2000.1.1",
          },
          {
            owner: "zod",
            birth: "~2000.1.1",
          },
        ],*/,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: newOrder,
      pokeId: pin.birth,
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
      app: apiApp,
      mark: apiMark,
      json: newDeadline,
      pokeId: id.birth,
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
      app: apiApp,
      mark: apiMark,
      json: newDeadline,
      pokeId: id.birth,
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
      app: apiApp,
      mark: apiMark,
      json: poolToCopy,
      pokeId: oldPin.birth,
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
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: goalMove,
      pokeId: goalId.birth,
    });
  },
  yoke: async (pin, yokeList) => {
    const yokeSequence = {
      yoke: {
        pin,
        yoks: yokeList,
      },
    };
    return api.poke({
      app: apiApp,
      mark: apiMark,
      json: yokeSequence,
      pokeId: pin.birth,
    });
  },
  harvest: async (owner, birth) => {
    return api.createApi().scry({
      app: apiApp,
      path: `/goal/~${owner}/${birth}/full-harvest`,
    });
  },
  getPals: async () => {
    return api.createApi().scry({ app: "pals", path: "/json" });
  },

  getPool: async (poolId) => {
    return api
      .createApi()
      .scry({ app: apiApp, path: `/pool/${poolId.owner}/${poolId.birth}` });
  },
  getGoal: async (goalId) => {
    //  (all real and virtual descendents, with both id and goal)
    return api.createApi().scry({
      app: apiApp,
      path: `/goal/${goalId.owner}/${goalId.birth}/descendents`,
    });
  },

  harvestAsk: async (type = "main", id, tags = []) => {
    let bodyType;
    if (type === "main") {
      bodyType = { main: null };
    } else if (type === "pool") {
      bodyType = { pool: id };
    } else if (type === "goal") {
      bodyType = { goal: id };
    }
    const json = {
      harvest: {
        type: bodyType,
        method: "any", // can be "any" or "all"
        tags /*[
          { text: "tag1", color: "", private: false },
          { text: "tag2", color: "", private: true },
        ],*/,
      },
    };
    return api.poke({
      app: apiApp,
      mark: "goal-ask",
      json,
      pokeId: "12345",
    });
  },
  listAsk: async (type = "main", id, tags = []) => {
    log("type", type);
    let bodyType;
    if (type === "main") {
      bodyType = { main: null };
    } else if (type === "pool") {
      bodyType = { pool: id };
    } else if (type === "goal") {
      bodyType = { goal: id };
    }
    const json = {
      "list-view": {
        type: bodyType,
        "first-gen-only": false,
        "actionable-only": false,
        method: "any", // can be "any" or "all"
        tags,
      },
    };
    return api.poke({
      app: apiApp,
      mark: "goal-ask",
      json,
      pokeId: "12345",
    });
  },
};
export default api;
