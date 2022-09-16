/-  gol=goal, goal-store
/+  dbug, default-agent, verb, agentio,
    gol-cli-goals, gol-cli-goal-store, pl=gol-cli-pool,
    gol-cli-etch
|%
+$  versioned-state
  $%  state-0
      state-1
      state-2
      state-3
  ==
+$  state-0  state-0:gol
+$  state-1  state-1:gol
+$  state-2  state-2:gol
+$  state-3  state-3:gol
+$  card  card:agent:gall
--
=|  state-3
=*  state  -
::
%+  verb  |
%-  agent:dbug
^-  agent:gall
=<
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    io    ~(. agentio bowl)
    hc    ~(. +> bowl)
    gs    ~(. gol-cli-goal-store store)
    etch  ~(. gol-cli-etch store)
    directory  directory.store
    pools   pools.store
++  on-init   `this
++  on-save   !>(state)
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-vase)
  |-
  ?-    -.old
      %3
    `this(state old)
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
      =/  action  !<(action:goal-store vase)
      ?-    -.action
          ::
          :: [%new-pool title=@t admins=(set ship) captains=(set ship) viewers=(set ship)]
          %new-pool
        ?>  =(src.bowl our.bowl)
        %+  convert-home-cud:hc  ~
        %:  new-pool:gs
          title.action
          admins.action
          captains.action
          viewers.action
          src.bowl
          our.bowl
          now.bowl
        ==
          ::
          :: [%copy-pool =old=pin title=@t admins=(set ship) captains=(set ship) viewers=(set ship)]
          %copy-pool
        ?>  =(src.bowl our.bowl)
        %+  convert-home-cud:hc  ~
        %:  copy-pool:gs
          old-pin.action
          title.action
          admins.action
          captains.action
          viewers.action
          src.bowl
          our.bowl
          now.bowl
        ==
          ::
          :: [%delete-pool =pin]
          %delete-pool
        ?>  =(src.bowl our.bowl)
        ?.  =(our.bowl owner.pin.action)  ~|(%not-owner !!)
        %+  convert-home-cud:hc
          [%give %kick ~[/[`@`+<.pin.action]/[`@`+>.pin.action]] ~]~
        (delete-pool:gs pin.action our.bowl)
          ::
          :: [%spawn-goal =pin upid=(unit id) desc=@t actionable=? =goal-perms]
          %spawn-goal
        ?.  =(our.bowl owner.pin.action)
          =*  poke-other  ~(poke-other pass:hc /away/spawn-goal)
          :_  state
          [(poke-other owner.pin.action goal-action+!>(action))]~
        %+  convert-away-cud:hc  ~
        %:  spawn-goal:gs
          [pin.action src.bowl]
          [our now]:bowl
          upid.action
          desc.action
          actionable.action
          captains.action
          peons.action
        ==
          ::
          :: [%delete-goal =id]
          %delete-goal
        :: for now, only owner can delete goals
        ?.  =(our.bowl owner.id.action)
          =*  poke-other  ~(poke-other pass:hc /away/spawn-goal)
          :_  state
          [(poke-other owner.id.action goal-action+!>(action))]~
        =/  pool  (~(got by pools.store) (~(got by directory) id.action))
        %+  convert-away-cud:hc  ~
        (delete-goal:gs id.action our.bowl)
          ::
          :: [%edit-goal-desc =id desc=@t]
          %edit-goal-desc
        ?.  =(our.bowl owner.id.action)
          =*  poke-other  ~(poke-other pass:hc /away/edit-goal-desc)
          :_  state
          [(poke-other owner.id.action goal-action+!>(action))]~
        %+  convert-away-cud:hc  ~
        (edit-goal-desc:gs id.action desc.action src.bowl)
          ::
          :: [%edit-pool-title =pin title=@t]
          %edit-pool-title
        ?.  =(our.bowl owner.pin.action)
          =*  poke-other  ~(poke-other pass:hc /away/edit-pool-title)
          :_  state
          [(poke-other owner.pin.action goal-action+!>(action))]~
        %+  convert-away-cud:hc  ~
        (edit-pool-title:gs pin.action title.action src.bowl)
          ::
          :: [%yoke =pin yok=exposed-yoke]
          %yoke
        ?.  =(our.bowl owner.pin.action)
          =*  poke-other  ~(poke-other pass:hc /away/yoke)
          :_  state
          [(poke-other owner.pin.action goal-action+!>(action))]~
        %+  convert-away-cud:hc  ~
        (yoke:gs pin.action yok.action src.bowl)
          ::
          :: [%move-goal =pin cid=id upid=(unit id)]
          %move-goal
        ?.  =(our.bowl owner.pin.action)
          =*  poke-other  ~(poke-other pass:hc /away/move-goal)
          :_  state
          [(poke-other owner.pin.action goal-action+!>(action))]~
        %+  convert-away-cud:hc  ~
        (move-goal:gs pin.action cid.action upid.action src.bowl)
          ::
          :: [%set-deadline =id deadline=(unit @da)]
          %set-deadline
        ?.  =(our.bowl owner.id.action)
          =*  poke-other  ~(poke-other pass:hc /away/set-deadline)
          :_  state
          [(poke-other owner.id.action goal-action+!>(action))]~
        %+  convert-away-cud:hc  ~
        (set-deadline:gs id.action deadline.action src.bowl)
          ::
          :: [%mark-actionable =id]
          %mark-actionable
        ?.  =(our.bowl owner.id.action)
          =*  poke-other  ~(poke-other pass:hc /away/mark-actionable)
          :_  state
          [(poke-other owner.id.action goal-action+!>(action))]~
        %+  convert-away-cud:hc  ~
        (mark-actionable:gs id.action src.bowl)
          ::
          :: [%unmark-actionable =id]
          %unmark-actionable
        ?.  =(our.bowl owner.id.action)
          =*  poke-other  ~(poke-other pass:hc /away/unmark-actionable)
          :_  state
          [(poke-other owner.id.action goal-action+!>(action))]~
        %+  convert-away-cud:hc  ~
        (unmark-actionable:gs id.action src.bowl)
          ::
          :: [%mark-complete =id]
          %mark-complete
        ?.  =(our.bowl owner.id.action)
          =*  poke-other  ~(poke-other pass:hc /away/mark-complete)
          :_  state
          [(poke-other owner.id.action goal-action+!>(action))]~
        %+  convert-away-cud:hc  ~
        (mark-complete:gs id.action our.bowl)
          ::
          :: [%unmark-complete =id]
          %unmark-complete
        ?.  =(our.bowl owner.id.action)
          =*  poke-other  ~(poke-other pass:hc /away/unmark-complete)
          :_  state
          [(poke-other owner.id.action goal-action+!>(action))]~
        %+  convert-away-cud:hc  ~
        (unmark-complete:gs id.action src.bowl)
          ::
          :: [%make-goal-captain captain=ship =id]
          %make-goal-captain
        ?.  =(our.bowl owner.id.action)
          =*  poke-other  ~(poke-other pass:hc /away/make-goal-captain)
          :_  state
          [(poke-other owner.id.action goal-action+!>(action))]~
        %+  convert-away-cud:hc  ~
        (add-goal-captains:gs id.action (sy ~[captain.action]) src.bowl)
          ::
          :: [%make-goal-peon peon=ship =id]
          %make-goal-peon
        ?.  =(our.bowl owner.id.action)
          =*  poke-other  ~(poke-other pass:hc /away-make-goal-peon)
          :_  state
          [(poke-other owner.id.action goal-action+!>(action))]~
        %+  convert-away-cud:hc  ~
        (add-goal-peons:gs id.action (sy ~[peon.action]) src.bowl)
          ::
          :: [%invite invitee=ship =pin]
          %invite
        ?.  =(our.bowl owner.pin.action)  ~|(%not-owner !!)
        =*  poke-other  ~(poke-other pass:hc /invite)
        %+  convert-away-cud:hc
          %+  turn  
            %~  tap  in
            (~(uni in (~(uni in viewers.action) admins.action)) captains.action)
          |=  =ship
          (poke-other ship goal-action+!>([%subscribe pin.action]))
        %:  add-pool-invitees:gs
          pin.action
          viewers.action
          admins.action
          captains.action
          src.bowl
        ==
          ::
          :: [%subscribe =pin]
          %subscribe
        =/  pite  /[`@`+<.pin.action]/[`@`+>.pin.action]
        ?<  =(owner.pin.action our.bowl)
        ?:  (~(has by pools.store) pin.action)  ~|(%already-subscribed !!)
        =*  watch-other  ~(watch-other pass:hc pite)
        :_  state
        :~  (watch-other owner.pin.action pite)
        ==
          ::
          :: [%unsubscribe =pin]
          %unsubscribe
        =/  wire  /[`@`+<.pin.action]/[`@`+>.pin.action]
        ?<  =(owner.pin.action our.bowl)
        =*  leave-other  ~(leave-other pass:hc wire)
        :_  state(store (trash-pool:spawn-trash:etch pin.action))
        :~  (leave-other owner.pin.action)
            (fact:io goal-home-update+!>([[pin.action src.bowl] %trash-pool ~]) ~[/goals])
        ==
      ==
    ==
  [cards this]
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
      [%goals ~]  ?>((team:title our.bowl src.bowl) `this)
      [@ @ ~]
    =/  owner  `@p`i.path
    =/  birth  `@da`i.t.path
    =/  pin  `pin:gol`[%pin owner birth]
    =/  pool  (~(got by pools) pin)
    :_  this
    [%give %fact ~ %goal-away-update !>([our.bowl spawn-pool+pool])]~
  ==
::
++  on-leave  on-leave:def
  :: |=  =path
  :: ^-  (quip card _this)
  :: ?+    path  (on-watch:def path)
  ::     [@ @ ~]
  ::   =/  owner  `@p`i.path
  ::   =/  birth  `@da`i.t.path
  ::   =/  pin  `pin:gol`[%pin owner birth]
  ::   =/  pool  (~(got by pools) pin)
  ::   =/  pore  (apex:pl pool)
  ::   =.  pore  (rem-pool-viewers:pore (sy ~[src.bowl]))
  ::   
  :: ==
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  (on-peek:def path)
      [%x %initial ~]
    ``goal-peek+!>(initial+store)
    ::
      [%x %pool-keys ~]
    ``goal-peek+!>(pool-keys+~(key by pools))
    ::
      [%x %all-goal-keys ~]
    ``goal-peek+!>(all-goal-keys+~(key by directory))
    ::
      [%x %goal @ @ *]
    =/  owner  (slav %p i.t.t.path)
    =/  birth  (slav %da i.t.t.t.path)
    =/  id  `id:gol`[owner birth]
    =/  pin  (~(got by directory) id)
    =/  pool  (~(got by pools) pin)
    =/  goal  (~(got by goals.pool) id)
    ?+    t.t.t.t.path  (on-peek:def path)
        [%harvest ~]
      ``goal-peek+!>(harvest+~(tap in (~(leaf-precedents pl pool) id)))
      ::
        [%get-goal ~]
      ``goal-peek+!>(get-goal+(~(get by goals.pool) id))
      ::
        [%get-pin ~]
      ``goal-peek+!>(get-pin+(~(get by directory) id))
      ::
        [%yung *]
      ?+    t.t.t.t.t.path  (on-peek:def path)
          ~
        ``goal-peek+!>(yung+(hi-to-lo ~(tap in (yung goal))):[~(. pl pool) .])
        ::
          [%uncompleted ~]
        :-  ~  :-  ~  :-  %goal-peek
        !>  :-  %yung-uncompleted
            =+  ~(. pl pool)
            (hi-to-lo ~(tap in ((uncompleted yung) goal)))
        ::
          [%virtual ~]
        :-  ~  :-  ~  :-  %goal-peek
        !>  :-  %yung-virtual
            =+  ~(. pl pool)
            (hi-to-lo ~(tap in (~(dif in (yung goal)) kids.goal)))
      ==
      ::
        [%ryte-bound ~]
      ``goal-peek+!>(ryte-bound+(~(ryte-bound pl pool) [%d id]))
      ::
        [%plumb ~]
      ``goal-peek+!>(plumb+(~(plumb pl pool) id))
      ::
        [%priority ~]
      ``goal-peek+!>(priority+(~(priority pl pool) id))
      ::
        [%seniority @ @ ~]
      =/  mod  (slav %p i.t.t.t.t.t.path)
      =/  cp  i.t.t.t.t.t.t.path
      ?>  ?=(?(%c %p) cp)
      ``goal-peek+!>(seniority+(~(seniority pl pool) mod id cp))
    ==
      [%x %pool @ @ *]
    =/  owner  (slav %p i.t.t.path)
    =/  birth  (slav %da i.t.t.t.path)
    =/  pin  `pin:gol`[%pin owner birth]
    =/  pool  (~(got by pools) pin)
    ?+    t.t.t.t.path  (on-peek:def path)
        [%get-pool ~]
      ``goal-peek+!>(get-pool+(~(get by pools) pin))
      ::
        [%anchor ~]
      ``goal-peek+!>(anchor+~(anchor pl pool))
      ::
        [%roots *]
      ?+    t.t.t.t.t.path  (on-peek:def path)
          ~
        ``goal-peek+!>(roots+~(roots pl pool))
        ::
          [%uncompleted ~]
        ``goal-peek+!>(roots-uncompleted+~(uncompleted-roots pl pool))
      ==
    ==
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [@ @ ~] 
    =/  owner  `@p`i.wire
    =/  birth  `@da`i.t.wire
    =/  pin  `pin:gol`[%pin owner birth]
    ?>  =(src.bowl owner)
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign
        =*  poke-our  ~(poke-our pass:io /invite)
        ((slog 'You\'ve been invited to view a goal!' ~) `this)
      ((slog 'Invite failure.' ~) `this)
        %kick
      %-  (slog '%goal-store: Got kick, resubscribing...' ~)
      :_  this(store (trash-pool:spawn-trash:etch pin))
      :~  (fact:io goal-home-update+!>([[pin src.bowl] %trash-pool ~]) ~[/goals])
          [%pass wire %agent [src.bowl %goal-store] %watch wire]
      ==
        %fact
      ?>  =(p.cage.sign %goal-away-update)
      =/  update  !<(away-update:goal-store q.cage.sign)
      ?+    +<.update  (on-agent:def wire sign)
          %spawn-pool
        :_  this(store (spawn-pool:spawn-trash:etch pin pool.update))
        ~[(fact:io goal-home-update+!>([[pin src.bowl] +.update]) ~[/goals])]
        ::
          $?  %spawn-goal  %trash-goal
              %pool-perms  %pool-hitch  %pool-nexus
              %goal-perms  %goal-hitch  %goal-nexus  %goal-togls
          ==
        =/  pool  (~(got by pools.store) pin)
        =/  pore  (apex:pl pool)
        :_  this(store (update-store:gs pin [+.update]~ pool:abet:(etch:pore +.update)))
        ~[(fact:io goal-home-update+!>([[pin mod.update] +.update]) ~[/goals])]
      ==
    ==
  ==
::
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
|_  =bowl:gall
+*  io  ~(. agentio bowl)
::
++  pass
  |_  =wire
  ++  poke-other
    |=  [other=@p =cage]
    ^-  card
    (~(poke pass:io wire) [other dap.bowl] cage)
  ::
  ++  watch-other
    |=  [other=@p =path]
    ^-  card
    (~(watch pass:io wire) [other dap.bowl] path)
  ::
  ++  leave-other
    |=  other=@p
    ^-  card
    (~(leave pass:io wire) other dap.bowl)
  --
::
++  send-away-updates
  |=  [=pin:gol upd=(list away-update:goal-store)]
  ^-  (list card)
  ?>  =(our.bowl +<.pin)
  %+  turn  upd
  |=  =away-update:goal-store
  (fact:io goal-away-update+!>(away-update) ~[/[`@`+<.pin]/[`@`+>.pin]])
::
++  send-home-updates
  |=  upd=(list home-update:goal-store)
  ^-  (list card)
  %+  turn  upd
  |=  =home-update:goal-store
  (fact:io goal-home-update+!>(home-update) ~[/goals])
::
++  convert-home-cud
  |=  [cards=(list card) =home-cud:goal-store]
  ^-  (quip card _state)
  :_  state(store store.home-cud)
  %+  weld  cards
  (send-home-updates upd.home-cud)
::
++  convert-away-cud
  |=  [cards=(list card) =away-cud:goal-store]
  ^-  (quip card _state)
  :_  state(store store.away-cud)
  ;:  weld
    cards
    (send-away-updates [pin upd]:away-cud)
    %-  send-home-updates
    %+  turn  upd.away-cud
    |=  =away-update:goal-store
    [[pin.away-cud mod.away-update] +.away-update]
  ==
--
