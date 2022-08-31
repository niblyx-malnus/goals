/-  gol=goal, goal-store
/+  dbug, default-agent, verb, agentio,
    gol-cli-goals, gol-cli-goal-store
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 =store:gol]
+$  card  card:agent:gall
--
=|  state-0
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
    projects   projects.store
++  on-init   `this
++  on-save   !>(state)
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-vase)
  |-
  ?-    -.old
      %0
    `this(state old)
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
          :: [%new-project title=@t chefs=(set ship) peons=(set ship) viewers=(set ship)]
          %new-project
        ?>  =(src.bowl our.bowl)
        %+  convert-update:hc  ~
        %:  new-project:gs
          title.action
          chefs.action
          peons.action
          viewers.action
          src.bowl
          now.bowl
        ==
          ::
          :: [%copy-project =old=pin title=@t chefs=(set ship) peons=(set ship) viewers=(set ship)]
          %copy-project
        ?>  =(src.bowl our.bowl)
        %+  convert-update:hc  ~
        %:  copy-project:gs
          old-pin.action
          title.action
          chefs.action
          peons.action
          viewers.action
          src.bowl
          now.bowl
        ==
          ::
          :: [%delete-project =pin]
          %delete-project
        ?>  =(src.bowl our.bowl)
        ?>  =(our.bowl owner.pin.action)
        =/  store-update  (delete-project:gs pin.action our.bowl)
        :_  state(store store-update)
        :~  [%give %kick ~[/[`@`+<.pin.action]/[`@`+>.pin.action]] ~]
            (send-store-update store-update)
        ==
          ::
          :: [%new-goal =pin desc=@t chefs=(set ship) peons=(set ship) deadline=(unit @da) actionable=?]
          %new-goal
        ?>  =(our.bowl owner.pin.action)
        =/  ng
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
        :_  state(store store.ng)
        :~  %+  fact:io
              goal-update+!>(update.ng)
            ~[/[`@`+<.pin.ng]/[`@`+>.pin.ng]]
            (fact:io goal-update+!>(update.ng) ~[/goals])
        ==
          ::
          :: [%add-under =id desc=@t chefs=(set ship) peons=(set ship) deadline=(unit @da) actionable=?]
          %add-under
        ?>  =(our.bowl owner.id.action)
        =/  au
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
        :_  state(store store.au)
        :~  %+  fact:io
              goal-update+!>(update.au)
            ~[/[`@`+<.pin.au]/[`@`+>.pin.au]]
            (fact:io goal-update+!>(update.au) ~[/goals])
        ==
          ::
          :: [%delete-goal =id]
          %delete-goal
        ?>  =(src.bowl our.bowl)
        ?>  =(our.bowl owner.id.action)
        =/  store-update  (delete-goal:gs id.action our.bowl)
        :_  state(store store-update)
        [(send-store-update store-update)]~
          ::
          :: [%edit-goal-desc =id desc=@t]
          %edit-goal-desc
        ?>  =(our.bowl owner.id.action)
        %+  convert-update:hc  ~
        (edit-goal-desc:gs id.action desc.action src.bowl)
          ::
          :: [%edit-project-title =pin title=@t]
          %edit-project-title
        ?>  =(our.bowl owner.pin.action)
        %+  convert-update:hc  ~
        (edit-project-title:gs pin.action title.action src.bowl)
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
      [%goals ~]
    ?>  =(our.bowl src.bowl)
    :_  this
    [%give %fact ~ %goal-update !>(initial+store)]~
      [@ @ ~]
    =/  origin  `@p`i.path
    =/  birth  `@da`i.t.path
    =/  pin  `pin:gol`[%pin origin birth]
    =/  project  (~(got by projects) pin)
    :_  this
    [%give %fact ~ %goal-update !>(initial-project-update+project)]~
  ==
::
++  on-leave  on-leave:def
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  (on-peek:def path)
      [%x %initial ~]
    ``goal-update+!>(initial+store)
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [@ @ ~] 
    =/  origin  `@p`i.wire
    =/  birth  `@da`i.t.wire
    =/  pin  `pin:gol`[%pin origin birth]
    ?>  =(src.bowl origin)
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
          %project-update
        =/  new-store  (update-store:gs pin project.update)
        :_  this(store new-store)
        ~[(send-store-update:hc new-store)]
          %new-goal
        %-  (slog 'goal-store on-agent new-goal' ~)
        ?>  =(pin pin.update)
        :_  this(store (new-goal:update:gs +.update))
        ~[(fact:io goal-update+!>(update) ~[/goals])]
          %add-under
        %-  (slog 'goal-store on-agent add-under' ~)
        ?>  =(pin pin.update)
        :_  this(store (add-under:update:gs +.update))
        ~[(fact:io goal-update+!>(update) ~[/goals])]
          %yoke-sequence
        %-  (slog 'goal-store on-agent yoke-sequence' ~)
        ?>  =(pin pin.update)
        :_  this(store (yoke-sequence:update:gs +.update))
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
++  send-project-update
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
  :~  (send-project-update [pin update]:store-update)
      (send-store-update store.store-update)
  ==
--