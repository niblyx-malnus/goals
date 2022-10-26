/-  gol=goal, group-store, metadata-store
/+  dbug, default-agent, verb, agentio,
    pl=gol-cli-pool, gol-cli-goals, gol-cli-pools,
    gol-cli-etch, group-update
|%
+$  state-0  state-0:gol
+$  state-1  state-1:gol  
+$  state-2  state-2:gol
+$  state-3  state-3:gol
+$  state-4  state-4:gol
+$  versioned-state
  $%  state-0
      state-1
      state-2
      state-3
      state-4
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
  $(time (add unix-ms 1))
--
=|  state-4
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
    hc    ~(. +> bowl)
    gols  ~(. gol-cli-goals store)
    puls  ~(. gol-cli-pools store)
    etch  ~(. gol-cli-etch store)
    index   index.store
    pools   pools.store
    cache   cache.store
::
++  on-init   
  ^-  (quip card _this)
  =/  now=@  (unique-time now.bowl log)
  :_  this(log (put:log-orm *log:gol now [%init store]))
  ?:  (~(has by wex.bowl) [/groups our.bowl %group-store])
    ~
  [(~(watch-our pass:io /groups) %group-store /groups)]~
::
++  on-save   !>(state)
::
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-vase)
  |-
  ?-    -.old
      %4
    =/  now=@  (unique-time now.bowl log)
    :_  this(state old(log (put:log-orm *log:gol now [%init store.old])))
    ?:  (~(has by wex.bowl) [/groups our.bowl %group-store])
      ~
    [(~(watch-our pass:io /groups) %group-store /groups)]~
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
  =^  cards  state
    ?+    mark  (on-poke:def mark vase)
        %goal-action
      =/  action=action:gol  !<(action:gol vase)
      ?>  =(vzn -.action)  :: assert pokes are correct version
      =/  pid  pid.action
      =/  pok  pok.action
      ?-    -.pok
          ::
          %spawn-pool
        ?>  =(src.bowl our.bowl)
        =+  [pin pool]=(spawn-pool:puls title.pok src.bowl now.bowl)
        (send-home-updates:hc ~ pin src.bowl pid [vzn %spawn-pool pool]~)
          ::
          %clone-pool
        ?>  =(src.bowl our.bowl)
        =+  ^=  [pin pool]
          (clone-pool:puls pin.pok title.pok src.bowl now.bowl)
        (send-home-updates:hc ~ pin src.bowl pid [vzn %spawn-pool pool]~)
          ::
          :: [%cache-pool =pin]
          %cache-pool
        ?>  =(src.bowl our.bowl)
        ?>  =(src.bowl owner.pin.pok)
        %+  send-home-updates:hc
          [%give %kick ~[/[`@`+<.pin.pok]/[`@`+>.pin.pok]] ~]~
        [pin.pok src.bowl pid [vzn %cache-pool pin.pok]~]
          ::
          :: [%renew-pool =pin]
          %renew-pool
        ?>  =(src.bowl our.bowl)
        ?>  =(src.bowl owner.pin.pok)
        =*  poke-other  ~(poke-other pass:hc /away/renew-pool)
        %+  send-home-updates:hc
            %+  turn
              %~  tap  in
              (~(del in ~(key by perms:(~(got by cache) pin.pok))) our.bowl)
            |=  =ship
            ^-  card
            (poke-other ship goal-action+!>([vzn 0 %subscribe pin.pok]))
        =/  pool  (~(got by cache) pin.pok) :: this is redundant information
        [pin.pok src.bowl pid [vzn %renew-pool pin.pok pool]~]
          ::
          :: [%trash-pool =pin]
          %trash-pool
        ?>  =(src.bowl our.bowl)
        ?>  =(src.bowl owner.pin.pok)
        %+  send-home-updates:hc
          [%give %kick ~[/[`@`+<.pin.pok]/[`@`+>.pin.pok]] ~]~
        ?:  (~(has by pools) pin.pok)
          [pin.pok src.bowl pid [vzn %waste-pool ~]~]
        ?>  (~(has by cache) pin.pok)
        [pin.pok src.bowl pid [vzn %trash-pool ~]~]
          ::
          :: [%spawn-goal =pin upid=(unit id) desc=@t actionable=?]
          %spawn-goal
        =*  poke-other
          %~  poke-other
            pass:hc
          (en-away-path pid pin.pok %spawn-goal)
        ?.  =(our.bowl owner.pin.pok)
          :_  state
          [(poke-other owner.pin.pok goal-action+!>(action))]~
        =/  =id:gol  (unique-id:gols [our.bowl now.bowl])
        =/  pore
          %:  spawn-goal-fixns:(apex-pl:hc pin.pok)
            id
            upid.pok
            desc.pok
            actionable.pok
            src.bowl
          ==
        (send-away-updates:hc ~ pin.pok src.bowl pid pore)
          ::
          :: [%cache-goal =id]
          %cache-goal
        =/  pin  (got:idx-orm:gol index.store id.pok)
        =*  poke-other
          %~  poke-other
            pass:hc
          (en-away-path pid pin %cache-goal)
        ?.  =(our.bowl owner.id.pok)
          :_  state
          [(poke-other owner.id.pok goal-action+!>(action))]~
        =/  pore  (cache-goal:(apex-pl:hc pin) id.pok src.bowl)
        (send-away-updates:hc ~ pin src.bowl pid pore)
          ::
          :: [%renew-goal =id]
          %renew-goal
        =/  pin  (got:idx-orm:gol index.store id.pok)
        =*  poke-other
          %~  poke-other
            pass:hc
          (en-away-path pid pin %renew-goal)
        ?.  =(our.bowl owner.id.pok)
          :_  state
          [(poke-other owner.id.pok goal-action+!>(action))]~
        =/  pore  (renew-goal:(apex-pl:hc pin) id.pok src.bowl)
        (send-away-updates:hc ~ pin src.bowl pid pore)
          ::
          :: [%trash-goal =id]
          %trash-goal
        =/  pin  (got:idx-orm:gol index.store id.pok)
        =*  poke-other
          %~  poke-other
            pass:hc
          (en-away-path pid pin %trash-goal)
        ?.  =(our.bowl owner.id.pok)
          :_  state
          [(poke-other owner.id.pok goal-action+!>(action))]~
        =/  pore  (trash-goal:(apex-pl:hc pin) id.pok src.bowl)
        (send-away-updates:hc ~ pin src.bowl pid pore)
          ::
          :: [%edit-goal-desc =id desc=@t]
          %edit-goal-desc
        =/  pin  (got:idx-orm:gol index.store id.pok)
        =*  poke-other
          %~  poke-other
            pass:hc
          (en-away-path pid pin %edit-goal-desc)
        ?.  =(our.bowl owner.id.pok)
          :_  state
          [(poke-other owner.id.pok goal-action+!>(action))]~
        =/  pore
          (edit-goal-desc:(apex-pl:hc pin) id.pok desc.pok src.bowl)
        (send-away-updates:hc ~ pin src.bowl pid pore)
          ::
          :: [%edit-pool-title =pin title=@t]
          %edit-pool-title
        =*  poke-other
          %~  poke-other
            pass:hc
          (en-away-path pid pin.pok %edit-pool-title)
        ?.  =(our.bowl owner.pin.pok)
          :_  state
          [(poke-other owner.pin.pok goal-action+!>(action))]~
        =/  pore
          (edit-pool-title:(apex-pl:hc pin.pok) title.pok src.bowl)
        (send-away-updates:hc ~ pin.pok src.bowl pid pore)
          ::
          :: [%yoke =pin yoks=(list exposed-yoke)]
          %yoke
        =*  poke-other
          %~  poke-other
            pass:hc
          (en-away-path pid pin.pok %yoke)
        ?.  =(our.bowl owner.pin.pok)
          :_  state
          [(poke-other owner.pin.pok goal-action+!>(action))]~
        =/  pore  (yoke-sequence:(apex-pl:hc pin.pok) yoks.pok src.bowl)
        (send-away-updates:hc ~ pin.pok src.bowl pid pore)
          ::
          :: [%move cid=id upid=(unit id)]
          %move
        =/  pin  (got:idx-orm:gol index.store cid.pok)
        =*  poke-other
          %~  poke-other
            pass:hc
          (en-away-path pid pin %move)
        ?.  =(our.bowl owner.cid.pok)
          :_  state
          [(poke-other owner.cid.pok goal-action+!>(action))]~
        =/  pore  (move-emot:(apex-pl:hc pin) cid.pok upid.pok src.bowl)
        (send-away-updates:hc ~ pin src.bowl pid pore)
          ::
          :: [%set-kickoff =id kickoff=(unit @da)]
          %set-kickoff
        =/  pin  (got:idx-orm:gol index.store id.pok)
        =*  poke-other
          %~  poke-other
            pass:hc
          (en-away-path pid pin %set-kickoff)
        ?.  =(our.bowl owner.id.pok)
          :_  state
          [(poke-other owner.id.pok goal-action+!>(action))]~
        =/  pore
          (set-kickoff:(apex-pl:hc pin) id.pok kickoff.pok src.bowl)
        (send-away-updates:hc ~ pin src.bowl pid pore)
          ::
          :: [%set-deadline =id deadline=(unit @da)]
          %set-deadline
        =/  pin  (got:idx-orm:gol index.store id.pok)
        =*  poke-other
          %~  poke-other
            pass:hc
          (en-away-path pid pin %set-deadline)
        ?.  =(our.bowl owner.id.pok)
          :_  state
          [(poke-other owner.id.pok goal-action+!>(action))]~
        =/  pore
          (set-deadline:(apex-pl:hc pin) id.pok deadline.pok src.bowl)
        (send-away-updates:hc ~ pin src.bowl pid pore)
          ::
          ::
          :: [%mark-actionable =id]
          %mark-actionable
        =/  pin  (got:idx-orm:gol index.store id.pok)
        =*  poke-other
          %~  poke-other
            pass:hc
          (en-away-path pid pin %mark-actionable)
        ?.  =(our.bowl owner.id.pok)
          :_  state
          [(poke-other owner.id.pok goal-action+!>(action))]~
        =/  pore  (mark-actionable:(apex-pl:hc pin) id.pok src.bowl)
        (send-away-updates:hc ~ pin src.bowl pid pore)
          ::
          :: [%unmark-actionable =id]
          %unmark-actionable
        =/  pin  (got:idx-orm:gol index.store id.pok)
        =*  poke-other
          %~  poke-other
            pass:hc
          (en-away-path pid pin %unmark-actionable)
        ?.  =(our.bowl owner.id.pok)
          :_  state
          [(poke-other owner.id.pok goal-action+!>(action))]~
        =/  pore  (unmark-actionable:(apex-pl:hc pin) id.pok src.bowl)
        (send-away-updates:hc ~ pin src.bowl pid pore)
          ::
          :: [%mark-complete =id]
          %mark-complete
        =/  pin  (got:idx-orm:gol index.store id.pok)
        =*  poke-other
          %~  poke-other
            pass:hc
          (en-away-path pid pin %mark-complete)
        ?.  =(our.bowl owner.id.pok)
          :_  state
          [(poke-other owner.id.pok goal-action+!>(action))]~
        =/  pore  (mark-complete:(apex-pl:hc pin) id.pok src.bowl)
        (send-away-updates:hc ~ pin src.bowl pid pore)
          ::
          :: [%unmark-complete =id]
          %unmark-complete
        =/  pin  (got:idx-orm:gol index.store id.pok)
        =*  poke-other
          %~  poke-other
            pass:hc
          (en-away-path pid pin %unmark-complete)
        ?.  =(our.bowl owner.id.pok)
          :_  state
          [(poke-other owner.id.pok goal-action+!>(action))]~
        =/  pore  (unmark-complete:(apex-pl:hc pin) id.pok src.bowl)
        (send-away-updates:hc ~ pin src.bowl pid pore)
          ::
          :: [%update-goal-perms =id chief=ship rec=?(%.y %.n) spawn=(set ship)]
          %update-goal-perms
        =/  pin  (got:idx-orm:gol index.store id.pok)
        =*  poke-other
          %~  poke-other
            pass:hc
          (en-away-path pid pin %update-goal-perms)
        ?.  =(our.bowl owner.id.pok)
          :_  state
          [(poke-other owner.id.pok goal-action+!>(action))]~
        =/  pore
          %:  update-goal-perms:(apex-pl:hc pin)
            id.pok
            chief.pok
            rec.pok
            spawn.pok
            src.bowl
          ==
        (send-away-updates:hc ~ pin src.bowl pid pore)
          ::
          :: [%update-pool-perms =pin new=pool-perms]
          %update-pool-perms
        =*  poke-other
          %~  poke-other
            pass:hc
          (en-away-path pid pin.pok %update-pool-perms)
        ?.  =(our.bowl owner.pin.pok)
          :_  state
          [(poke-other owner.pin.pok goal-action+!>(action))]~
        =/  pool  (~(got by pools) pin.pok)
        =/  diff  (~(pool-diff pl pool) new.pok)
        %+  send-away-updates:hc
          ;:  weld
            ^-  (list card)
            %+  turn  invite.diff
            |=  =ship
            (poke-other ship goal-action+!>([vzn 0 %subscribe pin.pok]))
            ^-  (list card)
            %+  turn  remove.diff
            |=  =ship
            [%give %kick ~[/[`@`+<.pin.pok]/[`@`+>.pin.pok]] `ship]
          ==
        =/  pore
          (update-pool-perms:(apex-pl:hc pin.pok) new.pok src.bowl)
        [pin.pok src.bowl pid pore]
          ::
          :: [%subscribe =pin]
          %subscribe
        =/  pite  /[`@`+<.pin.pok]/[`@`+>.pin.pok]
        ?<  =(owner.pin.pok our.bowl)
        ?:  (~(has by pools.store) pin.pok)  ~|(%already-subscribed !!)
        =*  watch-other  ~(watch-other pass:hc pite)
        :_  state
        :~  (watch-other owner.pin.pok pite)
        ==
          ::
          :: [%unsubscribe =pin]
          %unsubscribe
        =/  wire  /[`@`+<.pin.pok]/[`@`+>.pin.pok]
        ?<  =(owner.pin.pok our.bowl)
        =*  leave-other  ~(leave-other pass:hc wire)
        %+  send-home-updates:hc
          [(leave-other owner.pin.pok)]~
        [pin.pok src.bowl pid [vzn %trash-pool ~]~]
      ==
    ==
  [cards this]
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
      [%goals ~]  ?>((team:title our.bowl src.bowl) `this)
      ::
      [@ @ ~]
    =/  owner  `@p`i.path
    =/  birth  `@da`i.t.path
    =/  pin  `pin:gol`[%pin owner birth]
    =/  pool  (~(got by pools) pin)
    ?>  (~(has by perms.pool) src.bowl)
    :_  this
    [%give %fact ~ %goal-away-update !>([[our.bowl 0] spawn-pool+pool])]~
  ==
::
++  on-leave
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
      [@ @ ~]
    =*  poke-self  ~(poke-self pass:io /viewer-leave)
    =/  owner  `@p`i.path
    =/  birth  `@da`i.t.path
    =/  pin  `pin:gol`[%pin owner birth]
    =/  pool  (~(got by pools) pin)
    ::
    :: 0 is reserved for endogenous updates
    :_  this
    :_  ~
    %-  poke-self
    :-  %goal-action
    !>([vzn 0 %update-pool-perms pin (~(del by perms.pool) src.bowl)])
  ==
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  (on-peek:def path)
      [%x %initial ~]
    ``goal-peek+!>(initial+store)
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
      [%x %groups ~]
    ``goal-peek+!>(groups+groups)
    ::
      [%x %groups-metadata ~]
    =/  gmd
      .^  associations:metadata-store 
        %gx
        :~  (scot %p our.bowl)  %metadata-store  (scot %da now.bowl)
            %app-name  %groups  %noun
        ==
      ==
    ``goal-peek+!>(groups-metadata+gmd)
    ::
      [%x %pool-keys ~]
    ``goal-peek+!>(pool-keys+~(key by pools))
    ::
      [%x %all-goal-keys ~]
    :-  ~  :-  ~  :-  %goal-peek
    !>(all-goal-keys+(turn (tap:idx-orm:gol index) |=([=id:gol pin:gol] id)))
    ::
      [%x %goal @ @ *]
    =/  owner  (slav %p i.t.t.path)
    =/  birth  (slav %da i.t.t.t.path)
    =/  id  `id:gol`[owner birth]
    ?+    t.t.t.t.path  (on-peek:def path)
        [%harvest ~]
      =/  pin  (got:idx-orm:gol index id)
      =/  pool  (~(got by pools) pin)
      ``goal-peek+!>(harvest+~(tap in (~(harvest pl pool) id)))
      ::
        [%full-harvest ~]
      =/  pin  (got:idx-orm:gol index id)
      =/  pool  (~(got by pools) pin)
      ``goal-peek+!>(full-harvest+(~(full-harvest pl pool) id))
      ::
        [%get-goal ~]
      =/  upin  (get:idx-orm:gol index id)
      ?~  upin
        ``goal-peek+!>(get-goal+~)
      =/  pool  (~(got by pools) u.upin)
      =/  goal  (~(got by goals.pool) id)
      ``goal-peek+!>(get-goal+(~(get by goals.pool) id))
      ::
        [%get-pin ~]
      ``goal-peek+!>(get-pin+(get:idx-orm:gol index id))
      ::
        [%yung *]
      =/  pin  (got:idx-orm:gol index id)
      =/  pool  (~(got by pools) pin)
      =/  goal  (~(got by goals.pool) id)
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
      =/  pin  (got:idx-orm:gol index id)
      =/  pool  (~(got by pools) pin)
      ``goal-peek+!>(ryte-bound+(~(ryte-bound pl pool) [%d id]))
      ::
        [%plumb ~]
      =/  pin  (got:idx-orm:gol index id)
      =/  pool  (~(got by pools) pin)
      ``goal-peek+!>(plumb+(~(plumb pl pool) id))
      ::
        [%priority ~]
      =/  pin  (got:idx-orm:gol index id)
      =/  pool  (~(got by pools) pin)
      ``goal-peek+!>(priority+(~(priority pl pool) id))
      ::
      ::   [%seniority @ @ ~]
      :: =/  mod  (slav %p i.t.t.t.t.t.path)
      :: =/  cp  i.t.t.t.t.t.t.path
      :: ?>  ?=(?(%c %p) cp)
      :: ``goal-peek+!>(seniority+(~(seniority pl pool) mod id cp))
    ==
      [%x %pool @ @ *]
    =/  owner  (slav %p i.t.t.path)
    =/  birth  (slav %da i.t.t.t.path)
    =/  pin  `pin:gol`[%pin owner birth]
    ?+    t.t.t.t.path  (on-peek:def path)
        [%get-pool ~]
      :-  ~  :-  ~  :-  %goal-peek
      !>  :-  %get-pool
      =/  gep  (~(get by pools) pin)
      ?~  gep
        (~(get by cache) pin)
      gep
      ::
        [%anchor ~]
      =/  pool  (~(got by pools) pin)
      ``goal-peek+!>(anchor+~(anchor pl pool))
      ::
        [%roots *]
      =/  pool  (~(got by pools) pin)
      ?+    t.t.t.t.t.path  (on-peek:def path)
          ~
        ``goal-peek+!>(roots+(hi-to-lo (turn (unnested roots) head)):~(. pl pool))
        ::
          [%uncompleted ~]
        :-  ~  :-  ~  :-  %goal-peek
        !>  :-  %roots-uncompleted
        (hi-to-lo (turn (incomplete (unnested roots)) head)):~(. pl pool)
      ==
    ==
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [%away @ @ @ *]
    =/  pid  i.t.wire
    =/  owner  `@p`i.t.t.wire
    =/  birth  `@da`i.t.t.t.wire
    =/  pin  `pin:gol`[%pin owner birth]
    ?+    -.sign  (on-agent:def wire sign)
        %poke-ack
      ?~  p.sign
        `this
      =^  cards  state
        %-  (slog u.p.sign)
        (send-home-updates:hc ~ pin our.bowl pid [vzn %poke-error u.p.sign]~)
      [cards this]
    ==
    ::
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
      =/  upd
        ?:  (~(has by pools) pin)
          (some [vzn %waste-pool ~])
        ?:  (~(has by cache) pin)
          (some [vzn %trash-pool ~])
        ~
      ?~  upd
        `this
      =^  cards  state
        %+  send-home-updates:hc 
          [%pass wire %agent [src.bowl %goal-store] %watch wire]~
        [pin src.bowl 0 [u.upd]~]
      [cards this]
        %fact
      ?>  =(p.cage.sign %goal-away-update)
      =+  ^-  [[mod=ship pid=@] =update:gol]
        !<(away-update:gol q.cage.sign)
      ?>  =(vzn -.update)  :: assert updates are correct version
      ?+    +<.update  (on-agent:def wire sign)
          $?  %spawn-pool
              %spawn-goal  %trash-goal
              %pool-perms  %pool-hitch  %pool-nexus
              %goal-perms  %goal-hitch  %goal-nexus  %goal-togls
          ==
        =^  cards  state
          (send-home-updates:hc ~ pin mod 0 [update]~)
        [cards this]
      ==
    ==
      [%groups ~]
    ?>  =(src.bowl our.bowl)
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign
        ((slog '%goal-store: Watch /groups succeeded.' ~) `this)
      ((slog '%goal-store: Watch /groups failed.' ~) `this)
      ::
        %kick
      %-  (slog '%goal-store: Got kick from %group-store, resubscribing...' ~)
      :_  this
      [%pass wire %agent [our.bowl %group-store] %watch wire]~
      ::
        %fact
      ?+    p.cage.sign  (on-agent:def wire sign)
          ?(%group-update-0 %group-action)
        =/  =update:group-store  !<(update:group-store q.cage.sign)
        :-  ~
        this(groups (~(group-update group-update [groups our.bowl]) update))
      ==
    ==
  ==
::
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
|_  =bowl:gall
+*  io    ~(. agentio bowl)
    etch  ~(. gol-cli-etch store)
::
++  en-away-path
  |=  [pid=@ =pin:gol =term]
  ^-  path
  /away/[`@`pid]/[`@`owner.pin]/[`@`birth.pin]/[term]
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
++  apex-pl  |=(=pin:gol (apex:pl (~(got by pools.store) pin)))
::
++  send-home-updates
  |=  [cards=(list card) =pin:gol mod=ship pid=@ upds=(list update:gol)]
  ^-  (quip card _state)
  =/  idx  0
  =|  home-cards=(list card)
  |-
  ?:  =(idx (lent upds))
    ::
    :: this approach using etch duplicates work updating the store
    :: (but quickest and easiest way to concordantly update index;
    ::  maybe should update eventually)
    [(weld cards home-cards) state(store (etch:etch pin upds))]
  =/  now=@  (unique-time now.bowl log)
  =/  hom=home-update:gol  [[pin mod pid] (snag idx upds)]
  %=  $
    idx  +(idx)
    log  (put:log-orm log now [%updt hom])
    home-cards  [(fact:io goal-home-update+!>(hom) ~[/goals]) home-cards]
  ==
::
++  send-away-updates
  |=  [cards=(list card) =pin:gol mod=ship pid=@ pore=_pl]
  ^-  (quip card _state)
  =+  abet:pore  :: exposes efx and pool
  ::
  :: send-home-updates performs state update
  =^  home-cards  state  (send-home-updates cards pin mod pid efx)
  :_  state
  ;:  weld  cards  home-cards
    ::
    :: send away updates
    ^-  (list card)
    %+  turn  efx
    |=  upd=update:gol
    (fact:io goal-away-update+!>([[mod pid] upd]) ~[/[`@`+<.pin]/[`@`+>.pin]])
  ==
--
