/+  *gol-cli-help
|%
::
+$  state-2  [%2 =store:s2]
+$  state-1  [%1 =store:s1]
+$  state-0  [%0 =store:s0]
::
+$  id          id:s2
+$  eid         eid:s2
+$  pin         pin:s2
+$  edge        edge:s2
::
+$  goal-froze  goal-froze:s2
+$  goal-perms  goal-perms:s2
+$  goal-nexus  goal-nexus:s2
+$  goal-togls  goal-togls:s2
+$  goal-hitch  goal-hitch:s2
::
+$  goal        goal:s2
+$  ngoal       ngoal:s2
+$  goals       goals:s2
::
+$  pool-froze  pool-froze:s2
+$  pool-perms  pool-perms:s2
+$  pool-nexus  pool-nexus:s2
+$  pool-togls  pool-togls:s2
+$  pool-hitch  pool-hitch:s2
::
+$  pool        pool:s2
+$  npool       npool:s2
+$  pools       pools:s2
::
+$  directory   directory:s2
::
+$  store       store:s2
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
  :: ::  
  :: +$  togl
  ::   $:  mod=ship
  ::       timestamp=@da
  ::   ==
  ::
  +$  goal-togls
    $:  complete=?(%.y %.n)
        actionable=?(%.y %.n)
        archived=?(%.y %.n)
    ==
  ::
  +$  goal-hitch
    $:  desc=@t
        :: meta=(map @tas (unit @tas))
        :: tags=(set @tas)
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
  +$  pool-nexus
    $:  =goals
    ==
  ::
  +$  pool-togls
    $:  archived=?(%.y %.n)
    ==
  ::
  +$  pool-hitch
    $:  title=@t
        :: fields=(map @tas (list @tas))
    ==
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
      %held-rend
      %held-yoke
      %move-goal
  ==
::
+$  yoke-tag  (union-from-list yoke-tags)
::
+$  exposed-yoke  $%([yoke-tag lid=id rid=id])
::
+$  yoke-sequence  (list ?(core-yoke [%held-rend lid=id rid=id] exposed-yoke))
::
+$  goal-perm
  $%  %mod-chefs
      %mod-peons
      %add-under
      %remove
      %edit-desc
      %set-deadline
      %mark-actionable
      %mark-complete
      %mark-active
  ==
::
+$  pool-perm
  $%  %mod-viewers
      %edit-title
      %new-goal
  ==
::
+$  pair-perm
  $%  %&
  ==
--
