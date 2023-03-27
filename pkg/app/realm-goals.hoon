/-  *realm-goals, m=membership, s=spaces-store, v=visas
/+  gol-cli-scries, dbug, default-agent, verb
:: import to force compilation during development
/=  a-   /mar/realm-goals/action
/=  r-   /mar/realm-goals/reaction
/=  sp-  /mar/space-pools
/=  p-   /mar/pool
|%
+$  versioned-state  $%(state-0)
+$  state-0  [%0 pins=(map space pin:gol)]
+$  card  card:agent:gall
--
::
%-  agent:dbug
%+  verb  |
=|  state-0
=*  state  -
=<
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    scy   ~(. gol-cli-scries bowl)
    hc    ~(. +> [bowl ~])
    cc    |=(cards=(list card) ~(. +> [bowl cards]))
::
++  on-init
  ^-  (quip card _this)
  ?.  has-spaces:hc
    ~&("ERROR: Must have %spaces installed." `this)
  :_  this
  [%pass /spaces %agent [our.bowl %spaces] %watch /updates]~
::
++  on-save  `vase`!>(state)
::
++  on-load
  |=  ole=vase
  ^-  (quip card _this)
  =/  old=state-0  !<(state-0 ole)
  =.  state  old
  =/  remote-spaces
    %+  murn
      ~(tap in ~(key by pins))
    |=(=space ?:(=(-.space our.bowl) ~ (some space)))
  =^  cards  state
    abet:(leave-and-refollow:hc remote-spaces)
  [cards this]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:def mark vase)
      %realm-goals-action
    =/  axn  !<(action vase)
    ?-    -.axn
        %follow-many
      =^  cards  state
        abet:(follow-many:hc spaces.axn)
      [cards this]
    ==
  ==
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  (on-peek:def path)
      [%x %space-pools ~]
    :-  ~  :-  ~  :-  %space-pools  !>
    %-  ~(gas by *(map space pool:gol))
    %+  turn  ~(tap by pins)
    |=  [=space =pin:gol]
    [space (need (get-pool:scy pin))]
    ::
      [%x %space-pool @t @t ~]
    =/  =space  [(slav %p i.t.t.path) i.t.t.t.path]
    ``pool+!>((need (get-pool:scy (~(got by pins) space))))
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [%spaces ~]
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign
        =/  tang  [leaf+"%trove: subscribed to /updates from %spaces."]~
        ((slog tang) `this)
      =/  tang
        :_  u.p.sign
        leaf+"%trove: failed to subscribe to /updates from %spaces."
      ((slog tang) `this)
      ::
        %kick
      :_  this
      [%pass wire %agent [src.bowl %spaces] %watch /updates]~
      ::
        %fact
      ?+    p.cage.sign  `this
          %visas-reaction
        =/  rxn  !<(reaction:v q.cage.sign)
        ?+    -.rxn  `this
            %kicked
          ~&  [path ship]:rxn
          `this

            %edited
          ~&  [path ship]:rxn
          `this
        ==
        ::
          %spaces-reaction
        =/  rxn  !<(reaction:s q.cage.sign)
        ?+    -.rxn  `this
            %initial
          =^  cards  state
            abet:(cof-many:hc ~(tap in ~(key by spaces.rxn)))
          [cards this]
            %add
          =^  cards  state
            abet:(create-or-follow:hc path.space.rxn)
          [cards this]
            %replace
          =^  cards  state
            abet:(create-or-follow:hc path.space.rxn)
          [cards this]
            %remote-space
          =^  cards  state
            abet:(create-or-follow:hc path.space.rxn)
          [cards this]
            %remove
          =^  cards  state
            abet:(delete-or-leave:hc path.rxn)
          [cards this]
        ==
      ==
    == 
    ::
      [@t @t ~]
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign
        %.  `this
        %-  slog
        :_  ~  
        leaf+"%realm-goals-client: joining /{<i.wire>}/{<i.t.wire>} succeeded!"
      %.  `this
      %-  slog
      :_  u.p.sign
      leaf+"%realm-goals-client: joining /{<i.wire>}/{<i.t.wire>} failed!"
    ::
        %kick
      ~&  "{<dap.bowl>}: got kick, resubscribing..."
      :_(this [%pass wire %agent [src.bowl dap.bowl] %watch wire]~)
    ::
        %fact
      =/  away  wire
      =/  space  (de-path wire) :: space-path from wire
      ?+    p.cage.sign  (on-agent:def wire sign)
          %realm-goals-reaction
        =/  rxn  !<(reaction q.cage.sign)
        ?>  =(%pin -.rxn)
        `this(pins (~(put by pins) space pin.rxn))
      ==
    ==
  ==
::
++  on-arvo   on-arvo:def
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
      [@t @t ~]
    =/  space  (de-path path)
    =/  =pin:gol  (~(got by pins) space)
    =/  rxn  `reaction`[%pin pin]
    :_(this [%give %fact ~ realm-goals-reaction+!>(rxn)]~)
  ==
::
++  on-fail   on-fail:def
++  on-leave  on-leave:def
--
::
|_  [=bowl:gall cards=(list card)]
+*  core  .
    io    ~(. agentio bowl)
++  abet  [(flop cards) state]
++  emit  |=(=card core(cards [card cards]))
++  emil  |=(cadz=(list card) core(cards (weld cadz cards)))
::
++  en-path  |=(=space /[(scot %p -.space)]/[+.space])
++  de-path
  |=  path=[i=@ta t=[i=@ta t=~]]
  ^-  space
  [(slav %p i.path) i.t.path]
::
++  create-space
  |=  =space
  ^-  _core
  ?>  =(-.space our.bowl)
  ?:  (~(has by pins) space)  core
  =/  pok  [vzn:gol now.bowl [%spawn-pool +.space]]
  =/  pin  pin+[our now]:bowl
  =.  pins  (~(put by pins) space pin)
  =/  dock  [our.bowl store-agent:gol]
  =.  core  (emit [%pass / %agent dock %poke goal-action+!>(pok)])
  (emit:core %give %fact ~[/updates] realm-goals-reaction+!>(pin+pin))
::
++  follow-space
  |=  =space
  ^-  _core
  ?<  =(-.space our.bowl)
  =/  pite  /[(scot %p -.space)]/[+.space]
  (emit [%pass pite %agent [-.space %realm-goals] %watch pite])
::
++  create-or-follow
  |=  =space
  ^-  _core
  ?:  =(-.space our.bowl)
    (create-space space)
  (follow-space space)
::
++  delete-space
  |=  =space
  ^-  _core
  ?>  =(-.space our.bowl)
  ?.  (~(has by pins) space)  core
  =.  pins  (~(del by pins) space)
  =/  pok   [vzn:gol now.bowl [%trash-pool (~(got by pins) space)]]
  =/  dock  [our.bowl store-agent:gol]
  (emit [%pass / %agent dock %poke goal-action+!>(pok)])
::
++  leave-space
  |=  =space
  ^-  _core
  ?<  =(-.space our.bowl)
  =.  pins  (~(del by pins) space)
  =/  wire  /[(scot %p -.space)]/[+.space]
  (emit [%pass wire %agent [-.space %realm-goals] %leave ~])
::
++  delete-or-leave
  |=  =space
  ^-  _core
  ?:  =(-.space our.bowl)
    (delete-space space)
  (leave-space space)
::
++  follow-many
  |=  spaces=(list space)
  ^-  _core
  ?~  spaces  core
  $(spaces t.spaces, core (follow-space:core i.spaces))
::
++  leave-many
  |=  spaces=(list space)
  ^-  _core
  ?~  spaces  core
  $(spaces t.spaces, core (leave-space:core i.spaces))
::
++  leave-and-refollow
  |=  spaces=(list space)
  ^-  _core
  %-  emit:(leave-many spaces)
  :*  %pass  /  %agent  [our dap]:bowl  %poke
      realm-goals-action+!>([%follow-many spaces])
  ==
::
++  cof-many
  |=  spaces=(list space)
  ^-  _core
  ?~  spaces  core
  $(spaces t.spaces, core (create-or-follow:core i.spaces))
::
++  sour  (scot %p our.bowl)
++  snow  (scot %da now.bowl)
::
++  has-spaces  .^(? %gu /[sour]/spaces/[snow])
::
++  is-member
  |=  [=space =ship]
  ^-  ?
  =/  ship  (scot %p ship)
  =/  host  (scot %p -.space)
  =/  view 
    .^(view:m %gx /[sour]/spaces/[snow]/[host]/[+.space]/is-member/[ship]/membership-view)
  ?>(?=(%is-member -.view) is-member.view)
::
++  got-member
  |=  [=space =ship]
  ^-  member:m
  =/  ship  (scot %p ship)
  =/  host  (scot %p -.space)
  =/  view 
    .^(view:m %gx /[sour]/spaces/[snow]/[host]/[+.space]/members/[ship]/membership-view)
  ?>(?=(%member -.view) member.view)
::
++  is-admin
  |=  [=space =ship]
  ^-  ?
  =/  =member:m  (got-member space ship)
  (~(has in roles.member) %admin)
--
