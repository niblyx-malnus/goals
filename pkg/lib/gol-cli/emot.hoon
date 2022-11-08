/-  gol=goal
/+  *gol-cli-util, gol-cli-pool, gol-cli-node, gol-cli-traverse
=|  efx=(list update:gol)
|_  p=pool:gol
+*  this  .
    tv    ~(. gol-cli-traverse goals.p)
    nd    ~(. gol-cli-node goals.p)
++  vzn   %4
++  pore  |.(~(. gol-cli-pool p))
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
  =.  old  old(trace.p trace.p)
  ?.  =(p.this p:(etch:old upd))
    ~|("non-equivalent-update" !!)
  (emit upd)
::
:: emit a list of effects after checking at each step that
:: apply the update yields an equivalent state
++  emol
  |=  [ets=_this upz=(list update:gol)]
  ^+  this
  ?~  upz
    =.  ets  ets(trace.p trace.p)
    ?:  =(p.this p.ets)
      this
    ~|("non-equivalent-update" !!)
  $(upz t.upz, ets (etch:ets i.upz), this (emit i.upz))
::
:: ============================================================================
:: 
:: MANAGE UPDATES WITH NEX/NEXUS
::
:: ============================================================================
::
++  diff
  |=  [a=goals:gol b=goals:gol]
  ^-  [lus=(set id:gol) hep=(set id:gol) sig=(set id:gol)]
  =/  lus  (~(dif in ~(key by b)) ~(key by a))
  =/  hep  (~(dif in ~(key by a)) ~(key by b))
  =/  int  (~(int in ~(key by a)) ~(key by b))
  =/  sig
    %-  ~(gas in *(set id:gol))
    %+  murn
      ~(tap in int)
    |=  =id:gol
    ?:  =((~(got by a) id) (~(got by b) id))
      ~
    (some id)
  [lus hep sig]
::
++  full-diff
  |=  [a=goals:gol b=goals:gol]
  ^-  [pon=goals:gol waz=goals:gol =nex:gol]
  =+  (diff a b)
  =/  pon  (gat-by b ~(tap in lus))
  =/  waz  (gat-by a ~(tap in hep))
  =/  nex  (make-nex b sig)
  [pon waz nex]
::
++  collapse-cache
  |=  cache=(map id:gol goals:gol)
  ^-  goals:gol
  =|  =goals:gol
  =/  ids  ~(tap in ~(key by cache))
  |-
  ?~  ids
    goals
  $(ids t.ids, goals (~(uni by goals) (~(got by cache) i.ids)))
::
:: a is a map from ids to a goal nexus
:: it contains crucial information regarding graph structure
:: it is easier to stay sane by sending updates in this manner
++  make-nex
  |=  [=goals:gol ids=(set id:gol)]
  ^-  nex:gol
  =|  =nex:gol
  %-  ~(gas by nex)
  %+  turn  ~(tap in ids)
  |=  =id:gol
  [id nexus:`ngoal:gol`(~(got by goals) id)]
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
    stock-map  (~(put by stock-map.trace.p) id stock.nus)
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
:: GOAL INFLATION (UPDATE WITH REDUNDANT INFORMATION)
::
:: ============================================================================
::
:: all of these should be O(nlogn) with size of the goals map
:: if it starts taking real performance hits we can revisit this...
++  trace-update
  |.
  ^-  trace:gol
  :*  stock-map=((chain:tv id:gol stock:gol) get-stocks:tv (bare-goals:nd) ~)
      ^=  left-bounds
        ((chain:tv nid:gol moment:gol) (get-bounds:tv %l) (root-nodes:nd) ~)
      ^=  ryte-bounds
        ((chain:tv nid:gol moment:gol) (get-bounds:tv %r) (leaf-nodes:nd) ~)
      left-plumbs=((chain:tv nid:gol @) (plomb:tv %l) (root-nodes:nd) ~)
      ryte-plumbs=((chain:tv nid:gol @) (plomb:tv %r) (leaf-nodes:nd) ~)
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
  =/  flow  ?-(dir %l (iflo:nd [src id]), %r (oflo:nd [src id]))
  =/  goal  (~(got by goals.p) id)
  %-  ~(gas in *(set id:gol))
  %+  murn
    ~(tap in flow)
  |=  =nid:gol
  ?.  ?&  =(dst -.nid) :: we keep when destination is as specified
          |(kid !(~(has in kids.goal) id.nid)) :: if k false, must not be in kids
          |(par !?~(par.goal %| =(id.nid u.par.goal))) :: if p is false, must not be par
      ==
    ~
  (some id.nid)
::  
++  prio-left  |=(=id:gol (neighbors id %& %| %l %k %k))
++  prio-ryte  |=(=id:gol (neighbors id %| %& %r %k %k))
++  prec-left  |=(=id:gol (neighbors id %& %& %l %k %d))
++  prec-ryte  |=(=id:gol (neighbors id %& %& %r %d %k))
++  nest-left  |=(=id:gol (neighbors id %| %& %l %d %d))
++  nest-ryte  |=(=id:gol (neighbors id %& %| %r %d %d))
::
++  inflate-goal
  |=  =id:gol
  ^-  goal:gol
  =/  goal  (~(got by goals.p) id)
  %=  goal
    stock  (~(got by stock-map.trace.p) id)
    ranks  (get-ranks:tv (~(got by stock-map.trace.p) id))
    prio-left  (prio-left id)
    prio-ryte  (prio-ryte id)
    prec-left  (prec-left id)
    prec-ryte  (prec-ryte id)
    nest-left  (nest-left id)
    nest-ryte  (nest-ryte id)
    left-bound.kickoff  (left-bound:tv [%k id]) 
    ryte-bound.kickoff  (ryte-bound:tv [%k id]) 
    left-plumb.kickoff  (left-plumb:tv [%k id]) 
    ryte-plumb.kickoff  (ryte-plumb:tv [%k id]) 
    left-bound.deadline  (left-bound:tv [%d id]) 
    ryte-bound.deadline  (ryte-bound:tv [%d id]) 
    left-plumb.deadline  (left-plumb:tv [%d id]) 
    ryte-plumb.deadline  (ryte-plumb:tv [%d id]) 
  ==
::
++  inflate-goals
  |.
  ^-  _this
  =.  trace.p  (trace-update)
  =.  goals.p
        %-  ~(gas by goals.p)
        %+  turn
          ~(tap in ~(key by goals.p))
        |=(=id:gol [id (inflate-goal id)])
  this
::
++  apply
  |*  [func=$-(* _(pore)) parm=*]
  ^-  _this
  =.  p  p:(func parm)
  (inflate-goals)
::
:: ============================================================================
:: 
:: UPDATES
::
:: ============================================================================
::
:: Move goal and subgoals from main goals to cache
++  cache-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  tore  (apply cache-goal:(pore) id mod)
  ::
  =/  coals  (collapse-cache cache.p.tore)
  =/  gdiff  (full-diff goals.p goals.p.tore)
  =/  cdiff  (full-diff goals.p coals)
  =/  nex  (~(uni by nex.gdiff) nex.cdiff)
  ::
  (emot:tore this [vzn %cache-goal nex id ~(key by waz.gdiff)])
::
:: Restore goal from cache to main goals
++  renew-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  tore  (apply renew-goal:(pore) id mod)
  =/  fd  (full-diff goals.p goals.p.tore)
  (emot:tore this [vzn %renew-goal id pon.fd])
::
:: Permanently delete goal
++  trash-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  ?:  (~(has by goals.p) id)
    =/  tore  (apply waste-goal:(pore) id mod)
    =/  fd  (full-diff goals.p goals.p.tore)
    (emot:tore this [vzn %waste-goal nex.fd id ~(key by waz.fd)])
  =/  tore  (apply trash-goal:(pore) id mod)
  =/  old-coals  (collapse-cache cache.p)
  =/  new-coals  (collapse-cache cache.p.tore)
  =/  diff  (diff old-coals new-coals)
  (emot:tore this [vzn %trash-goal id hep.diff])
::
++  move
  |=  [lid=id:gol urid=(unit id:gol) mod=ship]
  ^-  _this
  =/  tore  (apply move:(pore) lid urid mod)
  =/  fd  (full-diff goals.p goals.p.tore)
  (emot:tore this [vzn %pool-nexus %yoke nex.fd])
::
:: sequence of composite yokes
++  plex-sequence
  |=  [plez=(list plex:gol) mod=ship]
  ^-  _this
  =/  tore  (apply plex-sequence:(pore) plez mod)
  =/  fd  (full-diff goals.p goals.p.tore)
  (emot:tore this [vzn %pool-nexus %yoke nex.fd])
::
++  mark-actionable
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  tore  (apply mark-actionable:(pore) id mod)
  (emot:tore this [vzn %goal-togls id %actionable %.y])
::
++  mark-complete
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  tore  (apply mark-complete:(pore) id mod)
  (emot:tore this [vzn %goal-togls id %complete %.y])
::
++  unmark-actionable
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  tore  (apply unmark-actionable:(pore) id mod)
  (emot:tore this [vzn %goal-togls id %actionable %.n])
::
++  unmark-complete
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  tore  (apply unmark-complete:(pore) id mod)
  (emot:tore this [vzn %goal-togls id %complete %.n])
::
++  set-kickoff
  |=  [=id:gol =moment:gol mod=ship]
  ^-  _this
  =/  tore  (apply set-kickoff:(pore) id moment mod)
  =/  fd  (full-diff goals.p goals.p.tore)
  (emot:tore this [vzn %goal-dates nex.fd])
::
++  set-deadline
  |=  [=id:gol =moment:gol mod=ship]
  ^-  _this
  =/  tore  (apply set-deadline:(pore) id moment mod)
  =/  fd  (full-diff goals.p goals.p.tore)
  (emot:tore this [vzn %goal-dates nex.fd])
::
++  update-pool-perms
  |=  [new=pool-perms:gol mod=ship]
  ^-  _this
  =/  tore  (apply update-pool-perms:(pore) new mod)
  =/  fd  (full-diff goals.p goals.p.tore)
  (emot:tore this [vzn %pool-perms nex.fd perms.p.tore])
::
++  update-goal-perms
  |=  [=id:gol chief=ship rec=?(%.y %.n) spawn=(set ship) mod=ship]
  ^-  _this
  =/  tore  (apply update-goal-perms:(pore) id chief rec spawn mod)
  =/  fd  (full-diff goals.p goals.p.tore)
  (emot:tore this [vzn %goal-perms nex.fd])
::
++  edit-goal-desc
  |=  [=id:gol desc=@t mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-goal-edit-perm:(pore) id mod)
  =/  goal  (~(got by goals.p) id)
  =.  goals.p  (~(put by goals.p) id goal(desc desc))
  (emot old [vzn %goal-hitch id %desc desc])
:: 
++  edit-pool-title
  |=  [title=@t mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-pool-edit-perm:(pore) mod)
  =.  p  p(title title)
  (emot old [vzn %pool-hitch %title title])
::
:: wit all da fixin's
++  spawn-goal-fixns
  |=  [=id:gol upid=(unit id:gol) desc=@t actionable=?(%.y %.n) mod=ship]
  ^-  _this
  =/  old  this
  =/  tore  (apply spawn-goal:(pore) id upid mod)
  =.  tore
    ?:  actionable
      (apply:tore mark-actionable:(pore.tore) id mod)
    (apply:tore unmark-actionable:(pore.tore) id mod)
  =.  tore  (edit-goal-desc:tore id desc mod)
  =/  fd  (full-diff goals.p goals.p.tore)
  =/  goal  (~(got by goals.p.tore) id)
  (emot:tore(efx efx) old [vzn %spawn-goal nex.fd id goal])
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
