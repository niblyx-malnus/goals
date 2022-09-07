/-  gol=goal, goal-store
/+  dbug, default-agent, verb, agentio,
    gol-cli-goals, gol-cli-goal-store, pl=gol-cli-pool
|%
+$  versioned-state
  $%  state-0
      state-1
  ==
+$  state-0  state-0:gol
+$  state-1  state-1:gol
+$  card  card:agent:gall
--
=|  state-1
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
      %1
    `this(state old)
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
        =/  upd
          %:  new-pool:gs
            title.action
            chefs.action
            peons.action
            viewers.action
            src.bowl
            now.bowl
          ==
        :_  state(store store.upd)
        :~  %+  fact:io
              goal-update+!>(update.upd)
            ~[/[`@`+<.pin.upd]/[`@`+>.pin.upd]]
            (fact:io goal-update+!>(update.upd) ~[/goals])
            (fact:io goal-update+!>(update.upd) ~[/updates])
        ==
          ::
          :: [%copy-pool =old=pin title=@t chefs=(set ship) peons=(set ship) viewers=(set ship)]
          %copy-pool
        ?>  =(src.bowl our.bowl)
        =/  upd
          %:  copy-pool:gs
            old-pin.action
            title.action
            chefs.action
            peons.action
            viewers.action
            src.bowl
            now.bowl
          ==
        :_  state(store store.upd)
        :~  %+  fact:io
              goal-update+!>(update.upd)
            ~[/[`@`+<.pin.upd]/[`@`+>.pin.upd]]
            (fact:io goal-update+!>(update.upd) ~[/goals])
            (fact:io goal-update+!>(update.upd) ~[/updates])
        ==
          ::
          :: [%delete-pool =pin]
          %delete-pool
        ?>  =(src.bowl our.bowl)
        ?>  =(our.bowl owner.pin.action)
        =/  upd  (delete-pool:gs pin.action our.bowl)
        :_  state(store store.upd)
        :~  [%give %kick ~[/[`@`+<.pin.action]/[`@`+>.pin.action]] ~]
            (fact:io goal-update+!>(update.upd) ~[/goals])
            (fact:io goal-update+!>(update.upd) ~[/updates])
        ==
          ::
          :: [%new-goal =pin desc=@t chefs=(set ship) peons=(set ship) deadline=(unit @da) actionable=?]
          %new-goal
        ?>  =(our.bowl owner.pin.action)
        =/  upd
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
        :_  state(store store.upd)
        :~  %+  fact:io
              goal-update+!>(update.upd)
            ~[/[`@`+<.pin.upd]/[`@`+>.pin.upd]]
            (fact:io goal-update+!>(update.upd) ~[/goals])
            (fact:io goal-update+!>(update.upd) ~[/updates])
        ==
          ::
          :: [%add-under =id desc=@t chefs=(set ship) peons=(set ship) deadline=(unit @da) actionable=?]
          %add-under
        ?>  =(our.bowl owner.id.action)
        =/  upd
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
        :_  state(store store.upd)
        :~  %+  fact:io
              goal-update+!>(update.upd)
            ~[/[`@`+<.pin.upd]/[`@`+>.pin.upd]]
            (fact:io goal-update+!>(update.upd) ~[/goals])
            (fact:io goal-update+!>(update.upd) ~[/updates])
        ==
          ::
          :: [%delete-goal =id]
          %delete-goal
        ?>  =(src.bowl our.bowl)
        ?>  =(our.bowl owner.id.action)
        =/  upd  (delete-goal:gs id.action our.bowl)
        :_  state(store store.upd)
        :~  %+  fact:io
              goal-update+!>(update.upd)
            ~[/[`@`+<.pin.upd]/[`@`+>.pin.upd]]
            (fact:io goal-update+!>(update.upd) ~[/goals])
            (fact:io goal-update+!>(update.upd) ~[/updates])
        ==
          ::
          :: [%edit-goal-desc =id desc=@t]
          %edit-goal-desc
        ?>  =(our.bowl owner.id.action)
        %+  convert-update:hc  ~
        (edit-goal-desc:gs id.action desc.action src.bowl)
          ::
          :: [%edit-pool-title =pin title=@t]
          %edit-pool-title
        ?>  =(our.bowl owner.pin.action)
        %+  convert-update:hc  ~
        (edit-pool-title:gs pin.action title.action src.bowl)
          ::
          :: [%yoke-sequence =pin =yoke-sequence]
          %yoke-sequence
        ?>  =(our.bowl owner.pin.action)
        =/  as  (apply-sequence:gs pin.action src.bowl yoke-sequence.action)
        :_  state(store store.as)
        :~  %+  fact:io
              goal-update+!>(update.as)
            ~[/[`@`+<.pin.as]/[`@`+>.pin.as]]
            (fact:io goal-update+!>(update.as) ~[/goals])
            (fact:io goal-update+!>(update.as) ~[/updates])
        ==
          ::
          :: [%set-deadline =id deadline=(unit @da)]
          %set-deadline
        ?>  =(our.bowl owner.id.action)
        %+  convert-update:hc  ~
        (set-deadline:gs id.action deadline.action src.bowl)
          ::
          :: [%mark-actionable =id]
          %mark-actionable
        ?>  =(our.bowl owner.id.action)
        %+  convert-update:hc  ~
        (mark-actionable:gs id.action src.bowl)
          ::
          :: [%unmark-actionable =id]
          %unmark-actionable
        ?>  =(our.bowl owner.id.action)
        %+  convert-update:hc  ~
        (unmark-actionable:gs id.action src.bowl)
          ::
          :: [%mark-complete =id]
          %mark-complete
        ?>  =(our.bowl owner.id.action)
        %+  convert-update:hc  ~
        (mark-complete:gs id.action src.bowl)
          ::
          :: [%unmark-complete =id]
          %unmark-complete
        ?>  =(our.bowl owner.id.action)
        %+  convert-update:hc  ~
        (unmark-complete:gs id.action src.bowl)
          ::
          :: [%make-chef chef=ship =id]
          %make-chef
        ?>  =(our.bowl owner.id.action)
        %+  convert-update:hc  ~
        (make-chef:gs id.action chef.action src.bowl)
          ::
          :: [%make-peon peon=ship =id]
          %make-peon
        ?>  =(our.bowl owner.id.action)
        %+  convert-update:hc  ~
        (make-peon:gs id.action peon.action src.bowl)
          ::
          :: [%invite invitee=ship =pin]
          %invite
        =*  poke-other  ~(poke-other pass:hc /)
        ?<  =(invitee.action our.bowl)
        %+  convert-update:hc
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
      [%updates ~]  `this
      [%goals ~]
    ?>  =(our.bowl src.bowl)
    :_  this
    [%give %fact ~ %goal-update !>(initial+store)]~
      [@ @ ~]
    =/  owner  `@p`i.path
    =/  birth  `@da`i.t.path
    =/  pin  `pin:gol`[%pin owner birth]
    =/  pool  (~(got by pools) pin)
    :_  this
    [%give %fact ~ %goal-update !>(initial-pool-update+pool)]~
  ==
::
++  on-leave  on-leave:def
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  (on-peek:def path)
      [%x %initial ~]
    ``goal-update+!>(initial+store)
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
      ``goal-peek+!>(harvest+~(tap in (~(leaf-precedents pl pin pool) id)))
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
        ``goal-peek+!>(yung+(hi-to-lo ~(tap in (yung goal))):[~(. pl pin pool) .])
        ::
          [%uncompleted ~]
        :-  ~  :-  ~  :-  %goal-peek
        !>  :-  %yung-uncompleted
            =+  ~(. pl pin pool)
            (hi-to-lo ~(tap in ((uncompleted yung) goal)))
        ::
          [%virtual ~]
        :-  ~  :-  ~  :-  %goal-peek
        !>  :-  %yung-virtual
            =+  ~(. pl pin pool)
            (hi-to-lo ~(tap in (~(dif in (yung goal)) kids.goal)))
      ==
      ::
        [%ryte-bound ~]
      ``goal-peek+!>(ryte-bound+(~(ryte-bound pl pin pool) [%d id]))
      ::
        [%plumb ~]
      ``goal-peek+!>(plumb+(~(plumb pl pin pool) id))
      ::
        [%priority ~]
      ``goal-peek+!>(priority+(~(priority pl pin pool) id))
      ::
        [%seniority @ @ ~]
      =/  mod  (slav %p i.t.t.t.t.t.path)
      =/  cp  i.t.t.t.t.t.t.path
      ?>  ?=(?(%c %p) cp)
      ``goal-peek+!>(seniority+(~(seniority pl pin pool) mod id cp))
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
      ``goal-peek+!>(anchor+~(anchor pl pin pool))
      ::
        [%roots *]
      ?+    t.t.t.t.t.path  (on-peek:def path)
          ~
        ``goal-peek+!>(roots+~(roots pl pin pool))
        ::
          [%uncompleted ~]
        ``goal-peek+!>(roots-uncompleted+~(uncompleted-roots pl pin pool))
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
      :_  this
      [%pass wire %agent [src.bowl %goal-store] %watch wire]~
        %fact
      ?>  =(p.cage.sign %goal-update)
      =/  update  !<(update:goal-store q.cage.sign)
      ?+    -.update  (on-agent:def wire sign)
          %error  `this
          ::
          %pool-update
        =/  new-store  (update-store:gs pin pool.update)
        :_  this(store new-store)
        ~[(send-store-update:hc new-store)]
       ::   %new-pool
       :: `this
       ::   %copy-pool
       :: `this
       ::   %edit-goal-desc
       :: `this
       ::   %edit-pool-title
       :: `this
       ::   %delete-pool
       :: `this
       ::   %delete-goal
       :: `this
       ::   %yoke-sequence
       :: `this
       ::   %set-deadline
       :: `this
       ::   %mark-actionable
       :: `this
       ::   %unmark-actionable
       :: `this
       ::   %mark-complete
       :: `this
       ::   %unmark-complete
       :: `this
       ::   %make-chef
       :: `this
       ::   %make-peon
       :: `this
       ::   %invite
       :: `this
       ::   %subscribe
       :: `this
          %new-goal
        %-  (slog 'goal-store on-agent new-goal' ~)
        ?>  =(pin pin.update)
        :_  this(store (new-goal:update:gs +.update))
        ~[(fact:io goal-update+!>(update) ~[/goals])]
        ::
          %add-under
        %-  (slog 'goal-store on-agent add-under' ~)
        ?>  =(pin pin.update)
        :_  this(store (add-under:update:gs +.update))
        ~[(fact:io goal-update+!>(update) ~[/goals])]
        ::
          %yoke-sequence
        %-  (slog 'goal-store on-agent yoke-sequence' ~)
        ?>  =(pin pin.update)
        :_  this(store (yoke-sequence:update:gs +.update))
        ~[(fact:io goal-update+!>(update) ~[/goals])]
        ::
          %delete-goal
        %-  (slog 'goal-store on-agent delete-goal' ~)
        ?>  =(pin pin.update)
        :_  this(store (delete-goal:update:gs +.update))
        ~[(fact:io goal-update+!>(update) ~[/goals])]
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
++  send-pool-update
  |=  [=pin:gol =update:goal-store]
  ^-  card
  ?>  =(our.bowl +<.pin)
  (fact:io goal-update+!>(update) ~[/[`@`+<.pin]/[`@`+>.pin]])
::
++  send-store-update
  |=  =store:gol
  ^-  card
  (fact:io goal-update+!>(store-update+store) ~[/goals])
::
++  convert-update
  |=  [cards=(list card) =store-update:goal-store]
  ^-  (quip card _state)
  :_  state(store store.store-update)
  %+  weld  cards
  :~  (send-pool-update [pin update]:store-update)
      (send-store-update store.store-update)
  ==
--
