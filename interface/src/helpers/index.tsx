const isDev = () =>
  !process.env.NODE_ENV || process.env.NODE_ENV === "development";
const log = (...args: any) => {
  //console log, only displays results in dev mode
  if (!isDev) return;
  console.log(...args);
};
export { log, isDev };
