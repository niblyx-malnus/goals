/-  gol=goal
/+  *gol-cli-util
=|  efx=(list update:gol)
|_  p=pool:gol
+*  this  .
    pin   `pin:gol`[%pin owner.p birth.p]
++  vzn  %4
::
:: return this core with initial value
++  apex
  |=  =pool:gol
  this(p pool)
::
:: return this core with final effects list
++  abet
  ^-  [efx=(list update:gol) =pool:gol]
  [(flop efx) p]
::
:: emit an effect
++  emit
  |=  upd=update:gol
  this(efx [upd efx])
::
:: emit an effect only after checking that updating the data
:: structure using this effect yields the same result
++  emot
  |=  [old=_this upd=update:gol]
  ::
  :: confirm that applying update yields equivalent state
  ?.  =(this (etch:old upd)) :: be wary of changes to efx
  ~|("non-equivalent-update" !!)
  (emit upd)
::
:: get a node from a node id (edge = node ... woops, confusing)
++  got-edge
  |=  =eid:gol
  ^-  edge:gol
  =/  goal  (~(got by goals.p) id.eid)
  ?-  -.eid
    %k  kickoff.goal
    %d  deadline.goal
  ==
::
:: Update the edge at eid with the given edge
++  update-edge
  |=  [=eid:gol =edge:gol]
  ^-  goal:gol
  =/  goal  (~(got by goals.p) id.eid)
  ?-  -.eid
    %k  goal(kickoff edge)
    %d  goal(deadline edge)
  ==
::
:: a is a map from ids to a goal nexus
:: it contains crucial information regarding graph structure
:: it is easier to stay sane by sending updates in this manner
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
      trace.p
        =/  nex  ~(tap by nex)
        |-
        ?~  nex
          trace.p
        $(nex t.nex, trace.p (nexus-to-trace -.i.nex +.i.nex))
    ==
::
++  nexus-to-trace
  |=  [=id:gol nus=goal-nexus:gol]
  ^-  trace:gol
  %=  trace.p
    stocks  (~(put by stocks.trace.p) id stock.nus)
    left-bounds  
      %-  ~(gas by left-bounds.trace.p)
      ~[[[%k id] left-bound.kickoff.nus] [[%d id] left-bound.deadline.nus]]
    ryte-bounds
      %-  ~(gas by ryte-bounds.trace.p)
      ~[[[%k id] ryte-bound.kickoff.nus] [[%d id] ryte-bound.deadline.nus]]
    left-plumbs
      %-  ~(gas by left-plumbs.trace.p)
      ~[[[%k id] left-plumb.kickoff.nus] [[%d id] left-plumb.deadline.nus]]
    ryte-plumbs
      %-  ~(gas by ryte-plumbs.trace.p)
      ~[[[%k id] ryte-plumb.kickoff.nus] [[%d id] ryte-plumb.deadline.nus]]
  ==
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
  :: Initialize inflowing and outflowing edges
  =.  outflow.kickoff.goal  (~(put in *(set eid:gol)) [%d id])
  =.  inflow.deadline.goal  (~(put in *(set eid:gol)) [%k id])
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
  =/  goal  (init-goal id mod mod)
  ::
  :: Put goal in goals and move under upid
  =.  goals.p  (~(put by goals.p) id goal)
  ::
  :: Update redundant information
  =.  trace.p  (trace-update [%spawn id])
  =.  goals.p  (~(put by goals.p) id (inflate-goal id))
  ::
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
:: DEFINE NODE/GOAL SETS
::
:: ============================================================================
::
:: nodes which have no outflows (must be deadlines)
++  root-nodes
  |.  ^-  (list eid:gol)
  %+  turn
    %+  skim
      ~(tap by goals.p)
    |=([id:gol =goal:gol] =(~ outflow.deadline.goal))
  |=([=id:gol =goal:gol] [%d id])
::
:: nodes which have no inflows (must be kickoffs)
++  leaf-nodes
  |.  ^-  (list eid:gol)
  %+  turn
    %+  skim
      ~(tap by goals.p)
    |=([id:gol =goal:gol] =(~ inflow.kickoff.goal))
  |=([=id:gol =goal:gol] [%k id])
::
:: goals whose deadlines have no outflows
++  root-goals
  |.  ^-  (list id:gol)
  %+  turn
    %+  skim
      ~(tap by goals.p)
    |=([id:gol =goal:gol] =(~ outflow.deadline.goal))
  |=([=id:gol =goal:gol] id)
::
:: parentless goals
++  waif-goals
  |.  ^-  (list id:gol)
  %+  turn
    %+  skim
      ~(tap by goals.p)
    |=([id:gol =goal:gol] =(~ par.goal))
  |=([=id:gol =goal:gol] id)
::
:: childless goals
++  bare-goals
  |.  ^-  (list id:gol)
  %+  turn
    %+  skim
      ~(tap by goals.p)
    |=([id:gol =goal:gol] =(~ kids.goal))
  |=([=id:gol =goal:gol] id)
::
:: get max depth + 1; depth of "virtual" root node
++  anchor  |.(+((roll (turn (root-goals) plumb) max)))
::
:: accepts a deadline; returns inflowing deadlines
++  yong
  |=  =eid:gol
  ^-  (set eid:gol)
  ?>  =(%d -.eid)
  %-  ~(gas in *(set eid:gol))
  %+  murn
    ~(tap in (iflo eid))
  |=  =eid:gol
  ?-  -.eid
    %k  ~
    %d  (some eid)
  ==
::
:: gets the kids and "virtual children" of a goal
++  yung
  |=  =id:gol
  ^-  (list id:gol)
  (turn ~(tap in (yong [%d id])) |=(=eid:gol id.eid))
::
:: gets the "virtual children" of a goal
:: (non-kids inflowing deadlines to the deadline)
++  virt
  |=  =id:gol
  ^-  (list id:gol)
  %~  tap  in
  %-  %~  dif  in
      (~(gas in *(set id:gol)) (yung id))
  kids:(~(got by goals.p) id)
::
:: extracts ids of incomplete goals from a list of ids
++  incomplete
  |=  ids=(list id:gol)
  ^-  (list id:gol)
  (skip ids |=(=id:gol complete:(~(got by goals.p) id)))
::
:: Partition the set of goals q from its complement q- in goals.p
++  partition
  |=  [q=(set id:gol) mod=ship]
  ^-  [ids=(set id:gol) pore=_this]
  ::
  :: get complement of q
  =/  q-  (~(dif in ~(key by goals.p)) q)
  ::
  :: iterate through and break bonds between each id in q
  :: and all ids in q's complement
  =/  q  ~(tap in q)
  =|  ids=(set id:gol)
  =/  pore  this
  |-
  ?~  q
    [ids pore]
  =/  mup  (break-bonds:pore i.q q- mod)
  %=  $
    q  t.q
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
  =|  ids=(set id:gol)
  =/  pore  this
  |-
  ?~  pairs
    [ids pore]
  =/  mup  (dag-rend:pore p.i.pairs q.i.pairs mod)
  %=  $
    pairs  t.pairs
    ids  (~(uni in ids) ids.mup)
    pore  pore.mup
  ==
::
:: get all nodes from a set of ids
++  nodify
  |=  ids=(set id:gol)
  ^-  (set eid:gol)
  =/  kix=(set eid:gol)  (~(run in ids) |=(=id:gol [%k id]))
  =/  ded=(set eid:gol)  (~(run in ids) |=(=id:gol [%d id]))
  (~(uni in kix) ded)
::
:: get the nodes from a set of nodes which are
:: contained in the inflow/outflow of a goal's kickoff/deadline
++  bond-overlap
  |=  [=id:gol eids=(set eid:gol) dir=?(%l %r) src=?(%k %d)]
  ^-  (set (pair eid:gol eid:gol))
  =/  flo  ?-(dir %l iflo, %r oflo)
  %-  ~(run in (~(int in eids) (flo [src id])))
  |=(=eid:gol ?-(dir %l [eid src id], %r [[src id] eid]))
::
:: get the bonds which exist between a goal and a set of other goals
++  get-bonds
  |=  [=id:gol ids=(set id:gol)]
  ^-  (list (pair eid:gol eid:gol))
  ::
  :: get set of nodes of ids
  =/  eids  (nodify ids)
  :: 
  %~  tap  in
  ::
  :: get the edges flowing into id's kickoff
  %-  ~(uni in (bond-overlap id eids %l %k))
  ::
  :: get the edges flowing out of id's kickoff
  %-  ~(uni in (bond-overlap id eids %r %k))
  ::
  :: get the edges flowing into id's deadline
  %-  ~(uni in (bond-overlap id eids %l %d))
  ::
  :: get the edges flowing out of id's deadline
  (bond-overlap id eids %r %d)
::
:: ============================================================================
:: 
:: TRAVERSALS
::
:: ============================================================================
::
:: "engine" used to perform different kinds
:: of graph traversals using the traverse function
++  gine
  |*  [nod=mold med=mold fin=mold]
  :*  flow=|~(nod *(list nod))
      init=|~(nod *med)
      stop=|~([nod med] `?`%.n)
      meld=|~([nod old=med new=med] new)
      land=|~([nod =med] med)
      exit=|~([nod vis=(map nod med)] `fin`!!)
  ==
::
:: set defaults for gine where output mold is same
:: as transition mold
++  ginn
  |*  [nod=mold med=mold]
  =/  gine  (gine nod med med)
  gine(exit |~([=nod vis=(map nod med)] (~(got by vis) nod)))
::
:: traverse the underlying DAG (directed acyclic graph)
++  traverse
  |*  [nod=mold med=mold fin=mold]
  :: 
  :: takes an "engine" and a map of already visited nodes and values
  |=  [_(gine nod med fin) vis=(map nod med)]
  ::
  :: initialize path to catch cycles
  =|  pat=(list nod)
  ::
  :: accept single node id
  |=  =nod
  ::
  :: final transformation
  ^-  fin  %+  exit  nod
  |-
  ^-  (map ^nod med)
  ::
  :: catch cycles
  =/  i  (find [nod]~ pat) 
  =/  cyc=(list ^nod)  ?~(i ~ [nod (scag u.i pat)])
  ?.  =(0 (lent cyc))  ~|(["cycle" cyc] !!)
  ::
  :: iterate through neighbors (flo)
  =/  idx  0
  =/  flo  (flow nod)
  ::
  :: initialize output
  =/  med  (init nod)
  |-
  :: 
  :: stop when neighbors exhausted or stop condition met
  ?:  ?|  (stop nod med)
          =(idx (lent flo))
      ==
    ::
    :: output according to land function
    (~(put by vis) nod (land nod med))
  ::
  =/  neb  (snag idx flo)
  ::
  :: make sure visited reflects output of next neighbor
  =.  vis
    ?:  (~(has by vis) neb)
      vis :: if already in visited, use stored output
    ::
    :: recursively compute output for next neighbor
    %=  ^$
      nod  neb
      pat  [nod pat]
      vis  vis :: this has been updated by inner trap
    ==
  ::
  :: update the output and go to the next neighbor
  %=  $
    idx  +(idx)
    ::
    :: meld the running output with the new output
    med  (meld nod med (~(got by vis) neb))
  ==
::
:: chain multiple traversals together, sharing visited map
++  chain
  |*  [nod=mold med=mold]
  |=  $:  trav=$-([nod (map nod med)] (map nod med))
          nodes=(list nod)
          vis=(map nod med)
      ==
  ^-  (map nod med)
  ?~  nodes
    vis
  %=  $
    nodes  t.nodes
    vis  (trav i.nodes vis)
  ==
::
++  iflo  |=(=eid:gol inflow:(got-edge eid))
++  oflo  |=(=eid:gol outflow:(got-edge eid))
::
:: check if there is a path from src to dst
++  check-path
  |=  [src=eid:gol dst=eid:gol dir=?(%l %r)]
  ^-  ?
  ?<  =(src dst)
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  ginn  (ginn eid:gol ?)
  =.  ginn
    %=  ginn
      flow  |=(=eid:gol ~(tap in (flo eid)))  :: inflow or outflow
      init  |=(=eid:gol (~(has in (flo eid)) dst))  :: check for dst
      stop  |=([eid:gol out=?] out)  :: stop on true
      meld  |=([eid:gol a=? b=?] |(a b))
    ==
  (((traverse eid:gol ? ?) ginn ~) src)

:: set of neighbors on path from src to dst
++  step-stones
  |=  [src=eid:gol dst=eid:gol dir=?(%l %r)]
  ^-  (set eid:gol)
  ?<  =(src dst)
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  gine  (gine eid:gol ? (set eid:gol))
  =.  gine
    %=  gine
      flow  |=(=eid:gol ~(tap in (flo eid)))  :: inflow
      init  |=(=eid:gol (~(has in (flo eid)) dst))  :: check for e1
      ::
      :: never stop for immediate neighbors
      stop  |=([=eid:gol out=?] ?:(=(eid src) %.n out))
      meld  |=([eid:gol a=? b=?] |(a b))
      ::
      :: get neighbors which return true (have path to dst)
      exit
        |=  [=eid:gol vis=(map eid:gol ?)]
        %-  ~(gas in *(set eid:gol))
        %+  murn
          ~(tap in (flo eid))
        |=  =eid:gol
        ?:  (~(got by vis) eid)
          ~
        (some eid)
    ==
  (((traverse eid:gol ? (set eid:gol)) gine ~) src)
::
++  done  |=(=id:gol complete:(~(got by goals.p) id))
++  nond  |=(=id:gol !complete:(~(got by goals.p) id))
::
:: for use with %[un]mark-complete
:: check if there are any uncompleted goals to the left OR
:: check if there are any completed goals to the right
++  get-plete
  |=  dir=?(%l %r)
  |=  =id:gol
  ^-  ?
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  pyt  ?-(dir %l nond, %r done)
  =/  ginn  (ginn eid:gol ?)
  =.  ginn
    %=  ginn
      flow  |=(=eid:gol ~(tap in (flo eid)))
      ::
      :: check deadline completion in the flo
      init  |=(=eid:gol &(=(-.eid %d) !=(id id.eid) (pyt id.eid)))
      stop  |=([eid:gol out=?] out)  :: stop on true
      meld  |=([eid:gol a=? b=?] |(a b))
    ==
  (((traverse eid:gol ? ?) ginn ~) [%d id]) :: start at deadline
::
++  ryte-completed    (get-plete %r)
++  left-uncompleted  (get-plete %l)
::
:: check entire preceding graph for incorrect completion order
++  check-plete-mismatch
  |=  [=id:gol dir=?(%l %r)]
  ^-  ?
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  pyt  ?-(dir %l nond, %r done)
  =/  gine  (gine eid:gol (unit ?) ?)
  =.  gine
    %=  gine
      flow  |=(=eid:gol ~(tap in (flo eid)))
      init  |=(eid:gol (some %.n))
      stop  |=([eid:gol out=(unit ?)] =(~ out))
      meld  
        |=  [eid:gol a=(unit ?) b=(unit ?)]
        ?~  a  ~
        ?~  b  ~
        (some |(u.a u.b))
      land
        |=  [=eid:gol out=(unit ?)]
        ?~  out  ~
        ?:  =(%k -.eid)
          out
        ?:  (pyt id.eid) :: %l: if I am incomplete
          (some %.y) :: %l: return that there is left-incomplete
        ?:  u.out :: %l: if I am complete and there is left-incomplete
          ~ :: fail
        (some %.n) :: %l: else return that there is no left-incomplete
      exit
        |=  [=eid:gol vis=(map eid:gol (unit ?))]
        =(~ (~(got by vis) eid)) :: if the output is null, yes, plete mismatch
    ==
  (((traverse eid:gol (unit ?) ?) gine ~) [%d id]) :: start at deadline
::
:: get uncompleted leaf goals left of id
++  harvest
  |=  =id:gol
  ^-  (set id:gol)
  =/  ginn  (ginn eid:gol (set id:gol))
  =.  ginn
    %=  ginn
      ::
      :: incomplete inflow
      flow
        |=  =eid:gol
        %+  murn
          ~(tap in (iflo eid))
        |=  =eid:gol
        ?:  complete:(~(got by goals.p) id.eid)
          ~
        (some eid)
      ::
      meld  |=([eid:gol a=(set id:gol) b=(set id:gol)] (~(uni in a) b))  :: union
      ::
      :: harvest
      land
        |=  [=eid:gol out=(set id:gol)]
        ::
        :: a completed goal has no harvest
        ?:  complete:(~(got by goals.p) id.eid)
          ~
        ::
        :: in general, the harvest of a node is the union of the
        ::   harvests of its immediate inflow
        :: a deadline with an otherwise empty harvest
        ::   returns itself as its own harvest
        ?:  &(=(~ out) =(%d -.eid))
          (~(put in *(set id:gol)) id.eid)
        out
    ==
  ::
  :: work backwards from deadline
  (((traverse eid:gol (set id:gol) (set id:gol)) ginn ~) [%d id])
::
:: harvest with full goals
++  full-harvest
  |=  =id:gol
  ^-  goals:gol
  (gat-by goals.p (hi-to-lo ~(tap in (harvest id))))
::
:: get priority of a given goal - highest priority is 0
:: priority is the number of unique goals which must be started
:: before the given goal is started
++  priority
  |=  =id:gol
  ^-  @
  =/  gine  (gine eid:gol (set id:gol) @)
  =.  gine
    %=  gine
      flow  |=(=eid:gol ~(tap in (iflo eid)))  :: inflow
      ::
      :: all inflows
      init
        |=  =eid:gol
        %-  ~(gas in *(set id:gol))
        %+  turn
          ~(tap in (iflo eid))
        |=(=eid:gol id.eid)
      ::
      meld  |=([eid:gol a=(set id:gol) b=(set id:gol)] (~(uni in a) b))  :: union
      exit
        |=  [=eid:gol vis=(map eid:gol (set id:gol))]
        ~(wyt in (~(got by vis) eid))  :: get count of priors
    ==
  ::
  :: work backwards from kickoff
  (((traverse eid:gol (set id:gol) @) gine ~) [%k id])
::
:: highest to lowest priority (highest being smallest number)
++  hi-to-lo
  |=  lst=(list id:gol)
  %+  sort  lst
  |=  [a=id:gol b=id:gol]
  (lth (priority a) (priority b))
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
:: a ~ bounded by a ~ causes no bound-mismatch
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
++  trem  :: (extremum)
  |=  cmp=$-([(unit @) (unit @)] ?)
  |=([a=(unit @) b=(unit @)] ?:((cmp a b) a b))
::
::  (goth ~ [~ @da]) returns %.n
::  (omax ~ [~ @da]) returns [~ @da]
::  (goth ~ ~) returns %.n
::  (omax ~ ~) returns ~
::  (goth [~ @da] ~) returns %.y
::  (omax [~ @da] ~) returns [~ @da]
::  (goth [~ a=@da] [~ b=@da]) returns (gth a b)
::  (omax [~ a=@da] [~ b=@da]) returns (some (max a b))
::
::  omax returns null only if both inputs are null
++  omax  (trem goth)
::
::  (loth ~ [~ @da]) returns %.n
::  (omin ~ [~ @da]) returns [~ @da]
::  (loth ~ ~) returns %.n
::  (omin ~ ~) returns ~
::  (loth [~ @da] ~) returns %.y
::  (omin [~ @da] ~) returns [~ @da]
::  (loth [~ a=@da] [~ b=@da]) returns (lth a b)
::  (omin [~ a=@da] [~ b=@da]) returns (some (min a b))
::
::  omin returns null only if both inputs are null
++  omin  (trem loth)
::
++  get-bounds
  |=  dir=?(%l %r)
  |=  [=eid:gol vis=(map eid:gol bound:gol)]
  ^-  (map eid:gol bound:gol)
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  cmp  ?-(dir %l goth, %r loth)
  =/  gine  (gine eid:gol bound:gol (map eid:gol bound:gol))
  =.  gine
    %=  gine
      flow  |=(=eid:gol ~(tap in (flo eid)))
      init  |=(=eid:gol [moment:(got-edge eid) eid])
      meld  |=([eid:gol a=bound:gol b=bound:gol] ?:((cmp -.a -.b) a b))
      exit  |=([=eid:gol vis=(map eid:gol bound:gol)] vis)
    ==
  (((traverse eid:gol bound:gol (map eid:gol bound:gol)) gine vis) eid)
::
:: get the left or right bound of a node (assumes correct moment order)
++  ryte-bound  |=(=eid:gol `bound:gol`(~(got by ((get-bounds %r) eid ~)) eid))
++  left-bound  |=(=eid:gol `bound:gol`(~(got by ((get-bounds %l) eid ~)) eid))
::
:: check entire preceding graph for incorrect moment order
++  check-bound-mismatch
  |=  [=eid:gol dir=?(%l %r)]
  ^-  ?
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  tem  ?-(dir %l omax, %r omin)  :: extremum
  =/  gine  (gine eid:gol (unit moment:gol) ?)
  =.  gine
    %=  gine
      flow  |=(=eid:gol ~(tap in (flo eid)))
      init  |=(=eid:gol (some ~))
      stop  |=([eid:gol out=(unit moment:gol)] =(~ out))  :: stop if null
      meld
        |=  [eid:gol out=(unit moment:gol) new=(unit moment:gol)]
        ?~  out  ~
        ?~  new  ~
        (some (tem u.out u.new))
      land
        |=  [eid:gol out=(unit moment:gol)]
        ?~  out  ~
        =/  mot  moment:(got-edge eid)
        ?~  mot  out :: if moment is null, pass along bound
        =/  tem  (tem mot u.out)
        ?.  =(mot tem)
          ~ :: if moment is not extremum, fail (return null)
        (some tem) :: else return new bound
      exit
        |=  [=eid:gol vis=(map eid:gol (unit moment:gol))]
        =(~ (~(got by vis) eid)) :: if the output is null, yes, bound mismatch
    ==
  (((traverse eid:gol (unit moment:gol) ?) gine ~) eid) :: start at deadline
::
:: length of longest path to root or leaf
++  plomb
  |=  dir=?(%l %r)
  |=  [=eid:gol vis=(map eid:gol @)]
  ^-  (map eid:gol @)
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  gine  (gine eid:gol @ (map eid:gol @))
  =.  gine
    %=  gine
      flow  |=(=eid:gol ~(tap in (flo eid)))
      meld  |=([eid:gol a=@ b=@] (max a b))
      land  |=([eid:gol out=@] +(out))
      exit  |=([=eid:gol vis=(map eid:gol @)] vis)
    ==
  (((traverse eid:gol @ (map eid:gol @)) gine vis) eid)
::
++  ryte-plumb  |=(=eid:gol `@`(~(got by ((plomb %r) eid ~)) eid)) :: to root
++  left-plumb  |=(=eid:gol `@`(~(got by ((plomb %l) eid ~)) eid)) :: to leaf
::
:: get depth of a given goal (lowest level is depth of 1)
:: this is mostly for printing accurate level information in the CLI
++  plumb
  |=  =id:gol
  ^-  @
  =/  ginn  (ginn eid:gol @)
  =.  ginn
    %=  ginn
      flow  |=(=eid:gol ~(tap in (yong eid)))
      init  |=(=eid:gol 1)
      meld  |=([eid:gol a=@ b=@] (max a b))
      land  |=([eid:gol out=@] +(out))
    ==
  (((traverse eid:gol @ @) ginn ~) [%d id])
::
++  get-stocks
  |=  [=id:gol vis=(map id:gol stock:gol)]
  ^-  (map id:gol stock:gol)
  =/  gaso  [id:gol stock:gol (map id:gol stock:gol)]
  =/  gine  (gine gaso)
  =.  gine
    %=  gine
      flow  |=(=id:gol =/(par par:(~(got by goals.p) id) ?~(par ~ [u.par]~)))
      land  |=([=id:gol =stock:gol] [[id chief:(~(got by goals.p) id)] stock])
      exit  |=([=id:gol vis=(map id:gol stock:gol)] vis)
    ==
  (((traverse gaso) gine vis) id)
::
:: all nodes left or right of a given node including self
++  to-ends
  |=  [=eid:gol dir=?(%l %r)]
  ^-  (set eid:gol)
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  ginn  (ginn eid:gol (set eid:gol))
  =.  ginn
    %=  ginn
      flow  |=(=eid:gol ~(tap in (flo eid)))
      init  |=(=eid:gol (~(put in *(set eid:gol)) eid))
      meld  |=([eid:gol a=(set eid:gol) b=(set eid:gol)] (~(uni in a) b)) :: union
    ==
  (((traverse eid:gol (set eid:gol) (set eid:gol)) ginn ~) eid)
::
:: all descendents including self
++  progeny
  |=  =id:gol
  ^-  (set id:gol)
  =/  ginn  (ginn id:gol (set id:gol))
  =.  ginn
    %=  ginn
      flow  |=(=id:gol ~(tap in kids:(~(got by goals.p) id)))
      init  |=(=id:gol (~(put in *(set id:gol)) id))
      meld  |=([id:gol a=(set id:gol) b=(set id:gol)] (~(uni in a) b)) :: union
    ==
  (((traverse id:gol (set id:gol) (set id:gol)) ginn ~) id)
::
:: TODO: convert to gine
:: replace each chief in a kick set with the nearest non-kick superior
++  replace-chiefs
  |=  kick=(set ship)
  ^-  [ids=(set id:gol) pore=_this]
  |^
  =|  ids=(set id:gol)
  =/  pore  this
  :: 
  ::  start with parentless goals
  =/  waifs  (waif-goals)
  |-
  ?~  waifs
    [ids pore]
  =/  mup  (replace-chief i.waifs kick)
  %=  $
    waifs  t.waifs
    ids  (~(uni in ids) ids.mup)
    pore  pore(goals.p goals.mup)
  ==
  ++  replace-chief
    |=  [=id:gol kick=(set ship)]
    ^-  [ids=(set id:gol) =goals:gol]
    =/  goal  (~(got by goals.p) id)
    ::
    :: if the goal's chief is in kick, replace it
    :: if it has a par, replace with parent's chief
    :: if it has no par, replace with owner
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
    :: return either self or null depending on if changed
    =/  ids=(set id:gol)
      ?:  (~(has in kick) chief.goal)
        ~
      (~(put in *(set id:gol)) id)
    ::
    =/  kids  ~(tap in kids.goal)
    |-
    ?~  kids
      [ids goals.p]
    =/  mup  (replace-chief i.kids kick)
    %=  $
      kids  t.kids
      ids  (~(uni in ids) ids.mup)
      goals.p  goals.mup
    ==
  --
::
:: ============================================================================
:: 
:: INFLATE GOAL (UPDATE WITH REDUNDANT INFORMATION)
::
:: ============================================================================
::
++  stocks  ((chain id:gol stock:gol) get-stocks (bare-goals) ~)
++  left-bounds  ((chain eid:gol bound:gol) (get-bounds %l) (root-nodes) ~)
++  ryte-bounds  ((chain eid:gol bound:gol) (get-bounds %r) (leaf-nodes) ~)
++  ryte-plumbs  ((chain eid:gol @) (plomb %r) (leaf-nodes) ~)
++  left-plumbs  ((chain eid:gol @) (plomb %l) (root-nodes) ~)
::
+$  tracer
  $%  [%init ~]
      [%yoke e1=eid:gol e2=eid:gol]
      [%spawn =id:gol]
      [%chief =id:gol]
  ==
::
++  trace-update
  |=  =tracer
  ^-  trace:gol
  =,  tracer
  ?-    -.tracer
      %init
    :*  stocks
        left-bounds
        ryte-bounds
        left-plumbs
        ryte-plumbs
    ==
    ::
      %yoke
    :*  stocks.trace.p  :: change stocks elsewhere
        ::
        :: left-bounds
        %:  (chain eid:gol bound:gol)
          (get-bounds %l)
          (root-nodes)
          (gus-by left-bounds.trace.p ~(tap in (to-ends e2 %r)))
        ==
        ::
        :: ryte-bounds
        %:  (chain eid:gol bound:gol)
          (get-bounds %r)
          (leaf-nodes)
          (gus-by ryte-bounds.trace.p ~(tap in (to-ends e1 %l)))
        ==
        ::
        :: left-plumbs
        %:  (chain eid:gol @)
          (plomb %l)
          (root-nodes)
          (gus-by left-plumbs.trace.p ~(tap in (to-ends e2 %r)))
        ==
        ::
        :: ryte-plumbs
        %:  (chain eid:gol @)
          (plomb %r)
          (leaf-nodes)
          (gus-by ryte-plumbs.trace.p ~(tap in (to-ends e1 %l)))
        ==
    == 
    ::
      %spawn
    :*  (get-stocks id stocks.trace.p)
        ((get-bounds %l) [%d id] left-bounds.trace.p)
        ((get-bounds %r) [%k id] ryte-bounds.trace.p)
        ((plomb %l) [%d id] ryte-plumbs.trace.p)
        ((plomb %r) [%k id] ryte-plumbs.trace.p)
    ==
    ::
      %chief
    :*  %:  (chain id:gol stock:gol)
          get-stocks
          (bare-goals)
          (gus-by stocks.trace.p ~(tap in (progeny id)))
        ==
        left-bounds
        ryte-bounds
        left-plumbs
        ryte-plumbs
    ==
  ==
:: 
:: kid - include if kid, yes or no?
:: par - include if par, yes or no?
:: dir - leftward or rightward
:: src - starting in kickoff or deadline
:: dst - ending in kickoff or deadline
++  neighbors
  |=  [=id:gol kid=? par=? dir=?(%l %r) src=?(%k %d) dst=?(%k %d)]
  ^-  (set id:gol)
  =/  flow  ?-(dir %l (iflo [src id]), %r (oflo [src id]))
  =/  goal  (~(got by goals.p) id)
  %-  ~(gas in *(set id:gol))
  %+  murn
    ~(tap in flow)
  |=  =eid:gol
  ?.  ?&  =(dst -.eid) :: we keep when destination is as specified
          |(kid !(~(has in kids.goal) id.eid)) :: if k false, must not be in kids
          |(par !?~(par.goal %| =(id.eid u.par.goal))) :: if p is false, must not be par
      ==
    ~
  (some id.eid)
::  
++  prio-left  |=(=id:gol (neighbors id %& %| %l %k %k))
++  prio-ryte  |=(=id:gol (neighbors id %| %& %r %k %k))
++  prec-left  |=(=id:gol (neighbors id %& %& %l %k %d))
++  prec-ryte  |=(=id:gol (neighbors id %& %& %r %d %k))
++  nest-left  |=(=id:gol (neighbors id %| %& %l %d %d))
++  nest-ryte  |=(=id:gol (neighbors id %& %| %r %d %d))
::
++  get-ranks
  |=  =stock:gol
  ^-  ranks:gol
  =|  =ranks:gol
  |-
  ?~  stock
    ranks
  %=  $
    stock  t.stock
    ranks  (~(put by ranks) [chief id]:i.stock)
  ==
::
++  inflate-goal
  |=  =id:gol
  =/  goal  (~(got by goals.p) id)
  %=  goal
    stock  (~(got by stocks.trace.p) id)
    ranks  (get-ranks (~(got by stocks.trace.p) id))
    prio-left  (prio-left id)
    prio-ryte  (prio-ryte id)
    prec-left  (prec-left id)
    prec-ryte  (prec-ryte id)
    nest-left  (nest-left id)
    nest-ryte  (nest-ryte id)
    left-bound.kickoff  (~(got by left-bounds.trace.p) [%k id]) 
    ryte-bound.kickoff  (~(got by ryte-bounds.trace.p) [%k id]) 
    left-plumb.kickoff  (~(got by left-plumbs.trace.p) [%k id]) 
    ryte-plumb.kickoff  (~(got by ryte-plumbs.trace.p) [%k id]) 
    left-bound.deadline  (~(got by left-bounds.trace.p) [%d id]) 
    ryte-bound.deadline  (~(got by ryte-bounds.trace.p) [%d id]) 
    left-plumb.deadline  (~(got by left-plumbs.trace.p) [%d id]) 
    ryte-plumb.deadline  (~(got by ryte-plumbs.trace.p) [%d id]) 
  ==
::
++  inflate-goals
  |=  ids=(set id:gol)
  ^-  goals:gol
  %-  ~(gas by goals.p)
  %+  turn
    ~(tap in ids)
  |=(=id:gol [id (inflate-goal id)])
::
:: ** jellyfish-like motion **
:: update ryte-bounds/plumbs left of e1
:: update left-bounds/plumbs right of e2
++  jellyfish
  |=  [e1=eid:gol e2=eid:gol]
  ^-  [ids=(set id:gol) pore=_this]
  =/  eids  (~(uni in (to-ends e1 %l)) (to-ends e2 %r))
  =/  ids   (~(run in eids) |=(=eid:gol id.eid))
  =.  trace.p  (trace-update [%yoke e1 e2])
  =.  goals.p  (inflate-goals ids)
  [ids this]
::
:: reset all the stocks of all goals below and including specified goal
++  avalanche
  |=  =id:gol
  ^-  [ids=(set id:gol) pore=_this]
  =/  ids  (progeny id)
  =.  trace.p  (trace-update [%chief id])
  =.  goals.p  (inflate-goals ids)
  [ids this]
::
:: ============================================================================
:: 
:: PERMISSIONS UTILITIES
::
:: ============================================================================
::
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
:: checks if mod can move lid under urid
++  check-move-perm
  |=  [lid=id:gol urid=(unit id:gol) mod=ship]
  ^-  ?
  ?:  (check-pool-perm mod)  %&
  :: can only move to root with admin-level pool permissions
  ?~  urid  %|
  :: can move lid under u.urid if you have permissions on a goal
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
:: checks if mod can modify ship's pool permissions
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
:: set the chief of a goal or optionally all its subgoals
++  set-chief
  |=  [=id:gol chief=ship rec=?(%.y %.n)]
  ^-  [ids=(set id:gol) pore=_this]
  =/  ids=(set id:gol)  
    ?.  rec
      (progeny id)
    (~(put in *(set id:gol)) id)
  =/  lst  ~(tap in ids)
  :-  ids
  %=  this
    goals.p
      %-  ~(gas by goals.p)
      %+  turn
        lst
      |=  =id:gol
      =/  goal  (~(got by goals.p) id)
      [id goal(chief chief)]
  ==
::
:: remove a kick set from all goal spawn sets
++  purge-spawn
  |=  kick=(set ship)
  ^-  [ids=(set id:gol) pore=_this]
  =|  ids=(set id:gol)
  =/  goals  ~(tap by goals.p)
  |-
  ?~  goals
    [ids this]
  =+  `[=id:gol =goal:gol]`i.goals
  %=  $
    goals  t.goals
    ids  (~(put in ids) id)
    goals.p  (~(put by goals.p) id goal(spawn (~(dif in spawn.goal) kick)))
  ==
::
:: convert a new pool perms map to a list of updates
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
:: convert a new pool perms map to a list of ships to remove or invite
++  pool-diff
  |=  new=pool-perms:gol
  ^-  [remove=(list ship) invite=(list ship)]
  =/  remove  ~(tap in (~(dif in ~(key by perms.p)) ~(key by new)))
  =/  invite  ~(tap in (~(dif in ~(key by new)) ~(key by perms.p)))
  [remove invite]
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
  :: Cannot create relationship where either goal is complete
  :: and an uncompleted goal is to the left
  ?:  ?|  complete:(~(got by goals.p) id.e1)
          complete:(~(got by goals.p) id.e2)
      ==
    ~|("completed-goal" !!)
  ::
  :: Cannot create relationship with the deadline of the right id
  :: if the right id is an actionable goal
  ?:  ?&  =(-.e2 %d)
          actionable:(~(got by goals.p) id.e2)
      ==
    ~|("right-actionable" !!)
  ::
  :: e2 must not come before e1
  ?:  (check-path e2 e1 %r)  ~|("before-e2-e1" !!)
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
  (jellyfish e1 e2)
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
  :: Cannot break relationship between completed goals
  ?:  ?&  complete:(~(got by goals.p) id.e1)
          complete:(~(got by goals.p) id.e2)
      ==
    ~|("completed-goals" !!)
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
  (jellyfish e1 e2)
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
  [ids.mup pore.mup]
::
++  yoke-sequence
  |=  [yoks=(list exposed-yoke:gol) mod=ship]
  ^-  [ids=(set id:gol) pore=_this]
  =/  old  this
  =/  idx  0
  =|  ids=(set id:gol)
  =/  pore  this
  |-
  ?:  =(idx (lent yoks))
    [ids pore]
  =/  mup  (yoke:pore (snag idx yoks) mod)
  %=  $
    idx   +(idx)
    ids   (~(uni in ids) ids.mup)
    pore  pore.mup
  ==
::
:: perform several simultaneous rends
++  nuke
  |=  [=nuke:gol mod=ship]
  ^-  [ids=(set id:gol) pore=_this]
  =/  goal  (~(got by goals.p) id.nuke)
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
      ~(tap in prio-left.goal)
    |=  =id:gol
    ^-  exposed-yoke:gol
    [%prio-rend id id.nuke]
  ::
  ++  prio-ryte
    %+  turn
      ~(tap in prio-ryte.goal)
    |=  =id:gol
    ^-  exposed-yoke:gol
    [%prio-rend id.nuke id]
  ::
  ++  prec-left
    %+  turn
      ~(tap in prec-left.goal)
    |=  =id:gol
    ^-  exposed-yoke:gol
    [%prec-rend id id.nuke]
  ::
  ++  prec-ryte
    %+  turn
      ~(tap in prec-ryte.goal)
    |=  =id:gol
    ^-  exposed-yoke:gol
    [%prec-rend id.nuke id]
  ::
  ++  nest-left
    %+  turn
      ~(tap in nest-left.goal)
    |=  =id:gol
    ^-  exposed-yoke:gol
    [%nest-rend id id.nuke]
  ::
  ++  nest-ryte
    %+  turn
      ~(tap in nest-ryte.goal)
    |=  =id:gol
    ^-  exposed-yoke:gol
    [%nest-rend id.nuke id]
  --
::
:: composite yokes
++  plex
  |=  [=plex:gol mod=ship]
  ^-  [ids=(set id:gol) pore=_this]
  =/  old  this
  =,  plex
  =/  mup=[ids=(set id:gol) pore=_this]
    ?-    plex
        exposed-yoke:gol
      (yoke plex mod)
        nuke:gol
      (nuke plex mod)
    ==
  [ids.mup pore.mup]
::
:: sequence of composite yokes
++  plex-sequence
  |=  [plez=(list plex:gol) mod=ship]
  ^-  _this
  =/  old  this
  =/  idx  0
  =|  ids=(set id:gol)
  =/  pore  this
  |-
  ?:  =(idx (lent plez))
    (emot old [vzn %pool-nexus %yoke (make-nex ids)]):[pore .]
  =/  mup  (plex:pore (snag idx plez) mod)
  %=  $
    idx   +(idx)
    ids   (~(uni in ids) ids.mup)
    pore  pore.mup
  ==
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
      (~(put in *(set id:gol)) lid)
    (~(gas in *(set id:gol)) ~[lid u.par.l])
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
:: ============================================================================
:: 
:: COMPLETE/ACTIONABLE/KICKOFF/DEADLINE/PERMS UPDATES
::
:: ============================================================================
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
  =/  mup  (jellyfish [%k id] [%k id])
  (emot old [vzn %goal-dates (make-nex ids.mup)]):[pore.mup .]
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
  =/  mup  (jellyfish [%d id] [%d id])
  (emot old [vzn %goal-dates (make-nex ids.mup)]):[pore.mup .]
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
  =/  mup  (set-chief id chief rec)
  =/  myp  (avalanche:pore.mup id)
  ::
  =/  ids  (~(uni in ids.mup) ids.myp)
  (emot old [vzn %goal-perms (make-nex ids)]):[pore.myp .]
::
:: ============================================================================
:: 
:: HITCH UPDATES
::
:: ============================================================================
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
:: ============================================================================
:: 
:: ETCH CHANGES
::
:: ============================================================================
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
    :: goal-dates
    ::
      [%goal-dates *]
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
