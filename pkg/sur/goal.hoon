/+  *gol-cli-help
|%
::
+$  state-4  [%4 =store:s4]
+$  state-3  [%3 =store:s3]
+$  state-2  [%2 =store:s2]
+$  state-1  [%1 =store:s1]
+$  state-0  [%0 =store:s0]
::
+$  id          id:s4
+$  eid         eid:s4
+$  pin         pin:s4
+$  edge        edge:s4
+$  pool-role   pool-role:s4
+$  stock       stock:s4
+$  ranks       ranks:s4
+$  moment      moment:s4
+$  bound       bound:s4
::
+$  goal-froze  goal-froze:s4
+$  goal-nexus  goal-nexus:s4
+$  goal-hitch  goal-hitch:s4
::
+$  goal        goal:s4
+$  ngoal       ngoal:s4
+$  goals       goals:s4
::
+$  pool-froze  pool-froze:s4
+$  pool-perms  pool-perms:s4
+$  pool-nexus  pool-nexus:s4
+$  pool-hitch  pool-hitch:s4
::
+$  pool        pool:s4
+$  npool       npool:s4
+$  pools       pools:s4
::
+$  directory   directory:s4
::
+$  store       store:s4
::
++  s4
  |%
  +$  id  id:s3
  +$  eid  eid:s3
  +$  pin  pin:s3
  +$  directory  directory:s3
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
  +$  edge
    $:  =moment
        inflow=(set eid)
        outflow=(set eid)
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
        kickoff=edge
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
  +$  pool-role  ?(%admin %spawn)
  ::
  +$  pool-perms  (map ship (unit ?(%owner pool-role)))
  ::
  +$  pool-nexus  =goals
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
  +$  store  [=directory =pools]
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
  :: think of ~ as +inf in the case of lth and -inf in case of gth
  ++  unit-cmp
    |=  cmp=$-([@ @] ?)
    |=  [a=(unit @) b=(unit @)]
    ?~  a  %.n
    ?~  b  %.y
    (cmp u.a u.b)
  ::
  ++  unit-lth  (unit-cmp lth)
  ++  unit-gth  (unit-cmp gth)
  ::
  ++  head-extremum
    |=  cmp=$-([(unit @) (unit @)] ?)
    |*  lst=(list [(unit @) *])
    %+  roll
      ^+  lst  +.lst
    |:  [a=i.-.lst b=i.-.lst]
    ?:  (cmp -.a -.b)  a  b
  ::
  ++  list-min-head  (head-extremum unit-lth)
  ++  list-max-head  (head-extremum unit-gth)
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
  =.  pool-perms  (~(put by pool-perms) owner (some %owner))
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
  =.  nexus.npool  (goals-3-to-4 goals.nexus.^npool)
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

++  convert-3-to-4
  |=  =state-3
  ^-  state-4
  :*  %4
      directory.store.state-3
      (pools-3-to-4 pools.store.state-3)
  ==
::
++  convert-2-to-3
  |=  =state-2
  ^-  state-3
  `state-3`[%3 +.state-2]
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
::
:: From state-1 to state-2:
::   - add owner and birth to goal and pool
::   - restructure with froze, perms, nexus, togls, hitch
::
++  convert-1-to-2
  |=  =state-1
  ^-  state-2
  :*  %2
      directory.store.state-1
      (pools-1-to-2 pools.store.state-1)
  ==

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
+$  nex  (map id goal-nexus)
::
+$  comparator  $-([id id] ?)
::
+$  yoke  $-([id id] pools)
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
+$  yoke-sequence  (list ?(core-yoke [%held-rend lid=id rid=id] exposed-yoke))
--
