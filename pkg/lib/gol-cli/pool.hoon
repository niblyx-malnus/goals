/-  gol=goal
/+  *gol-cli-goal
=|  efx=(list update:gol)
|_  p=pool:gol
+*  this  .
    pin   `pin:gol`[%pin owner.p birth.p]
++  vzn  %4
++  apex
  |=  =pool:gol
  this(p pool)
::
++  abet
  ^-  [efx=(list update:gol) =pool:gol]
  [(flop efx) p]
::
++  emit
  |=  upd=update:gol
  this(efx [upd efx])
::
++  emot
  |=  [old=_this upd=update:gol]
  ?.  =(this (etch:old upd)) :: be wary of changes to efx
  ~|("non-equivalent-update" !!)
  (emit upd)
::
++  got-edge
  |=  =eid:gol
  ^-  edge:gol
  =/  goal  (~(got by goals.p) id.eid)
  ?-  -.eid
    %k  kickoff.goal
    %d  deadline.goal
  ==
::
++  update-edge
  |=  [=eid:gol =edge:gol]
  ^-  goal:gol
  =/  goal  (~(got by goals.p) id.eid)
  ?-  -.eid
    %k  goal(kickoff edge)
    %d  goal(deadline edge)
  ==
::
++  make-nex
  |=  ids=(set id:gol)
  ^-  nex:gol
  =|  =nex:gol
  %-  ~(gas by nex)
  %+  turn  ~(tap in ids)
  |=  =id:gol
  [id nexus:`ngoal:gol`(~(got by goals.p) id)]
::
++  apply-nex
  |=  =nex:gol
  ^-  _this
    %=  this
      goals.p
      %-  ~(gas by goals.p)
      %+  turn  ~(tap by nex)
      |=  [=id:gol =goal-nexus:gol]
      ^-  [id:gol goal:gol]
      =/  =ngoal:gol  (~(got by goals.p) id)
      [id ngoal(nexus goal-nexus)]
    ==
::
++  init-goal
  |=  [=id:gol chief=ship]
  ^-  goal:gol
  =|  =goal:gol
  =.  owner.goal  owner.id
  =.  birth.goal  birth.id
  =.  chief.goal  chief
  :: 
  :: Initialize edges
  =.  outflow.kickoff.goal  (~(put in *(set eid:gol)) [%d id])
  =.  inflow.deadline.goal  (~(put in *(set eid:gol)) [%k id])
  ::
  :: Initialize redundant data
  =.  goals.p  (~(put by goals.p) id goal) :: temporarily simulate adding goal
  ::
  =.  ranks.goal  (get-ranks id chief ~)
  ::
  =.  left-bound.kickoff.goal  (renew-bound [%k id] %l)
  =.  ryte-bound.kickoff.goal  (renew-bound [%k id] %r)
  =.  left-bound.deadline.goal  (renew-bound [%d id] %l)
  =.  ryte-bound.deadline.goal  (renew-bound [%d id] %r)
  ::
  =.  left-plumb.kickoff.goal  (renew-plumb [%k id] %l)
  =.  ryte-plumb.kickoff.goal  (renew-plumb [%k id] %r)
  =.  left-plumb.deadline.goal  (renew-plumb [%d id] %l)
  =.  ryte-plumb.deadline.goal  (renew-plumb [%d id] %r)
  ::
  goal
::
++  spawn-goal
  |=  [=id:gol upid=(unit id:gol) mod=ship]
  ^-  [ids=(set id:gol) pore=_this]
  =/  old  this
  ::
  :: Check mod permissions
  =/  par-perm
    ?~  upid
      (check-root-spawn-perm mod)
    (check-goal-spawn-perm u.upid mod)
  ?>  par-perm
  ::
  :: Initialize goal
  =/  goal  (init-goal id mod)
  ::
  :: Put goal in goals and move under upid
  =.  goals.p  (~(put by goals.p) id goal)
  (move id upid owner.p) :: divine intervention (owner)
::
:: wit all da fixin's
++  spawn-goal-fixns
  |=  $:  =id:gol
          upid=(unit id:gol)
          desc=@t
          actionable=?(%.y %.n)
          mod=ship
      ==
  ^-  _this
  =/  old  this
  =/  mup  (spawn-goal id upid mod)
  =/  pore  pore.mup
  =.  pore  (edit-goal-desc:pore id desc mod)
  =.  pore
    ?:  actionable
      (mark-actionable:pore id mod)
    (unmark-actionable:pore id mod)
  =+  pore(efx efx) :: ignore accumulated updates
  =/  nex  (make-nex ids.mup)
  (emot old [vzn %spawn-goal nex id (~(got by goals.p) id)])
::
:: All descendents including self
++  progeny
  |=  =id:gol
  ^-  (set id:gol)
  =/  output  (~(put in *(set id:gol)) id)
  =/  goal  (~(got by goals.p) id)
  =/  kids  ~(tap in kids.goal)
  =/  idx  0
  |-
  ?:  =(idx (lent kids))
    output
  %=  $
    idx  +(idx)
    output  (~(uni in output) (progeny (snag idx kids)))
  ==
::
:: Partition the set of goals q from its complement q- in goals.p
++  partition
  |=  [q=(set id:gol) mod=ship]
  ^-  [ids=(set id:gol) pore=_this]
  =/  q-  (~(dif in ~(key by goals.p)) q)
  =/  q  ~(tap in q)
  =/  idx  0
  =|  ids=(set id:gol)
  =/  pore  this
  |-
  ?:  =(idx (lent q))
    [ids pore]
  =/  mup  (break-bonds:pore (snag idx q) q- mod)
  %=  $
    idx  +(idx)
    ids  (~(uni in ids) ids.mup)
    pore  pore.mup
  ==
::
:: Break bonds between a goal and a set of other goals
++  break-bonds
  |=  [=id:gol exes=(set id:gol) mod=ship]
  ^-  [ids=(set id:gol) pore=_this]
  ::
  :: get the existing bonds between id and its (future) exes
  =/  pairs  (get-bonds id exes)
  ::
  :: iterate through and rend each of these bonds
  =/  idx  0
  =|  ids=(set id:gol)
  =/  pore  this
  |-
  ?:  =(idx (lent pairs))
    [ids pore]
  =/  pair  (snag idx pairs)
  =/  mup  (dag-rend:pore p.pair q.pair mod)
  ::
  :: be sure to fix neighbors, as this is a raw dag operation and not an
  :: exposed yoke
  %=  $
    idx  +(idx)
    ids  (~(uni in ids) ids.mup)
    pore  (fix-neighbors:pore.mup id.p.pair id.q.pair)
  ==
::
:: Get the bonds which exist between a goal and a set of other goals
++  get-bonds
  |=  [=id:gol ids=(set id:gol)]
  ^-  (list (pair eid:gol eid:gol))
  =+  (~(got by goals.p) id)  :: exposes kickoff and deadline
  ::
  :: get set of edges based on ids
  =/  eids=(set eid:gol)
    %-  %~  uni  in
        `(set eid:gol)`(~(run in ids) |=(=id:gol [%k id]))
    `(set eid:gol)`(~(run in ids) |=(=id:gol [%d id]))
  ::
  :: 
  %~  tap  in
  ::
  :: get the edges flowing into id's kickoff
  %-  %~  uni  in
      ^-  (set (pair eid:gol eid:gol))
      %-  ~(run in (~(int in eids) inflow.kickoff))
      |=(=eid:gol [eid %k id]) :: make sure these are ordered correctly
  ::
  :: get the edges flowing out of id's kickoff
  %-  %~  uni  in
      ^-  (set (pair eid:gol eid:gol))
      %-  ~(run in (~(int in eids) outflow.kickoff))
      |=(=eid:gol [[%k id] eid]) :: make sure these are ordered correctly
  ::
  :: get the edges flowing into id's deadline
  %-  %~  uni  in
      ^-  (set (pair eid:gol eid:gol))
      %-  ~(run in (~(int in eids) inflow.deadline))
      |=(=eid:gol [eid %d id]) :: make sure these are ordered correctly
  ::
  :: get the edges flowing out of id's deadline
  ^-  (set (pair eid:gol eid:gol))
  %-  ~(run in (~(int in eids) outflow.deadline))
  |=(=eid:gol [[%d id] eid]) :: make sure these are ordered correctly
::
:: Get the submap of goals associated with ids
++  gat-by
  |=  [=goals:gol ids=(list id:gol)]
  ^-  goals:gol
  =|  =goals:gol
  =/  idx  0
  |-
  ?:  =(idx (lent ids))
    goals
  %=  $
    idx  +(idx)
    goals
      =/  id  (snag idx ids)
      (~(put by goals) id (~(got by ^goals) id))
  ==
::
:: Remove all the goal objects associated with ids from goals
++  gus-by
  |=  [=goals:gol ids=(list id:gol)]
  ^-  goals:gol
  =/  idx  0
  |-
  ?:  =(idx (lent ids))
    goals
  %=  $
    idx  +(idx)
    goals  (~(del by goals) (snag idx ids))
  ==
::
:: Permanently delete goal and subgoals directly
++  waste-goal
  |=  [=id:gol mod=ship]
  ^-  [=nex:gol =id:gol waz=goals:gol pore=_this]
  ::
  :: Move goal to root
  =/  mup  (move id ~ owner.p) :: divine intervention (owner)
  =/  pore  pore.mup
  =/  ids  ids.mup
  ::
  :: Partition subgoals of goal from rest of goals
  =/  prog  (progeny:pore id)
  =.  mup  (partition:pore prog mod)
  =.  pore  pore.mup
  =.  ids  (~(uni in ids) ids.mup)
  ::
  :: Get nex and deleted goals
  =/  nex  (make-nex:pore ids)
  =/  waz  (gat-by goals.p.pore ~(tap in prog))
  ::
  :: Remove goal and subgoals from goals
  =.  goals.p.pore  (gus-by goals.p.pore ~(tap in prog))
  ::
  [nex id waz pore]
::
:: Move goal and subgoals from main goals to cache
++  cache-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  old  this
  ::
  :: Must have permissions on this goal to cache it
  ?>  (check-goal-perm id mod)
  ::
  :: Partition and remove
  =+  (waste-goal id mod) :: exposes nex, id, waz, and pore
  ::
  :: Add goal and subgoals to cache
  =.  cache.p.pore  (~(put by cache.p.pore) id waz)
  ::
  :: Emit update
  (emot:pore old [vzn %cache-goal nex id ~(key by waz)])
::
:: Restore goal from cache to main goals
++  renew-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  old  this
  ::
  :: Must have admin permissions to renew this goal
  ?>  (check-pool-perm mod)
  ::
  :: store redundant information
  =/  ren  (~(got by cache.p) id)
  ::
  =.  goals.p  (~(uni by goals.p) ren)
  =.  cache.p  (~(del by cache.p) id)
  ::
  :: ren is redundant
  (emot old [vzn %renew-goal id ren])
::
:: Permanently delete goal (must be in cache)
++  trash-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  old  this
  ::
  :: Must have admin permissions to permanently delete this goal
  ?>  (check-pool-perm mod)
  ::
  ?:  (~(has by goals.p) id)
    ::
    :: Delete directly from goals
    =+  (waste-goal id mod) :: exposes nex, id, waz, and pore
    ::
    :: Emit update
    (emot:pore old [vzn %waste-goal nex id ~(key by waz)])
  ::
  :: store redundant information
  =/  tas  (~(got by cache.p) id)
  :: 
  :: Delete from cache
  =.  cache.p  (~(del by cache.p) id)
  :: ::
  :: Emit update; emitting tas is redundant
  (emot old [vzn %trash-goal id ~(key by tas)])
::
:: ============================================================================
:: 
:: TRAVERSALS
::
:: ============================================================================
::
++  traverse
  |*  =mold
  |=  $:  flow=$-(eid:gol (list eid:gol))
          init=$-(eid:gol mold)
          stop=$-(mold ?)
          meld=$-([mold mold] mold)
          land=$-([eid:gol mold] mold)
      ==
  =|  path=(list eid:gol)
  =|  visited=(map eid:gol mold)
  |=  =eid:gol
  ^-  mold
  %.  eid
  %~  got  by
  |-
  ^-  (map eid:gol mold)
  ::
  :: catch cycles
  =/  i  (find [eid]~ path) 
  =/  cycle=(list eid:gol)  ?~(i ~ [eid (scag u.i path)])
  ?.  =(0 (lent cycle))  ~|(["cycle" cycle] !!)
  ::
  :: iterate through neighbors
  =/  idx  0
  =/  flo  (flow eid)
  ::
  :: initialize output
  =/  out=mold  (init eid)
  |-
  :: 
  :: stop when neighbors exhausted or stop condition met
  ?:  ?|  (stop out)
          =(idx (lent flo))
      ==
    ::
    :: output according to land function
    (~(put by visited) eid (land eid out))
  ::
  :: if in visited, use stored output
  =/  nxt  (snag idx flo)
  ?:  (~(has by visited) nxt)
    %=  $
      idx  +(idx)
      ::
      :: meld the running output with the new output
      out  (meld out (~(got by visited) nxt))
    ==
  ::
  :: recursively compute output for next neighbor
  =/  new-vis
    %=  ^$
      eid  nxt
      path  [eid path]
      visited  visited
    ==
  %=  $
    idx  +(idx)
    ::
    :: meld the running output with the new output
    out  (meld out (~(got by new-vis) nxt))
    visited  new-vis
  ==
::
:: is e1 before e2
++  before
  |=  [e1=eid:gol e2=eid:gol]
  ^-  ?
  =/  flow  |=(=eid:gol ~(tap in inflow:(got-edge eid)))
  =/  init  |=(=eid:gol (~(has in inflow:(got-edge eid)) e1))
  =/  stop  |=(out=? out)
  =/  meld  |=([a=? b=?] |(a b))
  =/  land  |=([=eid:gol out=?] out)
  (((traverse ?) flow init stop meld land) e2)
::
++  left-uncompleted
  |=  =id:gol
  ^-  ?
  =/  flow  |=(=eid:gol ~(tap in inflow:(got-edge eid)))
  =/  init
    |=  =eid:gol
    ?&  =(-.eid %d)
        !=(id id.eid)
        !complete:(~(got by goals.p) id.eid)
    ==
  =/  stop  |=(out=? out)
  =/  meld  |=([a=? b=?] |(a b))
  =/  land  |=([=eid:gol out=?] out)
  (((traverse ?) flow init stop meld land) [%d id])
::
++  ryte-completed
  |=  =id:gol
  ^-  ?
  =/  flow  |=(=eid:gol ~(tap in outflow:(got-edge eid)))
  =/  init
    |=  =eid:gol
    ?&  =(-.eid %d)
        !=(id id.eid)
        complete:(~(got by goals.p) id.eid)
    ==
  =/  stop  |=(out=? out)
  =/  meld  |=([a=? b=?] |(a b))
  =/  land  |=([=eid:gol out=?] out)
  (((traverse ?) flow init stop meld land) [%d id])
::
++  harvest
  |=  =id:gol
  ^-  (set id:gol)
  ::
  =/  flow
    |=  =eid:gol
    %+  murn
      ~(tap in inflow:(got-edge eid))
    |=  =eid:gol
    ?:  complete:(~(got by goals.p) id.eid)
      ~
    (some eid)
  ::
  =/  init  |=(eid:gol *(set id:gol))
  =/  stop  |=((set id:gol) %.n)
  =/  meld  |=([a=(set id:gol) b=(set id:gol)] (~(uni in a) b))
  ::
  =/  land
    |=  [=eid:gol out=(set id:gol)]
    ::
    :: a completed goal has no harvest
    ?:  complete:(~(got by goals.p) id.eid)
      ~
    :: in general, the harvest of a node is the union of the
    ::   harvests of its immediate precedents
    :: a deadline with an otherwise empty harvest
    ::   returns itself as its own harvest
    ?:  &(=(~ out) =(%d -.eid))
      (~(put in *(set id:gol)) id.eid)
    out
  ::
  (((traverse (set id:gol)) flow init stop meld land) [%d id])
::
:: harvest with full goals
++  full-harvest
  |=  =id:gol
  ^-  goals:gol
  (gat-by goals.p ~(tap in (harvest id)))
::
:: think of ~ as +inf
:: +inf should only be a ryte-bound if there is no smaller number in between
++  loth
  |=  [a=(unit @) b=(unit @)]
  ?~  a  %.n  :: ~ (+inf) is not less than any number (including itself)
  ?~  b  %.y  :: any number is less than ~ (+inf)
  (lth u.a u.b)
::
:: think of ~ as -inf
:: -inf should only be a left-bound if there is no larger number in between
++  goth
  |=  [a=(unit @) b=(unit @)]
  ?~  a  %.n  :: ~ (-inf) is not greater than any number (including itself)
  ?~  b  %.y  :: any number is greater than ~ (-inf)
  (gth u.a u.b)
::
:: a ~ bounded by a [~ @da] causes no bound-mismatch
:: a [~ @da] bounded by a ~ causes no bound-mismatch
:: only a [~ @da] bounded by a [~ @da] can cause a bound-mismatch
:: comparing to ~ always returns %.n
++  ath
  |=  cmp=$-([@ @] ?)
  |=  [a=(unit @) b=(unit @)]
  ?~  a  %.n
  ?~  b  %.n
  (cmp u.a u.b)
::
++  lath  (ath lth)
++  gath  (ath gth)
::
++  head-extremum
  |=  cmp=$-([(unit @) (unit @)] ?)
  |*  lst=(list [(unit @) *])
  %+  roll
    lst
  |:  [a=-.lst b=-.lst]
  ?:  (cmp -.a -.b)  a  b
::
++  list-min-head  (head-extremum loth)
++  list-max-head  (head-extremum goth)
::
++  bounder
  |=  dir=?(%l %r)
  |=  =eid:gol
  ^-  bound:gol
  =/  edge  (got-edge eid)
  =/  comp
    ?-  dir
      %l  list-max-head
      %r  list-min-head
    ==
  =/  flow
    ?-  dir
      %l  inflow.edge
      %r  outflow.edge
    ==
  ?:  =(0 ~(wyt in flow))
    [moment.edge eid]
  %-  comp
  %+  weld
    ~[[moment.edge eid]]
  %+  turn
    ~(tap in flow)
  (bounder dir)
::
++  left-bound  (bounder %l)
++  ryte-bound  (bounder %r)
::
:: get depth of a given goal (lowest level is depth of 1)
:: this is mostly for printing accurate level information in the CLI
++  plumb
  |=  =id:gol
  ^-  @ud
  =/  goal  (~(got by goals.p) id)
  =/  lvl  1
  =/  gots  (yung goal)
  ?:  =(0 ~(wyt in gots))  lvl :: if childless, depth of 1
  =/  idx  0
  =/  gots  ~(tap in gots)
  |-
  ?:  =(idx (lent gots))  +(lvl) :: add 1 to maximum child depth
  $(idx +(idx), lvl (max lvl (plumb (snag idx gots))))
::
++  roots
  ^-  (list [id:gol goal:gol])
  %+  skim
    ~(tap by goals.p)
  |=([id:gol =goal:gol] =(~ par.goal))
::
++  unnested
  |=  =(list [id:gol goal:gol])
  ^-  (^list [id:gol goal:gol])
  %+  skim
    list
  |=  [=id:gol =goal:gol]
  .=  0
  %-  lent
  %+  murn
    ~(tap in outflow.deadline.goal)
  |=  =eid:gol
  ?-  -.eid
    %k  ~
    %d  (some id.eid)
  ==
::
++  incomplete
  |=  =(list [id:gol goal:gol])
  ^-  (^list [id:gol goal:gol])
  (skip list |=([=id:gol =goal:gol] complete:goal))
::
:: get max depth + 1; depth of "virtual" root node
++  anchor  +((roll (turn (turn roots head) plumb) max))
::
++  uncompleted
  |=  getter=$-(goal:gol (set id:gol))
  |=  =goal:gol
  %-  ~(gas in *(set id:gol))
  (skim ~(tap in (getter goal)) |=(=id:gol !complete:(~(got by goals.p) id)))
::
:: get priority of a given goal (highest priority is 0)
:: priority is the number of goals prioritized ahead of a given goal
++  priority
  |=  =id:gol
  |^
  ~(wyt in (priors id ~))
  ++  priors
    |=  [=id:gol path=(list id:gol)]
    ^-  (set id:gol)
    =/  new-path=(list id:gol)  [id path]
    =/  i  (find [id]~ path) 
    ?.  =(~ i)  ?~(i !! ~&("cycle" ~|([%cycle (flop (scag u.i new-path))] !!)))
    =/  goal  (~(got by goals.p) id)
    =/  prio  (prio goal)
    =/  idx  0
    =/  output  prio
    =/  prio  ~(tap in prio)
    |-
    ?:  =(idx (lent prio))
      output
    $(idx +(idx), output (~(uni in output) (priors (snag idx prio) new-path)))
  --
::
:: highest to lowest priority (highest being smallest number)
++  hi-to-lo
  |=  lst=(list id:gol)
  %+  sort  lst
  |=  [a=id:gol b=id:gol]
  (lth (priority a) (priority b))
::
:: ============================================================================
:: 
:: PERMISSIONS
::
:: ============================================================================
::
:: Permission gates return %& or crash with error output
++  check-pool-perm
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
  ?~  perm  %|       :: not viewer
  ?~  u.perm  %|  %& :: no %admin or %spawn privileges
::
++  check-goal-perm
  |=  [=id:gol mod=ship]
  ^-  ?
  ?:  (check-pool-perm mod)  %&
  =/  goal  (~(got by goals.p) id)
  ?~  (~(get by ranks.goal) mod)  %|  %&
::
++  check-goal-spawn-perm
  |=  [=id:gol mod=ship]
  ^-  ?
  ?:  (check-goal-perm id mod)  %&
  =/  goal  (~(got by goals.p) id)
  (~(has in spawn.goal) mod)
::
:: Checks if mod can move lid under urid
++  check-move-perm
  |=  [lid=id:gol urid=(unit id:gol) mod=ship]
  ^-  ?
  ?:  (check-pool-perm mod)  %&
  :: Can only move to root with admin-level pool permissions
  ?~  urid  %|
  :: Can move lid under u.urid if you have permissions on a goal
  :: which contains them both
  =/  l-goal  (~(got by goals.p) lid)
  =/  r-goal  (~(got by goals.p) u.urid)
  =/  l-rank  (~(get by ranks.l-goal) mod)
  =/  r-rank  (~(get by ranks.r-goal) mod)
  ?~  l-rank  %|
  ?~  r-rank  %|
  ?:  =(u.l-rank u.r-rank)  %&
  ::
  :: if chief of root of lid and permissions on u.urid
  ?:  ?&  .=  mod
              =<  chief
              (snag 0 (flop `stock:gol`[[lid chief.l-goal] stock.l-goal]))
          (check-goal-perm u.urid mod)
      ==
    %&
  %|
::
:: Checks if mod can modify ship's pool permissions
++  check-ship-mod
  |=  [=ship mod=ship]
  ^-  ?
  ?:  =(ship owner.p)
    ~|("Cannot change owner perms." !!)
  ?>  (check-pool-perm mod)
  ?.  =((~(get by perms.p) ship) (some (some %admin)))  %&
  ?:  |(=(mod owner.p) =(mod ship))  %&
  ~|("not-owner-or-self" !!)
::
:: ============================================================================
:: 
:: UPDATE REDUNDANT/EXPLICIT GOAL INFORMATION
::
:: ============================================================================
::
++  renew-bound
  |=  [=eid:gol dir=?(%l %r)]
  ^-  bound:gol
  =/  edge  (got-edge eid)
  =/  cmp
    ?-  dir
      %l  list-max-head
      %r  list-min-head
    ==
  =/  flow
    ?-  dir
      %l  inflow.edge
      %r  outflow.edge
    ==
  ?:  =(0 ~(wyt in flow))
    [moment.edge eid]
  %-  cmp
  %+  weld
    ~[[moment.edge eid]]
  %+  turn
    ~(tap in flow)
  |=  =eid:gol
  ?-  dir
    %l  left-bound:(got-edge eid)
    %r  ryte-bound:(got-edge eid)
  ==
::
++  renew-plumb
  |=  [=eid:gol dir=?(%l %r)]
  ^-  @ud
  =/  edge  (got-edge eid)
  =/  cmp
    ?-  dir
      %l  max
      %r  min
    ==
  =/  flow
    ?-  dir
      %l  inflow.edge
      %r  outflow.edge
    ==
  ?:  =(0 ~(wyt in flow))
    0
  .+  %+  roll
        %+  turn
          ~(tap in flow)
        |=  =eid:gol
        ?-  dir
          %l  left-plumb:(got-edge eid)
          %r  ryte-plumb:(got-edge eid)
        ==
      cmp
::
++  cascade
  |=  [=eid:gol dir=?(%l %r)]
  ^-  (set [eid:gol edge:gol])
  =/  edge  (got-edge eid)
  =|  upds=(set [eid:gol edge:gol])
  =.  upds
    %-  ~(put in upds)
    :-  eid
    ?-    dir
        %l  :: cascading left; updating right side
      %=  edge
        ryte-bound  (renew-bound eid %r)
        ryte-plumb  (renew-plumb eid %r)
      ==
        %r  :: cascading right; updating left side
      %=  edge
        left-bound  (renew-bound eid %l)
        left-plumb  (renew-plumb eid %l)
      ==
    ==
  =/  next
    %~  tap  in
    ?-  dir
      %l  inflow.edge
      %r  outflow.edge
    ==
  =/  idx  0
  |-
  ?:  =(idx (lent next))
    upds
  %=  $
    idx  +(idx)
    upds  (~(uni in upds) (cascade (snag idx next) dir))
  ==
::
++  cascade-update
  |=  [e1=eid:gol e2=eid:gol]
  ^-  [ids=(set id:gol) pore=_this]
  =/  upds  ~(tap in (~(uni in (cascade e1 %l)) (cascade e2 %r)))
  =/  idx  0
  :-  (sy (turn upds |=([=eid:gol edge:gol] id.eid)))
  |-
  ?:  =(idx (lent upds))
    this
  =+  [eid edge]=(snag idx upds)
  %=  $
    idx  +(idx)
    goals.p  (~(put by goals.p) id.eid (update-edge eid edge))
  ==
::
++  fix-neighbors
  |=  [lid=id:gol rid=id:gol]
  ^-  _this
  |^
  =/  l-goal  (~(got by goals.p) lid)
  =/  r-goal  (~(got by goals.p) rid)
  =.  l-goal  (fix-neighbors l-goal)
  =.  r-goal  (fix-neighbors r-goal)
  this(goals.p (~(gas by goals.p) ~[[lid l-goal] [rid r-goal]]))
  ::
  ++  fix-neighbors
    |=  =goal:gol
    ^-  goal:gol
    |^
    =.  prio-left.goal  prio-left
    =.  prio-ryte.goal  prio-ryte
    =.  prec-left.goal  prec-left
    =.  prec-ryte.goal  prec-ryte
    =.  nest-left.goal  nest-left
    =.  nest-ryte.goal  nest-ryte
    goal
    ::
    ++  exclude-par
      |=  =(set id:gol)
      ^-  (^set id:gol)
      ?~  par.goal
        set
      (~(del in set) u.par.goal)
    ::
    ++  exclude-kids
      |=  =(set id:gol)
      ^-  (^set id:gol)
      (~(dif in set) kids.goal)
    ::  
    ++  prio-left
      ^-  (set id:gol)
      %-  exclude-par
      %-  ~(gas in *(set id:gol))
      %+  murn
        ~(tap in inflow.kickoff.goal)
      |=  =eid:gol
      ?-  -.eid
        %d  ~
        %k  (some id.eid)
      ==
    ::  
    ++  prio-ryte
      ^-  (set id:gol)
      %-  exclude-kids
      %-  ~(gas in *(set id:gol))
      %+  murn
        ~(tap in outflow.kickoff.goal)
      |=  =eid:gol
      ?-  -.eid
        %d  ~
        %k  (some id.eid)
      ==
    ::  
    ++  prec-left
      ^-  (set id:gol)
      %-  ~(gas in *(set id:gol))
      %+  murn
        ~(tap in inflow.kickoff.goal)
      |=  =eid:gol
      ?-  -.eid
        %k  ~
        %d  (some id.eid)
      ==
    ::  
    ++  prec-ryte
      ^-  (set id:gol)
      %-  ~(gas in *(set id:gol))
      %+  murn
        ~(tap in outflow.deadline.goal)
      |=  =eid:gol
      ?-  -.eid
        %d  ~
        %k  (some id.eid)
      ==
    ::  
    ++  nest-left
      ^-  (set id:gol)
      %-  exclude-kids
      %-  ~(gas in *(set id:gol))
      %+  murn
        ~(tap in inflow.deadline.goal)
      |=  =eid:gol
      ?-  -.eid
        %k  ~
        %d  (some id.eid)
      ==
    ::  
    ++  nest-ryte
      ^-  (set id:gol)
      %-  exclude-par
      %-  ~(gas in *(set id:gol))
      %+  murn
        ~(tap in outflow.deadline.goal)
      |=  =eid:gol
      ?-  -.eid
        %k  ~
        %d  (some id.eid)
      ==
    --
  --
::
:: ============================================================================
:: 
:: YOKES/RENDS
::
:: ============================================================================
::
++  dag-yoke
  |=  [e1=eid:gol e2=eid:gol mod=ship]
  ^-  [ids=(set id:gol) pore=_this]
  ::
  :: Check mod permissions
  :: Can yoke with permissions on *both* goals
  ?.  ?&  (check-goal-perm id.e1 mod)
          (check-goal-perm id.e2 mod)
      ==
    ~|("missing-goal-mod-perms" !!)
  ::
  :: Cannot relate goal to itself
  ?:  =(id.e1 id.e2)  ~|("same-goal" !!)
  =/  edge1  (got-edge e1)
  =/  edge2  (got-edge e2)
  ::
  :: Cannot create relationship where a completed goal is to the right
  :: and an uncompleted goal is to the left
  ?:  ?&  complete:(~(got by goals.p) id.e2)
          !complete:(~(got by goals.p) id.e1)
      ==
    ~|("incomplete-complete" !!)
  ::
  :: Cannot create relationship with the deadline of the right id
  :: if the right id is an actionable goal
  ?:  ?&  =(-.e2 %d)
          actionable:(~(got by goals.p) id.e2)
      ==
    ~|("right-actionable" !!)
  ::
  :: e2 must not come before e1
  ?:  (before e2 e1)  ~|("before-e2-e1" !!)
  ::
  :: there must be no bound mismatch between e1 and e2
  ?:  (gath moment.edge1 -:(ryte-bound e2))
    ~|("bound-mismatch" !!)
  ?:  (lath moment.edge2 -:(left-bound e1))
    ~|("bound-mismatch" !!)
  ::
  :: dag-yoke
  =.  outflow.edge1  (~(put in outflow.edge1) e2)
  =.  inflow.edge2  (~(put in inflow.edge2) e1)
  =.  goals.p  (~(put by goals.p) id.e1 (update-edge e1 edge1))
  =.  goals.p  (~(put by goals.p) id.e2 (update-edge e2 edge2))
  :: update bounds, plumbs, and other redundant/explicit information
  (cascade-update e1 e2)
::
++  dag-rend
  |=  [e1=eid:gol e2=eid:gol mod=ship]
  ^-  [ids=(set id:gol) pore=_this]
  ::
  :: Check mod permissions
  :: Can rend with permissions on *either* goal
  ?.  ?|  (check-goal-perm id.e1 mod)
          (check-goal-perm id.e2 mod)
      ==
    ~|("missing-goal-mod-perms" !!)
  :: ::
  :: Cannot unrelate goal from itself
  ?:  =(id.e1 id.e2)  ~|("same-goal" !!)
  ::
  :: Cannot destroy containment of an owned goal
  =/  l  (~(got by goals.p) id.e1)
  =/  r  (~(got by goals.p) id.e2)
  ?:  ?|  &(=(-.e1 %d) =(-.e2 %d) (~(has in kids.r) id.e1))
          &(=(-.e1 %k) =(-.e2 %k) (~(has in kids.l) id.e2))
      ==
    ~|("owned-goal" !!)
  ::
  :: dag-rend
  =/  edge1  (got-edge e1)
  =/  edge2  (got-edge e2)
  =.  outflow.edge1  (~(del in outflow.edge1) e2)
  =.  inflow.edge2  (~(del in inflow.edge2) e1)
  =.  goals.p  (~(put by goals.p) id.e1 (update-edge e1 edge1))
  =.  goals.p  (~(put by goals.p) id.e2 (update-edge e2 edge2))
  (cascade-update e1 e2)
::
++  yoke
  |=  [yok=exposed-yoke:gol mod=ship]
  ^-  [ids=(set id:gol) pore=_this]
  =/  old  this
  =,  yok
  =/  mup=[ids=(set id:gol) pore=_this]
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
      =/  mup  (dag-yoke [%d lid] [%d rid] mod)
      =/  myp  (dag-yoke:pore.mup [%k rid] [%k lid] mod)
      [(~(uni in ids.mup) ids.myp) pore.myp]
        %held-rend  
      =/  mup  (dag-rend [%d lid] [%d rid] mod)
      =/  myp  (dag-rend:pore.mup [%k rid] [%k lid] mod)
      [(~(uni in ids.mup) ids.myp) pore.myp]
    ==
  [ids.mup (fix-neighbors:pore.mup lid rid)]
::
++  yoke-sequence
  |=  [yoks=(list exposed-yoke:gol) mod=ship]
  ^-  _this
  =/  old  this
  =/  idx  0
  =|  ids=(set id:gol)
  =/  pore  this
  |-
  ?:  =(idx (lent yoks))
    (emot old [vzn %pool-nexus %yoke (make-nex ids)]):[pore .]
  =/  mup  (yoke:pore (snag idx yoks) mod)
  %=  $
    idx   +(idx)
    ids   (~(uni in ids) ids.mup)
    pore  pore.mup
  ==
::
++  get-ranks
  |=  [=id:gol chief=ship =stock:gol]
  ^-  ranks:gol
  =/  =ranks:gol  (~(put by *ranks:gol) chief id)
  =/  idx  0
  |-
  ?:  =(idx (lent stock))
    ranks
  =/  anc  (snag idx stock)
  %=  $
    idx  +(idx)
    ranks  (~(put by ranks) chief.anc id.anc)
  ==
::
++  avalanche-chief-mod
  |=  [=id:gol zop=(unit [chief=ship rec=?(%.y %.n)])]
  ^-  [ids=(set id:gol) pore=_this]
  =/  ids  (~(put in *(set id:gol)) id)
  =/  goal  (~(got by goals.p) id)
  =.  stock.goal
    ?~  par.goal
      ~
    =/  poal  (~(got by goals.p) u.par.goal)
    [[u.par.goal chief.poal] stock.poal]
  =.  chief.goal  ?~(zop chief.goal chief.u.zop)
  =.  ranks.goal  (get-ranks id chief.goal stock.goal)
  =/  pore  this(goals.p (~(put by goals.p) id goal))
  =/  idx  0
  =/  kids  ~(tap in kids.goal)
  |-
  ?:  =(idx (lent kids))
    [ids pore]
  =/  mup
    ?~  zop
      (avalanche-chief-mod:pore (snag idx kids) ~)
    ?.  rec.u.zop
      (avalanche-chief-mod:pore (snag idx kids) ~)
    (avalanche-chief-mod:pore (snag idx kids) zop)
  $(idx +(idx), ids ids.mup, pore pore.mup)
::
++  avalanche  |=(=id:gol (avalanche-chief-mod id ~))
::
++  move
  |=  [lid=id:gol urid=(unit id:gol) mod=ship]
  ^-  [ids=(set id:gol) pore=_this]
  =/  old  this
  ::
  :: Check mod permissions
  ?.  (check-move-perm lid urid mod)
    ~|("missing-goal-move-perms" !!)
  ::
  :: Identify ids to be modified
  =/  l  (~(got by goals.p) lid)
  =/  ids=(set id:gol)
    ?~  par.l
      (sy ~[lid])
    (sy ~[lid u.par.l])
  =.  ids
    ?~  urid
      ids
    (~(put in ids) u.urid)
  ::
  :: If par.l is non-null, remove lid from its kids
  =/  mup=[ids=(set id:gol) pore=_this]
    ?~  par.l
      [~ this]
    =/  q  (~(got by goals.p) u.par.l)
    =.  goals.p  (~(put by goals.p) u.par.l q(kids (~(del in kids.q) lid)))
    (yoke [%held-rend lid u.par.l] mod)
  =/  pore  pore.mup
  =.  ids  (~(uni in ids) ids.mup) :: cascading updates
  ::
  :: Replace lid's par with urid (null or unit of id)
  =.  l  (~(got by goals.p.pore) lid) :: l has changed
  =.  goals.p.pore  (~(put by goals.p.pore) lid l(par urid))
  ::
  :: Update stock and ranks
  =.  mup  (avalanche:pore lid)
  =.  pore  pore.mup
  =.  ids  (~(uni in ids) ids.mup) :: avalanche updates
  ::
  :: If urid is non-null, put lid in u.urid's kids
  =.  mup
    ?~  urid  
      [~ pore]
    =/  r  (~(got by goals.p.pore) u.urid)
    =.  goals.p.pore
      (~(put by goals.p.pore) u.urid r(kids (~(put in kids.r) lid)))
    (yoke:pore [%held-yoke lid u.urid] mod)
  ::
  [(~(uni in ids) ids.mup) pore.mup]
::
++  move-emot
  |=  [lid=id:gol urid=(unit id:gol) mod=ship]
  ^-  _this
  =/  old  this
  =/  mup  (move lid urid mod)
  (emot old [vzn %pool-nexus %yoke (make-nex ids.mup)]):[pore.mup .]
::
++  mark-actionable
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-goal-perm id mod)
  =/  goal  (~(got by goals.p) id)
  ?.  .=  0
      %+  murn
      ~(tap in inflow.deadline.goal) 
      |=(=eid:gol ?:(=(id id.eid) ~ (some eid)))
    ~|("has-nested" !!)
  =.  goals.p  (~(put by goals.p) id goal(actionable %&))
  (emot old [vzn %goal-togls id %actionable %.y])
::
++  mark-complete
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-goal-perm id mod)
  =/  goal  (~(got by goals.p) id)
  ?:  (left-uncompleted id)  ~|("left-uncompleted" !!)
  =.  goals.p  (~(put by goals.p) id goal(complete %&))
  (emot old [vzn %goal-togls id %complete %.y])
::
++  unmark-actionable
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-goal-perm id mod)
  =/  goal  (~(got by goals.p) id)
  =.  goals.p  (~(put by goals.p) id goal(actionable %|))
  (emot old [vzn %goal-togls id %actionable %.n])
::
++  unmark-complete
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-goal-perm id mod)
  =/  goal  (~(got by goals.p) id)
  ?:  (ryte-completed id)  ~|("ryte-completed" !!)
  =.  goals.p  (~(put by goals.p) id goal(complete %|))
  (emot old [vzn %goal-togls id %complete %.n])
::
++  set-kickoff
  |=  [=id:gol moment=(unit @da) mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-goal-perm id mod)
  =/  rb  (ryte-bound [%k id])
  =/  lb  (left-bound [%k id])
  ?:  &(!=(+.lb [%k id]) (lath moment -:lb))  ~|("bound-left" !!)
  ?:  &(!=(+.rb [%k id]) (gath moment -:rb))  ~|("bound-ryte" !!)
  =/  goal  (~(got by goals.p) id)
  =.  goals.p  (~(put by goals.p) id goal(moment.kickoff moment))
  (emot old [vzn %goal-nexus id %kickoff moment])
::
++  set-deadline
  |=  [=id:gol moment=(unit @da) mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-goal-perm id mod)
  =/  rb  (ryte-bound [%d id])
  =/  lb  (left-bound [%d id])
  ?:  &(!=(+.lb [%d id]) (lath moment -:lb))  ~|("bound-left" !!)
  ?:  &(!=(+.rb [%d id]) (gath moment -:rb))  ~|("bound-ryte" !!)
  =/  goal  (~(got by goals.p) id)
  =.  goals.p  (~(put by goals.p) id goal(moment.deadline moment))
  (emot old [vzn %goal-nexus id %deadline moment])
::
++  replace-chiefs
  |=  kick=(set ship)
  ^-  [ids=(set id:gol) pore=_this]
  |^
  =/  idx  0
  =|  ids=(set id:gol)
  =/  pore  this
  |-
  ?:  =(idx (lent roots))
    [ids pore]
  =/  mup  (replace-chief (head (snag idx roots)) kick)
  %=  $
    idx  +(idx)
    ids  (~(uni in ids) ids.mup)
    pore  pore(goals.p goals.mup)
  ==
  ++  replace-chief
    |=  [=id:gol kick=(set ship)]
    ^-  [ids=(set id:gol) =goals:gol]
    =/  goal  (~(got by goals.p) id)
    =.  goals.p
      %+  ~(put by goals.p)
        id
      ?.  (~(has in kick) chief.goal)
        goal
      ?~  par.goal
        goal(chief owner.p)
      =/  poal  (~(got by goals.p) u.par.goal)
      goal(chief chief.poal)
    ::
    =/  ids=(set id:gol)
      ?:  (~(has in kick) chief.goal)
        ~
      (~(put in *(set id:gol)) id)
    ::
    =/  idx  0
    =/  kids  ~(tap in kids.goal)
    |-
    ?:  =(idx (lent kids))
      [ids goals.p]
    =/  mup  (replace-chief (snag idx kids) kick)
    %=  $
      idx  +(idx)
      ids  (~(uni in ids) ids.mup)
      goals.p  goals.mup
    ==
  --
::
++  purge-spawn
  |=  kick=(set ship)
  ^-  [ids=(set id:gol) pore=_this]
  =/  idx  0
  =|  ids=(set id:gol)
  =/  goals  ~(tap by goals.p)
  |-
  ?:  =(idx (lent goals))
    [ids this]
  =+  `[=id:gol =goal:gol]`(snag idx goals)
  %=  $
    idx  +(idx)
    ids  (~(put in ids) id)
    goals.p  (~(put by goals.p) id goal(spawn (~(dif in spawn.goal) kick)))
  ==
::
:: Update pool permissions for individual ship.
:: If role is ~, remove ship as viewer.
::   If we remove a ship as a viewer, we must remove it from all goal
::   spawn sets. We must also remove it from all goal chiefs and replace
::   the chief with its nearest non-deleted ancestor chief or the pool
::   owner when no ancestor is available.
:: If role is [~ u=~], make ship basic viewer.
:: If role is [~ u=[~ u=?(%admin %spawn)]], make ship ?(%admin %spawn).
++  update-pool-perms
  |=  [new=pool-perms:gol mod=ship]
  ^-  _this
  =/  upds  (perms-to-upds new)
  =/  old  this
  =/  idx  0
  =|  kick=(set ship)
  |-
  ?:  =(idx (lent upds))
    =/  mup  (replace-chiefs kick)
    =/  myp  (purge-spawn:pore.mup kick)
    =/  ids  (~(uni in ids.mup) ids.myp)
    (emot old [vzn %pool-perms (make-nex ids) perms.p]):[pore.myp .]
  =/  upd  (snag idx upds)
  ?>  (check-ship-mod ship.upd mod)
  %=  $
    idx  +(idx)
    kick  ?~(role.upd (~(put in kick) ship.upd) kick)
    perms.p
      ?~  role.upd
        (~(del by perms.p) ship.upd)
      (~(put by perms.p) ship.upd u.role.upd)
  ==
::
++  perms-to-upds
  |=  new=pool-perms:gol
  ^-  (list [=ship role=(unit (unit pool-role:gol))])
  =/  upds  
    %+  turn
      ~(tap by new)
    |=  [=ship role=(unit pool-role:gol)]
    [ship (some role)]
  %+  weld
    upds
  ^-  (list [=ship role=(unit (unit pool-role:gol))])
  %+  turn
    ~(tap in (~(dif in ~(key by perms.p)) ~(key by new)))
  |=(=ship [ship ~])
::
++  pool-diff
  |=  new=pool-perms:gol
  ^-  [remove=(list ship) invite=(list ship)]
  =/  remove  ~(tap in (~(dif in ~(key by perms.p)) ~(key by new)))
  =/  invite  ~(tap in (~(dif in ~(key by new)) ~(key by perms.p)))
  [remove invite]
::
++  update-goal-perms
  |=  [=id:gol chief=ship rec=?(%.y %.n) spawn=(set ship) mod=ship]
  ^-  _this
  =/  old  this
  ::
  :: Check mod permissions
  ?.  (check-goal-perm id mod)
    ~|("missing goal perms" !!)
  ?.  (~(has by perms.p) chief)
    ~|("chief is a non-viewer" !!)
  ?.  =(0 ~(wyt in (~(dif in spawn) ~(key by perms.p))))
    ~|("ships in spawn are non-viewers" !!)
  ::
  :: Update spawn perms
  =/  goal  (~(got by goals.p) id)
  =.  goals.p  (~(put by goals.p) id goal(spawn spawn))
  ::
  :: Update chief, stock and ranks
  =/  mup  (avalanche-chief-mod id (some [chief rec]))
  ::
  (emot old [vzn %goal-perms (make-nex ids.mup)]):[pore.mup .]
::
++  edit-goal-desc
  |=  [=id:gol desc=@t mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-goal-perm id mod)
  =/  goal  (~(got by goals.p) id)
  =.  goals.p  (~(put by goals.p) id goal(desc desc))
  (emot old [vzn %goal-hitch id %desc desc])
:: 
++  edit-pool-title
  |=  [title=@t mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-pool-perm mod)
  =.  p  p(title title)
  (emot old [vzn %pool-hitch %title title])
::
++  etch
  |=  upd=update:gol
  ^-  _this
  |^
  ?+    +.upd  !!
    :: ------------------------------------------------------------------------
    :: spawn/trash
    ::
      [%spawn-goal *]
    (spawn-goal:life-cycle [nex id goal]:upd)
    ::
      [%waste-goal *]
    (waste-goal:life-cycle [nex id waz]:upd)
    ::
      [%cache-goal *]
    (cache-goal:life-cycle [nex id cas]:upd)
    ::
      [%renew-goal *]
    (renew-goal:life-cycle id.upd)
    ::
      [%trash-goal *]
    (trash-goal:life-cycle id.upd)
    :: ------------------------------------------------------------------------
    :: pool-perms
    ::
      [%pool-perms *]
    (pool-perms new.upd)
    ::
    :: ------------------------------------------------------------------------
    :: pool-hitch
    ::
      [%pool-hitch %title *]
    (title:pool-hitch title.upd)
    :: ------------------------------------------------------------------------
    :: pool-nexus
    ::
      [%pool-nexus %yoke *]
    (apply-nex nex.upd)
    :: ------------------------------------------------------------------------
    :: goal-perms
    ::
      [%goal-perms *]
    (apply-nex nex.upd)
    :: ------------------------------------------------------------------------
    :: goal-hitch
    ::
      [%goal-hitch id:gol %desc *]
    (desc:goal-hitch [id desc]:upd)
    :: ------------------------------------------------------------------------
    :: goal-nexus
    ::
      [%goal-nexus id:gol %deadline *]
    (deadline:goal-nexus [id moment]:upd)
    ::
      [%goal-nexus id:gol %kickoff *]
    (kickoff:goal-nexus [id moment]:upd)
    :: ------------------------------------------------------------------------
    :: goal-togls
    ::
      [%goal-togls id:gol %complete *]
    (complete:goal-togls [id complete]:upd)
    ::
      [%goal-togls id:gol %actionable *]
    (actionable:goal-togls [id actionable]:upd)
  ==
  ::
  ++  life-cycle
    |%
    ++  spawn-goal
      |=  [=nex:gol =id:gol =goal:gol]
      ^-  _this
      =.  goals.p  (~(put by goals.p) id goal)
      (apply-nex nex)
    ::
    ++  waste-goal
      |=  [=nex:gol =id:gol waz=(set id:gol)]
      ^-  _this
      =/  pore  (apply-nex nex)
      pore(goals.p (gus-by goals.p.pore ~(tap in waz)))
    ::
    ++  cache-goal
      |=  [=nex:gol =id:gol cas=(set id:gol)]
      ^-  _this
      =/  pore  (apply-nex nex)
      %=  pore
        cache.p
          %+  ~(put by cache.p.pore)
            id
          (gat-by goals.p.pore ~(tap in cas))
        goals.p  (gus-by goals.p.pore ~(tap in cas))
      ==
    ::
    ++  renew-goal
      |=  =id:gol
      ^-  _this
      %=  this
        goals.p  (~(uni by goals.p) (~(got by cache.p) id))
        cache.p  (~(del by cache.p) id)
      ==
    ::
    ++  trash-goal
      |=  =id:gol
      ^-  _this
      this(cache.p (~(del by cache.p) id))
    --
  ::
  ++  pool-perms  |=(perms=pool-perms:gol `_this`this(perms.p perms))
  ::
  ++  pool-hitch
    |%
    ++  title  |=(title=@t `_this`this(p p(title title)))
    --
  ::
  ++  goal-hitch
    |%
    ++  desc
      |=  [=id:gol desc=@t]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      this(goals.p (~(put by goals.p) id goal(desc desc)))
    --
  ::
  ++  goal-nexus
    |%
    ++  kickoff
      |=  [=id:gol moment=(unit @da)]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      this(goals.p (~(put by goals.p) id goal(moment.kickoff moment)))
    ::
    ++  deadline
      |=  [=id:gol moment=(unit @da)]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      this(goals.p (~(put by goals.p) id goal(moment.deadline moment)))
    --
  ::
  ++  goal-togls
    |%
    ++  complete
      |=  [=id:gol complete=?(%.y %.n)]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      this(goals.p (~(put by goals.p) id goal(complete complete)))
    ::
    ++  actionable
      |=  [=id:gol actionable=?(%.y %.n)]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      this(goals.p (~(put by goals.p) id goal(actionable actionable)))
    --
  --
--
