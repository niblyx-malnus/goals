import memoize from "lodash/memoize";

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
  //if (!isDev()) return;
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
export { log, isDev, shipName, getRoleTitle };
