# Pokes 
Available pokes for `%goal-store` as nouns and as JSON.

### Poke List
```
%new-pool
%copy-pool                                                                     
%spawn-goal                                                                     
%edit-goal-desc                                                                 
%edit-pool-title                                                             
%delete-pool                                                                 
%delete-goal                                                                    
%yoke     
%move-goal
%set-kickoff
%set-deadline                                                                   
%mark-actionable                                                                
%unmark-actionable                                                              
%mark-complete                                                                  
%unmark-complete  
%update-goal-perms
%update-pool-perms
```

## %new-pool

### Description
Create a new pool.

A `pool` is simply a collection of goals which can be interrelated with one another.
Anyone who is a viewer on a pool can see all goals in that pool.

`title` is the title of the new pool.

### Noun
```
[%new-pool title=@t]
```

### JSON
```
{
  "new-pool": {
    "title": "title of new pool"
  }
}
```

## %copy-pool
### Description
Make a copy of an existing pool.

`old-pin` is the "pin" or pool id of the pool you want to copy.

`title` is the title of the new pool copy.

### Noun
```
[%copy-pool =old=pin title=@t]
```

### JSON
```
{
  "copy-pool": {
    "old-pin": {
      "owner": "zod",
      "birth": "~2000.1.1"
    }
  }
}
```

## %spawn-goal
### Description
Create a goal under/owned-by/contained-by an existing goal.

`pin` is the pool id.

`upid` is a unit of the parent id (can be null).

`desc` is the description of the new goal.

`actionable` denotes whether a goal is allowed to contain further goals or not. An actionable goal cannot contain subgoals.

### Noun
```
$:  %spawn-goal                                                                  
  =pin                                                                           
  upid=(unit id)    
  desc=@t
  actionable=?                      
==                                                                              
```

### JSON
```
{
  "spawn-goal": {
    "pin": {
      "owner": "zod",
      "birth": "~2000.1.1"
    },
    "upid": (null or "id": { "owner": "zod", "birth": "~2000.1.1" },
    "desc": "description of new goal",
    "actionable": true
  }
}
```

## %edit-goal-desc
### Description
Edit the description of an existing goal.

`id` is the goal id of the goal whose description you want to edit.

`desc` is the new description of the goal.

### Noun
```
[%edit-goal-desc =id desc=@t]                                                   
```

### JSON
```
{
  "edit-goal-desc": {
    "id": {
      "owner": "zod",
      "birth": "~2000.1.1"
    },
    "desc": "new description of goal"
  }
}
```

## %edit-pool-title
### Description
Edit the title of an existing pool.

`pin` is the "pin" or pool id of the pool whose title you want to edit.

`title` is the new title of the pool.

### Noun
```
[%edit-pool-title =pin title=@t]                                             
```

### JSON
```
{
  "edit-pool-title": {
    "pin": {
      "owner": "zod",
      "birth": "~2000.1.1"
    },
    "title": "new title of pool"
  }
}
```

## %delete-pool
### Description
Delete a pool.

`pin` is the "pin" or pool id of the pool you want to delete.

### Noun
```
[%delete-pool =pin]                                                          
```

### JSON
```
{
  "delete-pool": {
    "pin": {
      "owner": "zod",
      "birth": "~2000.1.1"
    }
  }
}
```

## %delete-goal
### Description
Delete a goal.

`id` is the goal id of the goal you want to delete.

### Noun
```
[%delete-goal =id]                                                              
```

### JSON
```
{
  "delete-goal": {
    "id": {
      "owner": "zod",
      "birth": "~2000.1.1"
    }
  }
}
```

## %yoke
### Description
Apply a graph transformation on the DAG data structure.

There are 8 kinds of "yokes":

```
[%held-yoke lid rid]  creates an ownership/containment relationship: lid is owned/contained by rid
[%held-rend-strict lid rid]  breaks an ownership/containment relationship: lid is no longer owned/contained by rid
[%nest-yoke lid rid]  creates a "virtual nesting" relationship; lid is virtually nested under rid
[%nest-rend lid rid]  breaks a "virtual nesting" relationship; lid is no longer directly virtually nested under rid
[%prec-yoke lid rid]  creates a precedence relationship; lid precedes rid
[%prec-rend lid rid]  breaks a precedence relationship; lid no longer directly precedes rid
[%prio-yoke lid rid]  creates a priority relationship; lid is prioritized over rid
[%prio-rend lid rid]  breaks a priority relationship; lid is no longer directly prioritized over rid
```

### Noun
```
[%yoke =pin yok=exposed-yoke]                                               
```

### JSON
```
{
  "yoke": {
    "pin": {
      "owner": "zod",
      "birth": "~2000.1.1"
    },
    "yok": {
      "yoke": "nest-yoke",
      "lid": {
        "owner": "zod",
        "birth": "~2000.1.1"
      },
      "rid": {
        "owner": "zod",
        "birth": "~2000.1.1"
      }
    }
  }
}
```


## %move-goal
### Description
Move a goal.

`pin` is the id of the pool the goals are located in.

`cid` is the id of the goal you are moving (child id).

`upid` is the id of the goal you are moving the first goal under (null if you are moving to the root of the pool).

### Noun
```
[%move-goal =pin cid=id upid=(unit id)]                                                              
```

### JSON
```
{
  "move-goal": {
    "pin": {
      "owner": "zod",
      "birth": "~2000.1.1"
    },
    "cid": {
      "owner": "zod",
      "birth": "~2000.1.1"
    },
    "upid":
    null OR
    {
      "owner": "zod",
      "birth": "~2000.1.1"
    }
  }
}
```

## %set-kickoff
### Description
Set the kickoff of a goal.

`id` is the goal id of the goal whose kickoff you want to set.

`kickoff` is the optional datetime you will use to set the kickoff.

### Noun
```
[%set-kickoff =id kickoff=(unit @da)]                                         
```

### JSON
```
{
  "set-kickoff": {
    "id": {
      "owner": "zod",
      "birth": "~2000.1.1"
    },
    "kickoff": (null or "~2000.1.1")
  }
}
```

## %set-deadline
### Description
Set the deadline of a goal.

`id` is the goal id of the goal whose deadline you want to set.

`deadline` is the optional datetime you will use to set the deadline.

### Noun
```
[%set-deadline =id deadline=(unit @da)]                                         
```

### JSON
```
{
  "set-deadline": {
    "id": {
      "owner": "zod",
      "birth": "~2000.1.1"
    },
    "deadline": (null or "~2000.1.1")
  }
}
```

## %mark-actionable
### Description
Mark a goal actionable. An actionable goal can have no subgoals.

`id` is the goal id of the goal you want to mark actionable.

### Noun
```
[%mark-actionable =id]                                                          
```

### JSON
```
{
  "mark-actionable": {
    "id": {
      "owner": "zod",
      "birth": "~2000.1.1"
    }
  }
}
```

## %unmark-actionable
### Description
Unmark a goal actionable. An actionable goal can have no subgoals.

`id` is the goal id of the goal you want to unmark actionable.

### Noun
```
[%unmark-actionable =id]                                                        
```

### JSON
```
{
  "unmark-actionable": {
    "id": {
      "owner": "zod",
      "birth": "~2000.1.1"
    }
  }
}
```

## %mark-complete
### Description
Mark a goal complete. All preceding goals must already be marked complete.

`id` is the goal id of the goal you want to mark complete.

### Noun
```
[%mark-complete =id]
```

### JSON
```
{
  "mark-complete": {
    "id": {
      "owner": "zod",
      "birth": "~2000.1.1"
    }
  }
}
```

## %unmark-complete
### Description
Unmark a goal complete. No succeeding goals can already be marked complete.

`id` is the goal id of the goal you want to unmark complete.

### Noun
```
[%unmark-complete =id]                                                          
```

### JSON
```
{
  "unmark-complete": {
    "id": {
      "owner": "zod",
      "birth": "~2000.1.1"
    }
  }
}
```

## %update-goal-perms
### Description
Update goal permissions.

`id` is the id of the goal whose perms you are updating.

`chief` is the new chief of the goal.

`rec` is a flag. If rec is true, the chief will recursively be replaced on all goal descendents. If rec is false only the current goals chief will be replaced.

`lus` is a set of ships to add to the goal's spawn set. Ships with spawn privileges on a goal can spawn new goals under that goal on which they become the chief.

`hep` is a set of ships to remove from the goal's spawn set. Ships with spawn privileges on a goal can spawn new goals under that goal on which they become the chief.

### Noun
```
[%update-goal-perms =id chief=ship rec=?(%.y %.n) lus=(set ship) hep=(set ship)]
```

### JSON
```
{
  "update-goal-perms": {
    "id": {
      "owner": "zod",
      "birth": "~2000.1.1"
    },  
    "chief": "zod",
    "rec": true,
    "lus": ["nec", "bud", "wes"],
    "hep": ["sev", "per", "sut"]
  }
}
```


## %update-pool-perms
### Description
Update pool permissions and invite new viewers or kick existing viewers.

`pin` is the id of the pool whose perms you are updating.

`upds` is a list of ship/role pairs where you are updating ship's permissions on this pool to be role. `role` can be `null` if you want to make the ship a viewer, `admin` if you want to make them an `admin`, `spawn` if you want to give them spawn privileges, or `kick` if you want to remove them from the pool.

(If you are not poking using JSON, `~` corresponds to kick, `[~ ~]` corresponds to `null`, `[~ %admin]` corresponds to `admin`, and `[~ %spawn]` corresponds to `spawn`.)

### Noun
```
[%update-pool-perms =pin upds=(list [=ship role=(unit (unit ?(%admin %spawn)))])]
```

### JSON
```
{
  "update-pool-perms": {
    "pin": {
      "owner": "zod",
      "birth": "~2000.1.1"
    },   
    "upds":
      [
        {
          ship: "nec",
          role=(null or "kick" or "admin" or "spawn")
        }, 
        {
          ship: "nec", 
          role=(null or "kick" or "admin" or "spawn")
        }
      ]
  }
}
```
