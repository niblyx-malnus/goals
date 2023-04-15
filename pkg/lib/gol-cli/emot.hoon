/-  gol=goal
/+  *gol-cli-util, pl=gol-cli-pool, nd=gol-cli-node, tv=gol-cli-traverse,
    gol-cli-etch, fl=gol-cli-inflater
::
=|  efx=(list update:gol)
|_  =store:gol
+*  this  .
    etch  ~(. gol-cli-etch store)
    vzn   vzn:gol
::
++  apex  |=(=store:gol this(store store))
++  abet  efx=(flop efx)
++  emit  |=(upd=update:gol this(efx [upd efx]))
++  emot
  |=  [old=pool:gol new=pool:gol upd=update:gol]
  ?.  =(new (pool-etch:etch old upd))
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
++  cools  (~(uni by pools.store) cache.store)
++  coals  |=(p=pool:gol (~(uni by goals.p) cache.p))
++  pile  |=(=pin:gol (~(got by cools) pin))
++  pild  |=(=id:gol (pile (got:idx-orm:gol index.store id)))
::
:: ============================================================================
:: 
:: UPDATES
::
:: ============================================================================
::
:: wit all da fixin's
++  spawn-goal-fixns
  |=  [=pin:gol =id:gol upid=(unit id:gol) desc=@t actionable=_| mod=ship]
  ^-  _this
  =/  old=pool:gol  (pile pin)
  =/  new=pool:gol
    =/  pore  (spawn-goal:(apex:pl old) id upid mod)
    ?:  actionable
      abet:(mark-actionable:pore id mod)
    abet:(unmark-actionable:pore id mod)
  =/  =goal:gol  (~(got by goals.new) id)
  =.  goal  goal(desc desc)
  =.  goals.new  (~(put by goals.new) id goal)
  =/  fd  (full-diff goals.old goals.new)
  =/  =pex:gol  trace.new
  (emot old new [vzn %spawn-goal pex nex.fd id goal])
::
:: Move goal and subgoals from main goals to cache
++  cache-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild id)
  =/  new=pool:gol  abet:(cache-goal:(apex:pl old) id mod)
  =/  gdiff  (full-diff goals.old goals.new)
  =/  cdiff  (full-diff goals.old cache.new)
  =/  nex  (~(uni by nex.gdiff) nex.cdiff)
  =/  =pex:gol  trace.new
  (emot old new [vzn %cache-goal pex nex id ~(key by waz.gdiff)])
::
:: Restore goal from cache to main goals
++  renew-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild id)
  =/  new=pool:gol  abet:(renew-goal:(apex:pl old) id mod)
  =/  fd  (full-diff goals.old goals.new)
  =/  =pex:gol  trace.new
  (emot old new [vzn %renew-goal pex id pon.fd])
::
:: Permanently delete goal
++  trash-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild id)
  ?:  (~(has by goals.old) id)
    =/  new=pool:gol  abet:(waste-goal:(apex:pl old) id mod)
    =/  fd  (full-diff goals.old goals.new)
    =/  =pex:gol  trace.new
    (emot old new [vzn %waste-goal pex nex.fd id ~(key by waz.fd)])
  =/  new=pool:gol  abet:(trash-goal:(apex:pl old) id mod)
  =/  diff  (diff cache.old cache.new)
  =/  =pex:gol  trace.new
  (emot old new [vzn %trash-goal pex id hep.diff])
::
++  move
  |=  [lid=id:gol urid=(unit id:gol) mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild lid)
  =/  new=pool:gol  abet:(move:(apex:pl old) lid urid mod)
  =/  fd  (full-diff goals.old goals.new)
  =/  =pex:gol  trace.new
  (emot old new [vzn %pool-nexus %yoke pex nex.fd])
::
:: sequence of composite yokes
++  plex-sequence
  |=  [=pin:gol plez=(list plex:gol) mod=ship]
  ^-  _this
  =/  old=pool:gol  (pile pin)
  =/  new=pool:gol  abet:(plex-sequence:(apex:pl old) plez mod)
  =/  fd  (full-diff goals.old goals.new)
  =/  =pex:gol  trace.new
  (emot old new [vzn %pool-nexus %yoke pex nex.fd])
::
++  mark-actionable
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild id)
  =/  new=pool:gol  abet:(mark-actionable:(apex:pl old) id mod)
  (emot old new [vzn %goal-togls id %actionable %.y])
::
++  mark-complete
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild id)
  =/  new=pool:gol  abet:(mark-complete:(apex:pl old) id mod)
  (emot old new [vzn %goal-togls id %complete %.y])
::
++  unmark-actionable
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild id)
  =/  new=pool:gol  abet:(unmark-actionable:(apex:pl old) id mod)
  (emot old new [vzn %goal-togls id %actionable %.n])
::
++  unmark-complete
  |=  [=id:gol mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild id)
  =/  new=pool:gol  abet:(unmark-complete:(apex:pl old) id mod)
  (emot old new [vzn %goal-togls id %complete %.n])
::
++  set-kickoff
  |=  [=id:gol =moment:gol mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild id)
  =/  new=pool:gol  abet:(set-kickoff:(apex:pl old) id moment mod)
  =/  fd  (full-diff goals.old goals.new)
  =/  =pex:gol  trace.new
  (emot old new [vzn %goal-dates pex nex.fd])
::
++  set-deadline
  |=  [=id:gol =moment:gol mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild id)
  =/  new=pool:gol  abet:(set-deadline:(apex:pl old) id moment mod)
  =/  fd  (full-diff goals.old goals.new)
  =/  =pex:gol  trace.new
  (emot old new [vzn %goal-dates pex nex.fd])
::
++  update-pool-perms
  |=  [=pin:gol new=pool-perms:gol mod=ship]
  ^-  _this
  =/  old=pool:gol  (pile pin)
  |^
  =/  new=pool:gol
    =/  upds  (perms-to-upds new)
    =/  pore  (apex:pl old)
    |-  ?~  upds  abet:pore
    %=  $
      upds  t.upds
      pore  (set-pool-role:pore ship.i.upds role.i.upds mod)
    ==
  =/  fd  (full-diff goals.old goals.new)
  =/  =pex:gol  trace.new
  (emot old new [vzn %pool-perms pex nex.fd perms.new])
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
      ~(tap in (~(dif in ~(key by perms.old)) ~(key by new)))
    |=(=ship [ship ~])
  --
::
++  update-goal-perms
  |=  [=id:gol chief=ship rec=_| spawn=(set ship) mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild id)
  =/  new=pool:gol
    =/  pore  (set-chief:(apex:pl old) id chief rec mod)
    abet:(replace-spawn-set:pore id spawn mod)
  =/  fd  (full-diff goals.old goals.new)
  =/  =pex:gol  trace.new
  (emot old new [vzn %goal-perms pex nex.fd])
::
++  reorder-young
  |=  [=id:gol young=(list id:gol) mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild id)
  ?>  (check-goal-edit-perm:(apex:pl old) id mod)
  ?>  =((sy young) (~(young nd goals.old) id))
  =/  goal  (~(got by goals.old) id)
  =.  young.goal
    (en-virt:fl goal (~(topological-sort tv goals.old) %p d-k-precs.trace.old young))
  =/  new=pool:gol  old(goals (~(put by goals.old) id goal))
  =/  fd  (full-diff goals.old goals.new)
  (emot old new [vzn %goal-young nex.fd])
::
++  reorder-roots
  |=  [=pin:gol roots=(list id:gol) mod=ship]
  ^-  _this
  =/  old=pool:gol  (pile pin)
  ?>  (check-pool-edit-perm:(apex:pl old) mod)
  ?>  =((sy roots) (sy (~(root-goals nd goals.old))))
  =/  new=pool:gol
    %=  old
        roots.trace
      (~(topological-sort tv goals.old) %p d-k-precs.trace.old roots)
    ==
  =/  =pex:gol  trace.new
  (emot old new [vzn %goal-roots pex])
::
++  edit-goal-desc
  |=  [=id:gol desc=@t mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild id)
  ?>  (check-goal-edit-perm:(apex:pl old) id mod)
  =/  goal  (~(got by goals.old) id)
  =/  new=pool:gol  old(goals (~(put by goals.old) id goal(desc desc)))
  (emot old new [vzn %goal-hitch id %desc desc])
::
++  edit-goal-note
  |=  [=id:gol note=@t mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild id)
  ?>  (check-goal-edit-perm:(apex:pl old) id mod)
  =/  goal  (~(got by goals.old) id)
  =/  new=pool:gol  old(goals (~(put by goals.old) id goal(note note)))
  (emot old new [vzn %goal-hitch id %note note])
::
++  add-goal-tag
  |=  [=id:gol =tag:gol mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild id)
  ?>  (check-goal-edit-perm:(apex:pl old) id mod)
  =/  goal  (~(got by goals.old) id)
  =.  tags.goal  (~(put in tags.goal) tag)
  =/  new=pool:gol  old(goals (~(put by goals.old) id goal))
  (emot old new [vzn %goal-hitch id %add-tag tag])
:: 
++  del-goal-tag
  |=  [=id:gol =tag:gol mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild id)
  ?>  (check-goal-edit-perm:(apex:pl old) id mod)
  =/  goal  (~(got by goals.old) id)
  =.  tags.goal  (~(del in tags.goal) tag)
  =/  new=pool:gol  old(goals (~(put by goals.old) id goal))
  (emot old new [vzn %goal-hitch id %del-tag tag])
::
++  put-goal-tags
  |=  [=id:gol tags=(set tag:gol) mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild id)
  ?>  (check-goal-edit-perm:(apex:pl old) id mod)
  =/  goal  (~(got by goals.old) id)
  =/  new=pool:gol  old(goals (~(put by goals.old) id goal(tags tags)))
  :: incorporate private tags into update...
  =.  tags
    ?~  get=(~(get by goals.local.store) id)
      tags
    (~(uni in tags) tags.u.get)
  (emot old new [vzn %goal-hitch id %put-tags tags])
::
++  add-field-data
  |=  [=id:gol field=@t =field-data:gol mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild id)
  ?>  (check-goal-edit-perm:(apex:pl old) id mod)
  ?>  (~(has by fields.old) field)
  =/  =field-type:gol  (~(got by fields.old) field)
  ?>  =(-.field-type -.field-data)
  ?>  ?.  &(?=(%ct -.field-type) ?=(%ct -.field-data))  &
      (~(has in set.field-type) d.field-data)
  =/  goal  (~(got by goals.old) id)
  =.  fields.goal  (~(put by fields.goal) field field-data)
  =/  new=pool:gol  old(goals (~(put by goals.old) id goal))
  (emot old new [vzn %goal-hitch id %add-field-data field field-data])
::
++  del-field-data
  |=  [=id:gol field=@t mod=ship]
  ^-  _this
  =/  old=pool:gol  (pild id)
  ?>  (check-goal-edit-perm:(apex:pl old) id mod)
  =/  goal  (~(got by goals.old) id)
  =.  fields.goal  (~(del by fields.goal) field)
  =/  new=pool:gol  old(goals (~(put by goals.old) id goal))
  (emot old new [vzn %goal-hitch id %del-field-data field])
:: 
++  edit-pool-title
  |=  [=pin:gol title=@t mod=ship]
  ^-  _this
  =/  old=pool:gol  (pile pin)
  ?>  (check-pool-edit-perm:(apex:pl old) mod)
  =/  new=pool:gol  old(title title)
  (emot old new [vzn %pool-hitch %title title])
:: 
++  edit-pool-note
  |=  [=pin:gol note=@t mod=ship]
  ^-  _this
  =/  old=pool:gol  (pile pin)
  ?>  (check-pool-edit-perm:(apex:pl old) mod)
  =/  new=pool:gol  old(note note)
  (emot old new [vzn %pool-hitch %note note])
::
++  add-field-type
  |=  [=pin:gol field=@t =field-type:gol mod=ship]
  ^-  _this
  =/  old=pool:gol  (pile pin)
  ?>  (check-pool-edit-perm:(apex:pl old) mod)
  ?<  (~(has by fields.old) field) 
  =/  new=pool:gol  old(fields (~(put by fields.old) field field-type))
  (emot old new [vzn %pool-hitch %add-field-type field field-type])
::
++  del-field-type
  |=  [=pin:gol field=@t mod=ship]
  ^-  _this
  =/  old=pool:gol  (pile pin)
  ?>  (check-pool-edit-perm:(apex:pl old) mod)
  =/  new=pool:gol
    %=    old
      fields  (~(del by fields.old) field)
        goals
      %-  ~(gas by *goals:gol)
      %+  turn  ~(tap by goals.old)
      |=  [=id:gol =goal:gol]
      ^-  [id:gol goal:gol]
      [id goal(fields (~(del by fields.goal) field))]
    ==
  (emot old new [vzn %pool-hitch %del-field-type field])
--
