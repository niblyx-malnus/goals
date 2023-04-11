/-  *group, ms=metadata-store :: need to keep for historical reasons
/+  *gol-cli-util
|%
::
++  vzn  %5
::
+$  state-5  [%5 =store:s5 =log:s5]
+$  state-4  [%4 =store:s4 =groups =log:s4]
+$  state-3  [%3 =store:s3]
+$  state-2  [%2 =store:s2]
+$  state-1  [%1 =store:s1]
+$  state-0  [%0 =store:s0]
::
+$  id            id:s5
+$  nid           nid:s5
+$  pin           pin:s5
+$  node          node:s5
+$  edge          edge:s5
+$  edges         edges:s5
+$  pool-role     pool-role:s5
+$  stock         stock:s5
+$  ranks         ranks:s5
+$  moment        moment:s5
+$  tag           tag:s5
+$  field-type    field-type:s5
+$  field-data    field-data:s5
::
+$  goal-nexus    goal-nexus:s5
+$  goal-froze    goal-froze:s5
+$  goal-trace    goal-trace:s5
+$  goal-hitch    goal-hitch:s5
+$  goal-local    goal-local:s5
::
+$  local         local:s5
::
+$  goal          goal:s5
+$  ngoal         ngoal:s5
+$  goals         goals:s5
::
+$  pool-nexus    pool-nexus:s5
+$  pool-perms    pool-perms:s5
+$  pool-froze    pool-froze:s5
+$  pool-trace    pool-trace:s5
+$  pool-hitch    pool-hitch:s5
::
+$  pool          pool:s5
+$  npool         npool:s5
+$  pools         pools:s5
::
+$  index         index:s5
++  idx-orm       idx-orm:s5
::
+$  store         store:s5
::
+$  nux           nux:s5
+$  nex           nex:s5
+$  update        update:s5
+$  home-update   home-update:s5
+$  away-update   away-update:s5
+$  log-update    log-update:s5
+$  logged        logged:s5
+$  log           log:s5
::
+$  peek          peek:s5
::
+$  core-yoke     core-yoke:s5
+$  exposed-yoke  exposed-yoke:s5
+$  nuke          nuke:s5
+$  plex          plex:s5
::
++  action        action:s5
::
++  s5
  |%
  +$  id            id:s4
  +$  nid           nid:s4
  +$  pin           pin:s4
  +$  node          node:s4
  +$  edge          edge:s4
  +$  edges         edges:s4
  +$  pool-role     pool-role:s4
  +$  stock         stock:s4
  +$  ranks         ranks:s4
  +$  moment        moment:s4
  ::
  +$  goal-nexus
    $:  par=(unit id)
        kids=(set id)
        kickoff=node
        deadline=node
        complete=_|
        actionable=_|
        chief=ship
        spawn=(set ship)
    ==
  +$  goal-froze    goal-froze:s4
  ::
  :: values implied by the data structure
  +$  goal-trace
    $:  =stock
        =ranks
        young=(list id)
        young-by-kickoff=(list id)
        young-by-deadline=(list id)
        prio-left=(set id)
        prio-ryte=(set id)
        prec-left=(set id)
        prec-ryte=(set id)
        nest-left=(set id)
        nest-ryte=(set id)
    ==
  ::
  +$  tag  [text=@t color=@t private=?]
  ::
  +$  field-data
    $%  [%ct d=@t] :: categorical
        [%ud d=@ud]
        [%rd d=@rd]
    ==
  ::
  +$  field-type
    $%  [%ct =(set @t)] :: categorical
        [%ud ~]
        [%rd ~]
    ==
  ::
  ++  tag-bunt
    %-  sy
    :~  [%tag1 '#ff0000' |]
        [%tag2 '#00ff00' |]
        [%tag3 '#0000ff' |]
    ==
  ::
  +$  goal-hitch
    $:  desc=@t
        note=@t
        tags=$~(tag-bunt (set tag))
        fields=(map @t field-data)
    ==
  ::
  +$  goal  [goal-nexus goal-froze goal-trace goal-hitch]
  ::
  :: named goal (modules are named)
  +$  ngoal
    $:  nexus=goal-nexus
        froze=goal-froze
        trace=goal-trace
        hitch=goal-hitch
    ==
  ::
  +$  goals  (map id goal)
  ::
  +$  pool-perms   pool-perms:s4
  +$  pool-nexus
    $:  =goals
        cache=goals
        owner=ship
        perms=pool-perms
        roots=(list id)
    ==
  +$  pool-froze    pool-froze:s4
  ::
  +$  pool-trace
    $:  stock-map=(map id stock)
        roots=(list id)
        roots-by-kickoff=(list id)
        roots-by-deadline=(list id)
        left-bounds=(map nid moment)
        ryte-bounds=(map nid moment)
        left-plumbs=(map nid @)
        ryte-plumbs=(map nid @)
    ==
  ::
  +$  pool-hitch    
    $:  title=@t
        note=@t
        fields=(map @t field-type)
    ==
  ::
  +$  pool  [pool-nexus pool-froze trace=pool-trace pool-hitch]
  ::
  :: named pool (modules are named)
  +$  npool
    $:  nexus=pool-nexus
        froze=pool-froze
        trace=pool-trace
        hitch=pool-hitch
    ==
  ::
  +$  pools  (map pin pool)
  ::
  +$  index         index:s4
  ++  idx-orm       idx-orm:s4
  ::
  +$  goal-local
    $:  tags=(set tag)
    ==
  +$  local  (map id goal-local)
  ::
  +$  store  
    $:  =index
        =pools
        cache=pools
        =local
    ==
  ::
  +$  nux  [goal-nexus goal-trace]
  +$  nex  (map id nux)
  ::
  +$  pool-nexus-update
    $%  [%yoke =nex]
    ==
  ::
  +$  pool-hitch-update
    $%  [%title title=@t]
        [%note note=@t]
        [%add-field-type field=@t =field-type]
        [%del-field-type field=@t]
    ==
  ::
  +$  goal-hitch-update
    $%  [%desc desc=@t]
        [%note note=@t]
        [%add-tag =tag]
        [%del-tag =tag]
        [%put-tags tags=(set tag)]
        [%add-field-data field=@t =field-data]
        [%del-field-data field=@t]
    ==
  ::
  +$  goal-togls-update
    $%  [%complete complete=_|]
        [%actionable actionable=_|]
    ==
  ::
  +$  unver-update  :: underlying data structures have changed
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
        [%pool-perms =nex new=pool-perms]
        [%pool-hitch pool-hitch-update]
        [%pool-nexus pool-nexus-update]
        [%goal-dates =nex]
        [%goal-perms =nex]
        [%goal-roots roots=(list id)]
        [%goal-young =id young=(list id)]
        [%goal-hitch =id goal-hitch-update]
        [%goal-togls =id goal-togls-update]
        [%poke-error =tang]
    ==
  +$  update        [%5 unver-update]
  +$  away-update   [[mod=ship pid=@] update]
  +$  home-update   [[=pin mod=ship pid=@] update]
  +$  log-update    $%([%updt upd=home-update] [%init =store])
  +$  log           ((mop @ log-update) lth)
  +$  logged        (pair @ log-update)
  ::
  +$  peek          :: underlying data structures have changed
                    $%  [%initial =store] 
                        [%updates =(list logged)]
                        [%full-harvest harvest=goals]
                        [%get-goal ugoal=(unit goal)]
                        [%get-pool upool=(unit pool)]
                        $<  %initial       $<  %updates
                        $<  %full-harvest  $<  %get-goal
                        $<(%get-pool peek:s4)
                    ==
  ::
  +$  core-yoke     core-yoke:s4
  +$  exposed-yoke  exposed-yoke:s4
  +$  nuke          nuke:s4
  +$  plex          plex:s4
  ++  action
    =<  action
    |%
    +$  action  [%5 pid=@ pok=$%(util-action pool-action goal-action)]
    +$  util-action
      $%  [%subscribe =pin]
          [%unsubscribe =pin]
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
    --
  --
::
:: ============================================================================
::
:: STRUCTURES HISTORY
::
:: ============================================================================
::
++  convert-4-to-5
  |=  =state-4
  ^-  state-5
  *state-5  :: TODO: ACTUALLY IMPLEMENT
::
++  s4
  |%
  +$  id  id:s3
  +$  nid  eid:s3
  +$  pin  pin:s3
  +$  goal-froze  goal-froze:s3
  +$  goal-hitch  goal-hitch:s3
  +$  pool-hitch  pool-hitch:s3
  ::
  +$  stock  (list [=id chief=ship]) :: lineage; youngest to oldest
  +$  ranks  (map ship id) :: map of ship to highest ranking goal id
  ::
  +$  moment  (unit @da)
  ::
  +$  node-nexus
    $:  =moment
        inflow=(set nid)
        outflow=(set nid)
    ==
  ::
  :: values implied by the data structure
  +$  node-trace
    $:  left-bound=moment
        ryte-bound=moment
        left-plumb=@ud
        ryte-plumb=@ud
    ==
  ::
  +$  node  [node-nexus node-trace]
  ::
  +$  edge  (pair nid nid)
  +$  edges  (set edge)
  ::
  +$  goal-nexus
    $:  par=(unit id)
        kids=(set id)
        kickoff=node
        deadline=node
        complete=_|
        actionable=_|
        chief=ship
        spawn=(set ship)
    ==
  ::
  :: values implied by the data structure
  +$  goal-trace
    $:  =stock
        =ranks
        prio-left=(set id)
        prio-ryte=(set id)
        prec-left=(set id)
        prec-ryte=(set id)
        nest-left=(set id)
        nest-ryte=(set id)
    ==
  ::
  +$  goal  [goal-nexus goal-froze goal-trace goal-hitch]
  ::
  :: named goal (modules are named)
  +$  ngoal
    $:  nexus=goal-nexus
        froze=goal-froze
        trace=goal-trace
        hitch=goal-hitch
    ==
  ::
  +$  goals  (map id goal)
  ::
  +$  pool-role  ?(%admin %spawn)
  ::
  +$  pool-perms  (map ship (unit pool-role))
  ::
  +$  pool-nexus
    $:  =goals
        cache=goals
        owner=ship
        perms=pool-perms
    ==
  ::
  +$  pool-froze  [birth=@da creator=ship] :: owner moved to nexus
  ::
  +$  pool-trace
    $:  stock-map=(map id stock)
        left-bounds=(map nid moment)
        ryte-bounds=(map nid moment)
        left-plumbs=(map nid @)
        ryte-plumbs=(map nid @)
    ==
  ::
  +$  pool  [pool-nexus pool-froze trace=pool-trace pool-hitch]
  ::
  :: named pool (modules are named)
  +$  npool
    $:  nexus=pool-nexus
        froze=pool-froze
        trace=pool-trace
        hitch=pool-hitch
    ==
  ::
  +$  pools  (map pin pool)
  ::
  ++  lth-id
    |=  [a=id b=id]
    (lth birth.a birth.b)
  ::
  +$  index  ((mop id pin) lth-id)
  ++  idx-orm  ((on id pin) lth-id)
  ::
  +$  store  
    $:  =index
        =pools
        cache=pools
    ==
  ::
  +$  nux  [goal-nexus goal-trace]
  +$  nex  (map id nux)
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
  +$  goal-togls-update
    $%  [%complete complete=_|]
        [%actionable actionable=_|]
    ==
  ::
  +$  unver-update
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
        [%pool-perms =nex new=pool-perms]
        [%pool-hitch pool-hitch-update]
        [%pool-nexus pool-nexus-update]
        [%goal-dates =nex]
        [%goal-perms =nex]
        [%goal-hitch =id goal-hitch-update]
        [%goal-togls =id goal-togls-update]
        [%poke-error =tang]
    ==
  ::
  +$  update  [%4 unver-update]
  ::
  +$  away-update  [[mod=ship pid=@] update]
  +$  home-update  [[=pin mod=ship pid=@] update]
  ::
  +$  log-update
    $%  [%updt upd=home-update]
        [%init =store]
    ==
  +$  log  ((mop @ log-update) lth)
  +$  logged  (pair @ log-update)
  ::
  +$  peek
    $%  [%initial =store]
        [%updates =(list logged)]
        [%pool-keys keys=(set pin)]
        [%all-goal-keys keys=(set id)]
        [%harvest harvest=(list id)]
        [%full-harvest harvest=goals]
        [%get-goal ugoal=(unit goal)]
        [%get-pin upin=(unit pin)]
        [%get-pool upool=(unit pool)]
        [%ryte-bound moment=(unit @da)]
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
  +$  core-yoke
    $%  [%dag-yoke n1=nid n2=nid]
        [%dag-rend n1=nid n2=nid]
    ==
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
  ::
  +$  plex
    $%  exposed-yoke
        nuke
    ==
  +$  unver-action
    $%  [%spawn-pool title=@t]
        [%clone-pool =pin title=@t]
        [%cache-pool =pin]
        [%renew-pool =pin]
        [%trash-pool =pin]
        [%spawn-goal =pin upid=(unit id) desc=@t actionable=?]
        [%cache-goal =id]
        [%renew-goal =id]
        [%trash-goal =id]
        [%yoke =pin yoks=(list plex)]
        [%move cid=id upid=(unit id)]
        [%set-kickoff =id kickoff=(unit @da)]
        [%set-deadline =id deadline=(unit @da)]
        [%mark-actionable =id]
        [%unmark-actionable =id]
        [%mark-complete =id]
        [%unmark-complete =id]
        [%update-goal-perms =id chief=ship rec=_| spawn=(set ship)]
        [%update-pool-perms =pin new=pool-perms]
        [%edit-goal-desc =id desc=@t]
        [%edit-pool-title =pin title=@t]
        [%subscribe =pin]
        [%unsubscribe =pin]
        [%kicker =ship =pin]
    ==
  ::
  +$  action  [%4 pid=@ pok=unver-action]
  --
::
++  convert-3-to-4
  |=  =state-3
  ^-  state-4
  :*  %4
      :*  (index-3-to-4 directory.store.state-3)
          (pools-3-to-4 pools.store.state-3)
          *pools:s4
      == 
      *groups
      *log:s4
  ==
  ::
++  index-3-to-4
  |=  =directory:s3
  ^-  index:s4
  (gas:idx-orm:s4 *index:s4 ~(tap by directory))
::
++  pools-3-to-4
  |=  =pools:s3
  ^-  pools:s4
  %-  ~(gas by *pools:s4)
  %+  turn
    ~(tap by pools)
  |=  [=pin:s3 =pool:s3]
  ^-  [pin:s4 pool:s4]
  [pin (pool-3-to-4 pool)]
::
++  pool-3-to-4
  |=  =npool:s3
  ^-  pool:s4
  =|  =npool:s4
  =.  froze.npool  [birth creator]:froze.^npool
  =.  owner.nexus.npool  owner.froze.^npool
  =.  perms.nexus.npool  (pool-perms-3-to-4 perms.^npool)
  =.  goals.nexus.npool  (goals-3-to-4 goals.nexus.^npool)
  =.  hitch.npool  hitch.^npool
  npool
::
++  pool-perms-3-to-4
  |=  pool-perms:s3
  =|  =pool-perms:s4
  =.  pool-perms
    %-  ~(gas by pool-perms)
    %+  murn
      ~(tap in admins) 
    |=  =ship
    ?:  (~(has by pool-perms) ship)
      ~
    (some [ship (some %admin)])
  =.  pool-perms
    %-  ~(gas by pool-perms)
    %+  murn
      ~(tap in captains) 
    |=  =ship
    ?:  (~(has by pool-perms) ship)
      ~
    (some [ship (some %spawn)])
  =.  pool-perms
    %-  ~(gas by pool-perms)
    %+  murn
      ~(tap in viewers) 
    |=  =ship
    ?:  (~(has by pool-perms) ship)
      ~
    (some [ship ~])
  pool-perms
::
++  goals-3-to-4
  |=  =goals:s3
  ^-  goals:s4
  %-  ~(gas by *goals:s4)
  %+  turn
    ~(tap by goals)
  |=  [=id:s3 =goal:s3]
  ^-  [id:s4 goal:s4]
  [id (goal-3-to-4 goal goals)]
  ::
++  goal-3-to-4
  |=  [=goal:s3 =goals:s3]
  ^-  goal:s4
  =|  =ngoal:s4
  =.  froze.ngoal  froze:`ngoal:s3`goal
  =.  nexus.ngoal  (nexus-3-to-4 goal)
  =.  hitch.ngoal  hitch:`ngoal:s3`goal
  ngoal
  ::
++  nexus-3-to-4
  |=  =goal:s3
  ^-  goal-nexus:s4
  =|  nexus=goal-nexus:s4
  =.  par.nexus  par.goal
  =.  kids.nexus  kids.goal
  =.  kickoff.nexus  (node-3-to-4 kickoff.goal)
  =.  deadline.nexus  (node-3-to-4 deadline.goal)
  =.  complete.nexus  complete.goal
  =.  actionable.nexus  actionable.goal
  =.  chief.nexus  owner.goal
  nexus
::
++  node-3-to-4
  |=  =edge:s3
  ^-  node:s4
  =|  =node:s4
  =.  moment.node  moment.edge
  =.  inflow.node  inflow.edge
  =.  outflow.node  outflow.edge
  node
::
++  s3
  |%
  +$  id  id:s2
  +$  eid  eid:s2
  +$  pin  pin:s2
  +$  edge  edge:s2
  +$  directory  directory:s2
  +$  goal-froze  goal-froze:s2
  +$  goal-nexus  goal-nexus:s2
  +$  goal-togls  goal-togls:s2
  +$  goal-hitch  goal-hitch:s2
  +$  pool-froze  pool-froze:s2
  +$  pool-togls  pool-togls:s2
  +$  pool-hitch  pool-hitch:s2
  ::
  +$  goal-perms
    $:  captains=(set ship)
        peons=(set ship)
    ==
  ::
  +$  goal
    $:  goal-froze
        goal-perms
        goal-nexus
        goal-togls
        goal-hitch
    ==
  ::
  :: named goal (modules are named)
  +$  ngoal
    $:  froze=goal-froze
        perms=goal-perms
        nexus=goal-nexus
        togls=goal-togls
        hitch=goal-hitch
    ==
  ::
  +$  goals  (map id goal)
  ::
  +$  pool-perms
    $:  admins=(set ship)
        captains=(set ship)
        viewers=(set ship)
    ==
  ::
  +$  pool-nexus  =goals
  ::
  +$  pool
    $:  pool-froze
        pool-perms
        pool-nexus
        pool-togls
        pool-hitch
    ==
  ::
  :: named pool (modules are named)
  +$  npool
    $:  froze=pool-froze
        perms=pool-perms
        nexus=pool-nexus
        togls=pool-togls
        hitch=pool-hitch
    ==
  ::
  +$  pools  (map pin pool)
  ::
  +$  store  [=directory =pools]
  --
::
++  convert-2-to-3
  |=  =state-2
  ^-  state-3
  `state-3`[%3 +.state-2]
::
++  s2
  |%
  +$  id  id:s1
  +$  eid  eid:s1
  +$  pin  pin:s1
  +$  edge  edge:s1
  +$  directory  directory:s1
  ::
  +$  goal-froze
    $:  owner=ship
        birth=@da
        author=ship
    ==
  ::
  +$  goal-perms
    $:  chefs=(set ship)
        peons=(set ship)
    ==
  ::
  +$  goal-nexus
    $:  par=(unit id)
        kids=(set id)
        kickoff=edge
        deadline=edge
    ==
  ::
  +$  goal-togls
    $:  complete=?(%.y %.n)
        actionable=?(%.y %.n)
        archived=?(%.y %.n)
    ==
  ::
  +$  goal-hitch  desc=@t
  ::
  +$  goal
    $:  goal-froze
        goal-perms
        goal-nexus
        goal-togls
        goal-hitch
    ==
  ::
  :: named goal (modules are named)
  +$  ngoal
    $:  froze=goal-froze
        perms=goal-perms
        nexus=goal-nexus
        togls=goal-togls
        hitch=goal-hitch
    ==
  ::
  +$  goals  (map id goal)
  ::
  +$  pool-froze
    $:  owner=ship
        birth=@da
        creator=ship
    ==
  ::
  +$  pool-perms
    $:  chefs=(set ship)
        peons=(set ship)
        viewers=(set ship)
    ==
  ::
  +$  pool-nexus  =goals
  ::
  +$  pool-togls  archived=?(%.y %.n)
  ::
  +$  pool-hitch  title=@t
  ::
  +$  pool
    $:  pool-froze
        pool-perms
        pool-nexus
        pool-togls
        pool-hitch
    ==
  ::
  :: named pool (modules are named)
  +$  npool
    $:  froze=pool-froze
        perms=pool-perms
        nexus=pool-nexus
        togls=pool-togls
        hitch=pool-hitch
    ==
  ::
  +$  pools  (map pin pool)
  ::
  +$  store  [=directory =pools]
  --
::
:: From state-1 to state-2:
::   - add owner and birth to goal and pool
::   - restructure with froze, perms, nexus, togls, hitch
::
++  convert-1-to-2
  |=  =state-1
  ^-  state-2
  |^
  :*  %2
      directory.store.state-1
      (pools-1-to-2 pools.store.state-1)
  ==
  ::
  ++  goal-1-to-2
    |=  [=id:s1 =goal:s1]
    ^-  goal:s2
    =|  =goal:s2
    =.  owner.goal       owner.id
    =.  birth.goal       birth.id
    =.  desc.goal        desc.^goal
    =.  author.goal      author.^goal
    =.  chefs.goal       chefs.^goal
    =.  peons.goal       peons.^goal
    =.  par.goal         par.^goal
    =.  kids.goal        kids.^goal
    =.  kickoff.goal     kickoff.^goal
    =.  deadline.goal    deadline.^goal
    =.  complete.goal    complete.^goal
    =.  actionable.goal  actionable.^goal
    =.  archived.goal    archived.^goal
    goal
  ::
  ++  goals-1-to-2
    |=  =goals:s1
    ^-  goals:s2
    %-  ~(gas by *goals:s2)
    %+  turn
      ~(tap by goals)
    |=  [=id:s1 =goal:s1]
    ^-  [id:s2 goal:s2]
    [id (goal-1-to-2 id goal)]
  ::
  ++  pool-1-to-2
    |=  [=pin:s1 =pool:s1]
    ^-  pool:s2
    =|  =pool:s2
    =.  owner.pool       owner.pin
    =.  birth.pool       birth.pin
    =.  title.pool       title.^pool
    =.  creator.pool     creator.^pool
    =.  goals.pool       (goals-1-to-2 goals.^pool)
    =.  chefs.pool       chefs.^pool
    =.  peons.pool       peons.^pool
    =.  viewers.pool     viewers.^pool
    =.  archived.pool    archived.^pool
    pool
  ::
  ++  pools-1-to-2
    |=  =pools:s1
    ^-  pools:s2
    %-  ~(gas by *pools:s2)
    %+  turn
      ~(tap by pools)
    |=  [=pin:s1 =pool:s1]
    ^-  [pin:s2 pool:s2]
    [pin (pool-1-to-2 pin pool)]
  --
::
++  s1
  |%
  +$  id  id:s0
  +$  eid  eid:s0
  +$  pin  pin:s0
  +$  directory  directory:s0
  ::
  +$  edge
    $:  moment=(unit @da)
        inflow=(set eid)
        outflow=(set eid)
    ==
  ::
  +$  goal
    $:  desc=@t
        author=ship
        chefs=(set ship)
        peons=(set ship)
        par=(unit id)
        kids=(set id)
        kickoff=edge
        deadline=edge
        complete=?(%.y %.n)
        actionable=?(%.y %.n)
        archived=?(%.y %.n)
    ==
  ::
  +$  goals  (map id goal)
  ::
  +$  pool
    $:  title=@t
        creator=ship
        =goals
        chefs=(set ship)
        peons=(set ship)
        viewers=(set ship)
        archived=?(%.y %.n)
    ==
  ::
  +$  pools  (map pin pool)
  ::
  +$  store  [=directory =pools]
  --
::
:: From state-0 to state-1:
::   - split was changed to edge
::   - project was changed to pool
::   - projects was changed to pools
::
++  convert-0-to-1
  |=  =state-0
  ^-  state-1
  [%1 `store:s1`store.state-0]
::
++  s0
  |%
  ::
  :: $id: identity of a goal; determined by creator and time of creation
  +$  id  [owner=@p birth=@da]
  ::
  +$  eid  [?(%k %d) =id]
  ::
  +$  pin  [%pin id]
  ::
  +$  split
    $:  moment=(unit @da)
        inflow=(set eid)
        outflow=(set eid)
    ==
  ::
  +$  goal
    $:  desc=@t
        author=ship
        chefs=(set ship)
        peons=(set ship)
        par=(unit id)
        kids=(set id)
        kickoff=split
        deadline=split
        complete=?(%.y %.n)
        actionable=?(%.y %.n)
        archived=?(%.y %.n)
    ==
  ::
  +$  goals  (map id goal)
  ::
  +$  project
    $:  title=@t
        creator=ship
        =goals
        chefs=(set ship)
        peons=(set ship)
        viewers=(set ship)
        archived=?(%.y %.n)
    ==
  ::
  +$  projects  (map pin project)
  ::
  +$  directory  (map id pin)
  ::
  +$  store  [=directory =projects]
  --
--
