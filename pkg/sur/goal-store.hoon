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
      [%yoke =pin yok=exposed-yoke]
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
+$  pool-perms-update
  $%  [?(%viewer %chef %peon) =ship]
  ==
::
+$  pool-hitch-update
  $%  [%title title=@t]
  ==
::
+$  pool-nexus-update
  $%  [%yoke yok=exposed-yoke nex=(map id goal-nexus)]
  ==
::
+$  goal-perms-update
  $%  [?(%chef %peon) =ship]
  ==
::
+$  goal-hitch-update
  $%  [%desc desc=@t]
  ==
::
+$  goal-nexus-update
  $%  [%deadline moment=(unit @da)]
  ==
::
+$  goal-togls-update
  $%  [%complete complete=?(%.y %.n)]
      [%actionable actionable=?(%.y %.n)]
  ==
::
+$  away-update
  $%  [%spawn-goal =nex =id =goal]
      [%spawn-pool =pool]
      [%trash-goal =id]
      [%trash-pool ~]
      [%pool-perms pool-perms-update]
      [%pool-hitch pool-hitch-update]
      [%pool-nexus pool-nexus-update]
      [%goal-perms =id goal-perms-update]
      [%goal-hitch =id goal-hitch-update]
      [%goal-nexus =id goal-nexus-update]
      [%goal-togls =id goal-togls-update]
  ==
::
+$  home-update  [[=pin mod=ship] away-update]
::
+$  peek
  $%  [%initial =store]
      [%pool-keys keys=(set pin)]
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
+$  away-cud  [=pin =away-update =store]
+$  home-cud  [=pin =home-update =store]
--
