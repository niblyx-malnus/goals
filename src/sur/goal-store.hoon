/-  *goal
|%
::
+$  action
  $%  [%new-project title=@t chefs=(set ship) peons=(set ship) viewers=(set ship)]
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
      [%del =id]
      [%held-yoke lef=id ryt=id]
      [%held-rend lef=id ryt=id]
      [%nest-yoke lef=id ryt=id]
      [%nest-rend lef=id ryt=id]
      [%prec-yoke lef=id ryt=id]
      [%prec-rend lef=id ryt=id]
      [%prio-yoke lef=id ryt=id]
      [%prio-rend lef=id ryt=id]
      [%sd =id deadline=(unit @da)]
      [%actionate =id]
      [%complete =id]
      [%activate =id]
      [%make-chef chef=ship =id]
      [%make-peon peon=ship =id]
      [%invite invitee=ship =pin]
      [%subscribe owner=ship =pin]
  ==
::
+$  update
  $%  [%project-update =project]
      [%store-update =store]
  ==
--
