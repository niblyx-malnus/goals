/-  *goal, *goal-store
/+  *gol-cli-help
|%
++  dejs-action
  =,  dejs:format
  |=  jon=json
  ^-  action
  %.  jon
  %-  of
  :~  :-  %new-pool
      %-  ot
      :~  title+so
          chefs+dejs-set-ships
          peons+dejs-set-ships
          viewers+dejs-set-ships
      ==
      ::
      :-  %copy-pool
      %-  ot
      :~  old-pin+dejs-pin
          title+so
          chefs+dejs-set-ships
          peons+dejs-set-ships
          viewers+dejs-set-ships
      ==
      ::
      :-  %spawn-goal
      %-  ot
      :~  pin+dejs-pin
          upid+dejs-unit-id
          desc+so
          actionable+bo
          chefs+dejs-set-ships
          peons+dejs-set-ships
      ==
      [%edit-goal-desc (ot ~[id+dejs-id desc+so])]
      [%edit-pool-title (ot ~[pin+dejs-pin title+so])]
      [%delete-pool (ot ~[pin+dejs-pin])]
      [%delete-goal (ot ~[id+dejs-id])]
      [%yoke (ot ~[pin+dejs-pin yok+dejs-yoke])]
      [%set-deadline (ot ~[id+dejs-id deadline+dejs-unit-date])]
      [%mark-actionable (ot ~[id+dejs-id])]
      [%unmark-actionable (ot ~[id+dejs-id])]
      [%mark-complete (ot ~[id+dejs-id])]
      [%unmark-complete (ot ~[id+dejs-id])]
      [%make-chef (ot ~[chef+dejs-ship id+dejs-id])]
      [%make-peon (ot ~[peon+dejs-ship id+dejs-id])]
  ==
::
++  dejs-unit-date  |=(jon=json ?~(jon ~ (some (dejs-date jon))))
++  dejs-pin  (pe:dejs:format %pin dejs-id)
++  dejs-unit-id  |=(jon=json ?~(jon ~ (some (dejs-id jon))))
++  dejs-id  (ot:dejs:format ~[owner+dejs-ship birth+dejs-date])
++  dejs-set-ships  (as:dejs:format dejs-ship)
++  dejs-ship  (su:dejs:format fed:ag)
++  dejs-date  (su:dejs:format (cook |*(a=* (year +.a)) ;~(plug (just '~') when:so)))
++  dejs-yoke-seq  (ar:dejs:format dejs-yoke)
++  dejs-yoke  (ot:dejs:format ~[yoke+dejs-yoke-tag lid+dejs-id rid+dejs-id])
++  parse-yoke-tag
  ;~  pose
    (cold %prio-rend (jest 'prio-rend'))
    (cold %prio-yoke (jest 'prio-yoke'))
    (cold %prec-rend (jest 'prec-rend'))
    (cold %prec-yoke (jest 'prec-yoke'))
    (cold %nest-rend (jest 'nest-rend'))
    (cold %nest-yoke (jest 'nest-yoke'))
    (cold %held-rend (jest 'held-rend'))
    (cold %held-yoke (jest 'held-yoke'))
  ==
++  dejs-yoke-tag  (su:dejs:format parse-yoke-tag)
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
        [%chefs a+~[s+'zod' s+'nec' s+'bud']]
        [%peons a+~[s+'zod' s+'nec' s+'bud']]
        [%viewers a+~[s+'zod' s+'nec' s+'bud']]
    ==
  ++  copy-pool
    =,  enjs:format
    ^-  json
    %+  frond
      %copy-pool
    %-  pairs
    :~  [%old-pin (pairs ~[[%owner s+'zod'] [%birth test-date]])]
        [%title s+'test']
        [%chefs a+~[s+'zod' s+'nec' s+'bud']]
        [%peons a+~[s+'zod' s+'nec' s+'bud']]
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
        [%chefs a+~[s+'zod' s+'nec' s+'bud']]
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
  =/  upd=away-update  +.hom
  %-  pairs
  :~  :-  %hed
      %-  pairs
      :~  [%pin (enjs-pin pin.hom)]
          [%mod (ship mod.hom)]
      ==
      :-  -.upd
      ?-    -.upd
          %spawn-goal
        %-  pairs
        :~  [%nex (enjs-nex nex.upd)]
            [%id (enjs-id id.upd)]
            [%goal (enjs-goal goal.upd)]
        ==
        ::
        %spawn-pool  (frond %pool (enjs-pool pool.upd))
        ::
        %trash-goal  (frond %id (enjs-id id.upd))
        ::
        %trash-pool  ~
        ::
          %pool-perms
        ?-  +<.upd
          ?(%viewer %chef %peon)  (frond +<.upd (ship ship.upd))
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
          :~  [%yok (enjs-yoke yok.upd)]
              [%nex (enjs-nex nex.upd)]
          ==
        ==
          ?(%goal-perms %goal-hitch %goal-nexus %goal-togls)
        %-  pairs
        :~  [%id (enjs-id id.upd)]
            :-  +>-.upd
            ?-    -.upd
                %goal-perms
              ?-  +>-.upd
                ?(%chef %peon)  (ship ship.upd)
              ==
              ::
                %goal-hitch
              ?-  +>-.upd
                %desc  s+desc.upd
              ==
              ::
                %goal-nexus
              ?-  +>-.upd
                %deadline  ?~(moment.upd ~ s+(scot %da u.moment.upd))
              ==
              ::
                %goal-togls
              ?-  +>-.upd
                %complete  b+complete.upd
                %actionable  b+actionable.upd
              ==
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
      %ryte-bound
    %-  pairs
    :~  [%moment ?~(moment.pyk ~ s+(scot %da u.moment.pyk))]
        [%hereditor (enjs-eid hereditor.pyk)]
    ==
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
      %seniority
    %+  frond
      %senior
    ?~(u-senior.pyk ~ (enjs-id u.u-senior.pyk))
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
  :~  [%directory (enjs-directory directory.store)]
      [%pools (enjs-pools pools.store)]
  ==
::
++  enjs-directory
  =,  enjs:format
  |=  =directory
  :-  %a  %+  turn  ~(tap by directory)
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
          [%birth s+(scot %da birth.pool)]
          [%creator (ship creator.pool)]
      ==
      :-  %perms
      %-  pairs
      :~  [%chefs a+(turn ~(tap in chefs.pool) ship)]
          [%peons a+(turn ~(tap in peons.pool) ship)]
          [%viewers a+(turn ~(tap in viewers.pool) ship)]
      ==
      :-  %nexus
      %-  pairs
      :~  [%goals (enjs-goals goals.pool)]
      ==
      :-  %togls
      %-  pairs
      :~  [%archived b+archived.pool]
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
  |=  [=id nexus=goal-nexus] 
  %-  pairs
  :~  [%id (enjs-id id)]
      [%goal (enjs-goal-nexus nexus)]
  ==
::
++  enjs-goal-nexus
  =,  enjs:format
  |=  nexus=goal-nexus
  ^-  json
  %-  pairs
  :~  [%par ?~(par.nexus ~ (enjs-id u.par.nexus))]
      [%kids a+(turn ~(tap in kids.nexus) enjs-id)]
      [%kickoff (enjs-edge kickoff.nexus)]
      [%deadline (enjs-edge deadline.nexus)]
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
          [%birth s+(scot %da birth.goal)]
          [%author (ship author.goal)]
      ==
      :-  %perms
      %-  pairs
      :~  [%chefs a+(turn ~(tap in chefs.goal) ship)]
          [%peons a+(turn ~(tap in peons.goal) ship)]
      ==
      :-  %nexus
      %-  pairs
      :~  [%par ?~(par.goal ~ (enjs-id u.par.goal))]
          [%kids a+(turn ~(tap in kids.goal) enjs-id)]
          [%kickoff (enjs-edge kickoff.goal)]
          [%deadline (enjs-edge deadline.goal)]
      ==
      :-  %togls
      %-  pairs
      :~  [%complete b+complete.goal]
          [%actionable b+actionable.goal]
          [%archived b+archived.goal]
      ==
      :-  %hitch
      %-  pairs
      :~  [%desc s+desc.goal]
      ==
  ==
::
++  enjs-edge
   =,  enjs:format
   |=  =edge:goal
   ^-  json
   %-  pairs
   :~  [%moment ?~(moment.edge ~ s+(scot %da u.moment.edge))]
       [%inflow a+(turn ~(tap in inflow.edge) enjs-eid)]
       [%outflow a+(turn ~(tap in outflow.edge) enjs-eid)]
   ==
::
++  enjs-eid
  =,  enjs:format
  |=  =eid
  ^-  json
  %-  pairs
  :~  [%edge s+-.eid]
      [%id (enjs-id +.eid)]
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
--
