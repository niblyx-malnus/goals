/-  gol=goal, vyu=views, act=action
/+  dbug, default-agent, verb, agentio, gol-cli-emot, fl=gol-cli-inflater,
:: import during development to force compilation
::
    gol-cli-json
/=  mak-  /mar/goal/ask
/=  mgs-  /mar/goal/say
/=  mvs-  /mar/goal/view-send
/=  vak-  /mar/view-ack
/=  pyk-  /mar/goal/peek
/=  pyk-  /mar/goal/action
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
+$  inflated-state  [state-5 =views:vyu] 
+$  card  card:agent:gall
--
=|  inflated-state
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
    emot  ~(. gol-cli-emot bowl ~ state)
::
++  on-init   on-init:def
++  on-save   !>(-.state)
::
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-vase)
  |-
  ?-    -.old
      %5
    :: TODO: Reload pool subpaths according to new format
    :: leave-and-refollow...
    :-  %+  murn  ~(tap by sup.bowl)
        |=  [=duct =ship =path]
        ?.  ?=([%view *] path)  ~
        (some [%give %kick ~[path] ~])
    %=    this
      views  ~
        -.state
      %=  old
        pools.store
          %-  ~(gas by *pools:gol)
          %+  turn  ~(tap by pools.store.old)
          |=  [=pin:gol =pool:gol]
          [pin (inflate-pool:fl pool)]
      ==
    ==
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
    =/  =vid:vyu  !<(vid:vyu vase)
    =/  [ack=_| =view:vyu]  (~(got by views) vid)
    `this(views (~(put by views) vid [& view]))
    ::
      %goal-ask
    =/  =ask:vyu  !<(ask:vyu vase)
    =^  cards  state
      abet:(handle-ask:emot ask)
    [cards this]
    ::
      %goal-action
    =/  axn=action:act  !<(action:act vase)
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
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %store ~]  ``goal-peek+!>([%store store])
    [%x %views ~]  ``goal-peek+!>([%views views])
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
      :~  [%give %fact ~[view-path] goal-view-send+!>([%dot view-path])]
          [%pass cack-path %arvo %b %wait (add now.bowl ~s1)]
      ==
    ==
    ::
      [%check-ack v=@ ~]
    =/  =vid:vyu  (slav %uv v.pole)
    ?+    sign-arvo  (on-arvo pole sign-arvo)
        [%behn %wake *]
      ~&  %checking-ack
      ?:  ack:(~(got by views) vid)
        =/  [ack=_| =view:vyu]  (~(got by views) vid)
        :_  this(views (~(put by views) vid [| view]))
        =/  next=@da  (add now.bowl ~s1)
        [%pass /send-dot/[v.pole] %arvo %b %wait next]~
      :_  this(views (~(del by views) vid))
      [%give %kick ~[/view/[v.pole]] ~]~
    ==
  ==
::
++  on-fail   on-fail:def
--
|_  [=bowl:gall cards=(list card)]
+*  core  .
++  abet  [(flop cards) state]
++  emit  |=(=card core(cards [card cards]))
++  emil  |=(cadz=(list card) core(cards (weld cadz cards)))
--
