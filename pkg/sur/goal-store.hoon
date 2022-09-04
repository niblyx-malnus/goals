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
+$  update
  $%  [%pool-update =pool]
      [%initial-pool-update =pool]
      [%store-update =store]
      [%initial =store]
      [%new-goal =pin mod=ship =id =goal]
      [%add-under =pin mod=ship pid=id cid=id =goal]
      [%yoke-sequence =pin mod=ship =yoke-sequence]
  ==
::
+$  peek
  $%  [%harvest harvest=(list id)]
      [%get-goal ugoal=(unit goal)]
      [%ryte-bound moment=(unit @da) hereditor=eid]
      [%plumb depth=@ud]
      [%anchor depth=@ud]
      [%seniority u-senior=(unit id)]
  ==
::
+$  store-update  [=pin =update =store]
--
