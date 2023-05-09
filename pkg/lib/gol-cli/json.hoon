/-  *goal
|%
++  dejs-action
  =,  dejs:format
  |=  jon=json
  ^-  action
  :-  vzn
  %.  jon
  %-  ot
  :~  pid+so
      :-  %pok
      %-  of
      :~  [%spawn-pool (ot ~[title+so])]
          [%clone-pool (ot ~[pin+dejs-pin title+so])]
          [%cache-pool (ot ~[pin+dejs-pin])]
          [%renew-pool (ot ~[pin+dejs-pin])]
          [%trash-pool (ot ~[pin+dejs-pin])]
          :-  %spawn-goal
          %-  ot
          :~  pin+dejs-pin
              upid+dejs-unit-id
              desc+so
              actionable+bo
          ==
          [%cache-goal (ot ~[id+dejs-id])]
          [%renew-goal (ot ~[id+dejs-id])]
          [%trash-goal (ot ~[id+dejs-id])]
          [%yoke (ot ~[pin+dejs-pin yoks+dejs-yoke-seq])]
          [%move (ot ~[cid+dejs-id upid+dejs-unit-id])]
          [%set-kickoff (ot ~[id+dejs-id kickoff+dejs-unit-di])]
          [%set-deadline (ot ~[id+dejs-id deadline+dejs-unit-di])]
          [%mark-actionable (ot ~[id+dejs-id])]
          [%unmark-actionable (ot ~[id+dejs-id])]
          [%mark-complete (ot ~[id+dejs-id])]
          [%unmark-complete (ot ~[id+dejs-id])]
          :-  %update-goal-perms 
          %-  ot
          :~  id+dejs-id
              chief+dejs-ship
              rec+bo
              spawn+dejs-set-ships
          ==
          [%reorder-roots (ot ~[pin+dejs-pin roots+(ar dejs-id)])]
          [%reorder-young (ot ~[id+dejs-id young+(ar dejs-id)])]
          [%update-pool-perms (ot ~[pin+dejs-pin new+dejs-pool-perms])]
          [%edit-goal-desc (ot ~[id+dejs-id desc+so])]
          [%edit-pool-title (ot ~[pin+dejs-pin title+so])]
          [%edit-goal-note (ot ~[id+dejs-id note+so])]
          [%edit-pool-note (ot ~[pin+dejs-pin note+so])]
          [%add-goal-tag (ot ~[id+dejs-id tag+dejs-tag])]
          [%del-goal-tag (ot ~[id+dejs-id tag+dejs-tag])]
          [%put-goal-tags (ot ~[id+dejs-id tags+(as dejs-tag)])]
          :-  %add-field-type
          (ot ~[pin+dejs-pin field+so field-type+dejs-field-type])
          [%del-field-type (ot ~[pin+dejs-pin field+so])]
          :-  %add-field-data
          (ot ~[id+dejs-id field+so field-data+dejs-field-data])
          [%del-field-data (ot ~[id+dejs-id field+so])]
          [%put-private-tags (ot ~[id+dejs-id tags+(as dejs-tag)])]
          [%subscribe (ot ~[pin+dejs-pin])]
          [%unsubscribe (ot ~[pin+dejs-pin])]
      ==
  ==
::
++  dejs-tag
  =,  dejs:format
  %-  ot
  :~  text+so
      color+so
      private+bo
  ==
::
++  dejs-field-type
  =,  dejs:format
  |=  jon=json
  ^-  field-type
  %.  jon
  %-  of
  :~  [%ct (as so)]
      [%ud ul]
      [%rd ul]
  ==
::
++  dejs-field-data
  =,  dejs:format
  |=  jon=json
  ^-  field-data
  %.  jon
  %-  of
  :~  [%ct (ot ~[d+so])]
      [%ud (ot ~[d+(cu |=(=@t (slav %ud t)) so)])]
      [%rd (ot ~[d+(cu |=(=@t (slav %rd t)) so)])]
  ==
::
++  dejs-pool-perms
  |=  jon=json
  %-  ~(gas by *(map ship (unit pool-role)))
  %.  jon
  %-  ar:dejs:format
  (ot:dejs:format ~[ship+dejs-ship role+dejs-unit-role])
++  dejs-unit-role  |=(jon=json ?~(jon ~ (some (dejs-role jon))))
++  dejs-role  (su:dejs:format parse-role)
++  parse-role
    ;~  pose
      (cold %admin (jest 'admin'))
      (cold %spawn (jest 'spawn'))
    ==
++  dejs-unit-di  |=(jon=json ?~(jon ~ (some (di:dejs:format jon))))
++  dejs-unit-date  |=(jon=json ?~(jon ~ (some (dejs-date jon))))
++  dejs-pin  (pe:dejs:format %pin dejs-id)
++  dejs-unit-id  |=(jon=json ?~(jon ~ (some (dejs-id jon))))
++  dejs-id  (ot:dejs:format ~[owner+dejs-ship birth+dejs-date])
++  dejs-set-ships  (as:dejs:format dejs-ship)
++  dejs-ship  (su:dejs:format fed:ag)
++  dejs-date  (su:dejs:format (cook |*(a=* (year +.a)) ;~(plug (just '~') when:so)))
++  dejs-yoke-seq  (ar:dejs:format dejs-yoke)
++  dejs-yoke  
  |=  jon=json
  =/  out
    %.  jon
    (ot:dejs:format ~[yoke+dejs-yoke-tag lid+dejs-id rid+dejs-id])
  ^-  exposed-yoke
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
++  dejs-yoke-tag
  |=  jon=json
  =/  tag=term  (so:dejs:format jon)
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
++  enjs-peek
  =,  enjs:format
  |=  pyk=peek
  ^-  json
  ?-    -.pyk
    %store  (frond %store (enjs-store store.pyk))
    %views  (frond %views (enjs-views views.pyk))
  ==
::
++  enjs-views
  =,  enjs:format
  |=  =views
  ^-  json
  =-  o/(malt -)
  %+  turn  ~(tap by views)
  |=  [k=@uv ack=_| v=view:^views]
  :-  (scot %uv k)
  ^-  json
  %-  pairs
  :~  [%ack b+ack]
      [%view (enjs-view v)]
  ==
::
++  enjs-view
  =,  enjs:format
  |=  =view:views
  ^-  json
  %-  pairs
  :~  [%parm (enjs-view-parm ;;(parm:views [-.view parm.view]))]
      [%data s+%enjs-not-implemented]
  ==
::
++  enjs-view-parm
  =,  enjs:format
  |=  =parm:views
  |^  ^-  json
  ?-    -.parm
    %tree  (frond [%type (enjs-tree-type type.parm)])
      %harvest
    %-  pairs
    :~  [%type (enjs-harvest-type type.parm)]
        [%method s+method.parm]
        [%tags a+(turn ~(tap in tags.parm) enjs-tag)]
    ==
    ::
      %list-view
    %-  pairs
    :~  [%type (enjs-list-view-type type.parm)]
        [%first-gen-only b+first-gen-only.parm]
        [%actionable-only b+actionable-only.parm]
        [%method s+method.parm]
        [%tags a+(turn ~(tap in tags.parm) enjs-tag)]
    ==
    ::
    %page  (frond [%type (enjs-page-type type.parm)])
  ==
  ++  enjs-tree-type  enjs-harvest-type
  ++  enjs-page-type  enjs-harvest-type
  ++  enjs-harvest-type
    |=  =type:harvest:views
    ^-  json
    ?-  -.type
      %main  (frond %main ~)
      %pool  (frond %pool (enjs-pin pin.type))
      %goal  (frond %goal (enjs-id id.type))
    ==
  ++  enjs-list-view-type
    |=  =type:list-view:views
    ^-  json
    ?-    -.type
      %main  (frond %main ~)
      %pool  (frond %pool (enjs-pin pin.type))
      ::
        %goal
      %+  frond  %goal
      %-  pairs
      :~  [%id (enjs-id id.type)]
          [%ignore-virtual b+ignore-virtual.type]
      ==
    ==
  --
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
  |=  =pool
  %-  pairs
  :~  :-  %froze
      %-  pairs
      :~  [%owner (ship owner.pool)]
          [%birth (numb (unm:chrono:userlib birth.pool))]
          [%creator (ship creator.pool)]
      ==
      :-  %perms
      :-  %a  %+  turn  ~(tap by perms.pool) 
      |=  [chip=@p role=(unit pool-role)] 
      %-  pairs
      :~  [%ship (ship chip)]
          [%role ?~(role ~ s+u.role)]
      ==
      :-  %nexus
      %-  pairs
      :~  [%goals (enjs-goals goals.pool)]
          [%cache (enjs-goals cache.pool)]
      ==
      [%hitch (enjs-pool-hitch hitch:`npool`pool)]
      [%trace (enjs-pool-trace trace.pool)]
  ==
::
++  enjs-pool-hitch
  =,  enjs:format
  |=  ph=pool-hitch
  ^-  json
  %-  pairs
  :~  [%title s+title.ph]
      [%note s+note.ph]
      :-  %fields
      %-  pairs
      %+  turn  ~(tap by fields.ph)
      |=  [field=@t =field-type]
      ^-  [@t json]
      [field (enjs-field-type field-type)]
  ==

::
++  enjs-yoke
  =,  enjs:format
  |=  yok=exposed-yoke
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
      ::
      :-  %stock  :-  %a
      %+  turn  stock.nexus
      |=([=id chief=@p] (pairs ~[[%id (enjs-id id)] [%chief (ship chief)]]))
      ::
      :-  %ranks  :-  %a
      %+  turn  ~(tap by ranks.nexus)
      |=([chip=@p =id] (pairs ~[[%ship (ship chip)] [%id (enjs-id id)]]))
      ::
      [%young a+(turn young.nexus enjs-id-v)]
      [%young-by-precedence a+(turn young-by-precedence.nexus enjs-id-v)]
      [%young-by-kickoff a+(turn young-by-kickoff.nexus enjs-id-v)]
      [%young-by-deadline a+(turn young-by-deadline.nexus enjs-id-v)]
      ::
      :-  %progress
      %-  pairs
      :~  [%complete (numb complete.progress.nexus)]
          [%total (numb total.progress.nexus)]
      ==
      ::
      [%prio-left a+(turn ~(tap in prio-left.nexus) enjs-id)]
      [%prio-ryte a+(turn ~(tap in prio-ryte.nexus) enjs-id)]
      [%prec-left a+(turn ~(tap in prec-left.nexus) enjs-id)]
      [%prec-ryte a+(turn ~(tap in prec-ryte.nexus) enjs-id)]
      [%nest-left a+(turn ~(tap in nest-left.nexus) enjs-id)]
      [%nest-ryte a+(turn ~(tap in nest-ryte.nexus) enjs-id)]
  ==
::
++  enjs-goal
  =,  enjs:format
  |=  =goal
  ^-  json
  %-  pairs
  :~  :-  %froze
      %-  pairs
      :~  [%owner (ship owner.goal)]
          [%birth (numb (unm:chrono:userlib birth.goal))]
          [%author (ship author.goal)]
      ==
      [%nexus (enjs-goal-nexus-trace [nexus trace]:`ngoal`goal)]
      [%hitch (enjs-goal-hitch hitch:`ngoal`goal)]
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
      :-  %fields
      %-  pairs
      %+  turn  ~(tap by fields.gh)
      |=  [field=@t =field-data]
      ^-  [@t json]
      [field (enjs-field-data field-data)]
  ==
::
++  enjs-node
   =,  enjs:format
   |=  =node:goal
   ^-  json
   %-  pairs
   :~  [%moment ?~(moment.node ~ (numb (unm:chrono:userlib u.moment.node)))]
       [%inflow a+(turn ~(tap in inflow.node) enjs-nid)]
       [%outflow a+(turn ~(tap in outflow.node) enjs-nid)]
       :-  %left-bound
       %+  frond 
         %moment
       ?~(left-bound.node ~ (numb (unm:chrono:userlib u.left-bound.node)))
       :-  %ryte-bound
       %+  frond 
         %moment
       ?~(ryte-bound.node ~ (numb (unm:chrono:userlib u.ryte-bound.node)))
       [%left-plumb (numb left-plumb.node)]
       [%ryte-plumb (numb ryte-plumb.node)]
   ==
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
