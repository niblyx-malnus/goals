/-  *goal, act=action
|%
++  dejs
  =,  dejs:format
  |%
  ++  action
    |=  jon=json
    ^-  action:act
    %.  jon
    %-  ot
    =-  ~[pid+so pok+-]
    %-  of
    :~  [%spawn-pool (ot ~[title+so])]
        [%clone-pool (ot ~[pin+pin title+so])]
        [%cache-pool (ot ~[pin+pin])]
        [%renew-pool (ot ~[pin+pin])]
        [%trash-pool (ot ~[pin+pin])]
        [%spawn-goal (ot ~[pin+pin upid+unit-id desc+so actionable+bo])]
        [%cache-goal (ot ~[id+id])]
        [%renew-goal (ot ~[id+id])]
        [%trash-goal (ot ~[id+id])]
        [%yoke (ot ~[pin+pin yoks+yoke-seq])]
        [%move (ot ~[cid+id upid+unit-id])]
        [%set-kickoff (ot ~[id+id kickoff+unit-di])]
        [%set-deadline (ot ~[id+id deadline+unit-di])]
        [%mark-actionable (ot ~[id+id])]
        [%unmark-actionable (ot ~[id+id])]
        [%mark-complete (ot ~[id+id])]
        [%unmark-complete (ot ~[id+id])]
        [%update-goal-perms (ot ~[id+id chief+ship rec+bo spawn+set-ships])]
        [%reorder-roots (ot ~[pin+pin roots+(ar id)])]
        [%reorder-young (ot ~[id+id young+(ar id)])]
        [%update-pool-perms (ot ~[pin+pin new+pool-perms])]
        [%edit-goal-desc (ot ~[id+id desc+so])]
        [%edit-pool-title (ot ~[pin+pin title+so])]
        [%edit-goal-note (ot ~[id+id note+so])]
        [%edit-pool-note (ot ~[pin+pin note+so])]
        [%add-goal-tag (ot ~[id+id tag+tag])]
        [%del-goal-tag (ot ~[id+id tag+tag])]
        [%put-goal-tags (ot ~[id+id tags+(as tag)])]
        [%add-field-type (ot ~[pin+pin field+so field-type+field-type])]
        [%del-field-type (ot ~[pin+pin field+so])]
        [%add-field-data (ot ~[id+id field+so field-data+field-data])]
        [%del-field-data (ot ~[id+id field+so])]
        [%put-private-tags (ot ~[id+id tags+(as tag)])]
        [%subscribe (ot ~[pin+pin])]
        [%unsubscribe (ot ~[pin+pin])]
    ==
  ::
  ++  tag  (ot ~[text+so color+so private+bo])
  ::
  ++  field-type
    |=  jon=json
    ^-  ^field-type
    %.  jon
    %-  of
    :~  [%ct (as so)]
        [%ud ul]
        [%rd ul]
    ==
  ::
  ++  field-data
    |=  jon=json
    ^-  ^field-data
    %.  jon
    %-  of
    :~  [%ct (ot ~[d+so])]
        [%ud (ot ~[d+(cu |=(=@t (slav %ud t)) so)])]
        [%rd (ot ~[d+(cu |=(=@t (slav %rd t)) so)])]
    ==
  ::
  ++  pool-perms
    |=  jon=json
    ^-  (map ^ship (unit pool-role))
    %-  ~(gas by *(map ^ship (unit pool-role)))
    %.(jon (ar (ot ~[ship+ship role+unit-role])))

  ++  unit-role  |=(jon=json ?~(jon ~ (some (role jon))))
  ++  role
    %-  su
    ;~  pose
      (cold %admin (jest 'admin'))
      (cold %spawn (jest 'spawn'))
    ==
  ++  unit-di  |=(jon=json ?~(jon ~ (some (di jon))))
  ++  unit-date  |=(jon=json ?~(jon ~ (some (date jon))))
  ++  pin  (pe %pin id)
  ++  unit-id  |=(jon=json ?~(jon ~ (some (id jon))))
  ++  id  (ot ~[owner+ship birth+date])
  ++  set-ships  (as ship)
  ++  ship  (su fed:ag)
  ++  date  (su (cook |*(a=* (year +.a)) ;~(plug (just '~') when:^so)))
  ++  yoke-seq  (ar yoke)
  ++  yoke  
    |=  jon=json
    =/  out
      %.  jon
      (ot ~[yoke+yoke-tag lid+id rid+id])
    ^-  exposed-yoke:act
    ?-  -.out
      %prio-rend   [%prio-rend +<.out +>.out]
      %prio-yoke   [%prio-yoke +<.out +>.out]
      %prec-rend   [%prec-rend +<.out +>.out]
      %prec-yoke   [%prec-yoke +<.out +>.out]
      %nest-rend   [%nest-rend +<.out +>.out]
      %nest-yoke   [%nest-yoke +<.out +>.out]
      %hook-rend   [%hook-rend +<.out +>.out]
      %hook-yoke   [%hook-yoke +<.out +>.out]
      %held-rend   [%held-rend +<.out +>.out]
      %held-yoke   [%held-yoke +<.out +>.out]
    ==
  ::
  ++  yoke-tag
    |=  jon=json
    =/  tag=term  (so jon)
    ?+  tag  !!
      %prio-rend   %prio-rend
      %prio-yoke   %prio-yoke
      %prec-rend   %prec-rend
      %prec-yoke   %prec-yoke
      %nest-rend   %nest-rend
      %nest-yoke   %nest-yoke
      %hook-rend   %hook-rend
      %hook-yoke   %hook-yoke
      %held-rend   %held-rend
      %held-yoke   %held-yoke
    ==
  --
::
++  enjs-tag
  =,  enjs:format
  |=  =tag
  ^-  json
  %-  pairs
  :~  [%text s+text.tag]
      [%color s+color.tag]
      [%private b+private.tag]
  ==
::
++  enjs-field-type
  =,  enjs:format
  |=  =field-type
  ^-  json
  %+  frond  -.field-type
  ?-  -.field-type
    %ct  a+(turn ~(tap in set.field-type) |=(=@t s+t))
    %ud  ~
    %rd  ~
  ==
::
++  enjs-field-data
  =,  enjs:format
  |=  =field-data
  ^-  json
  %+  frond  -.field-data
  ?-  -.field-data
    %ct  s+d.field-data
    %ud  s+(scot %ud d.field-data)
    %rd  s+(scot %rd d.field-data)
  ==
::
++  enjs-store
  =,  enjs:format
  |=  =store
  ^-  json
  %-  pairs
  :~  [%index (enjs-index index.store)]
      [%pools (enjs-pools pools.store)]
      [%cache (enjs-pools cache.store)]
      [%local a+(turn order.local.store enjs-id)]
  ==
::
++  enjs-index
  =,  enjs:format
  |=  =index
  :-  %a  %+  turn  (tap:idx-orm index)
  |=  [=id =pin] 
  %-  pairs
  :~  [%id (enjs-id id)]
      [%pin (enjs-pin pin)]
  ==
  
++  enjs-pools
  =,  enjs:format
  |=  =pools
  :-  %a  %+  turn  ~(tap by pools) 
  |=  [=pin =pool] 
  %-  pairs
  :~  [%pin (enjs-pin pin)]
      [%pool (enjs-pool pool)]
  ==
::
++  enjs-pool
  =,  enjs:format
  |=  =npool
  %-  pairs
  :~  [%froze (enjs-pool-froze froze.npool owner.nexus.npool)]
      [%perms (enjs-pool-perms perms.nexus.npool)]
      [%nexus (enjs-pool-nexus nexus.npool)]
      [%hitch (enjs-pool-hitch hitch.npool)]
      [%trace (enjs-pool-trace trace.npool)]
  ==
::
++  enjs-pool-froze
  =,  enjs:format
  |=  [froze=pool-froze owner=^ship]
  ^-  json
  %-  pairs
  :~  [%owner (ship owner)]
      [%birth (numb (unm:chrono:userlib birth.froze))]
      [%creator (ship creator.froze)]
  ==
::
++  enjs-pool-perms
  =,  enjs:format
  |=  perms=pool-perms
  ^-  json
  :-  %a  %+  turn  ~(tap by perms) 
  |=  [chip=@p role=(unit pool-role)] 
  %-  pairs
  :~  [%ship (ship chip)]
      [%role ?~(role ~ s+u.role)]
  ==
::
++  enjs-pool-nexus
  =,  enjs:format
  |=  nexus=pool-nexus
  ^-  json
  %-  pairs
  :~  [%goals (enjs-goals goals.nexus)]
      [%cache (enjs-goals cache.nexus)]
  ==
::
++  enjs-pool-hitch
  =,  enjs:format
  |=  ph=pool-hitch
  ^-  json
  %-  pairs
  :~  [%title s+title.ph]
      [%note s+note.ph]
      [%fields (enjs-field-types fields.ph)]
  ==
::
++  enjs-field-types
  =,  enjs:format
  |=  fields=(map @t field-type)
  ^-  json
  %-  pairs
  %+  turn  ~(tap by fields)
  |=  [field=@t =field-type]
  ^-  [@t json]
  [field (enjs-field-type field-type)]
::
++  enjs-yoke
  =,  enjs:format
  |=  yok=exposed-yoke:act
  %-  pairs
  :~  [%yoke s+-.yok]
      [%lid (enjs-id lid.yok)]
      [%rid (enjs-id rid.yok)]
  ==
::
++  enjs-goals
  =,  enjs:format
  |=  =goals
  :-  %a  %+  turn  ~(tap by goals) 
  |=  [=id =goal] 
  %-  pairs
  :~  [%id (enjs-id id)]
      [%goal (enjs-goal goal)]
  ==
::
++  enjs-pex  enjs-pool-trace
::
++  enjs-pool-trace
  =,  enjs:format
  |=  trace=pool-trace
  ^-  json
  %-  pairs
  :~  [%roots a+(turn roots.trace enjs-id)]
      [%roots-by-precedence a+(turn roots-by-precedence.trace enjs-id)]
      [%roots-by-kickoff a+(turn roots-by-kickoff.trace enjs-id)]
      [%roots-by-deadline a+(turn roots-by-deadline.trace enjs-id)]
      [%cache-roots a+(turn cache-roots.trace enjs-id)]
      [%cache-roots-by-precedence a+(turn cache-roots-by-precedence.trace enjs-id)]
      [%cache-roots-by-kickoff a+(turn cache-roots-by-kickoff.trace enjs-id)]
      [%cache-roots-by-deadline a+(turn cache-roots-by-deadline.trace enjs-id)]
  ==
::
++  enjs-nex
  =,  enjs:format
  |=  =nex
  ^-  json
  :-  %a  %+  turn  ~(tap by nex) 
  |=  [=id nexus=goal-nexus trace=goal-trace] 
  %-  pairs
  :~  [%id (enjs-id id)]
      [%goal (enjs-goal-nexus-trace nexus trace)]
  ==
::
++  enjs-id-v
  =,  enjs:format
  |=  [=id v=?]
  ^-  json
  %-  pairs
  :~  [%id (enjs-id id)]
      [%virtual b+v]
  ==
::
++  enjs-goal-nexus-trace
  =,  enjs:format
  |=  nexus=[goal-nexus goal-trace]
  ^-  json
  %-  pairs
  :~  [%par ?~(par.nexus ~ (enjs-id u.par.nexus))]
      [%kids a+(turn ~(tap in kids.nexus) enjs-id)]
      [%kickoff (enjs-node kickoff.nexus)]
      [%deadline (enjs-node deadline.nexus)]
      [%complete b+complete.nexus]
      [%actionable b+actionable.nexus]
      [%chief (ship chief.nexus)]
      [%spawn a+(turn ~(tap in spawn.nexus) ship)]
      [%stock (enjs-stock stock.nexus)]
      [%ranks (enjs-ranks ranks.nexus)]
      [%young a+(turn young.nexus enjs-id-v)]
      [%young-by-precedence a+(turn young-by-precedence.nexus enjs-id-v)]
      [%young-by-kickoff a+(turn young-by-kickoff.nexus enjs-id-v)]
      [%young-by-deadline a+(turn young-by-deadline.nexus enjs-id-v)]
      [%progress (enjs-progress progress.nexus)]
      [%prio-left a+(turn ~(tap in prio-left.nexus) enjs-id)]
      [%prio-ryte a+(turn ~(tap in prio-ryte.nexus) enjs-id)]
      [%prec-left a+(turn ~(tap in prec-left.nexus) enjs-id)]
      [%prec-ryte a+(turn ~(tap in prec-ryte.nexus) enjs-id)]
      [%nest-left a+(turn ~(tap in nest-left.nexus) enjs-id)]
      [%nest-ryte a+(turn ~(tap in nest-ryte.nexus) enjs-id)]
  ==
::
++  enjs-stock
  =,  enjs:format
  |=  =stock
  ^-  json
  :-  %a  %+  turn  stock
  |=  [=id chief=@p]
  %-  pairs
  :~  [%id (enjs-id id)]
      [%chief (ship chief)]
  ==
::
++  enjs-ranks
  =,  enjs:format
  |=  =ranks
  ^-  json
  :-  %a
  %+  turn  ~(tap by ranks)
  |=  [chip=@p =id]
  %-  pairs
  :~  [%ship (ship chip)]
      [%id (enjs-id id)]
  ==
::
++  enjs-progress
  =,  enjs:format
  |=  [c=@ t=@]
  %-  pairs
  :~  complete+(numb c)
      total+(numb t)
  ==
::
++  enjs-goal
  =,  enjs:format
  |=  =goal
  ^-  json
  %-  pairs
  :~  [%froze (enjs-goal-froze froze:`ngoal`goal)]
      [%nexus (enjs-goal-nexus-trace [nexus trace]:`ngoal`goal)]
      [%hitch (enjs-goal-hitch hitch:`ngoal`goal)]
  ==
::
++  enjs-goal-froze
  =,  enjs:format
  |=  froze=goal-froze
  ^-  json
  %-  pairs
  :~  [%owner (ship owner.froze)]
      [%birth (numb (unm:chrono:userlib birth.froze))]
      [%author (ship author.froze)]
  ==
::
++  enjs-goal-hitch
  =,  enjs:format
  |=  gh=goal-hitch
  ^-  json
  %-  pairs
  :~  [%desc s+desc.gh]
      [%note s+note.gh]
      [%tags a+(turn ~(tap in tags.gh) enjs-tag)]
      [%fields (enjs-fields fields.gh)]
  ==
::
++  enjs-fields
  =,  enjs:format
  |=  fields=(map @t field-data)
  ^-  json
  %-  pairs
  %+  turn  ~(tap by fields)
  |=  [field=@t =field-data]
  ^-  [@t json]
  [field (enjs-field-data field-data)]
::
++  enjs-node
   =,  enjs:format
   |=  =node:goal
   ^-  json
   %-  pairs
   :~  [%moment (enjs-moment moment.node)]
       [%inflow a+(turn ~(tap in inflow.node) enjs-nid)]
       [%outflow a+(turn ~(tap in outflow.node) enjs-nid)]
       [%left-bound (frond %moment (enjs-moment left-bound.node))]
       [%ryte-bound (frond %moment (enjs-moment ryte-bound.node))]
       [%left-plumb (numb left-plumb.node)]
       [%ryte-plumb (numb ryte-plumb.node)]
   ==
::
++  enjs-moment
  =,  enjs:format
  |=  =moment
  ^-  json
  ?~  moment  ~
  %-  numb
  (unm:chrono:userlib u.moment)
::
++  enjs-nid
  =,  enjs:format
  |=  =nid
  ^-  json
  %-  pairs
  :: change %edge -> %node when confirmed no frontend effects
  :~  [%edge s+-.nid]
      [%id (enjs-id +.nid)]
  ==
::
++  enjs-pin
  =,  enjs:format
  |=  =pin
  ^-  json
  (enjs-id +.pin)
::
++  enjs-id
  =,  enjs:format
  |=  =id
  ^-  json
  %-  pairs
  :~  [%owner (ship owner.id)]
      [%birth s+(scot %da birth.id)]
  ==
::
++  enjs-tang  |=(=tang a+(turn tang tank:enjs:format))
--
