import memoize from "lodash/memoize";
import { v4 as uuidv4 } from "uuid";
import { Order } from "../types/types";

declare const window: Window &
  typeof globalThis & {
    scry: any;
    poke: any;
    ship: any;
  };
const isDev = () =>
  !process.env.NODE_ENV || process.env.NODE_ENV === "development";
const log = (...args: any) => {
  //console log, only displays results in dev mode
  if (!isDev()) return;
  console.log(...args);
};
const shipName = memoize(() => {
  //returns the current ship's name
  return isDev() ? process.env.REACT_APP_SHIP_NAME : window.ship;
});
const getRoleTitle = (role: any): "owner" | "admin" | "chief" | "viewer" => {
  if (role === "owner") {
    return "owner";
  } else if (role === "admin") {
    return "admin";
  } else if (role === "spawn") {
    return "chief";
  } //if (role === null)
  else {
    return "viewer";
  }
};
const uuid = (): string => {
  return uuidv4();
};
function selectOrderList(order: Order, options: any, isPool = true) {
  let prefix = isPool ? "roots" : "young";
  //return appropriate array according to given order
  //options is an object that has the possible 4 array to select from
  if (order === "by-kickoff") {
    return options[prefix + "-by-deadline"];
  } else if (order === "by-deadline") {
    return options[prefix + "-by-deadline"];
  } else if (order === "by-precedence") {
    return options[prefix + "-by-precedence"];
  } else {
    return options[prefix];
  }
}
export { log, isDev, shipName, getRoleTitle, uuid, selectOrderList };
