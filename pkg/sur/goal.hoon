/-  *group, ms=metadata-store
/+  *gol-cli-util
|%
::
++  vzn  %4
::
+$  state-4  [%4 =store:s4 =groups =log:s4]
+$  state-3  [%3 =store:s3]
+$  state-2  [%2 =store:s2]
+$  state-1  [%1 =store:s1]
+$  state-0  [%0 =store:s0]
::
+$  id            id:s4
+$  eid           eid:s4
+$  pin           pin:s4
+$  edge          edge:s4
+$  pool-role     pool-role:s4
+$  stock         stock:s4
+$  ranks         ranks:s4
+$  moment        moment:s4
+$  bound         bound:s4
::
+$  goal-froze    goal-froze:s4
+$  goal-nexus    goal-nexus:s4
+$  goal-hitch    goal-hitch:s4
::
+$  goal          goal:s4
+$  ngoal         ngoal:s4
+$  goals         goals:s4
+$  trace         trace:s4
::
+$  pool-froze    pool-froze:s4
+$  pool-perms    pool-perms:s4
+$  pool-nexus    pool-nexus:s4
+$  pool-hitch    pool-hitch:s4
::
+$  pool          pool:s4
+$  npool         npool:s4
+$  pools         pools:s4
::
+$  index         index:s4
++  idx-orm       idx-orm:s4
::
+$  store         store:s4
::
+$  nex           nex:s4
+$  update        update:s4
+$  home-update   home-update:s4
+$  away-update   away-update:s4
+$  log-update    log-update:s4
+$  logged        logged:s4
+$  log           log:s4
::
+$  peek          peek:s4
::
+$  core-yoke     core-yoke:s4
++  yoke-tags     yoke-tags:s4
+$  yoke-tag      yoke-tag:s4
+$  exposed-yoke  exposed-yoke:s4
+$  nuke          nuke:s4
+$  plex          plex:s4
+$  action        action:s4
::
++  s4
  |%
  +$  id  id:s3
  +$  eid  eid:s3
  +$  pin  pin:s3
  +$  goal-froze  goal-froze:s3
      :: +$  togl
      ::   $:  mod=ship
      ::       timestamp=@da
      ::   ==
  +$  goal-hitch  goal-hitch:s3
      :: meta=(map @tas (unit @tas))
      :: tags=(set @tas)
      ::
  +$  pool-froze  pool-froze:s3
  +$  pool-togls  pool-togls:s3
  +$  pool-hitch  pool-hitch:s3
  ::
  +$  stock  (list [=id chief=ship]) :: lineage; youngest to oldest
  +$  ranks  (map ship id) :: map of ship to highest ranking goal id
  ::
  +$  moment  (unit @da)
  +$  bound  [=moment hereditor=eid]
  ::
  +$  edge  :: should change to +$node
    $:  =moment
        inflow=(set eid)  :: should change to incoming
        outflow=(set eid) :: should change to outgoing
        ::
        =left=bound
        =ryte=bound
        left-plumb=@ud
        ryte-plumb=@ud
    ==
  ::
  +$  goal-nexus
    $:  par=(unit id)
        kids=(set id)
        kickoff=edge  :: should change to kick-off
        deadline=edge
        ::
        complete=?(%.y %.n)
        actionable=?(%.y %.n)
        ::
        chief=ship
        spawn=(set ship)
        ::
        :: these are redundant, but simplify things on the frontend
        =stock
        =ranks
        ::
        prio-left=(set id) :: excludes par
        prio-ryte=(set id) :: excludes kids
        prec-left=(set id)
        prec-ryte=(set id)
        nest-left=(set id) :: excludes kids
        nest-ryte=(set id) :: excludes par
    ==
  ::
  +$  goal
    $:  goal-froze
        goal-nexus
        goal-hitch
    ==
  ::
  :: named goal (modules are named)
  +$  ngoal
    $:  froze=goal-froze
        nexus=goal-nexus
        hitch=goal-hitch
    ==
  ::
  +$  goals  (map id goal)
  ::
  +$  trace
    $:  left-bounds=(map eid bound)
        ryte-bounds=(map eid bound)
        left-plumbs=(map eid @)
        ryte-plumbs=(map eid @)
    ==
  ::
  +$  pool-role  ?(%admin %spawn)
  ::
  +$  pool-perms  (map ship (unit pool-role))
  ::
  +$  pool-nexus
    $:  =goals
        =trace
        cache=(map id goals)
    ==
  ::
  +$  pool
    $:  pool-froze
        perms=pool-perms
        pool-nexus
        pool-hitch
    ==
  ::
  :: named pool (modules are named)
  +$  npool
    $:  froze=pool-froze
        perms=pool-perms
        nexus=pool-nexus
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
  +$  nex  (map id goal-nexus)
  ::
  +$  pool-hitch-update
    $%  [%title title=@t]
    ==
  ::
  +$  pool-nexus-update
    $%  [%yoke =nex]
        [%date =nex]
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
    $:  %4
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
        [%goal-perms =nex]
        [%goal-hitch =id goal-hitch-update]
        [%goal-nexus =id goal-nexus-update]
        [%goal-togls =id goal-togls-update]
        [%poke-error =tang]
    ==  ==
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
        [%groups =groups]
        [%groups-metadata metadata=associations:ms]
        [%pool-keys keys=(set pin)]
        [%all-goal-keys keys=(set id)]
        [%harvest harvest=(list id)]
        [%full-harvest harvest=goals]
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
  +$  core-yoke
    $%  [%dag-yoke e1=eid e2=eid]
        [%dag-rend e1=eid e2=eid]
    ==
  ::
  ++  yoke-tags
    :~  %prio-rend
        %prio-yoke
        %prec-rend
        %prec-yoke
        %nest-rend
        %nest-yoke
        %hook-rend
        %hook-yoke
        %held-rend
        %held-yoke
    ==
  ::
  +$  yoke-tag  (union-from-list yoke-tags)
  ::
  +$  exposed-yoke  $%([yoke-tag lid=id rid=id])
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
  ::
  +$  action
    $:  %4
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
        [%yoke =pin yoks=(list plex)]
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
    ==  ==  ==
  --
::
:: ============================================================================
::
:: STRUCTURES HISTORY
::
:: ============================================================================
::
++  convert-3-to-4
  |=  =state-3
  ^-  state-4
  |^
  :*  %4
      :*  (index-3-to-4 directory.store.state-3)
          (pools-3-to-4 pools.store.state-3)
          *pools
      == 
      *groups
      *log
  ==
  ::
  ++  goal-3-to-4
    |=  [=goal:s3 =goals:s3]
    ^-  goal:s4
    |^
    =/  goal  `ngoal:s3`goal
    =|  =ngoal:s4
    =.  froze.ngoal  froze.goal
    =.  nexus.ngoal  nexus-3-to-4
    =.  hitch.ngoal  hitch.goal
    ngoal
    ::
    ++  nexus-3-to-4
      ^-  goal-nexus:s4
      =|  nexus=goal-nexus:s4
      =.  par.nexus  par.goal
      =.  kids.nexus  kids.goal
      =.  kickoff.nexus  (edge-3-to-4 [%k owner.goal birth.goal])
      =.  deadline.nexus  (edge-3-to-4 [%d owner.goal birth.goal])
      ::
      =.  complete.nexus  complete.goal
      =.  actionable.nexus  actionable.goal
      ::
      =.  chief.nexus  owner.goal
      ::
      =.  stock.nexus  (get-stock [owner.goal birth.goal])
      =.  ranks.nexus
        %+  ~(put by *ranks:s4)
          chief.nexus
        id:(snag 0 (flop `stock:s4`[[[owner.goal birth.goal] owner.goal] stock.nexus]))
      =.  prio-left.nexus  prio-left
      =.  prio-ryte.nexus  prio-ryte
      =.  prec-left.nexus  prec-left
      =.  prec-ryte.nexus  prec-ryte
      =.  nest-left.nexus  nest-left
      =.  nest-ryte.nexus  nest-ryte
      nexus
    ::
    ++  edge-3-to-4
      |=  =eid:s3
      ^-  edge:s4
      =|  =edge:s4
      =.  moment.edge  moment:(got-edge eid)
      =.  inflow.edge  inflow:(got-edge eid)
      =.  outflow.edge  outflow:(got-edge eid)
      =.  left-bound.edge  (left-bound eid)
      =.  ryte-bound.edge  (ryte-bound eid)
      =.  left-plumb.edge  (left-plumb eid)
      =.  ryte-plumb.edge  (ryte-plumb eid)
      edge
    ::
    ++  get-stock
      |=  =id:s3
      ^-  stock:s4
      =/  goal  (~(got by goals) id)
      ?~  par.goal
        ~
      [[u.par.goal owner.goal] (get-stock u.par.goal)]
    ::
    ++  left-plumb
      |=  =eid:s3
      ^-  @ud
      =/  lvl  0
      =/  flow  inflow:(got-edge eid)
      ?:  =(0 ~(wyt in flow))  lvl
      =/  idx  0
      =/  flow  ~(tap in flow)
      |-
      ?:  =(idx (lent flow))  +(lvl) :: add 1 to maximum child depth
      $(idx +(idx), lvl (max lvl (left-plumb (snag idx flow))))
    ::
    ++  ryte-plumb
      |=  =eid:s3
      ^-  @ud
      =/  lvl  0
      =/  flow  outflow:(got-edge eid)
      ?:  =(0 ~(wyt in flow))  lvl
      =/  idx  0
      =/  flow  ~(tap in flow)
      |-
      ?:  =(idx (lent flow))  +(lvl) :: add 1 to maximum child depth
      $(idx +(idx), lvl (max lvl (ryte-plumb (snag idx flow))))
    ::
    :: think of ~ as +inf
    ++  loth
      |=  [a=(unit @) b=(unit @)]
      ?~  a  %.n
      ?~  b  %.y
      (lth u.a u.b)
    ::
    :: think of ~ as -inf
    ++  goth
      |=  [a=(unit @) b=(unit @)]
      ?~  a  %.n
      ?~  b  %.y
      (gth u.a u.b)
    ::
    ++  head-extremum
      |=  cmp=$-([(unit @) (unit @)] ?)
      |*  lst=(list [(unit @) *])
      %+  roll
        ^+  lst  +.lst
      |:  [a=i.-.lst b=i.-.lst]
      ?:  (cmp -.a -.b)  a  b
    ::
    ++  list-min-head  (head-extremum loth)
    ++  list-max-head  (head-extremum goth)
    ::
    ++  got-edge
      |=  =eid:s3
      ^-  edge:s3
      =/  goal  (~(got by goals) id.eid)
      ?-  -.eid
        %k  kickoff.goal
        %d  deadline.goal
      ==
    ::
    ++  left-bound
      |=  =eid:s3
      ^-  bound:s4
      =/  edge  (got-edge eid)
      ?:  =(0 ~(wyt in inflow.edge))
        [moment.edge eid]
      %-  list-max-head
      %+  weld
        ~[[moment.edge eid]]
      %+  turn
        ~(tap in inflow.edge)
      ryte-bound
    ::
    ++  ryte-bound
      |=  =eid:s3
      ^-  bound:s4
      =/  edge  (got-edge eid)
      ?:  =(0 ~(wyt in outflow.edge))
        [moment.edge eid]
      %-  list-min-head
      %+  weld
        ~[[moment.edge eid]]
      %+  turn
        ~(tap in outflow.edge)
      ryte-bound
    ::
    ++  exclude-par
      |=  =(set id)
      ?~  par.goal
        set
      (~(del in set) u.par.goal)
    ::
    ++  exclude-kids
      |=  =(set id)
      (~(dif in set) kids.goal)
    ::  
    ++  prio-left
      ^-  (set id)
      %-  exclude-par
      %-  ~(gas in *(set id))
      %+  murn
        ~(tap in inflow.kickoff.goal)
      |=  =eid:s3
      ?-  -.eid
        %d  ~
        %k  (some id.eid)
      ==
    ::  
    ++  prio-ryte
      ^-  (set id)
      %-  exclude-kids
      %-  ~(gas in *(set id))
      %+  murn
        ~(tap in outflow.kickoff.goal)
      |=  =eid:s3
      ?-  -.eid
        %d  ~
        %k  (some id.eid)
      ==
    ::  
    ++  prec-left
      ^-  (set id)
      %-  ~(gas in *(set id))
      %+  murn
        ~(tap in inflow.kickoff.goal)
      |=  =eid:s3
      ?-  -.eid
        %k  ~
        %d  (some id.eid)
      ==
    ::  
    ++  prec-ryte
      ^-  (set id)
      %-  ~(gas in *(set id))
      %+  murn
        ~(tap in outflow.deadline.goal)
      |=  =eid:s3
      ?-  -.eid
        %d  ~
        %k  (some id.eid)
      ==
    ::  
    ++  nest-left
      ^-  (set id)
      %-  exclude-kids
      %-  ~(gas in *(set id))
      %+  murn
        ~(tap in inflow.deadline.goal)
      |=  =eid:s3
      ?-  -.eid
        %k  ~
        %d  (some id.eid)
      ==
    ::  
    ++  nest-ryte
      ^-  (set id)
      %-  exclude-par
      %-  ~(gas in *(set id))
      %+  murn
        ~(tap in outflow.deadline.goal)
      |=  =eid:s3
      ?-  -.eid
        %k  ~
        %d  (some id.eid)
      ==
    --
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
  ++  pool-perms-3-to-4
    |=  [owner=ship pool-perms:s3]
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
  ++  pool-3-to-4
    |=  =npool:s3
    ^-  pool:s4
    =|  =npool:s4
    =.  froze.npool  froze.^npool
    =.  perms.npool  (pool-perms-3-to-4 owner.froze.^npool perms.^npool)
    =.  goals.nexus.npool  (goals-3-to-4 goals.nexus.^npool)
    =.  hitch.npool  hitch.^npool
    npool
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
  :: ::
  ++  index-3-to-4
    |=  =directory:s3
    ^-  index:s4
    (gas:idx-orm:s4 *index:s4 ~(tap by directory))
  --
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
