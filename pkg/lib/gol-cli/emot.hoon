/-  gol=goal
/+  *gol-cli-util, gol-cli-pool, gol-cli-node, gol-cli-traverse,
    gol-cli-etch, fl=gol-cli-inflater
::
=|  efx=(list update:gol)
=|  p=pool:gol
|_  =store:gol
+*  this  .
    tv    ~(. gol-cli-traverse goals.p)
    nd    ~(. gol-cli-node goals.p)
    etch  ~(. gol-cli-etch store)
    vzn   vzn:gol
::
++  pore  |.(~(. gol-cli-pool p))
::
++  abex
  |=  =pool:gol
  this(p pool)
::
++  apex
  |=  =pin:gol
  %=    this
      p
   (~(got by (~(uni by pools.store) cache.store)) pin)
  ==
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
  =/  tore  this(p (pool-etch:etch p.old upd))
  =.  p.tore  (inflate-pool:fl p.tore)
  ?.  =(p.this p.tore)
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
:: a nex is a map from ids to a goal nexus
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
++  apply
  |*  [func=$-(* _(pore)) parm=*]
  ^-  _this
  =.  p  p:(func parm)
  this(p (inflate-pool:fl p))
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
:: ============================================================================
:: 
:: UPDATES
::
:: ============================================================================
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
  =/  =pex:gol  trace.p.tore
  (emot:tore(efx efx) old [vzn %spawn-goal pex nex.fd id goal])
::
:: Move goal and subgoals from main goals to cache
++  cache-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  tore  (apply cache-goal:(pore) id mod)
  =/  gdiff  (full-diff goals.p goals.p.tore)
  =/  cdiff  (full-diff goals.p cache.p.tore)
  =/  nex  (~(uni by nex.gdiff) nex.cdiff)
  =/  =pex:gol  trace.p.tore
  (emot:tore this [vzn %cache-goal pex nex id ~(key by waz.gdiff)])
::
:: Restore goal from cache to main goals
++  renew-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  tore  (apply renew-goal:(pore) id mod)
  =/  fd  (full-diff goals.p goals.p.tore)
  =/  =pex:gol  trace.p.tore
  (emot:tore this [vzn %renew-goal pex id pon.fd])
::
:: Permanently delete goal
++  trash-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  ?:  (~(has by goals.p) id)
    =/  tore  (apply waste-goal:(pore) id mod)
    =/  fd  (full-diff goals.p goals.p.tore)
    =/  =pex:gol  trace.p.tore
    (emot:tore this [vzn %waste-goal pex nex.fd id ~(key by waz.fd)])
  =/  tore  (apply trash-goal:(pore) id mod)
  =/  diff  (diff cache.p cache.p.tore)
  =/  =pex:gol  trace.p.tore
  (emot:tore this [vzn %trash-goal pex id hep.diff])
::
++  move
  |=  [lid=id:gol urid=(unit id:gol) mod=ship]
  ^-  _this
  =/  tore  (apply move:(pore) lid urid mod)
  =/  fd  (full-diff goals.p goals.p.tore)
  =/  =pex:gol  trace.p.tore
  (emot:tore this [vzn %pool-nexus %yoke pex nex.fd])
::
:: sequence of composite yokes
++  plex-sequence
  |=  [plez=(list plex:gol) mod=ship]
  ^-  _this
  =/  tore  (apply plex-sequence:(pore) plez mod)
  =/  fd  (full-diff goals.p goals.p.tore)
  =/  =pex:gol  trace.p.tore
  (emot:tore this [vzn %pool-nexus %yoke pex nex.fd])
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
  =/  =pex:gol  trace.p.tore
  (emot:tore this [vzn %goal-dates pex nex.fd])
::
++  set-deadline
  |=  [=id:gol =moment:gol mod=ship]
  ^-  _this
  =/  tore  (apply set-deadline:(pore) id moment mod)
  =/  fd  (full-diff goals.p goals.p.tore)
  =/  =pex:gol  trace.p.tore
  (emot:tore this [vzn %goal-dates pex nex.fd])
::
++  update-pool-perms
  |=  [new=pool-perms:gol mod=ship]
  ^-  _this
  =/  tore  this
  =/  upds  (perms-to-upds new)
  |-
  ?~  upds
    =/  fd  (full-diff goals.p goals.p.tore)
    =/  =pex:gol  trace.p.tore
    (emot:tore this [vzn %pool-perms pex nex.fd perms.p.tore])
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
  =/  =pex:gol  trace.p.tore
  (emot:tore this [vzn %goal-perms pex nex.fd])
::
++  reorder-young
  |=  [=id:gol young=(list id:gol) mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-goal-edit-perm:(pore) id mod)
  ?>  =((sy young) (young:nd id))
  =/  goal  (~(got by goals.p) id)
  =.  young.goal
    (en-virt:fl goal (topological-sort:tv %p d-k-precs.trace.p young))
  =.  goals.p     (~(put by goals.p) id goal)
  =/  fd  (full-diff goals.p goals.p.old)
  (emot old [vzn %goal-young nex.fd])
::
++  reorder-roots
  |=  [roots=(list id:gol) mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-pool-edit-perm:(pore) mod)
  ?>  =((sy roots) (sy (root-goals:nd)))
  =.  roots.trace.p  (topological-sort:tv %p d-k-precs.trace.p roots)
  =/  =pex:gol  trace.p
  (emot old [vzn %goal-roots pex])
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
++  put-goal-tags
  |=  [=id:gol tags=(set tag:gol) mod=ship]
  ^-  _this
  =/  old  this
  ?>  (check-goal-edit-perm:(pore) id mod)
  =/  goal  (~(got by goals.p) id)
  =.  goals.p  (~(put by goals.p) id goal(tags tags))
  :: incorporate private tags into update...
  =.  tags
    ?~  get=(~(get by goals.local.store) id)
      tags
    (~(uni in tags) tags.u.get)
  (emot old [vzn %goal-hitch id %put-tags tags])
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
--
