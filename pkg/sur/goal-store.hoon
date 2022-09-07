/-  *goal
|%
::
+$  action
  $%  [%new-pool title=@t chefs=(set ship) peons=(set ship) viewers=(set ship)]
      $:  %copy-pool 
        =old=pin
        title=@t
        chefs=(set ship)
        peons=(set ship)
        viewers=(set ship)
      ==
      $:  %new-goal  
        =pin
        desc=@t
        chefs=(set ship)
        peons=(set ship)
        deadline=(unit @da)
        actionable=?
      ==
      $:  %add-under
        =id
        desc=@t
        chefs=(set ship)
        peons=(set ship)
        deadline=(unit @da)
        actionable=?
      ==
      [%edit-goal-desc =id desc=@t]
      [%edit-pool-title =pin title=@t]
      [%delete-pool =pin]
      [%delete-goal =id]
      [%yoke-sequence =pin =yoke-sequence]
      [%set-deadline =id deadline=(unit @da)]
      [%mark-actionable =id]
      [%unmark-actionable =id]
      [%mark-complete =id]
      [%unmark-complete =id]
      [%make-chef chef=ship =id]
      [%make-peon peon=ship =id]
      [%invite invitee=ship =pin]
      [%subscribe owner=ship =pin]
  ==
::
:: Each update is associated with a single pool
:: (1) Adding new pool
:: (2) Adding new goal to a pool 
:: (3) Updating existing goal in a pool
:: (4) Deleting goal in a pool
:: (5) Deleting a pool
:: Each update has a datetime at which it occurred
:: Each update has a src ship which initiated the update
:: [pin time src ]
::
+$  update
  $%  [%pool-update =pool]
      [%initial-pool-update =pool]
      [%store-update =store]
      [%initial =store]
      [%new-goal =pin mod=ship =id =goal]
      [%add-under =pin mod=ship pid=id cid=id =goal]
      [%yoke-sequence =pin mod=ship =nex]
      [%new-pool =pin =pool]
      [%delete-pool =pin]
      [%delete-goal =pin mod=ship =id]
     ::  [%edit-goal-desc [mod=ship =pin] =id desc=@t]
     ::  [%edit-pool-title [mod=ship =pin] title=@t]
     ::  [%set-deadline [mod=ship =pin] =id deadline=(unit @da)]
     ::  [%mark-actionable [mod=ship =pin] =id]
     ::  [%unmark-actionable [mod=ship =pin] =id]
     ::  [%mark-complete [mod=ship =pin] =id]
     ::  [%unmark-complete [mod=ship =pin] =id]
     ::  [%make-chef [mod=ship =pin] chef=ship =id]
     ::  [%make-peon [mod=ship =pin] peon=ship =id]
     ::  [%failed =action err=@tas]
  ==
::
+$  peek
  $%  [%pool-keys keys=(set pin)]
      [%all-goal-keys keys=(set id)]
      [%harvest harvest=(list id)]
      [%get-goal ugoal=(unit goal)]
      [%get-pin upin=(unit pin)]
      [%get-pool upool=(unit pool)]
      [%ryte-bound moment=(unit @da) hereditor=eid]
      [%plumb depth=@ud]
      [%anchor depth=@ud]
      [%priority priority=@ud]
      [%seniority u-senior=(unit id)]
      [%yung yung=(list id)]
      [%yung-uncompleted yung-uc=(list id)]
      [%yung-virtual yung-vr=(list id)]
      [%roots roots=(list id)]
      [%roots-uncompleted roots-uc=(list id)]
  ==
::
+$  store-update  [=pin =update =store]
--
