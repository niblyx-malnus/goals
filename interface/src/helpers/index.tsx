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
const createDataTree = (dataset: any, rootins: any, order: Order) => {
  //maybe here we don't just push to childNodes, we also make sure to push at a certain index childNodes[orderOfGoal] = hashTable[ID]
  const hashTable = Object.create(null);
  dataset.forEach((aData: any) => {
    const ID = aData.id.birth;
    hashTable[ID] = { ...aData, childNodes: [] };
  });

  const dataTree: any = [];
  dataset.forEach((aData: any) => {
    const parentID = aData.goal.nexus?.par?.birth;
    const ID = aData.id.birth;
    if (parentID) {
      if (hashTable[parentID]) {
        //get the young array into something we can easily use (apply indexOf to)
        const youngins = selectOrderList(
          order,
          hashTable[parentID].goal.nexus,
          false
        )?.map((item: any) => {
          return item.id.birth;
        });
        let indexOfChild = youngins.indexOf(ID);
        //add the child at the index it appears in in youngs
        hashTable[parentID].childNodes[indexOfChild] = hashTable[ID];
      }
    } else {
      //add at the correct index according to rootins
      let indexOfRoot = rootins.indexOf(ID);
      dataTree[indexOfRoot] = hashTable[ID];
    }
  });
  return dataTree;
};
export { log, isDev, shipName, getRoleTitle, uuid, selectOrderList , createDataTree};
