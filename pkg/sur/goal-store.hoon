/-  *goal, *group, metadata-store
|%
::
+$  action
  $:  pid=@
  $=  pok
  $%  [%spawn-pool title=@t]
      [%clone-pool =pin title=@t]
      [%cache-pool =pin]
      [%renew-pool =pin]
      [%trash-pool =pin]
      [%spawn-goal =pin upid=(unit id) desc=@t actionable=?]
      [%cache-goal =id]
      [%renew-goal =id]
      [%trash-goal =id]
      [%yoke =pin yoks=(list exposed-yoke)]
      [%move cid=id upid=(unit id)]
      [%set-kickoff =id kickoff=(unit @da)]
      [%set-deadline =id deadline=(unit @da)]
      [%mark-actionable =id]
      [%unmark-actionable =id]
      [%mark-complete =id]
      [%unmark-complete =id]
      [%update-goal-perms =id chief=ship rec=?(%.y %.n) spawn=(set ship)]
      [%update-pool-perms =pin new=pool-perms]
      [%edit-goal-desc =id desc=@t]
      [%edit-pool-title =pin title=@t]
      [%subscribe =pin]
      [%unsubscribe =pin]
  ==  ==
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
      [%cache-pool =pin]
      [%renew-pool =pin =pool]
      [%waste-pool ~]
      [%trash-pool ~]
      [%spawn-goal =nex =id =goal]
      [%waste-goal =nex =id waz=(set id)]
      [%cache-goal =nex =id cas=(set id)]
      [%renew-goal =id ren=goals]
      [%trash-goal =id tas=(set id)]
      [%pool-perms new=pool-perms]
      [%pool-hitch pool-hitch-update]
      [%pool-nexus pool-nexus-update]
      [%goal-perms =nex]
      [%goal-hitch =id goal-hitch-update]
      [%goal-nexus =id goal-nexus-update]
      [%goal-togls =id goal-togls-update]
      [%poke-error =tang]
  ==
+$  away-update  [[mod=ship pok=@] update]
::
+$  home-update  [[=pin mod=ship pok=@] update]
::
+$  peek
  $%  [%initial =store]
      [%groups =groups]
      [%groups-metadata metadata=associations:metadata-store]
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
--
