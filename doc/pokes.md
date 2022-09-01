# Pokes 
Available pokes for `%goal-store` as nouns and as JSON.

### Poke List
```
%new-project
%copy-project
%new-goal                                                                       
%add-under                                                                      
%edit-goal-desc                                                                 
%edit-project-title                                                             
%delete-project                                                                 
%delete-goal                                                                    
%yoke-sequence                                                                  
%set-deadline                                                                   
%mark-actionable                                                                
%unmark-actionable                                                              
%mark-complete                                                                  
%unmark-complete                                                                
%make-chef
%make-peon
```

## %new-project

### Description
Create a new project.

`title` is the title of the new project.

`chefs` are essentially admins; they have full permissions to add/edit/delete any goal in the project.

`peons` can mark (and unmark) any goal in the project complete. This is the only kind of permissions they have.

`viewers` can view the project and store a copy of the project on their own ship.

### Noun
```
$:  %new-project
    title=@t
    chefs=(set ship)
    peons=(set ship)
    viewers=(set ship)
==
```

### JSON
```
{
  "new-project": {
    "title": "title of new project",
    "chefs": ["zod", "nec", "bud"],
    "peons": ["zod", "nec", "bud"],
    "viewers": ["zod", "nec", "bud"]
  }
}
```

## %copy-project
### Description
Make a copy of an existing project.

`old-pin` is the "pin" or project id of the project you want to copy.

`title` is the title of the new project copy.

`chefs` are essentially admins; they have full permissions to add/edit/delete any goal in the project.

`peons` can mark (and unmark) any goal in the project complete. This is the only kind of permissions they have.

`viewers` can view the project and store a copy of the project on their own ship.

### Noun
```
$:  %copy-project
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
  "copy-project": {
    "old-pin": {
      "owner": "zod"
      "birth": 12345134551113451361
    },
    "title": "title of new project",
    "chefs": ["zod", "nec", "bud"],
    "peons": ["zod", "nec", "bud"],
    "viewers": ["zod", "nec", "bud"]
  }
}
```

## %new-goal  
### Description
Create a new root goal in a given project.

`pin` is the "pin" or project id of the project you want to add a goal to.

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
      "owner": "zod"
      "birth": 12345134551113451361
    },
    "desc": "description of new goal",
    "chefs": ["zod", "nec", "bud"],
    "peons": ["zod", "nec", "bud"],
    "deadline": (null or 12345134551113451361)
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
      "owner": "zod"
      "birth": 12345134551113451361
    },
    "desc": "description of new goal",
    "chefs": ["zod", "nec", "bud"],
    "peons": ["zod", "nec", "bud"],
    "deadline": (null or 12345134551113451361)
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
      "owner": "zod"
      "birth": 12345134551113451361
    },
    "desc": "new description of goal"
  }
}
```

## %edit-project-title
### Description
Edit the title of an existing project.

`pin` is the "pin" or project id of the project whose title you want to edit.

`title` is the new title of the project.

### Noun
```
[%edit-project-title =pin title=@t]                                             
```

### JSON
```
{
  "edit-project-title": {
    "pin": {
      "owner": "zod"
      "birth": 12345134551113451361
    },
    "title": "new title of project"
  }
}
```

## %delete-project
### Description
Delete a project.

`pin` is the "pin" or project id of the project you want to delete.

### Noun
```
[%delete-project =pin]                                                          
```

### JSON
```
{
  "delete-project": {
    "pin": {
      "owner": "zod"
      "birth": 12345134551113451361
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
      "owner": "zod"
      "birth": 12345134551113451361
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
[%yoke-sequence =pin =yoke-sequence]                                               
```

### JSON
```
{
  "yoke-sequence": {
    "pin": {
      "owner": "zod"
      "birth": 12345134551113451361
    },
    "yoke-sequence": [
      {
        "yoke": "nest-yoke",
        "lid": {
          "owner": "zod"
          "birth": 12345134551113451361
        },
        "rid": {
          "owner": "zod"
          "birth": 12345134514371751115
        }
      },
      {
        "yoke": "prec-yoke",
        "lid": {
          "owner": "zod"
          "birth": 12345134551113451361
        },
        "rid": {
          "owner": "zod"
          "birth": 12345134514371751115
        }
      },
      {
        "yoke": "prio-rend",
        "lid": {
          "owner": "zod"
          "birth": 12345134551113451361
        },
        "rid": {
          "owner": "zod"
          "birth": 12345134514371751115
        }
      }
    ]
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
      "owner": "zod"
      "birth": 12345134551113451361
    },
    "deadline": (null or 12345134551113451361)
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
      "owner": "zod"
      "birth": 12345134551113451361
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
      "owner": "zod"
      "birth": 12345134551113451361
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
      "owner": "zod"
      "birth": 12345134551113451361
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
      "owner": "zod"
      "birth": 12345134551113451361
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
      "owner": "zod"
      "birth": 12345134551113451361
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
      "owner": "zod"
      "birth": 12345134551113451361
    }
  }
}
```
