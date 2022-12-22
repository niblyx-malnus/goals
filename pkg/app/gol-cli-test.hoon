/-  gol=goal, vyu=view, commands, view-store
/+  shoe, verb, dbug, default-agent, agentio,
    gol-cli-handles, gol-cli-views, gol-cli-printer, gol-cli-scries,
    compar=gol-cli-command-parser
|%
+$  versioned-state
  $%  state-4
  ==
+$  state-4 
  $:  %4
      win=$~(10 @)
      cli=_|          :: is CLI active
      tix=@           :: active timers
      reboot=?        :: do we need to reboot handles/views
      =handles:vyu
      =views:vyu
      context=grip:vyu
      hide-completed=?
      =utc-offset:vyu
  ==
+$  command  command:commands
+$  card  card:shoe
--
=|  state-4
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
  :-  (drop (~(watch-store pass:hc /watch-store)))
  this(views (~(put by *views:vyu) [%all ~] *view:vyu))
::
++  on-save  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  :: don't care; no real persistent state for now
  :: =/  old  !<(versioned-state old-state)
  :_  this(views (~(put by *views:vyu) [%all ~] *view:vyu))
  %+  welp
    %-  print-cards:prtr
    :_  ~
    ;:  weld  
      "{(trip cli-agent:gol)}: "
      "Hit ENTER at the {(trip cli-agent:gol)} prompt to re-initialize."
    ==
  (drop (~(watch-store pass:hc /watch-store)))
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
        %+  welp
          [%pass /timers %arvo %b %wait (add now.bowl ~m1)]~
        (print-context:prtr context def-cols:hc dow:hc mode)
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
        :: [%set-loc a=@]
        %set-loc
      =/  view  (~(got by views) context)
      `this(views (~(put by views) context view(loc a.action)))
        :: [%set-win a=@]
        %set-win
      `this(win a.action)
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
      =/  cards
        ?.  ?|  =(wire /mod-command/slot-above)
                =(wire /mod-command/slot-below)
            ==
          ~
        [(~(poke-self pass:io /print-context) view-action+!>(print+~))]~
      ?~  p.sign
        ?:  cli
          [cards this]
        :_  this
        %+  welp
          cards
        (print-cards:prtr ~["{(trip cli-agent:gol)}: CLI timed out. Hit ENTER at the {(trip cli-agent:gol)} prompt for updates."])
      :: 
      :: ignore stack trace; only print error message
      %-  (slog `tang`[(snag 1 u.p.sign) ~])
      `this
    ==
    ::
      _store-sub:gol :: this is the wire
    ?>  =(src.bowl our.bowl)
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign
        %-  %-  slog
            [(crip "{(trip cli-agent:gol)}: Watch {(spud store-sub:gol)} succeeded.") ~]
        :-  ~
        %=  this
          handles  initial:hdls
          views    initial:vyuz
        ==
      =/  msg  (crip "{(trip cli-agent:gol)}: Watch {(spud store-sub:gol)} failed.")
      ((slog msg ~) `this)
      ::
        %kick
      =/  msg
        %-  crip
        %+  weld
          "{(trip cli-agent:gol)}: "
        "Got kick from {(trip store-agent:gol)}, resubscribing..."
      %-  (slog msg ~)
      :_  this
      (drop (~(watch-store pass:hc /watch-store)))
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
    =*  poke-store  ~(poke-store pass:hc /mod-command/invite)
    =+  [msg res]=(invalid-pool-error:prtr h.command)  ?.  =(~ msg)  msg
    =/  pool  (got-pool:scry pin.res)
    =.  perms.pool  (~(put by perms.pool) ship.command ~) 
    ~[(poke-store goal-action+!>([vzn now.bowl %update-pool-perms pin.res perms.pool]))]
      ::
      %hide-completed
    =*  poke-self  ~(poke-self pass:io /view-command/hide-completed)
    ~[(poke-self view-action+!>([%hide-completed ~]))]
      ::
      %unhide-completed
    =*  poke-self  ~(poke-self pass:io /view-command/unhide-completed)
    ~[(poke-self view-action+!>([%unhide-completed ~]))]
      ::
      %slot-above
    =*  poke-store  ~(poke-store pass:hc /mod-command/slot-above)
    =+  [msg r]=(invalid-goal-error:prtr r.command)  ?.  =(~ msg)  msg
    =+  [msg l]=(invalid-goal-error:prtr l.command)  ?.  =(~ msg)  msg
    [(poke-store goal-action+!>([vzn now.bowl %slot-above id.r id.l]))]~
      ::
      %slot-below
    =*  poke-store  ~(poke-store pass:hc /mod-command/slot-below)
    =+  [msg r]=(invalid-goal-error:prtr r.command)  ?.  =(~ msg)  msg
    =+  [msg l]=(invalid-goal-error:prtr l.command)  ?.  =(~ msg)  msg
    [(poke-store goal-action+!>([vzn now.bowl %slot-below id.r id.l]))]~
      ::
      %held-yoke
    =*  poke-store  ~(poke-store pass:hc /mod-command/move)
    =+  [msg l]=(invalid-goal-error:prtr l.command)  ?.  =(~ msg)  msg
    =+  [msg r]=(invalid-goal-error:prtr r.command)  ?.  =(~ msg)  msg
    ?.  =(owner.id.l owner.id.r)  (print-cards:prtr ~["diff-ownr"])
    =/  pin  (got-pin:scry id.l)
    [(poke-store goal-action+!>([vzn now.bowl %move id.l (some id.r)]))]~
      ::
      %held-rend
    =*  poke-store  ~(poke-store pass:hc /mod-command/move)
    =+  [msg l]=(invalid-goal-error:prtr l.command)  ?.  =(~ msg)  msg
    =+  [msg r]=(invalid-goal-error:prtr r.command)  ?.  =(~ msg)  msg
    ?.  =(owner.id.l owner.id.r)  (print-cards:prtr ~["diff-ownr"])
    =/  pin  (got-pin:scry id.l)
    [(poke-store goal-action+!>([vzn now.bowl %move id.l ~]))]~
      ::
      $?  %nest-yoke  %nest-rend
          %prec-yoke  %prec-rend
          %prio-yoke  %prio-rend
      ==
    (yoke-command:hc command)
      ::
      :: [%spawn-pool title=@t]
      %spawn-pool
    =*  poke-store  ~(poke-store pass:hc /mod-command/spawn-pool)
    [(poke-store goal-action+!>([vzn now.bowl %spawn-pool title.command]))]~
      ::
      :: [%clone-pool h=@t title=@t]
      %clone-pool
    =*  poke-store  ~(poke-store pass:hc /mod-command/clone-pool)
    =+  [msg res]=(invalid-pool-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-store goal-action+!>([vzn now.bowl %clone-pool pin.res title.command]))]~
      ::
      :: [%cache-pool h=@t]
      %cache-pool
    =*  poke-store  ~(poke-store pass:hc /mod-command/cache-pool)
    =*  poke-self  ~(poke-self pass:io /view-command/change-context)
    =+  [msg res]=(invalid-pool-error:prtr h.command)  ?.  =(~ msg)  msg
    ;:  welp
      [(poke-store goal-action+!>([vzn now.bowl %cache-pool pin.res]))]~
      [(poke-self view-action+!>([%change-context [%all ~]]))]~
    ==
      ::
      :: [%renew-pool h=@t]
      %renew-pool
    =*  poke-store  ~(poke-store pass:hc /mod-command/renew-pool)
    =+  [msg res]=(invalid-pool-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-store goal-action+!>([vzn now.bowl %renew-pool pin.res]))]~
      ::
      :: [%trash-pool h=@t]
      %trash-pool
    =*  poke-store  ~(poke-store pass:hc /mod-command/trash-pool)
    =*  poke-self  ~(poke-self pass:io /view-command/change-context)
    =+  [msg res]=(invalid-pool-error:prtr h.command)  ?.  =(~ msg)  msg
    %+  welp
      [(poke-store goal-action+!>([vzn now.bowl %trash-pool pin.res]))]~
    [(poke-self view-action+!>([%change-context [%all ~]]))]~
      ::
      ::  [%spawn-goal desc=@t]                
      %spawn-goal
    =*  poke-store  ~(poke-store pass:hc /mod-command/spawn-goal)
    ?-    -.context
        %all
      (print-cards:prtr ~["ERROR: Cannot add goal outside of a pool."])
        %pool
      :~  %-  poke-store
          goal-action+!>([vzn now.bowl %spawn-goal pin.context ~ desc.command %|])
      ==
        %goal
      =/  pin  (got-pin:scry id.context)
      :~  %-  poke-store
          goal-action+!>([vzn now.bowl %spawn-goal pin (some id.context) desc.command %|])
      ==
    ==
      ::
      :: [%cache-goal h=@t]
      %cache-goal
    =*  poke-store  ~(poke-store pass:hc /mod-command/cache-goal)
    =+  [msg res]=(invalid-goal-id-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-store goal-action+!>([vzn now.bowl %cache-goal id.res]))]~
      ::
      :: [%renew-goal h=@t]
      %renew-goal
    =*  poke-store  ~(poke-store pass:hc /mod-command/renew-goal)
    =+  [msg res]=(invalid-goal-id-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-store goal-action+!>([vzn now.bowl %renew-goal id.res]))]~
      ::
      :: [%trash-goal h=@t]
      %trash-goal
    =*  poke-store  ~(poke-store pass:hc /mod-command/trash-goal)
    =+  [msg res]=(invalid-goal-id-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-store goal-action+!>([vzn now.bowl %trash-goal id.res]))]~
      ::
      ::  [%set-kickoff h=@t k=(unit @da)]
      %set-kickoff
    =*  poke-store  ~(poke-store pass:hc /mod-command/set-kickoff)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke-store goal-action+!>([vzn now.bowl %set-kickoff id.res k.command]))]
      ::
      ::  [%set-deadline h=@t d=(unit @da)]
      %set-deadline
    =*  poke-store  ~(poke-store pass:hc /mod-command/set-deadline)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke-store goal-action+!>([vzn now.bowl %set-deadline id.res d.command]))]
      ::
      :: [%set-utc-offset hours=@dr ahead=?]
      %set-utc-offset
    =*  poke-self  ~(poke-self pass:io /view-command/set-utc-offset)
    ~[(poke-self view-action+!>([%set-utc-offset hours.command ahead.command]))]
      ::
      :: [%set-loc a=@]
      %set-loc
    =*  poke-self  ~(poke-self pass:io /view-command/set-loc)
    ~[(poke-self view-action+!>([%set-loc a.command]))]
      ::
      :: [%set-win a=@]
      %set-win
    =*  poke-self  ~(poke-self pass:io /view-command/set-win)
    ~[(poke-self view-action+!>([%set-win a.command]))]
      ::
      ::  [%edit-goal-desc h=@t desc=@t]                
      %edit-goal-desc
    =*  poke-store  ~(poke-store pass:hc /mod-command/edit-goal-desc)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-store goal-action+!>([vzn now.bowl %edit-goal-desc id.res desc.command]))]~
      ::
      ::  [%edit-pool-title h=@t title=@t]
      %edit-pool-title
    =*  poke-store  ~(poke-store pass:hc /mod-command/edit-pool-title)
    =+  [msg res]=(invalid-pool-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-store goal-action+!>([vzn now.bowl %edit-pool-title pin.res title.command]))]~
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
    =*  poke-store  ~(poke-store pass:hc /mod-command/mark-actionable)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-store goal-action+!>([vzn now.bowl %mark-actionable id.res]))]~
      ::
      :: [%unmark-actionable h=@t]
      %unmark-actionable
    =*  poke-store  ~(poke-store pass:hc /mod-command/unmark-actionable)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-store goal-action+!>([vzn now.bowl %unmark-actionable id.res]))]~
      ::
      :: [%mark-complete h=@t]
      %mark-complete
    =*  poke-store  ~(poke-store pass:hc /mod-command/mark-complete)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-store goal-action+!>([vzn now.bowl %mark-complete id.res]))]~
      ::
      :: [%unmark-complete h=@t]
      %unmark-complete
    =*  poke-store  ~(poke-store pass:hc /mod-command/unmark-complete)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-store goal-action+!>([vzn now.bowl %unmark-complete id.res]))]~
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
  ::
  ++  poke-store
    |=  =cage
    ^-  card
    (~(poke-our pass:io wire) store-agent:gol cage)
  ::
  ++  watch-store
    |.
    ^-  (unit card)
    ?:  (~(has by wex.bowl) [store-sub:gol our.bowl store-agent:gol])  ~
    (some (~(watch-our pass:io wire) store-agent:gol store-sub:gol))
  ::
  ++  leave-store
    |.
    ^-  card
    (~(leave-our pass:io wire) store-agent:gol)
  --
::
++  def-cols  ~[%handle %level %deadline %priority]
++  dow  [loc:(~(got by views) context) win]
::
++  yoke-command
  |*  [hed=term l=@t r=@t]
  ^-  (list card)
  =*  poke-store  ~(poke-store pass /mod-command/[hed])
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
  [(poke-store goal-action+!>([vzn now.bowl %yoke pin ~[yok]]))]~
--
