/+  *gol-cli-help
|%
::
+$  state-3  [%3 =store:s3]
+$  state-2  [%2 =store:s2]
+$  state-1  [%1 =store:s1]
+$  state-0  [%0 =store:s0]
::
+$  id          id:s3
+$  eid         eid:s3
+$  pin         pin:s3
+$  edge        edge:s3
::
+$  goal-froze  goal-froze:s3
+$  goal-perms  goal-perms:s3
+$  goal-nexus  goal-nexus:s3
+$  goal-togls  goal-togls:s3
+$  goal-hitch  goal-hitch:s3
::
+$  goal        goal:s3
+$  ngoal       ngoal:s3
+$  goals       goals:s3
::
+$  pool-froze  pool-froze:s3
+$  pool-perms  pool-perms:s3
+$  pool-nexus  pool-nexus:s3
+$  pool-togls  pool-togls:s3
+$  pool-hitch  pool-hitch:s3
::
+$  pool        pool:s3
+$  npool       npool:s3
+$  pools       pools:s3
::
+$  directory   directory:s3
::
+$  store       store:s3
::
++  s4
  |%
  +$  id  id:s3
  +$  eid  eid:s3
  +$  pin  pin:s3
  +$  edge  edge:s3
  +$  directory  directory:s3
  +$  goal-froze  goal-froze:s3
  +$  goal-nexus  goal-nexus:s3
  +$  goal-togls  goal-togls:s3
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
  +$  goal-role  ?(%captain %peon)
  ::
  +$  goal-perms  
    $:  point=(unit ship)
        perms=(map ship [role=goal-role font=id])
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
  +$  pool-role  ?(%owner %admin %captain)
  ::
  +$  pool-perms  (map ship (unit pool-role))
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
