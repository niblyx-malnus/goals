/-  gol=goal, goal-store
/+  dbug, default-agent, verb, agentio,
    gol-cli-goals, gol-cli-goal-store, pl=gol-cli-pool,
    gol-cli-etch
|%
+$  versioned-state
  $%  state-0
      state-1
      state-2
  ==
+$  state-0  state-0:gol
+$  state-1  state-1:gol
+$  state-2  state-2:gol
+$  card  card:agent:gall
--
=|  state-2
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
      %2
    `this(state old)
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
          :: [%new-pool title=@t chefs=(set ship) peons=(set ship) viewers=(set ship)]
          %new-pool
        ?>  =(src.bowl our.bowl)
        %+  convert-home-cud:hc
          ~
        %:  new-pool:gs
          title.action
          chefs.action
          peons.action
          viewers.action
          src.bowl
          our.bowl
          now.bowl
        ==
          ::
          :: [%copy-pool =old=pin title=@t chefs=(set ship) peons=(set ship) viewers=(set ship)]
          %copy-pool
        ?>  =(src.bowl our.bowl)
        %+  convert-home-cud:hc
          ~
        %:  copy-pool:gs
          old-pin.action
          title.action
          chefs.action
          peons.action
          viewers.action
          src.bowl
          our.bowl
          now.bowl
        ==
          ::
          :: [%delete-pool =pin]
          %delete-pool
        ?>  =(src.bowl our.bowl)
        ?>  =(our.bowl owner.pin.action)
        %+  convert-home-cud:hc
          [%give %kick ~[/[`@`+<.pin.action]/[`@`+>.pin.action]] ~]~
        (delete-pool:gs pin.action our.bowl)
          ::
          :: [%new-goal =pin desc=@t chefs=(set ship) peons=(set ship) deadline=(unit @da) actionable=?]
          %new-goal
        ?>  =(our.bowl owner.pin.action)
        %+  convert-away-cud:hc 
          ~
        %:  new-goal:gs
          pin.action
          desc.action
          chefs.action
          peons.action
          deadline.action
          actionable.action
          src.bowl
          now.bowl
        ==
          ::
          :: [%add-under =id desc=@t chefs=(set ship) peons=(set ship) deadline=(unit @da) actionable=?]
          %add-under
        ?>  =(our.bowl owner.id.action)
        %+  convert-away-cud:hc 
          ~
        %:  add-under:gs
          id.action
          desc.action
          chefs.action
          peons.action
          deadline.action
          actionable.action
          src.bowl
          now.bowl
        ==
          ::
          :: [%delete-goal =id]
          %delete-goal
        :: for now, only owner can delete goals
        ?>  =(src.bowl our.bowl)
        ?>  =(our.bowl owner.id.action)
        %+  convert-away-cud:hc  ~
        (delete-goal:gs id.action our.bowl)
          ::
          :: [%edit-goal-desc =id desc=@t]
          %edit-goal-desc
        ?>  =(our.bowl owner.id.action)
        %+  convert-away-cud:hc  ~
        (edit-goal-desc:gs id.action desc.action src.bowl)
          ::
          :: [%edit-pool-title =pin title=@t]
          %edit-pool-title
        ?>  =(our.bowl owner.pin.action)
        %+  convert-away-cud:hc  ~
        (edit-pool-title:gs pin.action title.action src.bowl)
          ::
          :: [%yoke =pin yok=exposed-yoke]
          %yoke
        ?>  =(our.bowl owner.pin.action)
        =/  pool  (~(got by pools.store) pin.action)
        =/  out  (~(apply-sequence pl pool) src.bowl [yok.action]~)
        ?-    -.out
          %|  ~|(+.out !!)
            %&
          =/  nex
            %-  ~(gas by *(map id:gol goal-nexus:gol))
            %+  turn  ~(tap in set.p.out)
            |=(=id:gol [id nexus:`ngoal:gol`(~(got by goals.pool.p.out) id)])
          %+  convert-away-cud:hc  ~
          :+  pin.action
            [%pool-nexus %yoke yok.action nex]
          store(pools (~(put by pools.store) pin.action pool.p.out))
        ==
          ::
          :: [%set-deadline =id deadline=(unit @da)]
          %set-deadline
        ?>  =(our.bowl owner.id.action)
        %+  convert-away-cud:hc  ~
        (set-deadline:gs id.action deadline.action src.bowl)
          ::
          :: [%mark-actionable =id]
          %mark-actionable
        ?>  =(our.bowl owner.id.action)
        %+  convert-away-cud:hc  ~
        (mark-actionable:gs id.action src.bowl)
          ::
          :: [%unmark-actionable =id]
          %unmark-actionable
        ?>  =(our.bowl owner.id.action)
        %+  convert-away-cud:hc  ~
        (unmark-actionable:gs id.action src.bowl)
          ::
          :: [%mark-complete =id]
          %mark-complete
        ?>  =(our.bowl owner.id.action)
        %+  convert-away-cud:hc  ~
        (mark-complete:gs id.action our.bowl)
          ::
          :: [%unmark-complete =id]
          %unmark-complete
        ?>  =(our.bowl owner.id.action)
        %+  convert-away-cud:hc  ~
        (unmark-complete:gs id.action src.bowl)
          ::
          :: [%make-chef chef=ship =id]
          %make-chef
        ?>  =(our.bowl owner.id.action)
        %+  convert-away-cud:hc  ~
        (make-chef:gs id.action chef.action src.bowl)
          ::
          :: [%make-peon peon=ship =id]
          %make-peon
        ?>  =(our.bowl owner.id.action)
        %+  convert-away-cud:hc  ~
        (make-peon:gs id.action peon.action src.bowl)
          ::
          :: [%invite invitee=ship =pin]
          %invite
        =*  poke-other  ~(poke-other pass:hc /)
        ?<  =(invitee.action our.bowl)
        %+  convert-away-cud:hc
          [(poke-other invitee.action goal-action+!>([%subscribe our.bowl pin.action]))]~
        (put-viewer:gs pin.action invitee.action src.bowl)
          ::
          :: [%subscribe owner=ship =pin]
          %subscribe
        =/  pite  /[`@`+<.pin.action]/[`@`+>.pin.action]
        =*  watch-other  ~(watch-other pass:hc pite)
        :_  state
        :~  (watch-other owner.action pite)
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
    [%give %fact ~ %goal-away-update !>(spawn-pool+pool)]~
  ==
::
++  on-leave  on-leave:def
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
    =/  mod  src.bowl
    ?>  =(mod owner)
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
      ?+    update  (on-agent:def wire sign)
        :: --------------------------------------------------------------------
        :: spawn/trash
        ::
        :: THIS WORKS
          [%spawn-pool *]
        :_  this(store (spawn-pool:spawn-trash:etch pin pool.update))
        ~[(fact:io goal-home-update+!>([[pin mod] update]) ~[/goals])]
        ::
        :: THIS WORKS
          [%spawn-goal *]
        :_  this(store (spawn-goal:spawn-trash:etch pin [nex id goal]:update))
        ~[(fact:io goal-home-update+!>([[pin mod] update]) ~[/goals])]
        ::
        :: THIS WORKS
          [%trash-goal *]
        :_  this(store (trash-goal:spawn-trash:etch pin id.update))
        ~[(fact:io goal-home-update+!>([[pin mod] update]) ~[/goals])]
        :: --------------------------------------------------------------------
        :: pool-perms
        ::
        :: THIS WORKS
          [%pool-perms %viewer *]
        :_  this(store (viewer:pool-perms:etch pin ship.update))
        ~[(fact:io goal-home-update+!>([[pin mod] update]) ~[/goals])]
        :: --------------------------------------------------------------------
        :: pool-hitch
        ::
        :: THIS WORKS
          [%pool-hitch %title *]
        :_  this(store (title:pool-hitch:etch pin title.update))
        ~[(fact:io goal-home-update+!>([[pin mod] update]) ~[/goals])]
        :: --------------------------------------------------------------------
        :: pool-nexus
        ::
          [%pool-nexus %yoke *]
        :_  this(store (yoke:pool-nexus:etch pin nex.update))
        ~[(fact:io goal-home-update+!>([[pin mod] update]) ~[/goals])]
        :: --------------------------------------------------------------------
        :: goal-perms
        ::
        :: THIS WORKS
          [%goal-perms id:gol %chef *]
        :_  this(store (chef:goal-perms:etch [id ship]:update))
        ~[(fact:io goal-home-update+!>([[pin mod] update]) ~[/goals])]
        ::
        :: THIS WORKS
          [%goal-perms id:gol %peon *]
        :_  this(store (peon:goal-perms:etch [id ship]:update))
        ~[(fact:io goal-home-update+!>([[pin mod] update]) ~[/goals])]
        :: --------------------------------------------------------------------
        :: goal-hitch
        ::
        :: THIS WORKS
          [%goal-hitch id:gol %desc *]
        :_  this(store (desc:goal-hitch:etch pin [id desc]:update))
        ~[(fact:io goal-home-update+!>([[pin mod] update]) ~[/goals])]
        :: --------------------------------------------------------------------
        :: goal-nexus
        ::
        :: THIS WORKS
          [%goal-nexus id:gol %deadline *]
        :_  this(store (deadline:goal-nexus:etch pin [id moment]:update))
        ~[(fact:io goal-home-update+!>([[pin mod] update]) ~[/goals])]
        :: --------------------------------------------------------------------
        :: goal-togls
        ::
        :: THIS WORKS
          [%goal-togls id:gol %complete *]
        :_  this(store (complete:goal-togls:etch pin [id complete]:update))
        ~[(fact:io goal-home-update+!>([[pin mod] update]) ~[/goals])]
        ::
        :: THIS WORKS
          [%goal-togls id:gol %actionable *]
        :_  this(store (actionable:goal-togls:etch pin [id actionable]:update))
        ~[(fact:io goal-home-update+!>([[pin mod] update]) ~[/goals])]
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
  --
::
++  send-away-update
  |=  [=pin:gol =away-update:goal-store]
  ^-  card
  ?>  =(our.bowl +<.pin)
  (fact:io goal-away-update+!>(away-update) ~[/[`@`+<.pin]/[`@`+>.pin]])
::
++  send-home-update
  |=  =home-update:goal-store
  ^-  card
  (fact:io goal-home-update+!>(home-update) ~[/goals])
::
++  convert-home-cud
  |=  [cards=(list card) =home-cud:goal-store]
  ^-  (quip card _state)
  :_  state(store store.home-cud)
  %+  weld  cards
  :~  (send-home-update home-update.home-cud)
  ==
::
++  convert-away-cud
  |=  [cards=(list card) =away-cud:goal-store]
  ^-  (quip card _state)
  :_  state(store store.away-cud)
  %+  weld  cards
  :~  (send-away-update [pin away-update]:away-cud)
      %-  send-home-update 
      [[pin src.bowl] away-update]:[away-cud .]
  ==
--
