/-  *goal
|%
::
+$  action
  $%  [%new-pool title=@t]
      [%copy-pool =old=pin title=@t]
      [%spawn-goal =pin upid=(unit id) desc=@t actionable=?]
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
      [%update-goal-perms =id chief=ship rec=?(%.y %.n) lus=(set ship) hep=(set ship)]
      [%update-pool-perms =pin upds=(list [=ship role=(unit (unit pool-role))])]
      [%subscribe =pin]
      [%unsubscribe =pin]
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
+$  goal-hitch-update
  $%  [%desc desc=@t]
  ==
::
+$  goal-nexus-update
  $%  [%kickoff moment=(unit @da)]
      [%deadline moment=(unit @da)]
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
      [%pool-perms upds=(list [=ship role=(unit (unit pool-role))])]
      [%pool-hitch pool-hitch-update]
      [%pool-nexus pool-nexus-update]
      [%goal-perms =nex]
      [%goal-hitch =id goal-hitch-update]
      [%goal-nexus =id goal-nexus-update]
      [%goal-togls =id goal-togls-update]
  ==
+$  away-update  [mod=ship update]
::
+$  home-update  [[=pin mod=ship] update]
:: ::
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
