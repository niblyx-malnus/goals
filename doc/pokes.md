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
    }
    "title": "title of new project",
    "chefs": ["zod", "nec", "bud"],
    "peons": ["zod", "nec", "bud"],
    "viewers": ["zod", "nec", "bud"]
  }
}
```

## %new-goal  
### Description

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
```

## %add-under
### Description

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
```

## %edit-goal-desc
### Description

### Noun
```
[%edit-goal-desc =id desc=@t]                                                   
```

### JSON
```
```

## %edit-project-title
### Description

### Noun
```
[%edit-project-title =pin title=@t]                                             
```

### JSON
```
```

## %delete-project
### Description

### Noun
```
[%delete-project =pin]                                                          
```

### JSON
```
```

## %delete-goal
### Description

### Noun
```
[%delete-goal =id]                                                              
```

### JSON
```
```

## %yoke-sequence
### Description

### Noun
```
[%yoke-sequence =pin =yoke-sequence]                                               
```

### JSON
```
```

## %set-deadline
### Description

### Noun
```
[%set-deadline =id deadline=(unit @da)]                                         
```

### JSON
```
```

## %mark-actionable
### Description

### Noun
```
[%mark-actionable =id]                                                          
```

### JSON
```
```

## %unmark-actionable
### Description

### Noun
```
[%unmark-actionable =id]                                                        
```

### JSON
```
```

## %mark-complete
### Description

### Noun
```
[%mark-complete =id]
```

### JSON
```
```

## %unmark-complete
### Description

### Noun
```
[%unmark-complete =id]                                                          
```

### JSON
```
```

## %make-chef
### Description

### Noun
```
[%make-chef chef=ship =id]
```

### JSON
```
```

## %make-peon
### Description

### Noun
```
[%make-peon peon=ship =id]                                                      
```

### JSON
```
```
