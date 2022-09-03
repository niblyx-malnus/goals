import memoize from "lodash/memoize";
import Urbit from "@urbit/http-api";
/*ENV HELPERS*/
const isDev = () =>
  !process.env.NODE_ENV || process.env.NODE_ENV === "development";
const api = {
  createApi: memoize(() => {
    /*
    Connect to urbit and return the urbit instance
    returns urbit instance
  */
    //ropnys-batwyd-nossyt-mapwet => nec
    //lidlut-tabwed-pillex-ridrup => zod
    const urb = isDev()
      ? new Urbit("http://localhost:80", "lidlut-tabwed-pillex-ridrup")
      : new Urbit("");
    urb.ship = isDev() ? "zod" : window.ship;
    // Just log errors if we get any
    urb.onError = (message) => console.log("onError: ", message);
    urb.onOpen = () => console.log("urbit onOpen");
    urb.onRetry = () => console.log("urbit onRetry");
    //not sure this is needed in release build
    urb.connect();

    return urb;
  }),

  getData: async () => {
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
};
export default api;
