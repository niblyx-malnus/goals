/-  gol=goal
/+  dbug, default-agent, verb, agentio,
    pl=gol-cli-pool, gol-cli-goals, gol-cli-pools,
    em=gol-cli-emot, gol-cli-node, gol-cli-traverse,
    gol-cli-etch,
:: import during development to force compilation
::
    gol-cli-json
|%
+$  state-0  state-0:gol
+$  state-1  state-1:gol  
+$  state-2  state-2:gol
+$  state-3  state-3:gol
+$  state-4  state-4:gol
+$  state-5  state-5:gol
+$  versioned-state
  $%  state-0
      state-1
      state-2
      state-3
      state-4
      state-5
  ==
+$  card  card:agent:gall
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
--
=|  state-5
=*  state  -
=*  vzn  vzn:gol
::
%+  verb  |
%-  agent:dbug
^-  agent:gall
=<
|_  =bowl:gall
+*  this    .
    def   ~(. (default-agent this %.n) bowl)
    io    ~(. agentio bowl)
    hc    ~(. +> [bowl ~])
    cc    |=(cards=(list card) ~(. +> [bowl cards]))
    gols  ~(. gol-cli-goals store)
    puls  ~(. gol-cli-pools store)
    etch  ~(. gol-cli-etch store)
    index   index.store
    pools   pools.store
    cache   cache.store
::
++  on-init   
  ^-  (quip card _this)
  =/  now=@  (unique-time now.bowl log)
  `this(log (put:log-orm *log:gol now [%init store]))
::
++  on-save   !>(state)
::
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-vase)
  |-
  ?-    -.old
      %5
    :: TODO: Reload subscriptions according to new format
    =.  old
      %=  old
        pools.store
          %-  ~(run by pools.store.old)
          |=  =pool:gol
          ^-  pool:gol
          pool:abet:(inflater:(apex:em pool))
      ==
    =/  now=@  (unique-time now.bowl log)
    `this(state old(log (put:log-orm *log:gol now [%init store.old])))
      %4
    $(old (convert-4-to-5:gol old))
      %3
    $(old (convert-3-to-4:gol old))
      %2
    $(old (convert-2-to-3:gol old))
      %1
    $(old (convert-1-to-2:gol old))
      %0
    $(old (convert-0-to-1:gol old))
  ==
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  =^  cards  state
    ?+    mark  (on-poke:def mark vase)
        %goal-action
      =/  action=action:gol  !<(action:gol vase)
      ?.  =(vzn -.action)  :: assert pokes are correct version
        ~|("incompatible version" !!)
      =/  pid  pid.action
      =/  pok  pok.action
      ?-    -.pok
          %put-private-tags
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?>  =(src our):bowl
        ?>  (~(all in tags.pok) |=(=tag:gol private.tag)) 
        =/  gl=goal-local:gol  (~(got by local.store) id.pok)
        =.  tags.gl  tags.pok
        :_  state(local.store (~(put by local.store) id.pok gl))
        =/  hom=home-update:gol
          [[pin our.bowl pid] vzn %goal-hitch id.pok %put-tags tags.pok]
        [%give %fact ~[/goals] goal-home-update+!>(hom)]~
        ::
          %add-field-type
        ?.  =(owner.pin.pok our.bowl)  abet:(relay pin.pok action)
        =/  pore
          %-  add-field-type:(apex-em:hc pin.pok)
          [field.pok field-type.pok src.bowl]
        abet:(send-away-updates:hc ~ [pin.pok src.bowl pid] efx:abet:pore)
        ::
          %del-field-type
        ?.  =(owner.pin.pok our.bowl)  abet:(relay pin.pok action)
        =/  pore  (del-field-type:(apex-em:hc pin.pok) field.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin.pok src.bowl pid] efx:abet:pore)
        ::
          %add-field-data
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        =/  pore
          %-  add-field-data:(apex-em:hc pin)
          [id.pok field.pok field-data.pok src.bowl]
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
        ::
          %del-field-data
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        =/  pore  (del-field-data:(apex-em:hc pin) id.pok field.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
        ::
          %add-goal-tag
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        ?<  private.tag.pok
        =/  pore  (add-goal-tag:(apex-em:hc pin) id.pok tag.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
        ::
          %del-goal-tag
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        ?<  private.tag.pok
        =/  pore  (del-goal-tag:(apex-em:hc pin) id.pok tag.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
        ::
          %put-goal-tags
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        ?>  (~(all in tags.pok) |=(=tag:gol !private.tag)) 
        =/  pore  (put-goal-tags:(apex-em:hc pin) id.pok tags.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
          :: [%edit-goal-note =id note=@t]
          ::
          %edit-goal-note
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        =/  pore  (edit-goal-note:(apex-em:hc pin) id.pok note.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
          :: [%edit-pool-note =pin note=@t]
          ::
          %edit-pool-note
        ?.  =(owner.pin.pok our.bowl)  abet:(relay pin.pok action)
        =/  pore  (edit-pool-note:(apex-em:hc pin.pok) note.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin.pok src.bowl pid] efx:abet:pore)
          ::
          %spawn-pool
        ?>  =(src.bowl our.bowl)
        =+  [pin pool]=(spawn-pool:puls title.pok src.bowl now.bowl)
        =/  upds=(list update:gol)  [vzn %spawn-pool pool]~
        abet:(send-home-updates:hc ~ [pin src.bowl pid] upds)
          ::
          %clone-pool
        ?>  =(src.bowl our.bowl)
        =+  ^=  [pin pool]
          (clone-pool:puls pin.pok title.pok src.bowl now.bowl)
        =/  upds=(list update:gol)  [vzn %spawn-pool pool]~
        abet:(send-home-updates:hc ~ [pin src.bowl pid] upds)
          ::
          :: [%cache-pool =pin]
          %cache-pool
        ?>  =(src.bowl our.bowl)
        ?>  =(src.bowl owner.pin.pok)
        =/  cards=(list card)  [%give %kick ~[(en-pool-path:hc pin.pok)] ~]~
        =/  upds=(list update:gol)  [vzn %cache-pool pin.pok]~
        abet:(send-home-updates:hc cards [pin.pok src.bowl pid] upds)
          ::
          :: [%renew-pool =pin]
          %renew-pool
        ?>  =(src.bowl our.bowl)
        ?>  =(src.bowl owner.pin.pok)
        =/  pool  (~(got by cache) pin.pok)
        =/  upds=(list update:gol)  [vzn %renew-pool pin.pok pool]~
        abet:(send-home-updates:hc ~ [pin.pok src.bowl pid] upds)
          ::
          :: [%trash-pool =pin]
          %trash-pool
        ?>  =(src.bowl our.bowl)
        ?>  =(src.bowl owner.pin.pok)
        =/  cards=(list card)  [%give %kick ~[(en-pool-path:hc pin.pok)] ~]~
        =/  upds=(list update:gol)
          ?:  (~(has by pools) pin.pok)  [vzn %waste-pool ~]~
          ?>  (~(has by cache) pin.pok)  [vzn %trash-pool ~]~
        abet:(send-home-updates:hc cards [pin.pok src.bowl pid] upds)
          ::
          :: [%spawn-goal =pin upid=(unit id) desc=@t actionable=?]
          %spawn-goal
        ?.  =(owner.pin.pok our.bowl)  abet:(relay pin.pok action)
        =/  =id:gol  (unique-id:gols [our.bowl now.bowl])
        =/  pore
          %:  spawn-goal-fixns:(apex-em:hc pin.pok)
            id
            upid.pok
            desc.pok
            actionable.pok
            src.bowl
          ==
        abet:(send-away-updates:hc ~ [pin.pok src.bowl pid] efx:abet:pore)
          ::
          :: [%cache-goal =id]
          %cache-goal
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        =/  pore  (cache-goal:(apex-em:hc pin) id.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
          ::
          :: [%renew-goal =id]
          %renew-goal
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        =/  pore  (renew-goal:(apex-em:hc pin) id.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
          ::
          :: [%trash-goal =id]
          %trash-goal
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        =/  pore  (trash-goal:(apex-em:hc pin) id.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
          ::
          :: [%edit-goal-desc =id desc=@t]
          %edit-goal-desc
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        =/  pore  (edit-goal-desc:(apex-em:hc pin) id.pok desc.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
          ::
          :: [%edit-pool-title =pin title=@t]
          %edit-pool-title
        ?.  =(owner.pin.pok our.bowl)  abet:(relay pin.pok action)
        =/  pore  (edit-pool-title:(apex-em:hc pin.pok) title.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin.pok src.bowl pid] efx:abet:pore)
          ::
          :: [%yoke =pin yoks=(list plex)]
          %yoke
        ?.  =(owner.pin.pok our.bowl)  abet:(relay pin.pok action)
        =/  pore  (plex-sequence:(apex-em:hc pin.pok) yoks.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin.pok src.bowl pid] efx:abet:pore)
          ::
          :: [%move cid=id upid=(unit id)]
          %move
        =/  pin  (got:idx-orm:gol index.store cid.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        =/  pore  (move:(apex-em:hc pin) cid.pok upid.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
          ::
          :: [%set-kickoff =id kickoff=(unit @da)]
          %set-kickoff
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        =/  pore  (set-kickoff:(apex-em:hc pin) id.pok kickoff.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
          ::
          :: [%set-deadline =id deadline=(unit @da)]
          %set-deadline
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        =/  pore  (set-deadline:(apex-em:hc pin) id.pok deadline.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
          ::
          :: [%mark-actionable =id]
          %mark-actionable
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        =/  pore  (mark-actionable:(apex-em:hc pin) id.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
          ::
          :: [%unmark-actionable =id]
          %unmark-actionable
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        =/  pore  (unmark-actionable:(apex-em:hc pin) id.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
          ::
          :: [%mark-complete =id]
          %mark-complete
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        =/  pore  (mark-complete:(apex-em:hc pin) id.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
          ::
          :: [%unmark-complete =id]
          %unmark-complete
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        =/  pore  (unmark-complete:(apex-em:hc pin) id.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
          ::
          :: [%update-goal-perms =id chief=ship rec=?(%.y %.n) spawn=(set ship)]
          %update-goal-perms
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        =/  pore
          %:  update-goal-perms:(apex-em:hc pin)
            id.pok
            chief.pok
            rec.pok
            spawn.pok
            src.bowl
          ==
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
          ::
          %reorder-young
        =/  pin  (got:idx-orm:gol index.store id.pok)
        ?.  =(owner.pin our.bowl)  abet:(relay pin action)
        =/  pore  (reorder-young:(apex-em:hc pin) id.pok young.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin src.bowl pid] efx:abet:pore)
          ::
          %reorder-roots
        ?.  =(owner.pin.pok our.bowl)  abet:(relay pin.pok action)
        =/  pore  (reorder-roots:(apex-em:hc pin.pok) roots.pok src.bowl)
        abet:(send-away-updates:hc ~ [pin.pok src.bowl pid] efx:abet:pore)
          ::
          :: [%update-pool-perms =pin new=pool-perms]
          %update-pool-perms
        ?.  =(owner.pin.pok our.bowl)  abet:(relay pin.pok action)
        =/  pore  (update-pool-perms:(apex-em:hc pin.pok) new.pok src.bowl)
        abet:(send-away-updates:hc cards [pin.pok src.bowl pid] efx:abet:pore)
          ::
          :: [%subscribe =pin]
          %subscribe
        ?>  =(src our):bowl
        ?<  =(owner.pin.pok our.bowl)
        =/  pite  (en-pool-path:hc pin.pok)
        =/  =dock  [owner.pin.pok dap.bowl]
        :_(state [%pass pite %agent dock %watch pite]~)
          ::
          :: [%unsubscribe =pin]
          %unsubscribe
        ?<  =(owner.pin.pok our.bowl)
        =/  =wire  (en-pool-path:hc pin.pok)
        =/  cards=(list card)
          [%pass wire %agent [owner.pin.pok dap.bowl] %leave ~]~
        =/  upds=(list update:gol)
          ?:  (~(has by cache) pin.pok)  [vzn %trash-pool ~]~
          ?:  (~(has by pools) pin.pok)  [vzn %waste-pool ~]~
          ~
        abet:(send-home-updates:hc cards [pin.pok src.bowl pid] upds)
      ==
    ==
  [cards this]
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
      [%goals ~]  ?>(=(src our):bowl `this)
      ::
      [@ @ ~]
    =/  owner  `@p`i.path
    =/  birth  `@da`i.t.path
    =/  pin  `pin:gol`[%pin owner birth]
    =/  pool  (~(got by pools) pin)
    ?>  (~(has by perms.pool) src.bowl)
    =/  way=away-update:gol  [[our.bowl 0] vzn spawn-pool+pool]
    :_(this [%give %fact ~ goal-away-update+!>(way)]~)
  ==
::
++  on-leave  on-leave:def
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  (on-peek:def path)
      [%x %initial ~]
    |^
    :-  ~  :-  ~  :-  %goal-peek
    !>  :-  %initial
    %=  store
      pools  (unify-tags pools)
      cache  (unify-tags cache)
    ==
    ++  unify-tags
      |=  =pools:gol
      ^-  pools:gol
      %-  ~(gas by *pools:gol)
      %+  turn  ~(tap by pools)
      |=  [=pin:gol =pool:gol]
      ^-  [pin:gol pool:gol]
      :-  pin
      %=    pool
          goals
        %-  ~(gas by *goals:gol)
        %+  turn  ~(tap by goals.pool)
        |=  [=id:gol =goal:gol]
        ^-  [id:gol goal:gol]
        :-  id
        %=    goal
            tags
         %-  ~(uni in tags.goal)
         ?~  get=(~(get by local.store) id)
           ~
         tags.u.get
        ==
      ==
    --
    ::
      [%x %updates *]
    ?+    t.t.path  (on-peek:def path)
        [%all ~]
      ``goal-peek+!>(updates+(tap:log-orm log))
      ::
        [%since @ ~]
      =/  since=@  (rash i.t.t.t.path dem)
      ``goal-peek+!>(updates+(tap:log-orm (lot:log-orm log `since ~)))
    ==
    ::
      [%x %pool-keys ~]
    ``goal-peek+!>(pool-keys+~(key by pools))
    ::
      [%x %all-goal-keys ~]
    :-  ~  :-  ~  :-  %goal-peek
    !>(all-goal-keys+(turn (tap:idx-orm:gol index) |=([=id:gol pin:gol] id)))
    ::
      [%x %goal @ @ *]
    =/  owner  (slav %p i.t.t.path)
    =/  birth  (slav %da i.t.t.t.path)
    =/  id  `id:gol`[owner birth]
    ?+    t.t.t.t.path  (on-peek:def path)
        [%harvest ~]
      =/  pin  (got:idx-orm:gol index id)
      =/  pool  (~(got by pools) pin)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      ``goal-peek+!>(harvest+~(tap in (harvest:tv id)))
      ::
        [%full-harvest ~]
      =/  pin  (got:idx-orm:gol index id)
      =/  pool  (~(got by pools) pin)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      ``goal-peek+!>(full-harvest+(full-harvest:tv id))
      ::
        [%get-goal ~]
      =/  upin  (get:idx-orm:gol index id)
      ?~  upin
        ``goal-peek+!>(get-goal+~)
      =/  pool  (~(got by pools) u.upin)
      =/  goal  (~(got by goals.pool) id)
      ``goal-peek+!>(get-goal+(~(get by goals.pool) id))
      ::
        [%get-pin ~]
      ``goal-peek+!>(get-pin+(get:idx-orm:gol index id))
      ::
        [%yung *]
      =/  pin  (got:idx-orm:gol index id)
      =/  pool  (~(got by pools) pin)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      =/  nd  ~(. gol-cli-node goals.pool)
      ?+    t.t.t.t.t.path  (on-peek:def path)
          ~
        ``goal-peek+!>(yung+(hi-to-lo:tv (yung:nd id)))
        ::
          [%uncompleted ~]
        :-  ~  :-  ~  :-  %goal-peek
        !>  :-  %yung-uncompleted
            (hi-to-lo:tv (incomplete:nd (yung:nd id)))
        ::
          [%virtual ~]
        :-  ~  :-  ~  :-  %goal-peek
        !>  :-  %yung-virtual
            (hi-to-lo:tv (virt:nd id))
      ==
      ::
        [%ryte-bound ~]
      =/  pin  (got:idx-orm:gol index id)
      =/  pool  (~(got by pools) pin)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      ``goal-peek+!>(ryte-bound+(ryte-bound:tv [%d id]))
      ::
        [%plumb ~]
      =/  pin  (got:idx-orm:gol index id)
      =/  pool  (~(got by pools) pin)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      ``goal-peek+!>(plumb+(plumb:tv id))
      ::
        [%priority ~]
      =/  pin  (got:idx-orm:gol index id)
      =/  pool  (~(got by pools) pin)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      ``goal-peek+!>(priority+(priority:tv id))
    ==
      [%x %pool @ @ *]
    =/  owner  (slav %p i.t.t.path)
    =/  birth  (slav %da i.t.t.t.path)
    =/  pin  `pin:gol`[%pin owner birth]
    ?+    t.t.t.t.path  (on-peek:def path)
        [%get-pool ~]
      :-  ~  :-  ~  :-  %goal-peek
      !>  :-  %get-pool
      =/  gep  (~(get by pools) pin)
      ?~  gep
        (~(get by cache) pin)
      gep
      ::
        [%anchor ~]
      =/  pool  (~(got by pools) pin)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      ``goal-peek+!>(anchor+(anchor:tv))
      ::
        [%roots *]
      =/  pool  (~(got by pools) pin)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      =/  nd  ~(. gol-cli-node goals.pool)
      ?+    t.t.t.t.t.path  (on-peek:def path)
          ~
        ``goal-peek+!>(roots+(hi-to-lo:tv (root-goals:nd)))
        ::
          [%uncompleted ~]
        :-  ~  :-  ~  :-  %goal-peek
        !>  :-  %roots-uncompleted
        (hi-to-lo:tv (incomplete:nd (root-goals:nd)))
      ==
    ==
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [%away @ @ @ *]
    =/  [pid=@ =pin:gol =term]  (de-relay-wire:hc wire)
    ?>  =(src.bowl owner.pin)
    ?+    -.sign  (on-agent:def wire sign)
        %poke-ack
      ?~  p.sign  `this
      =^  cards  state
        %-  (slog u.p.sign)
        =/  upds=(list update:gol)  [vzn %poke-error u.p.sign]~
        abet:(send-home-updates:hc ~ [pin src.bowl pid] upds)
      [cards this]
    ==
    ::
      [@ @ ~] 
    =/  =pin:gol  (de-pool-path wire)
    ?>  =(src.bowl owner.pin)
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign  `this
      =/  upd
        ?:  (~(has by pools) pin)
          (some [vzn %waste-pool ~])
        ?:  (~(has by cache) pin)
          (some [vzn %trash-pool ~])
        ~
      %-  (slog 'Subscribe failure.' ~)
      %-  (slog u.p.sign)
      ?~  upd  `this
      =^  cards  state
        abet:(send-home-updates:hc ~ [pin our.bowl 0] [u.upd]~)
      [cards this]
      ::
        %kick
      %-  (slog '%goal-store: Got kick, resubscribing...' ~)
      :_(this [%pass wire %agent [src dap]:bowl %watch wire]~)
      ::
        %fact
      ?>  =(p.cage.sign %goal-away-update)
      =/  [[mod=ship pid=@] =update:gol]  !<(away-update:gol q.cage.sign)
      ?.  =(vzn -.update)  :: assert updates are correct version
        ~|("incompatible version" !!)
      =^  cards  state
        abet:(send-home-updates:hc ~ [pin mod 0] [update]~)
      [cards this]
    ==
  ==
::
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
|_  [=bowl:gall cards=(list card)]
+*  core  .
    etch  ~(. gol-cli-etch store)
++  abet  [(flop cards) state]
++  emit  |=(=card core(cards [card cards]))
++  emil  |=(cadz=(list card) core(cards (weld cadz cards)))
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
  ^-  _core
  ?>  =(src our):bowl
  =/  =wire  (en-relay-wire pid.axn pin -.pok.axn)
  =/  =dock  [owner.pin dap.bowl]
  (emit %pass wire %agent dock %poke goal-action+!>(axn))
::
++  apex-em  |=(=pin:gol (apex:em (~(got by pools.store) pin)))
::
++  etch-updt
  |=  [[=pin:gol mod=ship pid=@] =update:gol]
  ^-  _core
  core(store (etch:etch pin ~[update]))
::
++  etch-upds
  |=  [[=pin:gol mod=ship pid=@] upds=(list update:gol)]
  ^-  _core
  ?~  upds  core
  $(upds t.upds, core (etch-updt:core [pin mod pid] i.upds))
::
++  home-emit
  |=  [[=pin:gol mod=ship pid=@] =update:gol]
  ^-  _core
  =/  hom=home-update:gol  [[pin mod pid] update]
  =.  store      (etch:etch pin ~[update])
  =/  now=@      (unique-time now.bowl log)
  =.  log.state  (put:log-orm log.state now [%updt hom])
  (emit %give %fact ~[/goals] goal-home-update+!>(hom))
::
++  home-emil
  |=  [[=pin:gol mod=ship pid=@] upds=(list update:gol)]
  ^-  _core
  ?~  upds  core
  $(upds t.upds, core (home-emit:core [pin mod pid] i.upds))
::
++  send-home-updates
  |=  [cards=(list card) [=pin:gol mod=ship pid=@] upds=(list update:gol)]
  ^-  _core
  =.  core  (emil cards)
  (home-emil:core [pin mod pid] upds)
::
++  away-emit
  |=  [[=pin:gol mod=ship pid=@] =update:gol]
  ^-  _core
  =/  way=away-update:gol  [[mod pid] update]
  =/  path  (en-pool-path pin)
  =.  core  (home-emit [pin mod pid] update)
  (emit:core %give %fact ~[path] goal-away-update+!>(way))
::
++  away-emil
  |=  [[=pin:gol mod=ship pid=@] upds=(list update:gol)]
  ^-  _core
  ?~  upds  core
  $(upds t.upds, core (away-emit:core [pin mod pid] i.upds))
::
++  send-away-updates
  |=  [cards=(list card) [=pin:gol mod=ship pid=@] upds=(list update:gol)]
  ^-  _core
  =.  core  (emil cards)
  =.  core  (away-emil:core [pin mod pid] upds)
  (kick-unwelcome:core pin)
:: kick people without member perms
::
++  kick-unwelcome
  |=  =pin:gol
  ^-  _core
  %-  emil
  %+  murn  ~(val by sup.bowl)
  |=  [=ship =path]
  ?.  ?=([@ta @ta ~] path)  ~
  =/  =pin:gol  (de-pool-path path)
  =/  =pool:gol  (~(got by pools.store) pin)
  ?:  (~(has by perms.pool) ship)  ~
  (some [%give %kick ~[path] `ship])
--
