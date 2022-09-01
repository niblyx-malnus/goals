# Pokes 
Available pokes for `%goal-store` as nouns and as JSON.

## %new-project

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

## copy-project

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
