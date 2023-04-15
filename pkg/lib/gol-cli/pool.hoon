/-  gol=goal
/+  *gol-cli-util, gol-cli-node, gol-cli-traverse, vd=gol-cli-validate,
    fl=gol-cli-inflater
|_  p=pool:gol
+*  this  .
    tv    ~(. gol-cli-traverse goals.p)
    nd    ~(. gol-cli-node goals.p)
++  vzn  vzn:gol
++  abet  (inflate-pool:fl p)
++  apex  |=(p=pool:gol this(p p))
::
:: ============================================================================
:: 
:: SPAWNING/CACHING/WASTING/TRASHING/RENEWING GOALS
::
:: ============================================================================
::
:: Initialize a goal with initial state
++  init-goal
  |=  [=id:gol chief=ship author=ship]
  ^-  goal:gol
  =|  =goal:gol
  =.  owner.goal  owner.id
  =.  birth.goal  birth.id
  =.  chief.goal  chief
  =.  author.goal  author
  :: 
  :: Initialize inflowing and outflowing nodes
  =.  outflow.kickoff.goal  (~(put in *(set nid:gol)) [%d id])
  =.  inflow.deadline.goal  (~(put in *(set nid:gol)) [%k id])
  goal
::
++  spawn-goal
  |=  [=id:gol upid=(unit id:gol) mod=ship]
  ^-  _this
  ?>  ?~  upid
        (check-root-spawn-perm mod)
      (check-goal-spawn-perm u.upid mod)
  =/  goal  (init-goal id mod mod)
  =.  goals.p  (~(put by goals.p) id goal)
  (move id upid owner.p) :: divine intervention (owner)
::
:: Extract goal from goals
++  wrest-goal
  |=  [=id:gol mod=ship]
  ^-  [trac=goals:gol main=goals:gol]
  ::
  :: Get subgoals of goal including self
  =/  prog  (progeny:tv id)
  ::
  :: Move goal to root
  =/  pore  (move id ~ owner.p) :: divine intervention (owner)
  ::
  :: Partition subgoals of goal from rest of goals
  =.  pore  (partition:pore prog mod)
  ::
  :: both of these should get validated here (validate-goals:vd goals)
  :: return extracted goals and remaining goals
  [(gat-by goals.p.pore ~(tap in prog)) (gus-by goals.p.pore ~(tap in prog))]
::
:: Permanently delete goal and subgoals directly
++  waste-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  ?>  (check-pool-edit-perm mod)
  this(goals.p main:(wrest-goal id mod))
::
:: Move goal and subgoals from main goals to cache
++  cache-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm id mod)
  =/  wrest  (wrest-goal id mod) :: mod has the correct perms for this
  %=  this
    goals.p  main.wrest
    cache.p  (~(uni by cache.p) trac.wrest)
  ==
::
:: Restore goal from cache to main goals
++  renew-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  ?>  (check-pool-edit-perm mod) :: only owner/admins can renew
  ::
  :: mod has the correct perms for this
  =/  wrest  (wrest-goal:this(goals.p cache.p) id mod) 
  %=  this
    goals.p  (~(uni by goals.p) (validate-goals:vd trac.wrest))
    cache.p  main.wrest
  ==
::
:: Permanently delete goal and subgoals from cache
++  trash-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  ?>  (check-pool-edit-perm mod)
  this(cache.p main:(wrest-goal:this(goals.p cache.p) id mod))
::
:: Partition the set of goals q from its complement q- in goals.p
++  partition
  |=  [q=(set id:gol) mod=ship]
  ^-  _this
  ::
  :: get complement of q
  =/  q-  (~(dif in ~(key by goals.p)) q)
  ::
  :: iterate through and break bonds between each id in q
  :: and all ids in q's complement
  =/  q  ~(tap in q)
  =/  pore  this
  |-
  ?~  q
    pore
  $(q t.q, pore (break-bonds:pore i.q q- mod))
::
:: Break bonds between a goal and a set of other goals
++  break-bonds
  |=  [=id:gol exes=(set id:gol) mod=ship]
  ^-  _this
  ::
  :: get the existing bonds between id and its (future) exes
  =/  pairs  (get-bonds:nd id exes)
  ::
  :: iterate through and rend each of these bonds
  =/  pore  this
  |-
  ?~  pairs
    pore
  %=  $
    pairs  t.pairs
    pore  (dag-rend:pore p.i.pairs q.i.pairs mod)
  ==
::
:: ============================================================================
:: 
:: PERMISSIONS UTILITIES
::
:: ============================================================================
::
++  check-pool-edit-perm
  |=  mod=ship
  ^-  ?
  ?:  =(mod owner.p)  %&
  =/  perm  (~(got by perms.p) mod)
  ?~  perm  %|
  ?:  ?=(%admin u.perm)  %&  %|
::
++  check-root-spawn-perm
  |=  mod=ship
  ^-  ?
  ?:  =(mod owner.p)  %&
  =/  perm  (~(get by perms.p) mod)
  ?~  perm  %|   :: not viewer
  ?~  u.perm  %| :: no %admin or %spawn privileges
  %&
::
++  check-goal-edit-perm
  |=  [=id:gol mod=ship]
  ^-  ?
  ?:  (check-pool-edit-perm mod)  %&
  =/  goal  (~(got by goals.p) id)
  ?~  (get-rank:tv mod id)  %|  %&
::
++  check-goal-spawn-perm
  |=  [=id:gol mod=ship]
  ^-  ?
  ?:  (check-goal-edit-perm id mod)  %&
  =/  goal  (~(got by goals.p) id)
  (~(has in spawn.goal) mod)
::
:: most senior ancestor
++  stock-root
  |=  =id:gol
  ^-  [=id:gol chief=ship]
  (snag 0 (flop (get-stock:tv id)))
::
:: owner, admin, or chief of stock-root
++  check-goal-master
  |=  [=id:gol mod=ship]
  ^-  ?
  ?:  (check-pool-edit-perm mod)  %&
  =(mod chief:(stock-root id))
::
++  check-move-to-root-perm
  |=  [=id:gol mod=ship]
  ^-  ?
  &((check-goal-master id mod) (check-root-spawn-perm mod))
::
:: checks if mod can move kid under pid
++  check-move-to-goal-perm
  |=  [kid=id:gol pid=id:gol mod=ship]
  ^-  ?
  ?:  (check-pool-edit-perm mod)  %&
  :: can move kid under pid if you have permissions on a goal
  :: which contains them both
  =/  krank  (get-rank:tv mod kid)
  =/  prank  (get-rank:tv mod pid)
  ?~  krank  %|
  ?~  prank  %|
  ?:  =(u.krank u.prank)  %&
  ::
  :: if chief of stock-root of kid and permissions on pid
  ?:  ?&  =(mod chief:(stock-root kid))
          (check-goal-edit-perm pid mod)
      ==
    %&
  %|
::
:: checks if mod can modify ship's pool permissions
++  check-pool-role-mod
  |=  [=ship mod=ship]
  ^-  ?
  ?:  =(ship owner.p)
    ~|("Cannot change owner perms." !!)
  ?.  (check-pool-edit-perm mod)
    ~|("Do not have owner or admin perms." !!)
  ?:  ?&  =((~(get by perms.p) ship) (some (some %admin)))
          !|(=(mod owner.p) =(mod ship))
      ==
    ~|("Must be owner or self to modify admin perms." !!)
  %&
::
++  check-in-pool  |=(=ship |(=(ship owner.p) (~(has by perms.p) ship)))
::
:: replace all chiefs of goals whose chiefs have been kicked
++  replace-chiefs
   |=  kick=(set ship)
   ^-  _this
   ::
   :: list of all ids of goals with replacable chiefs
   =/  kickable=(list id:gol)
     %+  murn
       ~(tap by goals.p)
     |=  [=id:gol =goal:gol]
     ?.  (~(has in kick) chief.goal)
       ~
     (some id)
   ::
   :: accurate updated chief information
   =/  chiefs
     ((chain:tv id:gol ship) (replace-chief:tv kick owner.p) kickable ~)
   ::
   :: update goals.p to reflect new chief information
  %=  this
    goals.p
      %-  ~(gas by goals.p)
      %+  turn
        kickable
      |=  =id:gol
      =/  goal  (~(got by goals.p) id)
      [id goal(chief (~(got by chiefs) id))]
  ==
::
:: remove a kick set from all goal spawn sets
++  purge-spawn
  |=  kick=(set ship)
  ^-  _this
  %=  this
    goals.p
      %-  ~(run by goals.p)
      |=  =goal:gol
      goal(spawn (~(dif in spawn.goal) kick))
  ==
::
:: ============================================================================
:: 
:: YOKES/RENDS
::
:: ============================================================================
::
++  dag-yoke
  |=  [n1=nid:gol n2=nid:gol mod=ship]
  ^-  _this
  ::
  :: Check mod permissions
  :: Can yoke with permissions on *both* goals
  ?.  ?&  (check-goal-edit-perm id.n1 mod)
          (check-goal-edit-perm id.n2 mod)
      ==
    ~|("missing-goal-mod-perms" !!)
  ::
  :: Cannot relate goal to itself
  ?:  =(id.n1 id.n2)  ~|("same-goal" !!)
  ::
  :: Cannot create relationship where either goal is complete
  ?:  ?|  complete:(~(got by goals.p) id.n1)
          complete:(~(got by goals.p) id.n2)
      ==
    ~|("completed-goal" !!)
  ::
  :: Cannot create relationship with the deadline of the right id
  :: if the right id is an actionable goal
  ?:  ?&  =(-.n2 %d)
          actionable:(~(got by goals.p) id.n2)
      ==
    ~|("right-actionable" !!)
  ::
  :: n2 must not come before n1
  ?:  (check-path:tv n2 n1 %r)  ~|("before-n2-n1" !!)
  ::
  =/  node1  (got-node:nd n1)
  =/  node2  (got-node:nd n2)
  ::
  :: there must be no bound mismatch between n1 and n2
  =/  lb  ?~(moment.node1 (left-bound:tv n1) moment.node1)
  =/  rb  ?~(moment.node2 (ryte-bound:tv n2) moment.node2)
  ?:  ?~(lb %| ?~(rb %| (gth u.lb u.rb)))  ~|("bound-mismatch" !!)
  ::
  :: dag-yoke
  =.  outflow.node1  (~(put in outflow.node1) n2)
  =.  inflow.node2  (~(put in inflow.node2) n1)
  =.  goals.p  (update-node:nd n1 node1)
  =.  goals.p  (update-node:nd n2 node2)
  :: update bounds, plumbs, and other redundant/explicit information
  this
::
++  dag-rend
  |=  [n1=nid:gol n2=nid:gol mod=ship]
  ^-  _this
  ::
  :: Check mod permissions
  :: Can rend with permissions on *either* goal
  ?.  ?|  (check-goal-edit-perm id.n1 mod)
          (check-goal-edit-perm id.n2 mod)
      ==
    ~|("missing-goal-mod-perms" !!)
  :: ::
  :: Cannot unrelate goal from itself
  ?:  =(id.n1 id.n2)  ~|("same-goal" !!)
  ::
  :: Cannot break relationship between completed goals
  ?:  ?&  complete:(~(got by goals.p) id.n1)
          complete:(~(got by goals.p) id.n2)
      ==
    ~|("completed-goals" !!)
  ::
  :: Cannot destroy containment of an owned goal
  =/  l  (~(got by goals.p) id.n1)
  =/  r  (~(got by goals.p) id.n2)
  ?:  ?|  &(=(-.n1 %d) =(-.n2 %d) (~(has in kids.r) id.n1))
          &(=(-.n1 %k) =(-.n2 %k) (~(has in kids.l) id.n2))
      ==
    ~|("owned-goal" !!)
  ::
  :: dag-rend
  =/  node1  (got-node:nd n1)
  =/  node2  (got-node:nd n2)
  =.  outflow.node1  (~(del in outflow.node1) n2)
  =.  inflow.node2  (~(del in inflow.node2) n1)
  =.  goals.p  (update-node:nd n1 node1)
  =.  goals.p  (update-node:nd n2 node2)
  this
::
++  yoke
  |=  [yok=exposed-yoke:gol mod=ship]
  ^-  _this
  =,  yok
  ?-  -.yok
    %prio-yoke  (dag-yoke [%k lid] [%k rid] mod)
    %prio-rend  (dag-rend [%k lid] [%k rid] mod)
    %prec-yoke  (dag-yoke [%d lid] [%k rid] mod)
    %prec-rend  (dag-rend [%d lid] [%k rid] mod)
    %nest-yoke  (dag-yoke [%d lid] [%d rid] mod)
    %nest-rend  (dag-rend [%d lid] [%d rid] mod)
    %hook-yoke  (dag-yoke [%k lid] [%d rid] mod)
    %hook-rend  (dag-rend [%k lid] [%d rid] mod)
      %held-yoke  
    =/  pore  (dag-yoke [%d lid] [%d rid] mod)
    (dag-yoke:pore [%k rid] [%k lid] mod)
      %held-rend  
    =/  pore  (dag-rend [%d lid] [%d rid] mod)
    (dag-rend:pore [%k rid] [%k lid] mod)
  ==
::
++  move-to-root
  |=  [=id:gol mod=ship]
  ^-  _this
  ?.  (check-move-to-root-perm id mod)
    ~|("missing-move-to-root-perms" !!)
  =/  k  (~(got by goals.p) id)  
  ?~  par.k  this
  =/  q  (~(got by goals.p) u.par.k)
  =.  goals.p  (~(put by goals.p) id k(par ~))
  =.  goals.p  (~(put by goals.p) u.par.k q(kids (~(del in kids.q) id)))
  (yoke [%held-rend id u.par.k] mod)
::
++  move-to-goal
  |=  [kid=id:gol pid=id:gol mod=ship]
  ^-  _this
  ?.  (check-move-to-goal-perm kid pid mod)
    ~|("missing-move-to-goal-perms" !!)
  ::
  =/  pore  (move-to-root kid owner.p) :: divine intervention (owner)
  =/  k  (~(got by goals.p.pore) kid)
  =/  q  (~(got by goals.p.pore) pid)
  =.  goals.p.pore  (~(put by goals.p.pore) kid k(par (some pid)))
  =.  goals.p.pore  (~(put by goals.p.pore) pid q(kids (~(put in kids.q) kid)))
  (yoke:pore [%held-yoke kid pid] mod)
::
++  move
  |=  [kid=id:gol upid=(unit id:gol) mod=ship]
  ^-  _this
  ?~(upid (move-to-root kid mod) (move-to-goal kid u.upid mod))
::
++  yoke-sequence
  |=  [yoks=(list exposed-yoke:gol) mod=ship]
  ^-  _this
  =/  pore  this
  |-
  ?~  yoks
    pore
  %=  $
    yoks  t.yoks
    pore  (yoke:pore i.yoks mod)
  ==
::
:: perform several simultaneous rends
++  nuke
  |=  [=nuke:gol mod=ship]
  ^-  _this
  |^
  ::
  %-  yoke-sequence
  :_  mod
  ?-    -.nuke
    %nuke-prio-left  prio-left
    %nuke-prio-ryte  prio-ryte
    %nuke-prio  (weld prio-left prio-ryte)
    %nuke-prec-left  prec-left
    %nuke-prec-ryte  prec-ryte
    %nuke-prec  (weld prec-left prec-ryte)
    %nuke-prio-prec  :(weld prio-left prio-ryte prec-left prec-ryte)
    %nuke-nest-left  nest-left
    %nuke-nest-ryte  nest-ryte
    %nuke-nest  (weld nest-left nest-ryte)
  ==
  ::
  ++  prio-left
    %+  turn
      ~(tap in (prio-left:nd id.nuke))
    |=  =id:gol
    ^-  exposed-yoke:gol
    [%prio-rend id id.nuke]
  ::
  ++  prio-ryte
    %+  turn
      ~(tap in (prio-ryte:nd id.nuke))
    |=  =id:gol
    ^-  exposed-yoke:gol
    [%prio-rend id.nuke id]
  ::
  ++  prec-left
    %+  turn
      ~(tap in (prec-left:nd id.nuke))
    |=  =id:gol
    ^-  exposed-yoke:gol
    [%prec-rend id id.nuke]
  ::
  ++  prec-ryte
    %+  turn
      ~(tap in (prec-ryte:nd id.nuke))
    |=  =id:gol
    ^-  exposed-yoke:gol
    [%prec-rend id.nuke id]
  ::
  ++  nest-left
    %+  turn
      ~(tap in (nest-left:nd id.nuke))
    |=  =id:gol
    ^-  exposed-yoke:gol
    [%nest-rend id id.nuke]
  ::
  ++  nest-ryte
    %+  turn
      ~(tap in (nest-ryte:nd id.nuke))
    |=  =id:gol
    ^-  exposed-yoke:gol
    [%nest-rend id.nuke id]
  --
::
:: composite yokes
++  plex
  |=  [=plex:gol mod=ship]
  ^-  _this
  ?-    plex
      exposed-yoke:gol
    (yoke plex mod)
      nuke:gol
    (nuke plex mod)
  ==
::
:: sequence of composite yokes
++  plex-sequence
  |=  [plez=(list plex:gol) mod=ship]
  ^-  _this
  =/  pore  this
  |-
  ?~  plez
    pore
  $(plez t.plez, pore (plex:pore i.plez mod))
::
:: ============================================================================
:: 
:: COMPLETE/ACTIONABLE/KICKOFF/DEADLINE/PERMS UPDATES
::
:: ============================================================================
::
:: if inflow to deadline has more than its own kickoff;
:: in other words if has actually or virtually nested goals
++  has-nested  |=(=id:gol `?`(gth (lent ~(tap in (iflo:nd [%d id]))) 1))
::
++  mark-actionable
  |=  [=id:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm id mod)
  =/  goal  (~(got by goals.p) id)
  ?:  (has-nested id)  ~|("has-nested" !!)
  this(goals.p (~(put by goals.p) id goal(actionable %&)))
::
++  mark-complete
  |=  [=id:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm id mod)
  =/  goal  (~(got by goals.p) id)
  ?:  (left-uncompleted:tv id)  ~|("left-uncompleted" !!)
  this(goals.p (~(put by goals.p) id goal(complete %&)))
::
++  unmark-actionable
  |=  [=id:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm id mod)
  =/  goal  (~(got by goals.p) id)
  this(goals.p (~(put by goals.p) id goal(actionable %|)))
::
++  unmark-complete
  |=  [=id:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm id mod)
  =/  goal  (~(got by goals.p) id)
  ?:  (ryte-completed:tv id)  ~|("ryte-completed" !!)
  this(goals.p (~(put by goals.p) id goal(complete %|)))
::
++  bounded
  |=  [=nid:gol =moment:gol dir=?(%l %r)]
  ^-  ?
  ?-  dir
    %l  =/(lb (left-bound:tv nid) ?~(moment %| ?~(lb %| (gth u.lb u.moment))))
    %r  =/(rb (ryte-bound:tv nid) ?~(moment %| ?~(rb %| (lth u.rb u.moment))))
  == 
::
++  set-kickoff
  |=  [=id:gol =moment:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm id mod)
  ?:  (bounded [%k id] moment %l)  ~|("bound-left" !!)
  ?:  (bounded [%k id] moment %r)  ~|("bound-ryte" !!)
  =/  goal  (~(got by goals.p) id)
  this(goals.p (~(put by goals.p) id goal(moment.kickoff moment)))
::
++  set-deadline
  |=  [=id:gol =moment:gol mod=ship]
  ^-  _this
  ?>  (check-goal-edit-perm id mod)
  ?:  (bounded [%d id] moment %l)  ~|("bound-left" !!)
  ?:  (bounded [%d id] moment %r)  ~|("bound-ryte" !!)
  =/  goal  (~(got by goals.p) id)
  this(goals.p (~(put by goals.p) id goal(moment.deadline moment)))
::
:: Update pool permissions for individual ship.
:: If role is ~, remove ship as viewer.
::   If we remove a ship as a viewer, we must remove it from all goal
::   spawn sets. We must also remove it from all goal chiefs and replace
::   the chief with its nearest non-deleted ancestor chief or the pool
::   owner when no ancestor is available.
:: If role is [~ u=~], make ship basic viewer.
:: If role is [~ u=[~ u=?(%admin %spawn)]], make ship ?(%admin %spawn).
++  set-pool-role
  |=  [=ship role=(unit (unit pool-role:gol)) mod=ship]
  ^-  _this
  ?>  (check-pool-role-mod ship mod)
  ?~  role
    =/  pore  (replace-chiefs (sy ~[ship]))
    =/  pore  (purge-spawn:pore (sy ~[ship]))
    pore(perms.p (~(del by perms.p) ship))
  this(perms.p (~(put by perms.p) ship u.role))
::
:: set the chief of a goal or optionally all its subgoals
++  set-chief
  |=  [=id:gol chief=ship rec=?(%.y %.n) mod=ship]
  ^-  _this
  ?.  (check-goal-edit-perm id mod)  ~|("missing goal perms" !!)
  ?.  (check-in-pool chief)  ~|("chief not in pool" !!)
  =/  ids  ?.(rec ~[id] ~(tap in (progeny:tv id)))
  %=  this
    goals.p
      %-  ~(gas by goals.p)
      %+  turn
        ids
      |=  =id:gol
      =/  goal  (~(got by goals.p) id)
      [id goal(chief chief)]
  ==
::
:: replace the spawn set of a goal with a new spawn set
++  replace-spawn-set
  |=  [=id:gol spawn=(set ship) mod=ship]
  ^-  _this
  ?.  (check-goal-edit-perm id mod)  ~|("missing goal perms" !!)
  ?.  (~(all in spawn) check-in-pool)
    ~|("some ships in spawn set are not in pool" !!)
  =/  goal  (~(got by goals.p) id)
  this(goals.p (~(put by goals.p) id goal(spawn spawn)))
--
