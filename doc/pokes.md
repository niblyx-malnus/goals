# Pokes 
Available pokes for `%goal-store` as nouns and as JSON.

### Poke List
```
%new-pool
%copy-pool
%new-goal                                                                       
%add-under                                                                      
%edit-goal-desc                                                                 
%edit-pool-title                                                             
%delete-pool                                                                 
%delete-goal                                                                    
%yoke                                                                  
%set-deadline                                                                   
%mark-actionable                                                                
%unmark-actionable                                                              
%mark-complete                                                                  
%unmark-complete                                                                
%make-chef
%make-peon
```

## %new-pool

### Description
Create a new pool.

A `pool` is simply a collection of goals which can be interrelated with one another.
Anyone who is a viewer on a pool can see all goals in that pool.

`title` is the title of the new pool.

`chefs` are essentially admins; they have full permissions to add/edit/delete any goal in the pool.

`peons` can mark (and unmark) any goal in the pool complete. This is the only kind of permissions they have.

`viewers` can view the pool and store a copy of the pool on their own ship.

### Noun
```
$:  %new-pool
    title=@t
    chefs=(set ship)
    peons=(set ship)
    viewers=(set ship)
==
```

### JSON
```
{
  "new-pool": {
    "title": "title of new pool",
    "chefs": ["zod", "nec", "bud"],
    "peons": ["zod", "nec", "bud"],
    "viewers": ["zod", "nec", "bud"]
  }
}
```

## %copy-pool
### Description
Make a copy of an existing pool.

`old-pin` is the "pin" or pool id of the pool you want to copy.

`title` is the title of the new pool copy.

`chefs` are essentially admins; they have full permissions to add/edit/delete any goal in the pool.

`peons` can mark (and unmark) any goal in the pool complete. This is the only kind of permissions they have.

`viewers` can view the pool and store a copy of the pool on their own ship.

### Noun
```
$:  %copy-pool
    =old=pin
    title=@t
    chefs=(set ship)
    peons=(set ship)
    viewers=(set ship)
==
```

### JSON
```
{
  "copy-pool": {
    "old-pin": {
      "owner": "zod",
      "birth": "~2000.1.1"
    },
    "title": "title of new pool",
    "chefs": ["zod", "nec", "bud"],
    "peons": ["zod", "nec", "bud"],
    "viewers": ["zod", "nec", "bud"]
  }
}
```

## %new-goal  
### Description
Create a new root goal in a given pool.

`pin` is the "pin" or pool id of the pool you want to add a goal to.

`desc` is the description of the new goal.

`chefs` are essentially admins; they have full permissions to add/edit/delete this goal, or any of its descendents.

`peons` can mark (and unmark) this goal and any of its descendents complete. This is the only kind of permissions they have.

`deadline` is an optional datetime marking the deadline for the goal.

`actionable` denotes whether a goal is allowed to contain further goals or not. An actionable goal cannot contain subgoals.

### Noun
```
$:  %new-goal                                                                   
  =pin                                                                             
  desc=@t                                                                       
  chefs=(set ship)                                                                 
  peons=(set ship)                                                              
  deadline=(unit @da)                                                           
  actionable=?                                                                  
==                                                                                 
```

### JSON
```
{
  "new-goal": {
    "pin": {
      "owner": "zod",
      "birth": "~2000.1.1"
    },
    "desc": "description of new goal",
    "chefs": ["zod", "nec", "bud"],
    "peons": ["zod", "nec", "bud"],
    "deadline": (null or "~2000.1.1")
    "actionable": true
  }
}
```

## %add-under
### Description
Create a goal under/owned-by/contained-by an existing goal.

`id` is the goal id of the goal you want to add a goal under.

`desc` is the description of the new goal.

`chefs` are essentially admins; they have full permissions to add/edit/delete this goal, or any of its descendents.

`peons` can mark (and unmark) this goal and any of its descendents complete. This is the only kind of permissions they have.

`deadline` is an optional datetime marking the deadline for the goal.

`actionable` denotes whether a goal is allowed to contain further goals or not. An actionable goal cannot contain subgoals.

### Noun
```
$:  %add-under                                                                  
  =id                                                                           
  desc=@t                                                                       
  chefs=(set ship)                                                              
  peons=(set ship)                                                              
  deadline=(unit @da)                                                           
  actionable=?                                                                  
==                                                                              
```

### JSON
```
{
  "add-under": {
    "id": {
      "owner": "zod",
      "birth": "~2000.1.1"
    },
    "desc": "description of new goal",
    "chefs": ["zod", "nec", "bud"],
    "peons": ["zod", "nec", "bud"],
    "deadline": (null or "~2000.1.1")
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

## %yoke-sequence
### Description
Apply a sequence of graph transformations on the DAG data structure (if all are successful; if any fail, none go through).

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

## %make-chef
### Description
Make a ship a "chef" on a given goal. A "chef" has broad permissions on a goal and all its descendents.

`chef` is the ship you want to make a "chef".

`id` is the goal id of the goal you want to make `chef` a "chef" of.

### Noun
```
[%make-chef chef=ship =id]
```

### JSON
```
{
  "make-chef": {
    "chef": "zod",
    "id": {
      "owner": "zod",
      "birth": "~2000.1.1"
    }
  }
}
```

## %make-peon
### Description
Make a ship a "peon" on a given goal. A "peon" can mark (and unmark) a goal and all its descendents complete.

`peon` is the ship you want to make a "peon".

`id` is the goal id of the goal you want to make `peon` a "peon" of.

### Noun
```
[%make-peon peon=ship =id]                                                      
```

### JSON
```
{
  "make-peon": {
    "peon": "zod",
    "id": {
      "owner": "zod",
      "birth": "~2000.1.1"
    }
  }
}
```
