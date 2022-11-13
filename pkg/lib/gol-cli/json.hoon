/-  *goal
/+  *gol-cli-util, group-store, metadata-store
|%
++  dejs-action
  =,  dejs:format
  |=  jon=json
  ^-  action
  :-  vzn
  %.  jon
  %-  ot
  :~  pid+ni
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
          [%update-pool-perms (ot ~[pin+dejs-pin new+dejs-pool-perms])]
          [%edit-goal-desc (ot ~[id+dejs-id desc+so])]
          [%edit-pool-title (ot ~[pin+dejs-pin title+so])]
          [%subscribe (ot ~[pin+dejs-pin])]
          [%unsubscribe (ot ~[pin+dejs-pin])]
      ==
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
++  dejs-tests
  |%
  ++  test-date  s+(scot %da (add ~2000.1.1 ~s1..0001))
  ++  new-pool
    =,  enjs:format
    ^-  json
    %+  frond
      %new-pool
    %-  pairs
    :~  [%title s+'test']
        [%admins a+~[s+'zod' s+'nec' s+'bud']]
        [%captains a+~[s+'zod' s+'nec' s+'bud']]
        [%viewers a+~[s+'zod' s+'nec' s+'bud']]
    ==
  ++  invite
    =,  enjs:format
    ^-  json
    %+  frond
      %invite
    %-  pairs
    :~  [%invitee s+'zod']
        [%pin (pairs ~[[%owner s+'zod'] [%birth test-date]])]
    ==
  ++  copy-pool
    =,  enjs:format
    ^-  json
    %+  frond
      %copy-pool
    %-  pairs
    :~  [%old-pin (pairs ~[[%owner s+'zod'] [%birth test-date]])]
        [%title s+'test']
        [%admins a+~[s+'zod' s+'nec' s+'bud']]
        [%captains a+~[s+'zod' s+'nec' s+'bud']]
        [%viewers a+~[s+'zod' s+'nec' s+'bud']]
    ==
  ++  new-goal
    =,  enjs:format
    ^-  json
    %+  frond
      %new-goal
    %-  pairs
    :~  [%pin (pairs ~[[%owner s+'zod'] [%birth test-date]])]
        [%desc s+'test desc']
        [%captains a+~[s+'zod' s+'nec' s+'bud']]
        [%peons a+~[s+'zod' s+'nec' s+'bud']]
        [%deadline test-date]
        [%actionable b+%.n]
    ==
  ++  yoke-sequence
    =,  enjs:format
    ^-  json
    %+  frond
      %yoke-sequence
    %-  pairs
    :~  [%pin (pairs ~[[%owner s+'zod'] [%birth test-date]])]
        :-  %yoke-sequence
        :-  %a
        :~  %-  pairs
            :~  [%yoke s+'nest-yoke']
                [%lid (pairs ~[[%owner s+'zod'] [%birth test-date]])]
                [%rid (pairs ~[[%owner s+'zod'] [%birth test-date]])]
            ==
            %-  pairs
            :~  [%yoke s+'prec-rend']
                [%lid (pairs ~[[%owner s+'zod'] [%birth test-date]])]
                [%rid (pairs ~[[%owner s+'zod'] [%birth test-date]])]
            ==
        ==
    ==
  --
::
++  enjs-home-update
  =,  enjs:format
  |=  hom=home-update
  ^-  json
  =/  upd=update  +.hom
  =/  upd  +.upd  :: ignore version
  %-  pairs
  :~  :-  %hed
      %-  pairs
      :~  [%pin (enjs-pin pin.hom)]
          [%mod (ship mod.hom)]
          [%pid (numb pid.hom)]
      ==
      :-  %tel
      %+  frond  -.upd
      ?-    -.upd
        %poke-error  (frond %tang (enjs-tang tang.upd))
          %spawn-goal
        %-  pairs
        :~  [%pin (enjs-pin pin.hom)]
            [%nex (enjs-nex nex.upd)]
            [%id (enjs-id id.upd)]
            [%goal (enjs-goal goal.upd)]
        ==
        ::
          %waste-goal
        %-  pairs
        :~  [%pin (enjs-pin pin.hom)]
            [%nex (enjs-nex nex.upd)]
            [%id (enjs-id id.upd)]
            [%waz a+(turn ~(tap in waz.upd) enjs-id)]
        ==
        ::
          %cache-goal
        %-  pairs
        :~  [%pin (enjs-pin pin.hom)]
            [%nex (enjs-nex nex.upd)]
            [%id (enjs-id id.upd)]
            [%cas a+(turn ~(tap in cas.upd) enjs-id)]
        ==
        ::
        %renew-goal  
        %-  pairs
        :~  [%pin (enjs-pin pin.hom)]
            [%id (enjs-id id.upd)]
            [%ren (enjs-goals ren.upd)]
        ==
        ::
        %trash-goal
        %-  pairs
        :~  [%pin (enjs-pin pin.hom)]
            [%id (enjs-id id.upd)]
            [%tas a+(turn ~(tap in tas.upd) enjs-id)]
        ==
        ::
        %spawn-pool  (frond %pool (enjs-pool pool.upd))
        ::
        %cache-pool  (frond %pin (enjs-pin pin.upd))
        ::
          %renew-pool 
        (pairs ~[[%pin (enjs-pin pin.upd)] [%pool (enjs-pool pool.upd)]])
        ::
        %waste-pool  ~
        %trash-pool  ~
        ::
          %pool-perms
        :-  %a  %+  turn  ~(tap by new.upd) 
        |=  [chip=@p role=(unit pool-role)] 
        %-  pairs
        :~  [%ship (ship chip)]
            [%role ?~(role ~ s+u.role)]
        ==
        ::
          %pool-hitch
        ?-  +<.upd
          %title  (frond +<.upd s+title.upd)
        ==
        ::
          %pool-nexus
        ?-    +<.upd
            %yoke
          %+  frond  +<.upd
          %-  pairs
          :~  [%nex (enjs-nex nex.upd)]
          ==
        ==
        ::
          %goal-dates
        %+  frond  %nex
        (enjs-nex nex.upd)
        ::
          %goal-perms
        %+  frond  %nex
        (enjs-nex nex.upd)
        ::
          %goal-togls
        %-  pairs
        :~  [%id (enjs-id id.upd)]
            :-  %togls-updated
            %+  frond
              +>-.upd
            ?-  +>-.upd
              %complete  b+complete.upd
              %actionable  b+actionable.upd
            ==
        ==
        ::
          %goal-hitch
        %-  pairs
        :~  [%id (enjs-id id.upd)]
            :-  +>-.upd
            ?-  +>-.upd
              %desc  s+desc.upd
            ==
        ==
      ==
  ==
::
++  enjs-peek
  =,  enjs:format
  |=  pyk=peek
  ^-  json
  ?-    -.pyk
      %initial
    %+  frond
      %initial
    %-  pairs
    :~  [%store (enjs-store store.pyk)]
    ==
      %updates
    %+  frond
      %updates
    a+(turn list.pyk enjs-logged)
    ::
    %groups  (frond %groups (initial:enjs:group-store [%initial groups.pyk]))
    ::
      %groups-metadata
    (frond %metadata (associations:enjs:metadata-store metadata.pyk))
    ::
      %pool-keys
    %+  frond
      %pool-keys
    a+(turn ~(tap in keys.pyk) enjs-pin)
    ::
      %all-goal-keys
    %+  frond
      %all-goal-keys
    a+(turn ~(tap in keys.pyk) enjs-id)
    ::
      %harvest
    %+  frond
      %harvest
    a+(turn harvest.pyk enjs-id)
    ::
      %full-harvest
    %+  frond
      %full-harvest
    (enjs-goals harvest.pyk)
    ::
      %get-goal
    %+  frond
      %goal
    ?~(ugoal.pyk ~ (enjs-goal u.ugoal.pyk))
    ::
      %get-pin
    %+  frond
      %pin
    ?~(upin.pyk ~ (enjs-pin u.upin.pyk))
    ::
      %get-pool
    %+  frond
      %pool
    ?~(upool.pyk ~ (enjs-pool u.upool.pyk))
    ::
    %ryte-bound  (frond %moment ?~(moment.pyk ~ s+(scot %da u.moment.pyk)))
    ::
      %plumb
    %+  frond
      %depth
    (numb depth.pyk)
    ::
      %anchor
    %+  frond
      %depth
    (numb depth.pyk)
    ::
      %priority
    %+  frond
      %priority
    (numb priority.pyk)
    ::
    ::   %seniority
    :: %+  frond
    ::   %senior
    :: ?~(u-senior.pyk ~ (enjs-id u.u-senior.pyk))
    ::
      %yung
    %+  frond
      %yung
    a+(turn yung.pyk enjs-id)
    ::
      %yung-uncompleted
    %+  frond
      %yung-uncompleted
    a+(turn yung-uc.pyk enjs-id)
    ::
      %yung-virtual
    %+  frond
      %yung-virtual
    a+(turn yung-vr.pyk enjs-id)
    ::
      %roots
    %+  frond
      %roots
    a+(turn roots.pyk enjs-id)
    ::
      %roots-uncompleted
    %+  frond
      %roots-uncompleted
    a+(turn roots-uc.pyk enjs-id)
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
  ==
::
++  enjs-logged
  =,  enjs:format
  |=  =logged
  (pairs ~[[%time (numb p.logged)] [%entry (enjs-log-update q.logged)]])
::
++  enjs-log-update
  =,  enjs:format
  |=  =log-update
  ?-  -.log-update
    %init  (frond %init (enjs-store +.log-update))
    %updt  (frond %updt (enjs-home-update +.log-update))
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
      :-  %hitch
      %-  pairs
      :~  [%title s+title.pool]
      ==
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
++  enjs-nex
  =,  enjs:format
  |=  =nex
  :-  %a  %+  turn  ~(tap by nex) 
  |=  [=id nexus=goal-nexus trace=goal-trace] 
  %-  pairs
  :~  [%id (enjs-id id)]
      [%goal (enjs-goal-nexus-trace nexus trace)]
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
      :-  %hitch
      %-  pairs
      :~  [%desc s+desc.goal]
      ==
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
