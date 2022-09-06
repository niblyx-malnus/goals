import memoize from "lodash/memoize";
import Urbit from "@urbit/http-api";
import { isDev } from "./helpers";
const api = {
  createApi: memoize(() => {
    /*
    Connect to urbit and return the urbit instance
    returns urbit instance
  */
    //ropnys-batwyd-nossyt-mapwet => nec
    //lidlut-tabwed-pillex-ridrup => zod
    const urb = isDev()
      ? new Urbit("http://localhost:8080", "ritdur-hodlyn-wathut-rocmyn")
      : new Urbit("");
    urb.ship = isDev() ? "dorsup-pacsyn-niblyx-malnus" : window.ship;
    // Just log errors if we get any
    urb.onError = (message) => console.log("onError: ", message);
    urb.onOpen = () => console.log("urbit onOpen");
    urb.onRetry = () => console.log("urbit onRetry");
    //not sure this is needed in release build
    urb.connect();

    return urb;
  }),

  getData: async () => {
    //gets our main data we display (pools/goals)
    return api.createApi().scry({ app: "goal-store", path: "/initial" });
  },
  addPool: async (title) => {
    const newPool = {
      "new-pool": {
        title,
        chefs: [],
        peons: [],
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
    //TODO: ask niblyx about order of stuff
    const poolToDelete = {
      "delete-pool": {
        pin,
      },
    };
    return api
      .createApi()
      .poke({ app: "goal-store", mark: "goal-action", json: poolToDelete });
  },
  addGoal: async (desc, pin) => {
    //adds a goal directly under a pool
    const { owner, birth } = pin;
    const newGoal = {
      "new-goal": {
        pin: {
          owner,
          birth,
        },
        desc,
        chefs: [],
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
    //TODO: ask niblyx about order of stuff
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

  addGoalUnderGoal: async (desc, id) => {
    //adds a goal under another goal
    const { owner, birth } = id;
    const newNestedGoal = {
      "add-under": {
        id: {
          owner,
          birth,
        },
        desc,
        chefs: [],
        peons: [],
        deadline: null,
        actionable: false,
      },
    };
    return api
      .createApi()
      .poke({ app: "goal-store", mark: "goal-action", json: newNestedGoal });
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
};
export default api;
