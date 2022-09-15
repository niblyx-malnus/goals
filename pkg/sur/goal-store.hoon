/-  *goal
|%
::
+$  action
  $%  $:  %new-pool
          title=@t
          admins=(set ship)
          captains=(set ship)
          viewers=(set ship)
      ==
      $:  %copy-pool 
        =old=pin
        title=@t
        admins=(set ship)
        captains=(set ship)
        viewers=(set ship)
      ==
      $:  %spawn-goal
        =pin
        upid=(unit id)
        desc=@t
        actionable=?
        captains=(set ship)
        peons=(set ship)
      ==
      [%edit-goal-desc =id desc=@t]
      [%edit-pool-title =pin title=@t]
      [%delete-pool =pin]
      [%delete-goal =id]
      [%yoke =pin yok=exposed-yoke]
      [%move-goal =pin cid=id upid=(unit id)]
      [%set-deadline =id deadline=(unit @da)]
      [%mark-actionable =id]
      [%unmark-actionable =id]
      [%mark-complete =id]
      [%unmark-complete =id]
      [%make-goal-captain captain=ship =id]
      [%make-goal-peon peon=ship =id]
      $:  %invite
        =pin
        admins=(set ship)
        captains=(set ship)
        viewers=(set ship)
      ==
      [%subscribe =pin]
      [%unsubscribe =pin]
  ==
::
+$  pool-perms-update
  $%  [%add-pool-viewers viewers=(set ship)]
      [%rem-pool-viewers viewers=(set ship)]  
      [%add-pool-admins admins=(set ship)]
      [%rem-pool-admins admins=(set ship)]
      [%add-pool-captains captains=(set ship)]
      [%rem-pool-captains captains=(set ship)]
      [%add-perms admins=(set ship) captains=(set ship) viewers=(set ship)]
  ==
::
+$  pool-hitch-update
  $%  [%title title=@t]
  ==
::
+$  pool-nexus-update
  $%  [%yoke =nex]
  ==
::
+$  goal-perms-update
  $%  [%add-goal-captains captains=(set ship)]
      [%rem-goal-captains captains=(set ship)]
      [%add-goal-peons peons=(set ship)]
      [%rem-goal-peons peons=(set ship)]
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
+$  update
  $%  [%spawn-pool =pool]
      [%trash-pool ~]
      [%spawn-goal =nex =id =goal]
      [%trash-goal =nex del=(set id)]
      [%pool-perms pool-perms-update]
      [%pool-hitch pool-hitch-update]
      [%pool-nexus pool-nexus-update]
      [%goal-perms =id goal-perms-update]
      [%goal-hitch =id goal-hitch-update]
      [%goal-nexus =id goal-nexus-update]
      [%goal-togls =id goal-togls-update]
  ==
+$  away-update  [mod=ship update]
::
+$  home-update  [[=pin mod=ship] update]
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
+$  away-cud  [=pin upd=(list away-update) =store]
+$  home-cud  [=pin upd=(list home-update) =store]
--
