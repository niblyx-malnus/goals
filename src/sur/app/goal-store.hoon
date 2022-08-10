/-  gol=goal, goal-store
/+  dbug, default-agent, verb, agentio,
    gol-cli-goals
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
    gols  ~(. gol-cli-goals store)
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
        %:  new-project:gols
          title.action
          chefs.action
          peons.action
          viewers.action
          src.bowl
          now.bowl
        ==
          ::
          :: [%new-goal =pin desc=@t chefs=(set ship) peons=(set ship) deadline=(unit @da) actionable=?]
          %new-goal
        ?>  =(our.bowl owner.pin.action)
        %+  convert-update:hc  ~
        %:  new-goal:gols
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
        %+  convert-update:hc  ~
        %:  add-under:gols
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
          :: [%del =id]
          %del
        ::?.  (check-perm:gols %del par src.bowl)  `state
        `state
        :: :-  ~
        :: %=  this
        ::   goals  (purge-goals:gols id.action)
        ::   handles  (purge-handles:hdls [%goal id.action])
        ::   views  (~(del by views) id.action)
        :: ==
          ::
          :: [%edit-goal-desc =id desc=@t]
          %edit-goal-desc
        ?>  =(our.bowl owner.id.action)
        %+  convert-update:hc  ~
        (edit-goal-desc:gols id.action desc.action src.bowl)
          ::
          :: [%edit-project-title =pin title=@t]
          %edit-project-title
        ?>  =(our.bowl owner.pin.action)
        %+  convert-update:hc  ~
        (edit-project-title:gols pin.action title.action src.bowl)
          ::
          :: [%held-yoke lef=id ryt=id]
          %held-yoke
        ?>  &(=(our.bowl owner.lef.action) =(our.bowl owner.ryt.action))
        %+  convert-update:hc  ~
        (held-yoke-update:gols lef.action ryt.action src.bowl)
          ::
          :: [%held-rend lef=id ryt=id]
          %held-rend
        `state
          ::
          :: [%nest-yoke lef=id ryt=id]
          %nest-yoke
        `state
          ::
          :: [%nest-rend lef=id ryt=id]
          %nest-rend
        `state
          ::
          :: [%prec-yoke ryt=id lef=id]
          %prec-yoke
        `state
          ::
          :: [%prec-rend ryt=id lef=id]
          %prec-rend
        `state
          ::
          :: [%prio-yoke ryt=id lef=id]
          %prio-yoke
        `state
          ::
          :: [%prio-rend ryt=id lef=id]
          %prio-rend
        `state
          ::
          :: [%sd =id deadline=(unit @da)]
          %sd
        `state
       ::  :-  ~
       ::  %=  this
       ::    goals   %+  ~(jab by goals)  id.action
       ::            |=(=goal:gol goal(deadline deadline.action))
       ::  ==
          ::
          :: [%actionate =id]
          %actionate
        `state
        :: `state(goals (~(jab by goals) id.action actionate:gols))
          ::
          :: [%activate =id]
          %complete
        `state
        :: `state(goals (~(jab by goals) id.action complete:gols))
          ::
          :: [%activate =id]
          %activate
        `state
        :: `state(goals (~(jab by goals) id.action activate:gols))
          ::
          :: [%make-chef chef=ship =id]
          %make-chef
        ?>  =(our.bowl owner.id.action)
        %+  convert-update:hc  ~
        (make-chef:gols id.action chef.action src.bowl)
       :: =*  poke-other  ~(poke-other pass:hc /)
       :: ?<  =(chef.action our.bowl)
       :: ?.  =(our.bowl -.id.action)  [[(poke-other -.id.action [mark vase])]~ this]
       :: =/  make-chef  (make-chef:gols id.action chef.action src.bowl)
       :: ?-  -.make-chef
       ::   %&  [(send-project-update update.make-chef) this(store store.make-chef)]
       ::   %|  ~&  error.make-chef  `state  :: send error back to src
       :: ==
          ::
          :: [%make-peon chef=ship =id]
          %make-peon
        `state
       ::  =*  poke-other  ~(poke-other pass:hc /)
       ::  ?<  =(peon.action our.bowl)
       ::  ?.  =(our.bowl -.id.action)  [[(poke-other -.id.action [mark vase])]~ this]
       ::  =/  make-peon  (make-peon:gols id.action peon.action src.bowl)
       ::  ?-  -.make-peon
       ::    %&  [(send-project-update update.make-peon) this(store store.make-peon)]
       ::    %|  ~&  error.make-peon  `state
       ::  ==
          ::
          :: [%invite invitee=ship =pin]
          %invite
        =*  poke-other  ~(poke-other pass:hc /)
        ?<  =(invitee.action our.bowl)
        %+  convert-update:hc
          [(poke-other invitee.action goal-action+!>([%subscribe our.bowl pin.action]))]~
        (put-viewer:gols pin.action invitee.action src.bowl)
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
    [%give %fact ~ %goal-update !>(store-update+store)]~
      [@ @ ~]
    =/  origin  `@p`i.path
    =/  birth  `@da`i.t.path
    =/  id  `id:gol`[origin birth]
    =/  project  (~(got by projects) [%pin id])
    :_  this
    [%give %fact ~ %goal-update !>(project-update+project)]~
  ==
::
++  on-leave  on-leave:def
++  on-peek   on-peek:def
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [@ @ ~] 
    =/  origin  `@p`i.wire
    =/  birth  `@da`i.t.wire
    =/  id  `id:gol`[origin birth]
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign
        ((slog 'You\'ve been invited to view a goal!' ~) `this)
      `this
        %kick
      %-  (slog '%goal-store: Got kick, resubscribing...' ~)
      :_  this
      [%pass wire %agent [src.bowl %goal-store] %watch wire]~
        %fact
      ?+    p.cage.sign  (on-agent:def wire sign)
          %goal-update
        =/  update  !<(update:goal-store q.cage.sign)
        ?+    -.update  (on-agent:def wire sign)
            %project-update
          =/  new-store  (update-store:gols [%pin id] project.update)
          :_  this(store new-store)
          ~[(send-store-update:hc new-store)]
        ==
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
  |=  [=pin:gol =project:gol]
  ^-  card
  ?>  =(our.bowl +<.pin)
  (fact:io goal-update+!>(project-update+project) ~[/[`@`+<.pin]/[`@`+>.pin]])
::
++  send-store-update
  |=  =store:gol
  ^-  card
  (fact:io goal-update+!>(store-update+store) ~[/goals])
++  convert-update
  |=  [cards=(list card) =store-update:gol]
  ^-  (quip card _state)
  ?-    -.store-update
      %&
    :_  state(store store.store-update)
    %+  weld  cards
    :~  (send-project-update update.store-update)
        (send-store-update store.store-update)
    ==
      %|
    ~&  error.store-update  `state
  ==
--
