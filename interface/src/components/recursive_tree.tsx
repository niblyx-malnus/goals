import React, { Fragment, useState, memo, useEffect } from "react";
import styled from "@emotion/styled/macro";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import ChevronRightIcon from "@mui/icons-material/ChevronRight";
import Box from "@mui/material/Box";
import { PinId, Tree } from "../types/types";
import MoreHorizIcon from "@mui/icons-material/MoreHoriz";
import IconButton from "@mui/material/IconButton";
import Typography from "@mui/material/Typography";
import NewGoalInput from "./NewGoalInput";
import IconMenu from "./IconMenu";
import EditInput from "./EditInput";
import AddIcon from "@mui/icons-material/Add";
import useStore from "../store";
import CircularProgress from "@mui/material/CircularProgress";
import Chip from "@mui/material/Chip";
import Avatar from "@mui/material/Avatar";
import { log, shipName } from "../helpers";

interface TreeItemProps {
  readonly id: number;
  readonly onSelectCallback: (id: number) => void;
  readonly label: string;
  readonly isSelected: boolean | undefined;
  readonly children: ReadonlyArray<JSX.Element>;
  readonly idObject: any;
  readonly goal: any;
  poolRole: string;
  pin: PinId;
  isCaptain: boolean;
}

export interface RecursiveTreeProps {
  readonly goalList: Tree;
  pin: PinId;

  readonly onSelectCallback: (id: number) => void;
}

const TreeItem = memo(
  ({
    onSelectCallback,
    label,
    isSelected,
    children,
    id,
    idObject,
    goal,
    pin,
    poolRole,
    isCaptain,
  }: TreeItemProps) => {
    const [isOpen, toggleItemOpen] = useState<boolean | null>(null);
    const [selected, setSelected] = useState(isSelected);
    const [addingGoal, setAddingGoal] = useState<boolean>(false);
    const [editingTitle, setEditingTitle] = useState<boolean>(false);
    const [trying, setTrying] = useState<boolean>(false);
    const collapseAll = useStore((store) => store.collapseAll);

    useEffect(() => {
      //everytime collapse all changes, we force isOpen value to comply
      toggleItemOpen(collapseAll.status);
    }, [collapseAll.count]);
    const handleAdd = () => {
      toggleItemOpen(true);
      setAddingGoal(true);
    };
    const renderIconMenu = () => {
      if (poolRole === "viewer") return;
      if (poolRole === "captain" && !isCaptain) return;
      return trying ? (
        <CircularProgress
          size={24}
          sx={{
            position: "absolute",
            left: -30,
          }}
        />
      ) : (
        <IconMenu
          type="goal"
          complete={goal.togls.complete}
          id={idObject}
          pin={pin}
          setParentTrying={setTrying}
        />
      );
    };
    const renderTitle = () => {
      const noEditPermTitle = (
        <Typography
          variant="h6"
          color={"text.primary"}
          style={{
            marginLeft: children && children.length === 0 ? "24px" : "",
            background: `${selected ? "#d5d5d5" : ""}`,
            textDecoration: goal.togls.complete ? "line-through" : "auto",
          }}
        >
          {label}
        </Typography>
      );
      if (poolRole === "viewer") return noEditPermTitle;
      if (poolRole === "captain" && !isCaptain) return noEditPermTitle;
      return !editingTitle ? (
        <Typography
          variant="h6"
          color={trying ? "text.disabled" : "text.primary"}
          onDoubleClick={() => {
            !trying && setEditingTitle(true);
          }}
          style={{
            marginLeft: children && children.length === 0 ? "24px" : "",
            background: `${selected ? "#d5d5d5" : ""}`,
            textDecoration: goal.togls.complete ? "line-through" : "auto",
          }}
        >
          {label}
        </Typography>
      ) : (
        <div
          style={{
            marginLeft: children && children.length === 0 ? "24px" : "",
          }}
        >
          <EditInput
            type="goal"
            title={label}
            onDone={() => {
              setEditingTitle(false);
            }}
            pin={pin}
            id={idObject}
            setParentTrying={setTrying}
          />
        </div>
      );
    };
    const renderAddButton = () => {
      if (poolRole === "viewer") return;
      if (poolRole === "captain" && !isCaptain) return;
      return (
        !trying && (
          <IconButton
            sx={{ opacity: 0 }}
            className="show-on-hover"
            // sx={{ position: "absolute", right: 35 }}
            aria-label="add goal button"
            size="small"
            onClick={handleAdd}
          >
            <AddIcon />
          </IconButton>
        )
      );
    };
    return (
      <div>
        <StyledTreeItem
          sx={{
            "&:hover": {
              cursor: "pointer",
              "& .show-on-hover": {
                opacity: 1,
              },
            },
          }}
        >
          <>
            {renderIconMenu()}

            {children && children.length > 0 && (
              <Box
                sx={{
                  display: "flex",
                  justifyContent: "center",
                  alignItems: "center",
                }}
                className="icon-container"
                onClick={() => toggleItemOpen(!isOpen)}
              >
                {isOpen ? <ExpandMoreIcon /> : <ChevronRightIcon />}
              </Box>
            )}
            {renderTitle()}

            {renderAddButton()}
          </>
          {goal.perms.captains.map((item: any, index: number) => {
            return (
              <Chip
                key={item}
                sx={{ opacity: 0, marginLeft: 1 }}
                avatar={<Avatar>C</Avatar>}
                className="show-on-hover"
                size="small"
                label={<Typography fontWeight={"bold"}>{item}</Typography>}
                color="primary"
                variant="outlined"
              />
            );
          })}
        </StyledTreeItem>
        {addingGoal && (
          <NewGoalInput
            pin={pin}
            parentId={idObject}
            under={true}
            callback={() => setAddingGoal(false)}
          />
        )}
        <StyledTreeChildren
          style={{
            height: !isOpen ? "0px" : "auto",
            overflow: !isOpen ? "hidden" : "visible",
          }}
        >
          {children}
        </StyledTreeChildren>
      </div>
    );
  }
);

const RecursiveTree = ({ goalList, pin, onSelectCallback, poolRole }: any) => {
  const filterGoals = useStore((store) => store.filterGoals);
  const ship = shipName();
  const createTree = (goal: any) => {
    const currentGoal = goal.goal;
    const currentGoalId = goal.id.birth;
    const childGoals = goal.childNodes;
    //filter out complete if store says so
    if (currentGoal.togls.complete && filterGoals === "complete") return null;
    //we need to know if the current ship is a captain on this goal
    const isCaptain = currentGoal.perms.captains.includes(ship);

    return (
      <TreeItem
        idObject={goal.id}
        id={currentGoalId}
        key={currentGoalId}
        onSelectCallback={(id: number) => {
          onSelectCallback(id);
        }}
        isSelected={currentGoal.selected}
        label={currentGoal.hitch.desc}
        goal={currentGoal}
        pin={pin}
        poolRole={poolRole}
        isCaptain={isCaptain}
      >
        {childGoals.map((goal: any) => {
          const currentChildGoalId = goal.id.birth;
          return (
            <Fragment key={currentChildGoalId}>{createTree(goal)}</Fragment>
          );
        })}
      </TreeItem>
    );
  };
  return (
    <Box>
      {goalList.map((goal: any, index: number) => {
        return createTree(goal);
      })}
    </Box>
  );
};

export default memo(RecursiveTree);

// styles
const StyledMenuButton = styled(IconButton)({
  opacity: 0,
  "&:hover": {
    opacity: 1,
  },
});
const StyledMenuButtonContainer = styled(Box)({
  opacity: 0,
  "&:hover": {
    opacity: 1,
  },
});
const StyledLabel = styled(Box)({
  height: "24px",
  "&:hover": {
    cursor: "pointer",
  },
});
const StyledTreeItem = styled(Box)({
  display: "flex",
  flexDirection: "row",
  alignItems: "center",
  position: "relative",
});
const StyledTreeChildren = styled(Box)({
  paddingLeft: "10px",
});
