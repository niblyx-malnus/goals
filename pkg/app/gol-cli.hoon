/-  gol=goal, vyu=view, commands,
    goal-store, view-store
/+  shoe, verb, dbug, default-agent, agentio,
    gol-cli-handles, gol-cli-views, gol-cli-printer, gol-cli-scries,
    compar=gol-cli-command-parser
|%
+$  versioned-state
  $%  state-0
      state-1
      state-2
  ==
+$  state-0  state-0:vyu
+$  state-1  state-1:vyu
+$  state-2  state-2:vyu
+$  command  command:commands
+$  card  card:shoe
--
=|  state-2
=*  state  -
::
%+  verb  |
%-  agent:dbug
^-  agent:gall
%-  (agent:shoe command)
^-  (shoe:shoe command)
=<
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    des   ~(. (default:shoe this command) bowl)
    io    ~(. agentio bowl)
    hc    ~(. +> bowl)
    scry  ~(. gol-cli-scries bowl)
    hdls  ~(. gol-cli-handles handles bowl)
    vyuz  ~(. gol-cli-views views bowl)
    prtr  ~(. gol-cli-printer handles views context utc-offset bowl)
::
++  on-init
  ^-  (quip card _this)
  :_  this(views (~(put by views) [%all ~] *view:vyu))
  [%pass /goals %agent [our.bowl %goal-store] %watch /goals]~
::
++  on-save  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  |-
  ?-    -.old
      %2
    `this(state old)
      %1
    $(old (convert-1-to-2:vyu old))
      %0
    $(old (convert-0-to-1:vyu old))
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:def mark vase)
      %view-action
    =/  action  !<(action:view-store vase)
    ?-    -.action
        ::
        :: [%print ~]
        %print
        ?>  =(src.bowl our.bowl)
        =/  mode
          ?-  hide-completed
            %&  %normal
            %|  %normal-completed
          ==
        :_  this
        (nest-print:prtr context def-cols:hc mode)
        ::
        :: [%change-context c=grip]
        %change-context
      `this(context c.action)
        ::
        :: [%hide-completed ~]
        %hide-completed  `this(hide-completed %&)
        ::
        :: [%unhide-completed ~]
        %unhide-completed  `this(hide-completed %|)
        ::
        :: [%collapse ctx=grip clp=grip rec=?]
        %collapse
      `this(views (collapsify:vyuz ctx.action clp.action %normal rec.action %.n))
        ::
        :: [%uncollapse ctx=grip clp=grip rec=?]
        %uncollapse
      `this(views (collapsify:vyuz ctx.action clp.action %normal rec.action %.y))
        ::
        :: [%set-utc-offset utc-offset=[hour=@dr ahead=?]]
        %set-utc-offset
      `this(utc-offset utc-offset.action)
    ==
  ==
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
    :: poke-ack/nack on a view-command wire prompts a print
      [%view-command *]
    =*  poke-self  ~(poke-self pass:io /)
    :_  this
    [(poke-self view-action+!>(print+~))]~
    ::
      [%goals ~]
    ?>  =(src.bowl our.bowl)
    ?+    -.sign  (on-agent:def wire sign)
        %kick
      %-  (slog '%gol-cli: Got kick from %goal-store, resubscribing...' ~)
      :_  this
      [%pass wire %agent [src.bowl %goal-store] %watch wire]~
        %fact
      ?+    p.cage.sign  (on-agent:def wire sign)
          %goal-update
        =*  poke-self  ~(poke-self pass:io /)
        =/  update  !<(update:goal-store q.cage.sign)
        ?+    -.update
          :: should print only when =(mod.update our.bowl)
          :_  this
          [(poke-self view-action+!>(print+~))]~
          ::
            %error
          :_  this
          (print-cards:prtr ~[(trip msg.update)])
          ::
            ?(%initial %store-update)
          :-  [(poke-self view-action+!>(print+~))]~
          %=  this
            handles  initial:hdls
            views  initial:vyuz
          ==
          ::
            %new-goal
          :-  [(poke-self view-action+!>(print+~))]~
          %=  this
            handles  (new-goal:hdls id.update)
            views  (new-goal:vyuz id.update)
          ==
          ::
            %add-under
          :-  [(poke-self view-action+!>(print+~))]~
          %=  this
            handles  (new-goal:hdls cid.update)
            views  (new-goal:vyuz cid.update)
          ==
          ::
            %new-pool
          :-  [(poke-self view-action+!>(print+~))]~
          %=  this
            handles  (new-pool:hdls pin.update pool.update)
            views  (new-pool:vyuz pin.update pool.update)
          ==
          ::
            %delete-goal
          :-  [(poke-self view-action+!>(print+~))]~
          this(handles (delete-goal:hdls id.update))
          ::
            %delete-pool
          :-  [(poke-self view-action+!>(print+~))]~
          %=  this
            handles  (delete-pool:hdls pin.update)
          ==
        ==
      ==
    ==
  ==
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
::
++  command-parser
  |=  sole-id=@ta
  ^+  |~(nail *(like [? command]))  
  %+  stag  |
  (command-parser:compar now.bowl utc-offset)
::
++  tab-list
  |=  sole-id=@ta
  ^-  (list [@t tank])
  tab-list:commands
::
++  on-command
  |=  [sole-id=@ta =command]
  ^-  (quip card _this)
  =;  cards=(list card)
    [cards this]
  ?-    -.command
      ::
      %hide-completed
    =*  poke-self  ~(poke-self pass:io /view-command/hide-completed)
    ~[(poke-self view-action+!>([%hide-completed ~]))]
      ::
      %unhide-completed
    =*  poke-self  ~(poke-self pass:io /view-command/unhide-completed)
    ~[(poke-self view-action+!>([%unhide-completed ~]))]
      ::
      %held-yoke
    (yoke-command:hc command %held-yoke)
      ::
      %held-rend-strict
    (yoke-command:hc command %held-rend-strict)
      ::
      %nest-yoke
    (yoke-command:hc command %nest-yoke)
      ::
      %nest-rend
    (yoke-command:hc command %nest-rend)
      ::
      %prec-yoke
    (yoke-command:hc command %prec-yoke)
      ::
      %prec-rend
    (yoke-command:hc command %prec-rend)
      ::
      %prio-yoke
    (yoke-command:hc command %prio-yoke)
      ::
      %prio-rend
    (yoke-command:hc command %prio-rend)
      ::
      ::  [%invite invitee=@p =id]
      %invite
    =*  poke  ~(poke pass:io /mod-command/invite)
    =+  [msg res]=(invalid-pool-error:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke [owner.pin.res %goal-store] goal-action+!>([%invite invitee.command pin.res]))]
      ::
      ::  [%make-chef chef=@p =id]
      %make-chef
    =*  poke  ~(poke pass:io /mod-command/make-chef)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke [owner.id.res %goal-store] goal-action+!>([%make-chef chef.command id.res]))]
      ::
      ::  [%make-peon peon=@p =id]
      %make-peon
    =*  poke  ~(poke pass:io /mod-command/make-peon)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke [owner.id.res %goal-store] goal-action+!>([%make-peon peon.command id.res]))]
      ::
      :: [%new-pool title=@t]
      %new-pool
    =*  poke-our  ~(poke-our pass:io /mod-command/new-pool)
    [(poke-our %goal-store goal-action+!>([%new-pool title.command ~ ~ ~]))]~
      ::
      :: [%delete-pool-goal h=@t]
      %delete-pool-goal
    =*  poke-our  ~(poke-our pass:io /mod-command/delete-pool-goal)
    =+  [msg p]=(invalid-pool-error:prtr h.command)
    ?.  =(~ msg)
      =+  [msg g]=(invalid-goal-error:prtr h.command)
      ?.  =(~ msg)
        (print-cards:prtr ~["Invalid handle."])
      [(poke-our %goal-store goal-action+!>([%delete-goal id.g]))]~
    [(poke-our %goal-store goal-action+!>([%delete-pool pin.p]))]~
      ::
      :: [%copy-pool h=@t title=@t]
      %copy-pool
    =*  poke-our  ~(poke-our pass:io /mod-command/copy-pool)
    =+  [msg res]=(invalid-pool-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-our %goal-store goal-action+!>([%copy-pool pin.res title.command ~ ~ ~]))]~
      ::
      ::  [%add-goal desc=@t]                
      %add-goal
    =*  poke  ~(poke pass:io /mod-command/add-goal)
    ?-    -.context
        %all
      (print-cards:prtr ~["ERROR: Cannot add goal outside of a pool."])
        %pool
      :~  %+  poke  [owner.pin.context %goal-store]
          goal-action+!>([%new-goal pin.context desc.command ~ ~ ~ %.n])
      ==
        %goal
      :~  %+  poke  [owner.id.context %goal-store]
          goal-action+!>([%add-under id.context desc.command ~ ~ ~ %.n])
      ==
    ==
      ::
      ::  [%set-deadline h=@t d=(unit @da)]
      %set-deadline
    =*  poke  ~(poke pass:io /mod-command/set-deadline)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke [owner.id.res %goal-store] goal-action+!>([%set-deadline id.res d.command]))]
      ::
      :: [%set-utc-offset hours=@dr ahead=?]
      %set-utc-offset
    =*  poke-self  ~(poke-self pass:io /view-command/set-utc-offset)
    ~[(poke-self view-action+!>([%set-utc-offset hours.command ahead.command]))]
      ::
      ::  [%edit-goal-desc h=@t desc=@t]                
      %edit-goal-desc
    =*  poke  ~(poke pass:io /mod-command/edit-goal-desc)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke [owner.id.res %goal-store] goal-action+!>([%edit-goal-desc id.res desc.command]))]~
      ::
      ::  [%edit-pool-title h=@t title=@t]
      %edit-pool-title
    =*  poke  ~(poke pass:io /mod-command/edit-pool-title)
    =+  [msg res]=(invalid-pool-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke [owner.pin.res %goal-store] goal-action+!>([%edit-pool-title pin.res title.command]))]~
      ::
      :: [%print-context ~]
      %print-context
    =/  mode
      ?-  hide-completed
        %&  %normal
        %|  %normal-completed
      ==
    (nest-print:prtr context def-cols:hc mode)
      ::
      ::  [%change-context c=(unit @t)]            
      %change-context
    =*  poke-self  ~(poke-self pass:io /view-command/change-context)
    ::
    :: ~ context
    ?~  c.command  ~[(poke-self view-action+!>([%change-context %all ~]))]
    =/  grip  (~(get by hg.handles) u.c.command)
    ?~  grip  (print-cards:prtr ~["Handle does not exist."])
    ~[(poke-self view-action+!>([%change-context u.grip]))]
      ::
      ::  [%collapse h=@t rec=?]             
      %collapse
    =*  poke-self  ~(poke-self pass:io /view-command/collapse)
    =+  [msg grip]=(invalid-goal-pool-error:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke-self view-action+!>([%collapse context grip rec.command]))]
      ::
      ::  [%uncollapse h=@t rec=?]             
      %uncollapse
    =*  poke-self  ~(poke-self pass:io /view-command/uncollapse)
    =+  [msg grip]=(invalid-goal-pool-error:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke-self view-action+!>([%uncollapse context grip rec.command]))]
      ::
      :: [%harvest h=@t]
      %harvest
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    (print-goal-list:prtr (harvest:scry id.res) def-cols:hc)
      ::
      :: [%mark-actionable h=@t]
      %mark-actionable
    =*  poke  ~(poke pass:io /mod-command/mark-actionable)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke [owner.id.res %goal-store] goal-action+!>([%mark-actionable id.res]))]~
      ::
      :: [%unmark-actionable h=@t]
      %unmark-actionable
    =*  poke  ~(poke pass:io /mod-command/unmark-actionable)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke [owner.id.res %goal-store] goal-action+!>([%unmark-actionable id.res]))]~
      ::
      :: [%mark-complete h=@t]
      %mark-complete
    =*  poke  ~(poke pass:io /mod-command/mark-complete)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke [owner.id.res %goal-store] goal-action+!>([%mark-complete id.res]))]~
      ::
      :: [%unmark-complete h=@t]
      %unmark-complete
    =*  poke  ~(poke pass:io /mod-command/unmark-complete)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke [owner.id.res %goal-store] goal-action+!>([%unmark-complete id.res]))]~
  ==
::
++  can-connect
  |=  sole-id=@ta
  ^-  ?
  =(our.bowl src.bowl)
::
++  on-connect      on-connect:des
++  on-disconnect   on-disconnect:des
--
::
::
|_  =bowl:gall
+*  io    ~(. agentio bowl)
    prtr  ~(. gol-cli-printer handles views context utc-offset bowl)
    scry  ~(. gol-cli-scries bowl)
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
++  def-cols  ~[%handle %level %deadline %priority]
::
++  yoke-command
  |=  [command=[yoke-tag:gol l=@t r=@t] =yoke-tag:gol]
  ^-  (list card)
  =*  poke  ~(poke pass:io [%command yoke-tag ~])
  =+  [msg l]=(invalid-goal-error:prtr l.command)  ?.  =(~ msg)  msg
  =+  [msg r]=(invalid-goal-error:prtr r.command)  ?.  =(~ msg)  msg
  ?.  =(owner.id.l owner.id.r)  (print-cards:prtr ~["diff-ownr"])
  [(poke [owner.id.l %goal-store] goal-action+!>([%yoke-sequence (got-pin:scry id.l) [yoke-tag id.l id.r]~]))]~
--
