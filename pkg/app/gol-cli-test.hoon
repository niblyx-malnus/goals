/-  gol=goal, vyu=view, commands, view-store
/+  shoe, verb, dbug, default-agent, agentio,
    gol-cli-handles, gol-cli-views, gol-cli-printer, gol-cli-scries,
    compar=gol-cli-command-parser
|%
+$  versioned-state
  $%  state-0
      state-1
      state-2
      state-3
  ==
+$  state-0  state-0:vyu
+$  state-1  state-1:vyu
+$  state-2  state-2:vyu
+$  state-3  state-3:vyu
+$  command  command:commands
+$  card  card:shoe
--
=|  state-3
=*  state  -
=*  vzn  vzn:gol
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
  :_  this(views (~(put by *views:vyu) [%all ~] *view:vyu))
  ?:  (~(has by wex.bowl) [/goals our.bowl %goal-store-test])
    ~
  [(~(watch-our pass:io /goals) %goal-store-test /goals)]~
::
++  on-save  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  |-
  ?-    -.old
      %3
    :-  %+  weld
          (print-cards:prtr ~["%gol-cli-test: Hit ENTER at the %gol-cli-test prompt to re-initialize."])
        ^-  (list card)
        ?:  (~(has by wex.bowl) [/goals our.bowl %goal-store-test])
          ~
        [(~(watch-our pass:io /goals) %goal-store-test /goals)]~
    %=  this
      cli        %|
      tix        0
      reboot     %&
      context    [%all ~]
      handles    *handles:vyu
      views      (~(put by *views:vyu) [%all ~] *view:vyu)
    ==
      %2
    $(old (convert-2-to-3:vyu old))
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
        =*  poke-self  ~(poke-self pass:io /print)
        ?>  =(src.bowl our.bowl)
        ::
        :: if reboot is %&, initialize handles and views
        ?:  reboot
          :-  [(poke-self view-action+!>(print+~))]~
          %=  this
            reboot  %|
            context    [%all ~]
            handles    initial:hdls
            views      initial:vyuz
          ==
        ::
        :: otherwise set a timer for automatic console printing
        :: and print-context normally
        =/  mode
          ?-  hide-completed
            %&  %normal
            %|  %normal-completed
          ==
        :_  this(cli %&, tix +(tix))
        ?:  ?-  -.context
              %all  %.n
              %goal  =(~ (get-goal:scry id.context))
              %pool  =(~ (get-pool:scry pin.context))
            ==
          =*  poke-self  ~(poke-self pass:io /view-command/change-context)
          [(poke-self view-action+!>([%change-context [%all ~]]))]~
        %+  weld
          [%pass /timers %arvo %b %wait (add now.bowl ~m1)]~
        (print-context:prtr context def-cols:hc mode)
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
    ::
    :: poke-ack on a view-command wire prompts a print
      [%view-command *]
    ?:  =(t.wire [%print-context ~])
      ?.  =(-.sign %poke-ack)
        (on-agent:def wire sign)
      `this
    ?.  =(-.sign %poke-ack)
      (on-agent:def wire sign)
    =*  poke-self  ~(poke-self pass:io /print-context)
    :_  this
    [(poke-self view-action+!>(print+~))]~
    ::
      [%mod-command *]
    ?+    -.sign  (on-agent:def wire sign)
        %poke-ack
      ?~  p.sign
        ?:  cli
          `this
        :_  this
        (print-cards:prtr ~["%gol-cli-test: CLI timed out. Hit ENTER at the %gol-cli-test prompt for updates."])
      :: 
      :: ignore stack trace; only print error message
      %-  (slog u.p.sign)
      :: %-  (slog `tang`[(snag 1 u.p.sign) ~])
      `this
    ==
    ::
      [%goals ~]
    ?>  =(src.bowl our.bowl)
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign
        %-  (slog '%gol-cli-test: Watch /goals succeeded.' ~)
        :-  ~
        %=  this
          handles  initial:hdls
          views    initial:vyuz
        ==
      %-  (slog '%gol-cli-test: Watch /goals failed.' ~)
      `this
      ::
        %kick
      %-  (slog '%gol-cli-test: Got kick from %goal-store-test, resubscribing...' ~)
      :_  this
      [%pass wire %agent [src.bowl %goal-store-test] %watch wire]~
      ::
        %fact
      ?+    p.cage.sign  (on-agent:def wire sign)
          %goal-home-update
        =*  poke-self  ~(poke-self pass:io /print-context)
        =/  cards
          ?.  cli
            ~
          [(poke-self view-action+!>(print+~))]~
        =+  ^-  [[=pin:gol mod=ship pok=@] =update:gol]
          !<(home-update:gol q.cage.sign)
        ?+    +<.update  [cards this]
          ::
            %spawn-goal
          :-  cards
          %=  this
            handles  (new-goal:hdls id.update)
            views  (new-goal:vyuz id.update)
          ==
          ::
            %spawn-pool
          :-  cards
          %=  this
            handles  (new-pool:hdls pin pool.update)
            views  (new-pool:vyuz pin pool.update)
          ==
        ==
      ==
    ==
  ==
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+    wire  (on-arvo:def wire sign-arvo)
      [%timers ~]
    ?+    sign-arvo  (on-arvo:def wire sign-arvo)
        [%behn %wake *]
      ?~  error.sign-arvo
        ?:  =(tix 0)
          `this(cli %|)
        =.  tix  (dec tix)
        ?.  =(tix 0)
          `this
        `this(cli %|)
      (on-arvo:def wire sign-arvo)
    ==
  ==
::
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
      ::  [%invite =pin ship]
      %invite
    =*  poke-our  ~(poke-our pass:io /mod-command/invite)
    =+  [msg res]=(invalid-pool-error:prtr h.command)  ?.  =(~ msg)  msg
    =/  pool  (got-pool:scry pin.res)
    =.  perms.pool  (~(put by perms.pool) ship.command ~) 
    ~[(poke-our %goal-store-test goal-action+!>([vzn now.bowl %update-pool-perms pin.res perms.pool]))]
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
    =*  poke-our  ~(poke-our pass:io /mod-command/move)
    =+  [msg l]=(invalid-goal-error:prtr l.command)  ?.  =(~ msg)  msg
    =+  [msg r]=(invalid-goal-error:prtr r.command)  ?.  =(~ msg)  msg
    ?.  =(owner.id.l owner.id.r)  (print-cards:prtr ~["diff-ownr"])
    =/  pin  (got-pin:scry id.l)
    [(poke-our %goal-store-test goal-action+!>([vzn now.bowl %move id.l (some id.r)]))]~
      ::
      %held-rend
    =*  poke-our  ~(poke-our pass:io /mod-command/move)
    =+  [msg l]=(invalid-goal-error:prtr l.command)  ?.  =(~ msg)  msg
    =+  [msg r]=(invalid-goal-error:prtr r.command)  ?.  =(~ msg)  msg
    ?.  =(owner.id.l owner.id.r)  (print-cards:prtr ~["diff-ownr"])
    =/  pin  (got-pin:scry id.l)
    [(poke-our %goal-store-test goal-action+!>([vzn now.bowl %move id.l ~]))]~
      ::
      $?  %nest-yoke  %nest-rend
          %prec-yoke  %prec-rend
          %prio-yoke  %prio-rend
      ==
    (yoke-command:hc command)
      ::
      :: [%spawn-pool title=@t]
      %spawn-pool
    =*  poke-our  ~(poke-our pass:io /mod-command/spawn-pool)
    [(poke-our %goal-store-test goal-action+!>([vzn now.bowl %spawn-pool title.command]))]~
      ::
      :: [%clone-pool h=@t title=@t]
      %clone-pool
    =*  poke-our  ~(poke-our pass:io /mod-command/clone-pool)
    =+  [msg res]=(invalid-pool-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-our %goal-store-test goal-action+!>([vzn now.bowl %clone-pool pin.res title.command]))]~
      ::
      :: [%cache-pool h=@t]
      %cache-pool
    =*  poke-our  ~(poke-our pass:io /mod-command/cache-pool)
    =*  poke-self  ~(poke-self pass:io /view-command/change-context)
    =+  [msg res]=(invalid-pool-error:prtr h.command)  ?.  =(~ msg)  msg
    ;:  weld
      [(poke-our %goal-store-test goal-action+!>([vzn now.bowl %cache-pool pin.res]))]~
      [(poke-self view-action+!>([%change-context [%all ~]]))]~
    ==
      ::
      :: [%renew-pool h=@t]
      %renew-pool
    =*  poke-our  ~(poke-our pass:io /mod-command/renew-pool)
    =+  [msg res]=(invalid-pool-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-our %goal-store-test goal-action+!>([vzn now.bowl %renew-pool pin.res]))]~
      ::
      :: [%trash-pool h=@t]
      %trash-pool
    =*  poke-our  ~(poke-our pass:io /mod-command/trash-pool)
    =*  poke-self  ~(poke-self pass:io /view-command/change-context)
    =+  [msg res]=(invalid-pool-error:prtr h.command)  ?.  =(~ msg)  msg
    ;:  weld
      [(poke-our %goal-store-test goal-action+!>([vzn now.bowl %trash-pool pin.res]))]~
      [(poke-self view-action+!>([%change-context [%all ~]]))]~
    ==
      ::
      ::  [%spawn-goal desc=@t]                
      %spawn-goal
    =*  poke-our  ~(poke-our pass:io /mod-command/spawn-goal)
    ?-    -.context
        %all
      (print-cards:prtr ~["ERROR: Cannot add goal outside of a pool."])
        %pool
      :~  %+  poke-our  %goal-store-test
          goal-action+!>([vzn now.bowl %spawn-goal pin.context ~ desc.command %|])
      ==
        %goal
      =/  pin  (got-pin:scry id.context)
      :~  %+  poke-our  %goal-store-test
          goal-action+!>([vzn now.bowl %spawn-goal pin (some id.context) desc.command %|])
      ==
    ==
      ::
      :: [%cache-goal h=@t]
      %cache-goal
    =*  poke-our  ~(poke-our pass:io /mod-command/cache-goal)
    =+  [msg res]=(invalid-goal-id-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-our %goal-store-test goal-action+!>([vzn now.bowl %cache-goal id.res]))]~
      ::
      :: [%renew-goal h=@t]
      %renew-goal
    =*  poke-our  ~(poke-our pass:io /mod-command/renew-goal)
    =+  [msg res]=(invalid-goal-id-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-our %goal-store-test goal-action+!>([vzn now.bowl %renew-goal id.res]))]~
      ::
      :: [%trash-goal h=@t]
      %trash-goal
    =*  poke-our  ~(poke-our pass:io /mod-command/trash-goal)
    =+  [msg res]=(invalid-goal-id-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-our %goal-store-test goal-action+!>([vzn now.bowl %trash-goal id.res]))]~
      ::
      ::  [%set-kickoff h=@t k=(unit @da)]
      %set-kickoff
    =*  poke-our  ~(poke-our pass:io /mod-command/set-kickoff)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke-our %goal-store-test goal-action+!>([vzn now.bowl %set-kickoff id.res k.command]))]
      ::
      ::  [%set-deadline h=@t d=(unit @da)]
      %set-deadline
    =*  poke-our  ~(poke-our pass:io /mod-command/set-deadline)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke-our %goal-store-test goal-action+!>([vzn now.bowl %set-deadline id.res d.command]))]
      ::
      :: [%set-utc-offset hours=@dr ahead=?]
      %set-utc-offset
    =*  poke-self  ~(poke-self pass:io /view-command/set-utc-offset)
    ~[(poke-self view-action+!>([%set-utc-offset hours.command ahead.command]))]
      ::
      ::  [%edit-goal-desc h=@t desc=@t]                
      %edit-goal-desc
    =*  poke-our  ~(poke-our pass:io /mod-command/edit-goal-desc)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-our %goal-store-test goal-action+!>([vzn now.bowl %edit-goal-desc id.res desc.command]))]~
      ::
      ::  [%edit-pool-title h=@t title=@t]
      %edit-pool-title
    =*  poke-our  ~(poke-our pass:io /mod-command/edit-pool-title)
    =+  [msg res]=(invalid-pool-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-our %goal-store-test goal-action+!>([vzn now.bowl %edit-pool-title pin.res title.command]))]~
      ::
      :: [%print-context ~]
      %print-context
    =*  poke-self  ~(poke-self pass:io /view-command/print-context)
    =/  mode
      ?-  hide-completed
        %&  %normal
        %|  %normal-completed
      ==
    [(poke-self view-action+!>(print+~))]~
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
    =*  poke-our  ~(poke-our pass:io /mod-command/mark-actionable)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-our %goal-store-test goal-action+!>([vzn now.bowl %mark-actionable id.res]))]~
      ::
      :: [%unmark-actionable h=@t]
      %unmark-actionable
    =*  poke-our  ~(poke-our pass:io /mod-command/unmark-actionable)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-our %goal-store-test goal-action+!>([vzn now.bowl %unmark-actionable id.res]))]~
      ::
      :: [%mark-complete h=@t]
      %mark-complete
    =*  poke-our  ~(poke-our pass:io /mod-command/mark-complete)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-our %goal-store-test goal-action+!>([vzn now.bowl %mark-complete id.res]))]~
      ::
      :: [%unmark-complete h=@t]
      %unmark-complete
    =*  poke-our  ~(poke-our pass:io /mod-command/unmark-complete)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-our %goal-store-test goal-action+!>([vzn now.bowl %unmark-complete id.res]))]~
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
  ::
  ++  leave-other
    |=  other=@p
    ^-  card
    (~(leave pass:io wire) other dap.bowl)
  --
::
++  def-cols  ~[%handle %level %deadline %priority]
::
++  yoke-command
  |*  [hed=term l=@t r=@t]
  ^-  (list card)
  =*  poke-our  ~(poke-our pass:io /mod-command/[hed])
  =+  [msg l]=(invalid-goal-error:prtr l)  ?.  =(~ msg)  msg
  =+  [msg r]=(invalid-goal-error:prtr r)  ?.  =(~ msg)  msg
  ?.  =(owner.id.l owner.id.r)  (print-cards:prtr ~["diff-ownr"])
  =/  pin  (got-pin:scry id.l)
  =/  yok=exposed-yoke:gol
    ?+    hed  !!
      %prio-rend  [%prio-rend id.l id.r]
      %prio-yoke  [%prio-yoke id.l id.r]
      %prec-rend  [%prec-rend id.l id.r]
      %prec-yoke  [%prec-yoke id.l id.r]
      %nest-rend  [%nest-rend id.l id.r]
      %nest-yoke  [%nest-yoke id.l id.r]
      %hook-rend  [%hook-rend id.l id.r]
      %hook-yoke  [%hook-yoke id.l id.r]
      %held-rend  [%held-rend id.l id.r]
      %held-yoke  [%held-yoke id.l id.r]
    ==
  [(poke-our %goal-store-test goal-action+!>([vzn now.bowl %yoke pin ~[yok]]))]~
--
