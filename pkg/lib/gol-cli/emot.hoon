/-  gol=goal
/+  *gol-cli-util, gol-cli-pool, gol-cli-node, gol-cli-traverse,
:: import during development to force compilation
::
    gol-cli-json
::
=|  efx=(list update:gol)
|_  p=pool:gol
+*  this  .
    tv    ~(. gol-cli-traverse goals.p)
    nd    ~(. gol-cli-node goals.p)
    vzn   vzn:gol
::
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
  =/  pon  (gat-by b ~(tap in lus)) :: spawned
  =/  waz  (gat-by a ~(tap in hep)) :: wasted
  =/  nex  (make-nex b sig) :: changed
  [pon waz nex]
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
  [id [nexus trace]:`ngoal:gol`(~(got by goals) id)]
::
++  apply-nex
  |=  =nex:gol
  ^-  _this
    %=  this
      goals.p
        %-  ~(gas by goals.p)
        %+  turn  ~(tap by nex)
        |=  [=id:gol =nux:gol]
        ^-  [id:gol goal:gol]
        =/  =ngoal:gol  (~(got by goals.p) id)
        [id ngoal(nexus -.nux, trace +.nux)]
      trace.p
        =/  nex  ~(tap by nex)
        |-
        ?~  nex
          trace.p
        %=  $
          nex  t.nex
          trace.p  (nex-trace-update -.i.nex +.i.nex)
        ==
    ==
::
++  nex-trace-update
  |=  [=id:gol nus=goal-nexus:gol tar=goal-trace:gol]
  ^-  pool-trace:gol
  %=  trace.p
    stock-map  (~(put by stock-map.trace.p) id stock.tar)
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
  ::
  :: make sure tracing both goals and cache
  =.  goals.p  (~(uni by goals.p) cache.p)
  ::
  ^-  pool-trace:gol
  :*  stock-map=((chain:tv id:gol stock:gol) get-stocks:tv (bare-goals:nd) ~)
      ^=  left-bounds
        ((chain:tv nid:gol moment:gol) (get-bounds:tv %l) (root-nodes:nd) ~)
      ^=  ryte-bounds
        ((chain:tv nid:gol moment:gol) (get-bounds:tv %r) (leaf-nodes:nd) ~)
      left-plumbs=((chain:tv nid:gol @) (plomb:tv %l) (root-nodes:nd) ~)
      ryte-plumbs=((chain:tv nid:gol @) (plomb:tv %r) (leaf-nodes:nd) ~)
  ==
::
++  inflate-goal
  |=  =id:gol
  ^-  goal:gol
  ::
  :: make sure inflating both goals and cache
  =.  goals.p  (~(uni by goals.p) cache.p)
  ::
  =/  goal  (~(got by goals.p) id)
  %=  goal
    stock  (~(got by stock-map.trace.p) id)
    ranks  (get-ranks:tv (~(got by stock-map.trace.p) id))
    prio-left  (prio-left:nd id)
    prio-ryte  (prio-ryte:nd id)
    prec-left  (prec-left:nd id)
    prec-ryte  (prec-ryte:nd id)
    nest-left  (nest-left:nd id)
    nest-ryte  (nest-ryte:nd id)
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
  |=  =goals:gol
  ^-  goals:gol
  %-  ~(gas by goals)
  %+  turn
    ~(tap in ~(key by goals))
  |=(=id:gol [id (inflate-goal id)])
::
++  inflater
  |.
  ^-  _this
  =.  trace.p  (trace-update)
  =.  goals.p  (inflate-goals goals.p)
  =.  cache.p  (inflate-goals cache.p)
  this
::
++  apply
  |*  [func=$-(* _(pore)) parm=*]
  ^-  _this
  =.  p  p:(func parm)
  (inflater)
::
:: ============================================================================
:: 
:: HELPERS
::
:: ============================================================================
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
:: UPDATES
::
:: ============================================================================
::
:: Move goal and subgoals from main goals to cache
++  cache-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  tore  (apply cache-goal:(pore) id mod)
  =/  gdiff  (full-diff goals.p goals.p.tore)
  =/  cdiff  (full-diff goals.p cache.p.tore)
  =/  nex  (~(uni by nex.gdiff) nex.cdiff)
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
  =/  diff  (diff cache.p cache.p.tore)
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
  =/  tore  this
  =/  upds  (perms-to-upds new)
  |-
  ?~  upds
    =/  fd  (full-diff goals.p goals.p.tore)
    (emot:tore this [vzn %pool-perms nex.fd perms.p.tore])
  %=  $
    upds  t.upds
    tore  (apply set-pool-role:(pore.tore) ship.i.upds role.i.upds mod)
  ==
::
++  update-goal-perms
  |=  [=id:gol chief=ship rec=_| spawn=(set ship) mod=ship]
  ^-  _this
  =/  tore  (apply set-chief:(pore) id chief rec mod)
  =.  tore  (apply replace-spawn-set:(pore.tore) id spawn mod)
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
++  edit-goal-note
  |=  [=id:gol note=@t mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-goal-edit-perm:(pore) id mod)
  =/  goal  (~(got by goals.p) id)
  =.  goals.p  (~(put by goals.p) id goal(note note))
  (emot old [vzn %goal-hitch id %note note])
::
++  add-goal-tag
  |=  [=id:gol =tag:gol mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-goal-edit-perm:(pore) id mod)
  =/  goal  (~(got by goals.p) id)
  =.  goals.p
    (~(put by goals.p) id goal(tags (~(put in tags.goal) tag)))
  (emot old [vzn %goal-hitch id %add-tag tag])
:: 
++  del-goal-tag
  |=  [=id:gol =tag:gol mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-goal-edit-perm:(pore) id mod)
  =/  goal  (~(got by goals.p) id)
  =.  goals.p
    (~(put by goals.p) id goal(tags (~(del in tags.goal) tag)))
  (emot old [vzn %goal-hitch id %del-tag tag])
::
++  add-field-data
  |=  [=id:gol field=@t =field-data:gol mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-goal-edit-perm:(pore) id mod)
  ?>  (~(has by fields.p) field)
  =/  =field-type:gol  (~(got by fields.p) field)
  ?>  =(-.field-type -.field-data)
  ?>  ?.  &(?=(%ct -.field-type) ?=(%ct -.field-data))  &
      (~(has in set.field-type) d.field-data)
  =/  goal  (~(got by goals.p) id)
  =.  goals.p
    %+  ~(put by goals.p)  id
    goal(fields (~(put by fields.goal) field field-data))
  (emot old [vzn %goal-hitch id %add-field-data field field-data])
::
++  del-field-data
  |=  [=id:gol field=@t mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-goal-edit-perm:(pore) id mod)
  =/  goal  (~(got by goals.p) id)
  =.  goals.p
    %+  ~(put by goals.p)  id
    goal(fields (~(del by fields.goal) field))
  (emot old [vzn %goal-hitch id %del-field-data field])
:: 
++  edit-pool-title
  |=  [title=@t mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-pool-edit-perm:(pore) mod)
  =.  p  p(title title)
  (emot old [vzn %pool-hitch %title title])
:: 
++  edit-pool-note
  |=  [note=@t mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-pool-edit-perm:(pore) mod)
  =.  p  p(note note)
  (emot old [vzn %pool-hitch %note note])
::
++  add-field-type
  |=  [field=@t =field-type:gol mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-pool-edit-perm:(pore) mod)
  ?<  (~(has by fields.p) field) 
  =.  p  p(fields (~(put by fields.p) field field-type))
  (emot old [vzn %pool-hitch %add-field-type field field-type])
::
++  del-field-type
  |=  [field=@t mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-pool-edit-perm:(pore) mod)
  ::
  =.  goals.p
    %-  ~(gas by *goals:gol)
    %+  turn  ~(tap by goals.p)
    |=  [=id:gol =goal:gol]
    ^-  [id:gol goal:gol]
    [id goal(fields (~(del by fields.goal) field))]
  ::
  =.  p  p(fields (~(del by fields.p) field))
  (emot old [vzn %pool-hitch %del-field-type field])
::
:: wit all da fixin's
++  spawn-goal-fixns
  |=  [=id:gol upid=(unit id:gol) desc=@t actionable=_| mod=ship]
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
    ::
      [%pool-hitch %note *]
    (note:pool-hitch note.upd)
    ::
      [%pool-hitch %add-field-type *]
    (add-field-type:pool-hitch [field field-type]:upd)
    ::
      [%pool-hitch %del-field-type *]
    (del-field-type:pool-hitch field.upd)
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
    ::
      [%goal-hitch id:gol %note *]
    (note:goal-hitch [id note]:upd)
    ::
      [%goal-hitch id:gol %add-tag *]
    (add-tag:goal-hitch [id tag]:upd)
    ::
      [%goal-hitch id:gol %del-tag *]
    (del-tag:goal-hitch [id tag]:upd)
    ::
      [%goal-hitch id:gol %add-field-data *]
    (add-field-data:goal-hitch [id field field-data]:upd)
    ::
      [%goal-hitch id:gol %del-field-data *]
    (del-field-data:goal-hitch [id field]:upd)
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
        goals.p  (gus-by goals.p.pore ~(tap in cas))
        cache.p
          %-  ~(uni by cache.p.pore)
          `goals:gol`(gat-by goals.p.pore ~(tap in cas))
      ==
    ::
    ++  renew-goal
      |=  =id:gol
      ^-  _this
      =/  prog  ~(tap in (~(progeny gol-cli-traverse cache.p) id))
      %=  this
        cache.p  (gus-by cache.p prog)
        goals.p  (~(uni by goals.p) `goals:gol`(gat-by cache.p prog))
      ==
    ::
    ++  trash-goal
      |=  =id:gol
      ^-  _this
      =/  prog  ~(tap in (~(progeny gol-cli-traverse cache.p) id))
      this(cache.p (gus-by cache.p prog))
    --
  ::
  ++  pool-perms  |=(perms=pool-perms:gol `_this`this(perms.p perms))
  ::
  ++  pool-hitch
    |%
    ++  note   |=(note=@t `_this`this(p p(note note)))
    ++  title  |=(title=@t `_this`this(p p(title title)))
    ++  add-field-type
      |=  [field=@t =field-type:gol]
      ^-  _this
      this(p p(fields (~(put by fields.p) field field-type)))
    ++  del-field-type
      |=  field=@t
      ^-  _this
      ::
      =.  goals.p
        %-  ~(gas by *goals:gol)
        %+  turn  ~(tap by goals.p)
        |=  [=id:gol =goal:gol]
        ^-  [id:gol goal:gol]
        [id goal(fields (~(del by fields.goal) field))]
      ::
      this(p p(fields (~(del by fields.p) field)))
    --
  ::
  ++  goal-hitch
    |%
    ++  note
      |=  [=id:gol note=@t]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      this(goals.p (~(put by goals.p) id goal(note note)))
    ++  desc
      |=  [=id:gol desc=@t]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      this(goals.p (~(put by goals.p) id goal(desc desc)))
    ++  add-tag
      |=  [=id:gol =tag:gol]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      %=    this
          goals.p
        (~(put by goals.p) id goal(tags (~(put in tags.goal) tag)))
      ==
    ++  del-tag
      |=  [=id:gol =tag:gol]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      %=    this
          goals.p
        (~(put by goals.p) id goal(tags (~(del in tags.goal) tag)))
      ==
    ++  add-field-data  
      |=  [=id:gol field=@t =field-data:gol]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      %=    this
          goals.p
        %+  ~(put by goals.p)  id
        goal(fields (~(put by fields.goal) field field-data))
      ==
    ++  del-field-data
      |=  [=id:gol field=@t]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      %=    this
          goals.p
        %+  ~(put by goals.p)  id
        goal(fields (~(del by fields.goal) field))
      ==
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
