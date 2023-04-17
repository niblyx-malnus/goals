/-  gol=goal
/+  *gol-cli-util, pl=gol-cli-pool, nd=gol-cli-node, tv=gol-cli-traverse,
    gol-cli-etch, fl=gol-cli-inflater, gol-cli-goals
::
|_  [=bowl:gall cards=(list card:agent:gall) state-5:gol]
+*  this   .
    state  +<+>
    gols   ~(. gol-cli-goals store)
    etch   ~(. gol-cli-etch store)
    vzn    vzn:gol
+$  card  card:agent:gall
++  abet  [(flop cards) state]
++  emit  |=(=card this(cards [card cards]))
++  emil  |=(cadz=(list card) this(cards (weld cadz cards)))
::
++  cools  (~(uni by pools.store) cache.store)
++  pile  |=(=pin:gol (~(got by cools) pin))
++  pind  |=(=id:gol `pin:gol`(got:idx-orm:gol index.store id))
::
++  log-orm  ((on @ log-update:gol) lth)
++  unique-time
  |=  [=time =log:gol]
  ^-  @
  =/  unix-ms=@
    (unm:chrono:userlib time)
  |-
  ?.  (has:log-orm log unix-ms)
    unix-ms
  $(unix-ms (add unix-ms 1))
::
++  en-pool-path
  |=(=pin:gol `path`/(scot %p owner.pin)/(scot %da birth.pin))
::
++  de-pool-path
  |=  =path
  ^-  pin:gol
  ?>  ?=([@ta @ta ~] path)
  [%pin (slav %p i.path) (slav %da i.t.path)]
::
++  en-relay-wire
  |=  [pid=@ =pin:gol =term]
  ^-  wire
  /away/[pid]/(scot %p owner.pin)/(scot %da birth.pin)/[term]
::
++  de-relay-wire
  |=  =wire
  ^-  [@ pin:gol term]
  ?>  ?=([%away @ @ta @ta @ta ~] wire)
  :*  i.t.wire
      [%pin (slav %p i.t.t.wire) (slav %da i.t.t.t.wire)] 
      i.t.t.t.t.wire
  ==
::
++  relay
  |=  [=pin:gol axn=action:gol]
  ^-  _this
  ?>  =(src our):bowl
  =/  =wire  (en-relay-wire pid.axn pin -.pok.axn)
  =/  =dock  [owner.pin dap.bowl]
  (emit %pass wire %agent dock %poke goal-action+!>(axn))
::
++  log-update
  |=  [[=pin:gol mod=ship pid=@] upd=update:gol]
  ^-  _this
  =/  now=@  (unique-time now.bowl log)
  this(log (put:log-orm log.state now [%updt [[pin mod pid] upd]]))
::
++  home-emit
  |=  [[=pin:gol mod=ship pid=@] upd=update:gol]
  ^-  _this
  (emit %give %fact ~[/goals] goal-home-update+!>([[pin mod pid] upd]))
::
++  away-emit
  |=  [[=pin:gol mod=ship pid=@] upd=update:gol]
  ^-  _this
  =/  path  (en-pool-path pin)
  (emit %give %fact ~[path] goal-away-update+!>([[mod pid] upd]))
:: kick people without member perms
::
++  kick-unwelcome
  |=  =pin:gol
  ^-  _this
  %-  emil
  %+  murn  ~(val by sup.bowl)
  |=  [=ship =path]
  ?.  ?=([@ta @ta ~] path)  ~
  =/  =pin:gol  (de-pool-path path)
  =/  =pool:gol  (~(got by pools.store) pin)
  ?:  (~(has by perms.pool) ship)  ~
  (some [%give %kick ~[path] `ship])
::
++  send-home-update
  |=  [[=pin:gol mod=ship pid=@] upd=update:gol]
  ^-  _this
  =.  this  (log-update [pin mod pid] upd)
  (home-emit:this [pin mod pid] upd)
::
++  send-away-update
  |=  [[=pin:gol mod=ship pid=@] upd=update:gol]
  ^-  _this
  =.  this  (log-update [pin mod pid] upd)
  =.  this  (home-emit:this [pin mod pid] upd)
  =.  this  (away-emit:this [pin mod pid] upd)
  (kick-unwelcome:this pin)
::
:: ============================================================================
:: 
:: HELPERS
::
:: ============================================================================
::
++  unique-pin
  |=  [own=ship now=@da]
  ^-  pin:gol
  ?.  (~(has by pools.store) [%pin own now])
    [%pin own now]
  $(now (add now ~s0..0001))
::
++  spawn-pool
  |=  [title=@t own=ship now=@da]
  ^-  [pin:gol pool:gol]
  =/  pin  (unique-pin own now)
  =|  =pool:gol
  =:  owner.pool  owner.pin
      birth.pool  birth.pin
      title.pool  title
      creator.pool  own
    ==
  [pin pool]
::
++  clone-pool
  |=  [=old=pin:gol title=@t own=ship now=@da]
  ^-  [pin:gol pool:gol]
  =/  old-pool  (~(got by pools.store) old-pin)
  =/  [=pin:gol =pool:gol]  (spawn-pool title own now)
  =.  pool  pool(creator owner.old-pin)
  =.  pool  pool(goals goals:(clone-goals:gols goals.old-pool own now))
  [pin (inflate-pool:fl pool)]
::
++  all-goals  
  ^-  goals:gol
  =/  pools  ~(val by pools.store)
  =|  =goals:gol
  |-  ?~  pools  goals
  %=  $
    pools  t.pools
    goals  (~(uni by goals) goals.i.pools)
  ==
::
++  fix-order
  ^-  (list id:gol)
  =/  d-k-precs  (~(precedents-map tv all-goals) %d %k)
  %-  ~(fix-list tv all-goals)
  [%p d-k-precs order.local.store ~(key by all-goals)]
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
++  field-check
  |=  [=field-type:gol =field-data:gol]
  ^-  ?
  ?:  =([%ud %ud] [-.field-type -.field-data])  &
  ?:  =([%rd %rd] [-.field-type -.field-data])  &
  =/  =(set @t)
    ?-  -.field-type
      ?(%ud %rd)  !!
      %ct  set.field-type
    ==
  =/  d=@t
    ?-  -.field-data
      ?(%ud %rd)  !!
      %ct  d.field-data
    ==
  (~(has in set) d)
::
:: ============================================================================
:: 
:: UPDATES
::
:: ============================================================================
::
++  handle-watch
  |=  =path
  ^-  _this
  =/  =pin:gol  (de-pool-path path)
  =/  pool      (~(got by pools.store) pin)
  ?>  (~(has by perms.pool) src.bowl)
  =/  way=away-update:gol  [[our.bowl 0] vzn spawn-pool+pool]
  (emit %give %fact ~ goal-away-update+!>(way))
::
++  handle-poke
  |=  axn=action:gol
  ^-  _this
  =/  mod  src.bowl
  ?-    -.pok.axn
      %spawn-goal
    =,  pok.axn
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    =/  =id:gol  (unique-id:gols [our now]:bowl)
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
    =/  upd=update:gol  [vzn %spawn-goal pex nex.fd id goal]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store        (~(put by pools.store) pin new)
    =.  index.store        (put:idx-orm:gol index.store id pin)
    =.  order.local.store  fix-order
    (send-away-update [pin mod pid.axn] upd)
    ::
      %cache-goal
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    =/  new=pool:gol  abet:(cache-goal:(apex:pl old) id mod)
    =/  gdiff  (full-diff goals.old goals.new)
    =/  cdiff  (full-diff goals.old cache.new)
    =/  nex  (~(uni by nex.gdiff) nex.cdiff)
    =/  =pex:gol  trace.new
    =/  upd=update:gol  [vzn %cache-goal pex nex id ~(key by waz.gdiff)]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %renew-goal
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    =/  new=pool:gol  abet:(renew-goal:(apex:pl old) id mod)
    =/  fd  (full-diff goals.old goals.new)
    =/  =pex:gol  trace.new
    =/  upd=update:gol  [vzn %renew-goal pex id pon.fd]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %trash-goal
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    ?:  (~(has by goals.old) id)
      =/  new=pool:gol  abet:(waste-goal:(apex:pl old) id mod)
      =/  fd  (full-diff goals.old goals.new)
      =/  =pex:gol  trace.new
      =/  upd=update:gol  [vzn %waste-goal pex nex.fd id ~(key by waz.fd)]
      ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
      =.  pools.store        (~(put by pools.store) pin new)
      =.  index.store        (gus-idx-orm:etch index.store ~(tap in ~(key by waz.fd)))
      =.  order.local.store  fix-order
      (send-away-update [pin mod pid.axn] upd)
    =/  new=pool:gol  abet:(trash-goal:(apex:pl old) id mod)
    =/  diff  (diff cache.old cache.new)
    =/  =pex:gol  trace.new
    =/  upd=update:gol  [vzn %trash-goal pex id hep.diff]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store        (~(put by pools.store) pin new)
    =/  prog               ~(tap in (~(progeny tv cache.old) id))
    =.  index.store        (gus-idx-orm:etch index.store prog)
    =.  order.local.store  fix-order
    (send-away-update [pin mod pid.axn] upd)
    ::
      %move
    =,  pok.axn
    =/  =pin:gol  (pind cid)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    =/  new=pool:gol  abet:(move:(apex:pl old) cid upid mod)
    =/  fd  (full-diff goals.old goals.new)
    =/  =pex:gol  trace.new
    =/  upd=update:gol  [vzn %pool-nexus %yoke pex nex.fd]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store        (~(put by pools.store) pin new)
    =.  order.local.store  fix-order
    (send-away-update [pin mod pid.axn] upd)
    ::
      %yoke
    =,  pok.axn
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    =/  new=pool:gol  abet:(plex-sequence:(apex:pl old) yoks mod)
    =/  fd  (full-diff goals.old goals.new)
    =/  =pex:gol  trace.new
    =/  upd=update:gol  [vzn %pool-nexus %yoke pex nex.fd]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store        (~(put by pools.store) pin new)
    =.  order.local.store  fix-order
    (send-away-update [pin mod pid.axn] upd)
    ::
      %mark-actionable
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    =/  new=pool:gol  abet:(mark-actionable:(apex:pl old) id mod)
    =/  upd=update:gol  [vzn %goal-togls id %actionable %.y]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %mark-complete
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    =/  new=pool:gol  abet:(mark-complete:(apex:pl old) id mod)
    =/  upd=update:gol  [vzn %goal-togls id %complete %.y]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %unmark-actionable
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    =/  new=pool:gol  abet:(unmark-actionable:(apex:pl old) id mod)
    =/  upd=update:gol  [vzn %goal-togls id %actionable %.n]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %unmark-complete
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    =/  new=pool:gol  abet:(unmark-complete:(apex:pl old) id mod)
    =/  upd=update:gol  [vzn %goal-togls id %complete %.n]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %set-kickoff
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    =/  new=pool:gol  abet:(set-kickoff:(apex:pl old) id kickoff mod)
    =/  fd  (full-diff goals.old goals.new)
    =/  =pex:gol  trace.new
    =/  upd=update:gol  [vzn %goal-dates pex nex.fd]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %set-deadline
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    =/  new=pool:gol  abet:(set-deadline:(apex:pl old) id deadline mod)
    =/  fd  (full-diff goals.old goals.new)
    =/  =pex:gol  trace.new
    =/  upd=update:gol  [vzn %goal-dates pex nex.fd]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %update-pool-perms
    =,  pok.axn
    ?.  =(owner.pin our.bowl)  (relay pin axn)
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
    =/  upd=update:gol  [vzn %pool-perms pex nex.fd perms.new]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
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
      %update-goal-perms
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    =/  new=pool:gol
      =/  pore  (set-chief:(apex:pl old) id chief rec mod)
      abet:(replace-spawn-set:pore id spawn mod)
    =/  fd  (full-diff goals.old goals.new)
    =/  =pex:gol  trace.new
    =/  upd=update:gol  [vzn %goal-perms pex nex.fd]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %reorder-young
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    ?>  (check-goal-edit-perm:(apex:pl old) id mod)
    ?>  =((sy young) (~(young nd goals.old) id))
    =/  goal  (~(got by goals.old) id)
    =.  young.goal
      (en-virt:fl goal (~(topological-sort tv goals.old) %p d-k-precs.trace.old young))
    =/  new=pool:gol  old(goals (~(put by goals.old) id goal))
    =/  fd  (full-diff goals.old goals.new)
    =/  upd=update:gol  [vzn %goal-young nex.fd]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %reorder-roots
    =,  pok.axn
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    ?>  (check-pool-edit-perm:(apex:pl old) mod)
    ?>  =((sy roots) (sy (~(root-goals nd goals.old))))
    =/  new=pool:gol
      %=  old
          roots.trace
        (~(topological-sort tv goals.old) %p d-k-precs.trace.old roots)
      ==
    =/  =pex:gol  trace.new
    =/  upd=update:gol  [vzn %goal-roots pex]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %edit-goal-desc
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    =/  old=pool:gol  (pile pin)
    ?>  (check-goal-edit-perm:(apex:pl old) id mod)
    =/  goal  (~(got by goals.old) id)
    =/  new=pool:gol  old(goals (~(put by goals.old) id goal(desc desc)))
    =/  upd=update:gol  [vzn %goal-hitch id %desc desc]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %edit-goal-note
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    ?>  (check-goal-edit-perm:(apex:pl old) id mod)
    =/  goal  (~(got by goals.old) id)
    =/  new=pool:gol  old(goals (~(put by goals.old) id goal(note note)))
    =/  upd=update:gol  [vzn %goal-hitch id %note note]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %add-goal-tag
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    ?<  private.tag
    ?>  (check-goal-edit-perm:(apex:pl old) id mod)
    =/  goal  (~(got by goals.old) id)
    =.  tags.goal  (~(put in tags.goal) tag)
    =/  new=pool:gol  old(goals (~(put by goals.old) id goal))
    =/  upd=update:gol  [vzn %goal-hitch id %add-tag tag]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %del-goal-tag
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    ?<  private.tag
    ?>  (check-goal-edit-perm:(apex:pl old) id mod)
    =/  goal  (~(got by goals.old) id)
    =.  tags.goal  (~(del in tags.goal) tag)
    =/  new=pool:gol  old(goals (~(put by goals.old) id goal))
    =/  upd=update:gol  [vzn %goal-hitch id %del-tag tag]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %put-goal-tags
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    ?>  (~(all in tags) |=(=tag:gol !private.tag)) 
    ?>  (check-goal-edit-perm:(apex:pl old) id mod)
    =/  goal  (~(got by goals.old) id)
    =/  new=pool:gol  old(goals (~(put by goals.old) id goal(tags tags)))
    :: incorporate private tags into update...
    =/  local-tags=(set tag:gol)
      ?~(get=(~(get by goals.local.store) id) ~ tags.u.get)
    =/  upd=update:gol
      [vzn %goal-hitch id %put-tags (~(uni in tags) local-tags)]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %put-private-tags
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?>  =(src our):bowl
    ?>  (~(all in tags) |=(=tag:gol private.tag)) 
    =/  gl=goal-local:gol
      ?~  get=(~(get by goals.local.store) id)
        *goal-local:gol
      u.get
    =.  tags.gl  tags
    =.  goals.local.store  (~(put by goals.local.store) id gl)
    =/  =pool:gol  (~(got by pools.store) pin)
    =/  =goal:gol  (~(got by goals.pool) id)
    =/  upd=update:gol
      [vzn %goal-hitch id %put-tags (~(uni in tags) tags.goal)]
    =.  this  (log-update [pin our.bowl pid.axn] upd)
    (home-emit:this [pin our.bowl pid.axn] upd)
    ::
      %add-field-data
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    ?>  (check-goal-edit-perm:(apex:pl old) id mod)
    ?>  (~(has by fields.old) field)
    =/  =field-type:gol  (~(got by fields.old) field)
    ?>  (field-check field-type field-data)
    =/  goal  (~(got by goals.old) id)
    =.  fields.goal  (~(put by fields.goal) field field-data)
    =/  new=pool:gol  old(goals (~(put by goals.old) id goal))
    =/  upd=update:gol  [vzn %goal-hitch id %add-field-data field field-data]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %del-field-data
    =,  pok.axn
    =/  =pin:gol  (pind id)
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    ?>  (check-goal-edit-perm:(apex:pl old) id mod)
    =/  goal  (~(got by goals.old) id)
    =.  fields.goal  (~(del by fields.goal) field)
    =/  new=pool:gol  old(goals (~(put by goals.old) id goal))
    =/  upd=update:gol  [vzn %goal-hitch id %del-field-data field]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    :: 
      %edit-pool-title
    =,  pok.axn
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    ?>  (check-pool-edit-perm:(apex:pl old) mod)
    =/  new=pool:gol  old(title title)
    =/  upd=update:gol  [vzn %pool-hitch %title title]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    :: 
      %edit-pool-note
    =,  pok.axn
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    ?>  (check-pool-edit-perm:(apex:pl old) mod)
    =/  new=pool:gol  old(note note)
    =/  upd=update:gol  [vzn %pool-hitch %note note]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %add-field-type
    =,  pok.axn
    ?.  =(owner.pin our.bowl)  (relay pin axn)
    =/  old=pool:gol  (pile pin)
    ?>  (check-pool-edit-perm:(apex:pl old) mod)
    ?<  (~(has by fields.old) field) 
    =/  new=pool:gol  old(fields (~(put by fields.old) field field-type))
    =/  upd=update:gol  [vzn %pool-hitch %add-field-type field field-type]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %del-field-type
    =,  pok.axn
    ?.  =(owner.pin our.bowl)  (relay pin axn)
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
    =/  upd=update:gol  [vzn %pool-hitch %del-field-type field]
    ?.  =(new (pool-etch:etch old upd))  ~|("non-equivalent-update" !!)
    =.  pools.store  (~(put by pools.store) pin new)
    (send-away-update [pin mod pid.axn] upd)
    ::
      %spawn-pool
    =,  pok.axn
    ?>  =(src our):bowl
    =/  [=pin:gol =pool:gol]  (spawn-pool title [src now]:bowl)
    =/  upd=update:gol  [vzn %spawn-pool pool]
    =.  pools.store  (~(put by pools.store) pin pool)
    (send-home-update [pin src.bowl pid.axn] upd)
    ::
      %clone-pool
    =,  pok.axn
    ?>  =(src our):bowl
    =/  [=pin:gol =pool:gol]  (clone-pool pin title [src now]:bowl)
    =/  upd=update:gol  [vzn %spawn-pool pool]
    =.  pools.store        (~(put by pools.store) pin pool)
    =.  order.local.store  fix-order
    (send-home-update [pin src.bowl pid.axn] upd)
    ::
      %cache-pool
    =,  pok.axn
    ?>  =(src our):bowl
    ?>  =(src.bowl owner.pin)
    =.  this  (emit %give %kick ~[(en-pool-path pin)] ~)
    =/  upd=update:gol  [vzn %cache-pool pin]
    (send-home-update:this [pin src.bowl pid.axn] upd)
    ::
      %renew-pool
    =,  pok.axn
    ?>  =(src our):bowl
    ?>  =(src.bowl owner.pin)
    =/  pool  (~(got by cache.store) pin)
    =/  upd=update:gol  [vzn %renew-pool pin pool]
    (send-home-update [pin src.bowl pid.axn] upd)
    ::
      %trash-pool
    :: TODO: purge locals; purge index; purge order
    =,  pok.axn
    ?>  =(src our):bowl
    ?>  =(src.bowl owner.pin)
    =.  this  (emit %give %kick ~[(en-pool-path pin)] ~)
    =/  upd=update:gol
      ?:  (~(has by pools.store) pin)  [vzn %waste-pool ~]
      ?>  (~(has by cache.store) pin)  [vzn %trash-pool ~]
    (send-home-update:this [pin src.bowl pid.axn] upd)
    ::
      %slot-above
    =,  pok.axn
    ?~  idx=(find [dis]~ order.local.store)  !!
    =.  order.local.store  (oust [u.idx 1] order.local.store)
    ?~  idx=(find [dat]~ order.local.store)  !!
    =.  order.local.store  (into order.local.store u.idx dis)
    this(order.local.store fix-order)
    ::
      %slot-below
    =,  pok.axn
    ?~  idx=(find [dis]~ order.local.store)  !!
    =.  order.local.store  (oust [u.idx 1] order.local.store)
    ?~  idx=(find [dat]~ order.local.store)  !!
    =.  order.local.store  (into order.local.store +(u.idx) dis)
    this(order.local.store fix-order)
    ::
      %subscribe
    =,  pok.axn
    ?>  =(src our):bowl
    ?<  =(src.bowl owner.pin)
    =/  pite=wire  (en-pool-path pin)
    =/  =dock  [owner.pin dap.bowl]
    (emit %pass pite %agent dock %watch pite)
    ::
      %unsubscribe
    =,  pok.axn
    ?>  =(src our):bowl
    ?<  =(src.bowl owner.pin)
    =/  =wire  (en-pool-path pin)
    =/  =dock  [owner.pin dap.bowl]
    =.  this  (emit %pass wire %agent dock %leave ~)
    =/  upd=update:gol
      ?:  (~(has by cache.store) pin)  [vzn %trash-pool ~]
      ?>  (~(has by pools.store) pin)  [vzn %waste-pool ~]
    (send-home-update:this [pin src.bowl pid.axn] upd)
  ==
--
