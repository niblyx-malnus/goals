# Pokes 
Available pokes for `%goal-store` as nouns and as JSON.

### poke-list

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
:*  %new-project
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
```

### JSON
```
```

## %new-goal  
### Description

### Noun
```
```

### JSON
```
```

## %add-under
### Description

### Noun
```
```

### JSON
```
```

## %edit-goal-desc
### Description

### Noun
```
```

### JSON
```
```

## %edit-project-title
### Description

### Noun
```
```

### JSON
```
```

## %delete-project
### Description

### Noun
```
```

### JSON
```
```

## %delete-goal
### Description

### Noun
```
```

### JSON
```
```

## %yoke-sequence
### Description

### Noun
```
```

### JSON
```
```

## %set-deadline
### Description

### Noun
```
```

### JSON
```
```

## %mark-actionable
### Description

### Noun
```
```

### JSON
```
```

## %unmark-actionable
### Description

### Noun
```
```

### JSON
```
```

## %mark-complete
### Description

### Noun
```
```

### JSON
```
```

## %unmark-complete
### Description

### Noun
```
```

### JSON
```
```

## %make-chef
### Description

### Noun
```
```

### JSON
```
```

## %make-peon
### Description

### Noun
```
```

### JSON
```
```
