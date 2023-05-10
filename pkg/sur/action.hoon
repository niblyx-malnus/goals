/-  *goal
|%
+$  action  [pid=@ pok=$%(util-action pool-action goal-action local-action)]
+$  util-action
  $%  [%subscribe =pin]
      [%unsubscribe =pin]
  ==
+$  local-action
  $%  [%slot-above dis=id dat=id]  :: slot dis above dat
      [%slot-below dis=id dat=id]  :: slot dis below dat
  ==
++  pool-action
  =<  pool-action
  |%
  +$  pool-action  $%(spawn mutate)
  +$  spawn  [%spawn-pool title=@t]
  +$  mutate  $%(life-cycle nexus hitch)
  +$  life-cycle
    $%  [%clone-pool =pin title=@t]
        [%cache-pool =pin]
        [%renew-pool =pin]
        [%trash-pool =pin]
    ==
  +$  nexus
    $%  [%yoke =pin yoks=(list plex)]
        [%update-pool-perms =pin new=pool-perms]
    ==
  +$  hitch
    $%  [%edit-pool-title =pin title=@t]
        [%edit-pool-note =pin note=@t]
        [%add-field-type =pin field=@t =field-type]
        [%del-field-type =pin field=@t]
    ==
  --
++  goal-action
  =<  goal-action
  |%
  +$  goal-action  $%(spawn mutate local)
  +$  spawn  [%spawn-goal =pin upid=(unit id) desc=@t actionable=?]
  ++  mutate
    =<  mutate
    |%
    +$  mutate  $%(life-cycle nexus hitch)
    +$  life-cycle
      $%  [%cache-goal =id]
          [%renew-goal =id]
          [%trash-goal =id]
      ==
    +$  nexus
      $%  [%move cid=id upid=(unit id)] :: should probably be in nexus:pool-action
          [%set-kickoff =id kickoff=(unit @da)]
          [%set-deadline =id deadline=(unit @da)]
          [%mark-actionable =id]
          [%unmark-actionable =id]
          [%mark-complete =id]
          [%unmark-complete =id]
          [%update-goal-perms =id chief=ship rec=_| spawn=(set ship)]
          [%reorder-roots =pin roots=(list id)]
          [%reorder-young =id young=(list id)]
      ==
    +$  hitch
      $%  [%edit-goal-desc =id desc=@t]
          [%edit-goal-note =id note=@t]
          [%add-goal-tag =id =tag]
          [%del-goal-tag =id =tag]
          [%put-goal-tags =id tags=(set tag)]
          [%add-field-data =id field=@t =field-data]
          [%del-field-data =id field=@t]
      ==
    --
  +$  local
    $%  [%put-private-tags =id tags=(set tag)]
    ==
  --
::
+$  core-yoke
  $%  [%dag-yoke n1=nid n2=nid]
      [%dag-rend n1=nid n2=nid]
  ==
::
+$  plex  $%(exposed-yoke nuke)
::
+$  exposed-yoke  
  $%  [%prio-rend lid=id rid=id]
      [%prio-yoke lid=id rid=id]
      [%prec-rend lid=id rid=id]
      [%prec-yoke lid=id rid=id]
      [%nest-rend lid=id rid=id]
      [%nest-yoke lid=id rid=id]
      [%hook-rend lid=id rid=id]
      [%hook-yoke lid=id rid=id]
      [%held-rend lid=id rid=id]
      [%held-yoke lid=id rid=id]
  ==
::
+$  nuke
  $%  [%nuke-prio-left =id]
      [%nuke-prio-ryte =id]
      [%nuke-prio =id]
      [%nuke-prec-left =id]
      [%nuke-prec-ryte =id]
      [%nuke-prec =id]
      [%nuke-prio-prec =id]
      [%nuke-nest-left =id]
      [%nuke-nest-ryte =id]
      [%nuke-nest =id]
  ==
--
