/-  gol=goal
/+  dbug, default-agent, verb, agentio,
    pl=gol-cli-pool, gol-cli-goals, gol-cli-pools,
    gol-cli-emot, gol-cli-node, gol-cli-traverse,
    gol-cli-etch, fl=gol-cli-inflater,
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
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  (on-peek:def path)
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
    =;  keys  ``goal-peek+!>(all-goal-keys+keys)
    (turn (tap:idx-orm:gol index) |=([=id:gol pin:gol] id))
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
      ``goal-peek+!>(full-harvest+(full-harvest:tv id order.local.store))
      ::
    ==
      [%x %pool @ @ *]
    =/  owner  (slav %p i.t.t.path)
    =/  birth  (slav %da i.t.t.t.path)
    =/  pin  `pin:gol`[%pin owner birth]
    ?+    t.t.t.t.path  (on-peek:def path)
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
    =/  tv  ~(. gol-cli-traverse all-goals:emot)
    ``goal-peek+!>(harvest+~(tap in (goals-harvest:tv)))
    ::
      [%full-harvest ~]
    =/  tv  ~(. gol-cli-traverse all-goals:emot)
    ``goal-peek+!>(full-harvest+(full-goals-harvest:tv order.local.store))
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
      :: TODO: purge goals from local
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
