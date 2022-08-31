/-  *goal
|%
::
+$  action
  $%  [%new-project title=@t chefs=(set ship) peons=(set ship) viewers=(set ship)]
      $:  %copy-project 
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
      [%edit-project-title =pin title=@t]
      [%delete-project =pin]
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
  $%  [%project-update =project]
      [%initial-project-update =project]
      [%store-update =store]
      [%initial =store]
      [%new-goal =pin mod=ship =id =goal]
      [%add-under =pin mod=ship pid=id cid=id =goal]
      [%yoke-sequence =pin mod=ship =yoke-sequence]
  ==
::
+$  store-update  [=pin =update =store]
--
