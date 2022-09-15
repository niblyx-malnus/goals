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
const shipName = () => {
  //returns the current ship's name
  return isDev() ? process.env.REACT_APP_SHIP_NAME : window.ship;
};
export { log, isDev, shipName };
