# Pokes 
Available pokes for `%goal-store` as nouns and as JSON.

### Poke List
```
%spawn-pool
%clone-pool
%cache-pool
%renew-pool
%trash-pool
%spawn-goal
%waste-goal
%cache-goal
%renew-goal
%trash-goal
%edit-goal-desc                                                                 
%edit-pool-title                                                               
%move
%yoke
%set-kickoff
%set-deadline                                                                   
%mark-actionable                                                                
%unmark-actionable                                                              
%mark-complete                                                                  
%unmark-complete  
%update-goal-perms
%update-pool-perms
```

## %spawn-pool

### Description
Create a new pool.

A `pool` is simply a collection of goals which can be interrelated with one another.
Anyone who is a viewer on a pool can see all goals in that pool.

`title` is the title of the new pool.

### Noun
```
[%spawn-pool title=@t]
```

### JSON
```
{
  "spawn-pool": {
    "title": "title of new pool"
  }
}
```

## %clone-pool
### Description
Make a copy of an existing pool.

`pin` is the "pin" or pool id of the pool you want to clone/copy.

`title` is the title of the new pool copy.

### Noun
```
[%clone-pool =pin title=@t]
```

### JSON
```
{
  "clone-pool": {
    "pin": {
      "owner": "zod",
      "birth": "~2000.1.1"
    },
  "title": "new title"
  }
}
```

## %cache-pool
### Description
Move an active pool to the cache.

`pin` is the "pin" or pool id of the pool you want to cache/archive.

### Noun
```
[%cache-pool =pin]
```

### JSON
```
{
  "cache-pool": {
    "pin": {
      "owner": "zod",
      "birth": "~2000.1.1"
    }
  }
}
```

## %renew-pool
### Description
Renew a pool from the cache to the active pools.

`pin` is the "pin" or pool id of the pool you want to renew/restore.

### Noun
```
[%renew-pool =pin]
```

### JSON
```
{
  "renew-pool": {
    "pin": {
      "owner": "zod",
      "birth": "~2000.1.1"
    }
  }
}
```

## %trash-pool
### Description
Delete an existing pool from the active pools or from the cache.

`pin` is the "pin" or pool id of the pool you want to trash/delete.

### Noun
```
[%trash-pool =pin]
```

### JSON
```
{
  "trash-pool": {
    "pin": {
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

## %waste-goal
### Description
Permanently delete an active goal directly.

`id` is the id of the goal you want to directly permanently delete.

### Noun
```
[%waste-goal =id]
```

### JSON
```
{
  "waste-goal": {
    "id": {
      "owner": "zod",
      "birth": "~2000.1.1"
    }
  }
}
```

## %cache-goal
### Description
Move an active goal and its subgoals to the pool's cache.

`id` is the id of the goal you want to cache/archive.

### Noun
```
[%cache-goal =id]
```

### JSON
```
{
  "cache-goal": {
    "id": {
      "owner": "zod",
      "birth": "~2000.1.1"
    }
  }
}
```

## %renew-goal
### Description
Renew a goal from the cache to the active goals.

`id` is the id of the goal you want to renew/restore.

### Noun
```
[%renew-goal =id]
```

### JSON
```
{
  "renew-goal": {
    "id": {
      "owner": "zod",
      "birth": "~2000.1.1"
    }
  }
}
```

## %trash-goal
### Description
Delete a goal from the pool's cache.

`id` is the id of the goal you want to trash/delete.

### Noun
```
[%trash-goal =id]
```

### JSON
```
{
  "trash-goal": {
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
[%held-rend lid rid]  breaks an ownership/containment relationship: lid is no longer owned/contained by rid
[%nest-yoke lid rid]  creates a "virtual nesting" relationship; lid is virtually nested under rid
[%nest-rend lid rid]  breaks a "virtual nesting" relationship; lid is no longer directly virtually nested under rid
[%prec-yoke lid rid]  creates a precedence relationship; lid precedes rid
[%prec-rend lid rid]  breaks a precedence relationship; lid no longer directly precedes rid
[%prio-yoke lid rid]  creates a priority relationship; lid is prioritized over rid
[%prio-rend lid rid]  breaks a priority relationship; lid is no longer directly prioritized over rid
```

### Noun
```
[%yoke =pin yoks=(list exposed-yoke)]                                               
```

### JSON
```
{
  "yoke": {
    "pin": {
          "owner": "zod",
          "birth": "~2000.1.2"
        }
    "yoks": [
      {
        "yoke": "nest-yoke",
        "lid": {
          "owner": "zod",
          "birth": "~2000.1.1"
        },
        "rid": {
          "owner": "zod",
          "birth": "~2000.1.2"
        }
      },
      {
        "yoke": "nest-rend",
        "lid": {
          "owner": "zod",
          "birth": "~2000.1.3"
        },
        "rid": {
          "owner": "zod",
          "birth": "~2000.1.4"
        }
      }
    ]
  }
}
```


## %move
### Description
Move a goal.

`cid` is the id of the goal you are moving (child id).

`upid` is the id of the goal you are moving the first goal under (null if you are moving to the root of the pool).

### Noun
```
[%move cid=id upid=(unit id)]                                                              
```

### JSON
```
{
  "move": {
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

`spawn` is a new set of ships to replace the goal's spawn set.

### Noun
```
[%update-goal-perms =id chief=ship rec=?(%.y %.n) spawn=(set ship)]
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
    "spawn": ["nec", "bud", "wes"]
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

## %subscribe
### Description
Subscribe to an existing pool.

`pin` is the "pin" or pool id of the pool that you want to subscribe to.

### Noun
```
[%subscribe =pin]                                             
```

### JSON
```
{
  "subscribe": {
    "pin": {
      "owner": "zod",
      "birth": "~2000.1.1"
    }
}
```
