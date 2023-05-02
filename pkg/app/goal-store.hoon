/-  gol=goal
/+  dbug, default-agent, verb, agentio,
    pl=gol-cli-pool, gol-cli-goals, gol-cli-pools,
    gol-cli-emot, gol-cli-node, gol-cli-traverse,
    gol-cli-etch, fl=gol-cli-inflater,
:: import during development to force compilation
::
    gol-cli-json
/=  mak-  /mar/goal/ask
/=  mgs-  /mar/goal/say

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
    emot  ~(. gol-cli-emot bowl ~ state)
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
          %-  ~(gas by *pools:gol)
          %+  turn  ~(tap by pools.store.old)
          |=  [=pin:gol =pool:gol]
          [pin (inflate-pool:fl pool)]
      ==
    =/  now=@  (unique-time now.bowl log)
    `this(state old(log (put:log-orm *log:gol now [%init store.old])))
    ::
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
  ?+    mark  (on-poke:def mark vase)
      %goal-ask
    =/  =ask:gol  !<(ask:gol vase)
    ?.  =(vzn -.ask)
      ~|("incompatible version" !!)
    =^  cards  state
      abet:(handle-ask:hc ask)
    [cards this]
    ::
      %goal-action
    =/  axn=action:gol  !<(action:gol vase)
    ?.  =(vzn -.axn)
      ~|("incompatible version" !!)
    =^  cards  state
      abet:(handle-poke:emot axn)
    [cards this]
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
      [%ask ~]    ?>(=(src our):bowl `this) :: one-off ui requests
      [%goals ~]  ?>(=(src our):bowl `this)
      ::
      [@ @ ~]
    =^  cards  state
      abet:(handle-watch:emot path)
    [cards this]
  ==
::
++  on-leave  on-leave:def
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %store ~]  ``goal-peek+!>([%store store])

      [%x %initial ~]
    |^
    =;  init
      ``goal-peek+!>([%initial init])
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
         ?~  get=(~(get by goals.local.store) id)
           ~
         tags.u.get
        ==
      ==
    --
    ::
      [%x %updates rest=*]
    ?+    rest.pole  (on-peek:def pole)
        [%all ~]
      ``goal-peek+!>(updates+(tap:log-orm log))
      ::
        [%since s=@ ~]
      =/  since=@  (rash s.rest.pole dem)
      ``goal-peek+!>(updates+(tap:log-orm (lot:log-orm log `since ~)))
    ==
    ::
      [%x %pool-keys ~]
    ``goal-peek+!>(pool-keys+~(key by pools))
    ::
      [%x %all-goal-keys ~]
    =;  keys  ``goal-peek+!>(all-goal-keys+keys)
    (turn (tap:idx-orm:gol index) |=([=id:gol pin:gol] id))
    ::
      [%x %goal p=@ da=@ rest=*]
    =/  owner  (slav %p p.pole)
    =/  birth  (slav %da da.pole)
    =/  id  `id:gol`[owner birth]
    ?+    rest.pole  (on-peek:def pole)
        [%descendents ~] :: includes nested
      =/  =pin:gol    (got:idx-orm:gol index id)
      =/  =pool:gol   (~(got by pools) pin)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      =/  descendents=(set id:gol)  (virtual-progeny:tv id)
      =/  =goals:gol
         %-  ~(gas by *goals:gol)
         %+  murn  ~(tap by goals.pool)
         |=  [=id:gol =goal:gol]
         ?.  (~(has in descendents) id)
           ~
         (some [id goal])
      =;  =pools:gol  ``goal-peek+!>(pools+pools)
      (~(put by *pools:gol) pin pool(goals goals))
      ::
        [%hitch ~]
      =/  =pin:gol    (got:idx-orm:gol index id)
      =/  =pool:gol   (~(got by pools) pin)
      =/  =ngoal:gol  (~(got by goals.pool) id)
      ``goal-peek+!>(goal-hitch+hitch.ngoal)
      ::
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
      ``goal-peek+!>(full-harvest+(full-harvest:tv id order.local.store))
      ::
    ==
      [%x %pool p=@ da=@ rest=*]
    =/  owner  (slav %p p.pole)
    =/  birth  (slav %da da.pole)
    =/  pin  `pin:gol`[%pin owner birth]
    ?+    rest.pole  (on-peek:def pole)
        ~
      =;  =pools:gol  ``goal-peek+!>(pools+pools)
      (~(put by *pools:gol) pin (~(got by pools) pin))
      ::
        [%hitch ~]
      ``goal-peek+!>(pool-hitch+hitch:`npool:gol`(~(got by pools) pin))
      ::
        [%harvest ~]
      =/  pool  (~(got by pools) pin)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      ``goal-peek+!>(harvest+~(tap in (goals-harvest:tv)))
      ::
        [%full-harvest ~]
      =/  pool  (~(got by pools) pin)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      ``goal-peek+!>(full-harvest+(full-goals-harvest:tv order.local.store))
    ==
      [%harvest ~]
    =/  tv  ~(. gol-cli-traverse all-goals:etch)
    ``goal-peek+!>(harvest+~(tap in (goals-harvest:tv)))
    ::
      [%full-harvest ~]
    =/  tv  ~(. gol-cli-traverse all-goals:etch)
    ``goal-peek+!>(full-harvest+(full-goals-harvest:tv order.local.store))
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [%away @ @ @ *]
    ?+    -.sign  (on-agent:def wire sign)
        %poke-ack
      ?~  p.sign  `this
      %-  (slog u.p.sign)
      =^  cards  state
        abet:(handle-relay-poke-nack:emot wire u.p.sign)
      [cards this]
    ==
    ::
      [@ @ ~] 
    =/  =pin:gol  (de-pool-path:emot wire)
    ?>  =(src.bowl owner.pin)
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign  `this
      %-  (slog 'Subscribe failure.' ~)
      %-  (slog u.p.sign)
      =^  cards  state
        abet:(handle-pool-watch-nack:emot pin)
      [cards this]
      ::
        %kick
      %-  (slog '%goal-store: Got kick, resubscribing...' ~)
      :_(this [%pass wire %agent [src dap]:bowl %watch wire]~)
      ::
        %fact
      ?>  =(p.cage.sign %goal-away-update)
      =/  upd=away-update:gol  !<(away-update:gol q.cage.sign)
      =^  cards  state
        abet:(handle-etch-pool-update:emot pin upd)
      [cards this]
    ==
  ==
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+  wire  (on-arvo:def wire sign-arvo)
    [%bind-ask ~]  ?>(?=([%eyre %bound %.y *] sign-arvo) `this)
  ==
::
++  on-fail   on-fail:def
--
|_  [=bowl:gall cards=(list card)]
+*  core  .
    etch  ~(. gol-cli-etch store)
++  abet  [(flop cards) state]
++  emit  |=(=card core(cards [card cards]))
++  emil  |=(cadz=(list card) core(cards (weld cadz cards)))
++  handle-ask
  |=  =ask:gol
  ^-  _core
  ?-    -.pok.ask
      %harvest
    ?-    -.type.pok.ask
        %main
      =/  all-goals  (unify-tags all-goals:etch)
      =/  tv  ~(. gol-cli-traverse all-goals)
      =/  goals=(list [id:gol pin:gol goal:gol])
        %+  turn  (full-goals-harvest:tv order.local.store)
        |=  [=id:gol =goal:gol]
        ^-  [id:gol pin:gol goal:gol]
        [id (got:idx-orm:gol index.store id) goal]
      ::
      =?  goals  !=(~ tags.pok.ask)
        (filter-tags method.pok.ask tags.pok.ask goals)
      :: order according to order.local.store
      ::
      (emit %give %fact ~[/ask] goal-say+!>([%harvest goals]))
      ::
        %pool
      =/  pool  (~(got by pools.store) pin.type.pok.ask)
      =.  goals.pool  (unify-tags goals.pool)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      =/  goals=(list [id:gol pin:gol goal:gol])
        %+  turn  (full-goals-harvest:tv order.local.store)
        |=  [=id:gol =goal:gol]
        ^-  [id:gol pin:gol goal:gol]
        [id pin.type.pok.ask goal]
      ::
      =?  goals  !=(~ tags.pok.ask)
        (filter-tags method.pok.ask tags.pok.ask goals)
      :: order according to order.local.store
      ::
      (emit %give %fact ~[/ask] goal-say+!>([%harvest goals]))
      ::
        %goal
      =/  =pin:gol  (got:idx-orm:gol index.store id.type.pok.ask)
      =/  pool  (~(got by pools.store) pin)
      =.  goals.pool  (unify-tags goals.pool)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      =/  goals=(list [id:gol pin:gol goal:gol])
        %+  turn  (full-harvest:tv id.type.pok.ask order.local.store)
        |=  [=id:gol =goal:gol]
        ^-  [id:gol pin:gol goal:gol]
        [id pin goal]
      ::
      =?  goals  !=(~ tags.pok.ask)
        (filter-tags method.pok.ask tags.pok.ask goals)
      :: order according to order.local.store
      ::
      (emit %give %fact ~[/ask] goal-say+!>([%harvest goals]))
    ==
    ::
      %list-view
    ?-    -.type.pok.ask
        %main
      =/  all-goals  (unify-tags all-goals:etch)
      =/  tv  ~(. gol-cli-traverse all-goals)
      =/  nd  ~(. gol-cli-node all-goals)
      ::
      =/  goals=(list [id:gol pin:gol goal:gol])
        :: first-gen-only?
        ::
        ?:  first-gen-only.pok.ask
          %+  turn  (waif-goals:nd)
          |=  =id:gol
          [id (got:idx-orm:gol index.store id) (~(got by all-goals) id)]
        %+  turn  ~(tap by all-goals)
        |=  [=id:gol =goal:gol]
        [id (got:idx-orm:gol index.store id) goal]
      :: actionable-only?
      ::
      =?  goals  actionable-only.pok.ask
        %+  murn  goals
        |=  [id:gol pin:gol =goal:gol]
        ?.(actionable.goal ~ (some +<))
      ::
      =?  goals  !=(~ tags.pok.ask)
        (filter-tags method.pok.ask tags.pok.ask goals)
      :: order according to order.local.store
      ::
      (emit %give %fact ~[/ask] goal-say+!>([%list-view goals]))
      ::
        %pool
      =/  pool  (~(got by pools.store) pin.type.pok.ask)
      =.  goals.pool  (unify-tags goals.pool)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      =/  nd  ~(. gol-cli-node goals.pool)
      ::
      =/  goals=(list [id:gol pin:gol goal:gol])
        :: first-gen-only?
        ::
        ?:  first-gen-only.pok.ask
          %+  turn  (waif-goals:nd)
          |=  =id:gol
          [id pin.type.pok.ask (~(got by goals.pool) id)]
        %+  turn  ~(tap by goals.pool)
        |=  [=id:gol =goal:gol]
        [id pin.type.pok.ask goal]
      :: actionable-only?
      ::
      =?  goals  actionable-only.pok.ask
        %+  murn  goals
        |=  [id:gol pin:gol =goal:gol]
        ?.(actionable.goal ~ (some +<))
      ::
      =?  goals  !=(~ tags.pok.ask)
        (filter-tags method.pok.ask tags.pok.ask goals)
      :: order according to order.local.store
      ::
      (emit %give %fact ~[/ask] goal-say+!>([%list-view goals]))
      ::
        %goal
      =/  =pin:gol  (got:idx-orm:gol index.store id.type.pok.ask)
      =/  pool  (~(got by pools.store) pin)
      =.  goals.pool  (unify-tags goals.pool)
      =/  tv  ~(. gol-cli-traverse goals.pool)
      =/  nd  ~(. gol-cli-node goals.pool)
      ::
      =/  goals=(list [id:gol pin:gol goal:gol])
        =;  ids=(set id:gol)
          %+  turn  ~(tap in ids)
          |=  =id:gol
          [id pin (~(got by goals.pool) id)]
        :: first-gen-only? ignore-virtual?
        ::
        ?:  =([& &] [first-gen-only ignore-virtual.type]:pok.ask)
          kids:(~(got by goals.pool) id.type.pok.ask)
        ?:  =([& |] [first-gen-only ignore-virtual.type]:pok.ask)
          (young:nd id.type.pok.ask)
        ?:  =([| &] [first-gen-only ignore-virtual.type]:pok.ask)
          (progeny:tv id.type.pok.ask)
        ?>  =([| |] [first-gen-only ignore-virtual.type]:pok.ask)
        (virtual-progeny:tv id.type.pok.ask)
      :: actionable-only?
      ::
      =?  goals  actionable-only.pok.ask
        %+  murn  goals
        |=  [id:gol pin:gol =goal:gol]
        ?.(actionable.goal ~ (some +<))
      ::
      =?  goals  !=(~ tags.pok.ask)
        (filter-tags method.pok.ask tags.pok.ask goals)
      :: order according to order.local.store
      ::
      (emit %give %fact ~[/ask] goal-say+!>([%list-view goals]))
    ==
  ==
::
++  filter-tags
  |=  $:  method=?(%any %all)
          tags=(set tag:gol)
          goals=(list [id:gol pin:gol goal:gol])
      ==
  ^-  (list [id:gol pin:gol goal:gol])
  %+  murn  goals
  |=  [=id:gol =pin:gol =goal:gol]
  ^-  (unit [id:gol pin:gol goal:gol])
  ?-    method
      %any
    =-  ?:(- ~ (some id pin goal))
    =(~ (~(int in tags) tags.goal))
    ::
      %all
    =-  ?.(- ~ (some id pin goal))
    =(tags (~(int in tags) tags.goal))
  ==
::
++  unify-tags
  |=  =goals:gol
  ^-  goals:gol
  %-  ~(gas by *goals:gol)
  %+  turn  ~(tap by goals)
  |=  [=id:gol =goal:gol]
  ^-  [id:gol goal:gol]
  :-  id
  %=    goal
      tags
   %-  ~(uni in tags.goal)
   ?~  get=(~(get by goals.local.store) id)
     ~
   tags.u.get
  ==
--
