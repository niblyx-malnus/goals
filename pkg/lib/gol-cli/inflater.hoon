/-  gol=goal
/+  gol-cli-node, gol-cli-traverse
|%
::
:: ============================================================================
:: 
:: GOAL INFLATION
:: PRECOMPUTE USEFUL IMPLICIT DATA
::
:: ============================================================================
::
:: all of these should be O(nlogn) with size of the goals map
:: if it starts taking real performance hits we can revisit this...
++  inflate-pool
  |=  p=pool:gol
  ^-  pool:gol
  =.  p  (trace-update p)
  (inflate-goals p)
::
++  trace-update
  |=  p=pool:gol
  ^-  pool:gol
  :: can be waif-goals or root-goals, it's a matter of taste really
  ::
  =/  goals-roots  (~(waif-goals gol-cli-node goals.p))
  =/  cache-roots  (~(waif-goals gol-cli-node cache.p))
  ::
  :: make sure tracing both goals and cache
  =/  coals  (~(uni by goals.p) cache.p)
  ::
  =/  tv  ~(. gol-cli-traverse coals)
  =/  nd  ~(. gol-cli-node coals)
  ::
  =/  d-k-precs  (precedents-map:tv %d %k)
  =/  k-k-precs  (precedents-map:tv %k %k)
  =/  d-d-precs  (precedents-map:tv %d %d)
  ::
  %=    p
      trace
    :*  stock-map=((chain:tv id:gol stock:gol) get-stocks:tv (bare-goals:nd) ~)
        roots=(fix-list:tv roots.trace.p (sy goals-roots))
        roots-by-precedence=(fix-list-and-sort:tv %p d-k-precs roots.trace.p (sy goals-roots))
        roots-by-kickoff=(fix-list-and-sort:tv %k k-k-precs roots.trace.p (sy goals-roots))
        roots-by-deadline=(fix-list-and-sort:tv %d d-d-precs roots.trace.p (sy goals-roots))
        cache-roots=(fix-list:tv cache-roots.trace.p (sy cache-roots))
        cache-roots-by-precedence=(fix-list-and-sort:tv %p d-k-precs cache-roots.trace.p (sy cache-roots))
        cache-roots-by-kickoff=(fix-list-and-sort:tv %k k-k-precs cache-roots.trace.p (sy cache-roots))
        cache-roots-by-deadline=(fix-list-and-sort:tv %d d-d-precs cache-roots.trace.p (sy cache-roots))
        d-k-precs
        k-k-precs
        d-d-precs
        left-bounds=((chain:tv nid:gol moment:gol) (get-bounds:tv %l) (root-nodes:nd) ~)
        ryte-bounds=((chain:tv nid:gol moment:gol) (get-bounds:tv %r) (leaf-nodes:nd) ~)
        left-plumbs=((chain:tv nid:gol @) (plomb:tv %l) (root-nodes:nd) ~)
        ryte-plumbs=((chain:tv nid:gol @) (plomb:tv %r) (leaf-nodes:nd) ~)
    ==
  ==
::
++  inflate-goals
  |=  p=pool:gol
  |^  ^-  pool:gol
  %=  p
    goals  (~(rut by goals.p) inflate-goal)
    cache  (~(rut by cache.p) inflate-goal)
  ==
  ::
  ++  coals  (~(uni by goals.p) cache.p)
  ++  tv  ~(. gol-cli-traverse coals)
  ++  nd  ~(. gol-cli-node coals)
  ++  progress
    |=  =id:gol
    ^-  [complete=@ total=@]
    =/  prog=(list id:gol)  ~(tap in (progeny:tv id))
    =/  able=(list id:gol)
      %+  murn  prog
      |=(=id:gol ?.(actionable:(~(got by coals) id) ~ (some id)))
    =/  comp=(list id:gol)
      %+  murn  able
      |=(=id:gol ?.(complete:(~(got by coals) id) ~ (some id)))
    [(lent comp) (lent able)]
  ::
  ++  inflate-goal
    |=  [=id:gol =goal:gol]
    ^-  goal:gol
    %=  goal
      stock                (~(got by stock-map.trace.p) id)
      ranks                (get-ranks:tv (~(got by stock-map.trace.p) id))
      young                (en-virt goal (fix-list:tv (de-virt young.goal) (young:nd id)))
      young-by-precedence  (en-virt goal (fix-list-and-sort:tv %p d-k-precs.trace.p (de-virt young.goal) (young:nd id)))
      young-by-kickoff     (en-virt goal (fix-list-and-sort:tv %k k-k-precs.trace.p (de-virt young.goal) (young:nd id)))
      young-by-deadline    (en-virt goal (fix-list-and-sort:tv %d d-d-precs.trace.p (de-virt young.goal) (young:nd id)))
      progress             (progress id)
      prio-left            (prio-left:nd id)
      prio-ryte            (prio-ryte:nd id)
      prec-left            (prec-left:nd id)
      prec-ryte            (prec-ryte:nd id)
      nest-left            (nest-left:nd id)
      nest-ryte            (nest-ryte:nd id)
      left-bound.kickoff   (~(got by left-bounds.trace.p) [%k id])
      ryte-bound.kickoff   (~(got by ryte-bounds.trace.p) [%k id]) 
      left-plumb.kickoff   (~(got by left-plumbs.trace.p) [%k id]) 
      ryte-plumb.kickoff   (~(got by ryte-plumbs.trace.p) [%k id]) 
      left-bound.deadline  (~(got by left-bounds.trace.p) [%d id]) 
      ryte-bound.deadline  (~(got by ryte-bounds.trace.p) [%d id]) 
      left-plumb.deadline  (~(got by left-plumbs.trace.p) [%d id]) 
      ryte-plumb.deadline  (~(got by ryte-plumbs.trace.p) [%d id]) 
    ==
  --
::
++  en-virt
  |=  [par=goal:gol ids=(list id:gol)]
  ^-  (list [id:gol virtual=?])
  %+  turn  ids
  |=  =id:gol
  [id !(~(has in kids.par) id)]
::
++  de-virt
  |=  ids=(list [id:gol virtual=?])
  ^-  (list id:gol)
  (turn ids |=([=id:gol ?] id))
--
