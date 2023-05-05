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
/=  mvs-  /mar/goal/view-send
/=  vak-  /mar/view-ack
::
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
    :: TODO: Reload pool subpaths according to new format
    :: TODO: Clear out views and view-related subpaths
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
      %noun
    ?>  =(our src):bowl
    ?+    q.vase  (on-poke:def mark vase)
        %print-subs
      =;  [gsub=(list ship) asub=(list ship)]
        ~&([goals+gsub ask+asub] `this)
      :-  %+  murn  ~(tap by sup.bowl)
          |=  [duct =ship =path]
          ?.(?=([%goals ~] path) ~ (some ship))
      %+  murn  ~(tap by sup.bowl)
      |=  [duct =ship =path]
      ?.(?=([%goals ~] path) ~ (some ship))
    ==
    ::
      %view-ack
    =/  =vid:views:gol  !<(vid:views:gol vase)
    =/  =view:views:gol  (~(got by views) vid)
    `this(views (~(put by views) vid view(ack &)))
    ::
      %goal-ask
    =/  =ask:gol  !<(ask:gol vase)
    ?.  =(vzn -.ask)
      ~|("incompatible version" !!)
    =^  cards  state
      abet:(handle-ask:emot ask)
    [cards this]
    ::
      %goal-action
    =/  axn=action:gol  !<(action:gol vase)
    ?.  =(vzn -.axn)
      ~|("incompatible version" !!)
    =^  cards  state
      abet:(handle-action:emot axn)
    [cards this]
  ==
::
++  on-watch
  |=  =(pole knot)
  ^-  (quip card _this)
  ?+    pole  (on-watch:def pole)
      [%ask ~]    ~&(%watching-ask ?>(=(src our):bowl `this)) :: one-off ui requests
      [%goals ~]  ~&(%watching-goals ?>(=(src our):bowl `this))
      ::
      [%pool @ @ ~]
    =^  cards  state
      abet:(handle-watch:emot pole)
    [cards this]
      ::
      [%view v=@ ~]
    ?>  =(src our):bowl
    ?>  (~(has by views) (slav %uv v.pole))
    `this
  ==
::
++  on-leave
  |=  =(pole knot)
  ?+    pole  (on-leave:def pole)
      [%ask ~]    ~&(%leaving-ask `this) :: one-off ui requests
      [%goals ~]  ~&(%leaving-goals `this)
      :: TODO: implement on leave for a pool
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %store ~]  ``goal-peek+!>([%store store])
    [%x %views ~]  ``goal-peek+!>([%views views])
    ::
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
      [%pool @ @ ~] 
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
  |=  [=(pole knot) =sign-arvo]
  ^-  (quip card _this)
  ?+    pole  (on-arvo:def pole sign-arvo)
      [%send-dot v=@ ~]
    ?+    sign-arvo  (on-arvo pole sign-arvo)
        [%behn %wake *]
      ~&  %sending-dot
      :_  this
      =/  view-path=path  /view/[v.pole]
      =/  cack-path=path  /check-ack/[v.pole]
      :~  [%give %fact ~[view-path] goal-view-send+!>([%dot ~])]
          [%pass cack-path %arvo %b %wait (add now.bowl ~m1)]
      ==
    ==
    ::
      [%check-ack v=@ ~]
    =/  =vid:views:gol  (slav %uv v.pole)
    ?+    sign-arvo  (on-arvo pole sign-arvo)
        [%behn %wake *]
      ~&  %checking-ack
      ?:  ack:(~(got by views) vid)
        =/  next=@da  (add now.bowl ~m1)
        :_(this [%pass /send-dot/[v.pole] %arvo %b %wait next]~)
      :_  this(views (~(del by views) vid))
      [%give %kick ~[/view/[v.pole]] ~]~
    ==
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
--
