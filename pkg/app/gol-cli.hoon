/-  gol=goal, vyu=view, goal-store, view-store, commands
/+  shoe, verb, dbug, default-agent, agentio,
    gol-cli-goals, gol-cli-handles, gol-cli-views, gol-cli-printer, gol-cli-goal-store,
    dates=gol-cli-dates, compar=gol-cli-command-parser, pr=gol-cli-project
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  $:  %0
      =store:gol
      =handles:vyu
      =views:vyu
      context=grip:vyu
      hide-completed=?
      =utc-offset:dates
  ==
+$  command  command:commands
+$  card  card:shoe
--
=|  state-0
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
    gs    ~(. gol-cli-goal-store store)
    gols  ~(. gol-cli-goals store)
    hdls  ~(. gol-cli-handles store handles)
    vyuz  ~(. gol-cli-views store views)
    prtr  ~(. gol-cli-printer store handles views context utc-offset bowl)
    directory  directory.store
    projects  projects.store
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
      %0
    :_  this(state old)
    [%pass /goals %agent [our.bowl %goal-store] %watch /goals]~
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
        ?+    -.update  (on-agent:def wire sign)
            %store-update
          :-  [(poke-self view-action+!>(print+~))]~
          %=  this
            store  +.update
            handles  (generate:hdls +.update)
            views  (update-views:vyuz +.update)
          ==
            %new-goal
          =/  new-store  (new-goal:update:gs +.update)
          :-  [(poke-self view-action+!>(print+~))]~
          %=  this
            store  new-store
            handles  (add-new-goal:hdls id.update new-store)
            views  (add-new-goal:vyuz id.update new-store)
          ==
            %add-under
          =/  new-store  (add-under:update:gs +.update)
          :-  [(poke-self view-action+!>(print+~))]~
          %=  this
            store  new-store
            handles  (add-new-goal:hdls cid.update new-store)
            views  (add-new-goal:vyuz cid.update new-store)
          ==
            %yoke-sequence
          :_  this(store (yoke-sequence:update:gs +.update))
          [(poke-self view-action+!>(print+~))]~
        ==
      ==
    ==
      [%view-command *]
    =*  poke-self  ~(poke-self pass:io /)
    :_  this
    [(poke-self view-action+!>(print+~))]~
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
      %hide-completed
    =*  poke-self  ~(poke-self pass:io /view-command/hide-completed)
    ~[(poke-self view-action+!>([%hide-completed ~]))]
      %unhide-completed
    =*  poke-self  ~(poke-self pass:io /view-command/unhide-completed)
    ~[(poke-self view-action+!>([%unhide-completed ~]))]
      %held-yoke
    (yoke-command:hc command %held-yoke)
      %held-rend
    (yoke-command:hc command %held-rend)
      %nest-yoke
    (yoke-command:hc command %nest-yoke)
      %nest-rend
    (yoke-command:hc command %nest-rend)
      %prec-yoke
    (yoke-command:hc command %prec-yoke)
      %prec-rend
    (yoke-command:hc command %prec-rend)
      %prio-yoke
    (yoke-command:hc command %prio-yoke)
      %prio-rend
    (yoke-command:hc command %prio-rend)
      %held-left  ~
      %nest-left  ~
      %prec-left  ~
      %prio-left  ~
      ::
      ::  [%invite invitee=@p =id]
      %invite
    =*  poke  ~(poke pass:io /)
    =+  [msg res]=(invalid-project-error:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke [owner.pin.res %goal-store] goal-action+!>([%invite invitee.command pin.res]))]
      ::
      ::  [%make-chef chef=@p =id]
      %make-chef
    =*  poke  ~(poke pass:io /command/mc)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    =/  check  (make-chef:check:gs id.res chef.command our.bowl)
    ?.  -.check  (print-cards:prtr ~[(trip (scot %tas +.check))])
    ~[(poke [owner.id.res %goal-store] goal-action+!>([%make-chef chef.command id.res]))]
      ::
      ::  [%make-peon peon=@p =id]
      %make-peon
    =*  poke  ~(poke pass:io /command/mp)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    =/  check  (make-peon:check:gs id.res peon.command our.bowl)
    ?.  -.check  (print-cards:prtr ~[(trip (scot %tas +.check))])
    ~[(poke [owner.id.res %goal-store] goal-action+!>([%make-peon peon.command id.res]))]
      ::
      :: [%new-project title=@t]
      %new-project
    =*  poke-our  ~(poke-our pass:io /command/new-project)
    [(poke-our %goal-store goal-action+!>([%new-project title.command ~ ~ ~]))]~
      ::
      :: [%delete-project-goal h=@t]
      %delete-project-goal
    =*  poke-our  ~(poke-our pass:io /command/delete-project-goal)
    =+  [msg p]=(invalid-project-error:prtr h.command)
    ?.  =(~ msg)
      =+  [msg g]=(invalid-goal-error:prtr h.command)
      ?.  =(~ msg)
        (print-cards:prtr ~["Invalid handle."])
      =/  check  (delete-goal:check:gs id.g our.bowl)
      ?.  -.check  (print-cards:prtr ~[(trip (scot %tas +.check))])
      [(poke-our %goal-store goal-action+!>([%delete-goal id.g]))]~
    [(poke-our %goal-store goal-action+!>([%delete-project pin.p]))]~
      ::
      :: [%copy-project h=@t title=@t]
      %copy-project
    =*  poke-our  ~(poke-our pass:io /command/copy-project)
    =+  [msg res]=(invalid-project-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke-our %goal-store goal-action+!>([%copy-project pin.res title.command ~ ~ ~]))]~
      ::
      ::  [%ag desc=@t]                
      %add-goal
    =*  poke  ~(poke pass:io /command/ag)
    ?-    -.context
        %all
      (print-cards:prtr ~["ERROR: Cannot add goal outside of a project."])
        %project
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
    =*  poke  ~(poke pass:io /)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke [owner.id.res %goal-store] goal-action+!>([%set-deadline id.res d.command]))]
      ::
      :: [%set-utc-offset hours=@dr ahead=?]
      %set-utc-offset
    =*  poke-self  ~(poke-self pass:io /view-command/tz)
    ~[(poke-self view-action+!>([%set-utc-offset hours.command ahead.command]))]
      ::
      ::  [%at desc=@t]                
      %at
    ~
    :: =*  poke-self  ~(poke-self pass:io /)
    :: ;:  weld
    ::   ~[(poke-self view-action+!>([%add desc.command context %.y]))]
    ::   %-  print-cards:prtr
    ::   :~  "Adding actionable goal:"
    ::       "   {(trip desc.command)}"
    ::   ==
    :: ==
      ::
      ::  [%eg h=@t desc=@t]                
      %edit-goal-desc
    =*  poke  ~(poke pass:io /command/eg)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke [owner.id.res %goal-store] goal-action+!>([%edit-goal-desc id.res desc.command]))]~
      ::
      ::  [%edit-project-title h=@t title=@t]
      %edit-project-title
    =*  poke  ~(poke pass:io /command/ep)
    =+  [msg res]=(invalid-project-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke [owner.pin.res %goal-store] goal-action+!>([%edit-project-title pin.res title.command]))]~
      ::
      ::  [%ng c=@t p=@t]
      %ng
    ~
    :: =*  poke-self  ~(poke-self pass:io /)
    :: =+  [msg p]=(invalid-goal-error:prtr p.command)  ?.  =(~ msg)  msg
    :: =+  [msg c]=(invalid-goal-error:prtr c.command)  ?.  =(~ msg)  msg
    :: ;:  weld
    ::   ~[(poke-self view-action+!>([%nest id.p id.c]))]
    ::   %-  print-cards:prtr
    ::   :~  "Nesting goal:   [{(trip c.command)}]   {(trip desc.goal.c)}"
    ::       "under goal:     [{(trip p.command)}]   {(trip desc.goal.p)}"
    ::   ==
    :: ==
      ::
      ::  [%mv c=@t p=@t]
      %mv
    ~
    :: =*  poke-self  ~(poke-self pass:io /)
    :: =+  [msg p]=(invalid-goal-error:prtr p.command)  ?.  =(~ msg)  msg
    :: =+  [msg c]=(invalid-goal-error:prtr c.command)  ?.  =(~ msg)  msg
    :: ;:  weld
    ::   ^-  (list card)
    ::   ?-    -.context
    ::     %all  ~[(poke-self view-action+!>([%nest id.p id.c]))]
    ::     %project  !!
    ::       %goal
    ::     :~  (poke-self view-action+!>([%flee +.context id.c]))
    ::         (poke-self view-action+!>([%nest id.p id.c]))
    ::     ==
    ::   ==
    ::   %-  print-cards:prtr
    ::   :~  "Moving goal:   [{(trip c.command)}]   {(trip desc.goal.c)}"
    ::       "under goal:     [{(trip p.command)}]   {(trip desc.goal.p)}"
    ::   ==
    :: ==
      ::
      ::  [%ap l=@t r=@t]
      %ap
    ~
    :: =*  poke-self  ~(poke-self pass:io /)
    :: =+  [msg r]=(invalid-goal-error:prtr r.command)  ?.  =(~ msg)  msg
    :: =+  [msg l]=(invalid-goal-error:prtr l.command)  ?.  =(~ msg)  msg
    :: ;:  weld
    ::   ~[(poke-self view-action+!>([%prec id.r id.l]))]
    ::   %-  print-cards:prtr
    ::   :~  "Preceding goal:   [{(trip l.command)}]   {(trip desc.goal.l)}"
    ::       "ahead of goal:     [{(trip r.command)}]   {(trip desc.goal.r)}"
    ::   ==
    :: ==
      ::
      ::  [%fg c=@t p=@t]
      %fg
    ~
    :: =*  poke-self  ~(poke-self pass:io /)
    :: =+  [msg p]=(invalid-goal-error:prtr p.command)  ?.  =(~ msg)  msg
    :: =+  [msg c]=(invalid-goal-error:prtr c.command)  ?.  =(~ msg)  msg
    :: ;:  weld
    ::   ~[(poke-self view-action+!>([%flee id.p id.c]))]
    ::   %-  print-cards:prtr
    ::   :~  "Unnesting goal:    [{(trip c.command)}]   {(trip desc.goal.c)}"
    ::       "from under goal:   [{(trip p.command)}]   {(trip desc.goal.p)}"
    ::   ==
    :: ==
      ::
      ::  [%pt l=@t r=@t]
    :: =*  poke-self  ~(poke-self pass:io /)
    :: =+  [msg r]=(invalid-goal-error:prtr r.command)  ?.  =(~ msg)  msg
    :: =+  [msg l]=(invalid-goal-error:prtr l.command)  ?.  =(~ msg)  msg
    :: ;:  weld
    ::   ~[(poke-self view-action+!>([%prio id.r id.l]))]
    ::   %-  print-cards:prtr
    ::   :~  "Prioritize goal:   [{(trip l.command)}]   {(trip desc.goal.l)}"
    ::       "over goal:     [{(trip r.command)}]   {(trip desc.goal.r)}"
    ::   ==
    :: ==
      ::
      ::  [%up r=@t l=@t]
      %up
    ~
    :: =*  poke-self  ~(poke-self pass:io /)
    :: =+  [msg r]=(invalid-goal-error:prtr r.command)  ?.  =(~ msg)  msg
    :: =+  [msg l]=(invalid-goal-error:prtr l.command)  ?.  =(~ msg)  msg
    :: ;:  weld
    ::   ~[(poke-self view-action+!>([%uprt id.r id.l]))]
    ::   %-  print-cards:prtr
    ::   :~  "Unprioritize goal:    [{(trip l.command)}]   {(trip desc.goal.l)}"
    ::       "from over goal:   [{(trip r.command)}]   {(trip desc.goal.r)}"
    ::   ==
    :: ==
      ::
      ::  [%rp l=@t r=@t]
      %rp
    ~
    :: =*  poke-self  ~(poke-self pass:io /)
    :: =+  [msg r]=(invalid-goal-error:prtr r.command)  ?.  =(~ msg)  msg
    :: =+  [msg l]=(invalid-goal-error:prtr l.command)  ?.  =(~ msg)  msg
    :: ;:  weld
    ::   ~[(poke-self view-action+!>([%unpr id.r id.l]))]
    ::   %-  print-cards:prtr
    ::   :~  "Unpreceding goal:    [{(trip l.command)}]   {(trip desc.goal.l)}"
    ::       "from ahead of goal:   [{(trip r.command)}]   {(trip desc.goal.r)}"
    ::   ==
    :: ==
      ::
      ::  [%rg h=@t]            
      %rg
   ~
   ::  =*  poke-self  ~(poke-self pass:io /)
   ::  =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
   ::  ;:  weld
   ::    ~[(poke-self view-action+!>([%del id.res]))]
   ::    %-  print-cards:prtr
   ::    :~  "Removing:"
   ::        "   [hdl]"
   ::        "   [{(trip h.command)}]   {(trip desc.goal.res)}"
   ::    ==
   ::  ==
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
      ::  [%pg h=(unit @t) cpt=?]            
      %pg
    ~
   ::  ?:  cpt.command
   ::    ?~  h.command  (nest-print:prtr [%all ~] def-cols:hc %nest-left-completed)
   ::    =+  [msg res]=(invalid-goal-error:prtr u.h.command)  ?.  =(~ msg)  msg
   ::    (nest-print:prtr [%goal id.res] def-cols:hc %nest-left-completed)
   ::  ?~  h.command  (nest-print:prtr [%all ~] def-cols:hc %nest-left)
   ::  =+  [msg res]=(invalid-goal-error:prtr u.h.command)  ?.  =(~ msg)  msg
   ::  (nest-print:prtr [%goal id.res] def-cols:hc %nest-left)
      ::
      ::  [%pp h=@t]
      %pp
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    ;:  weld
      (print-cards:prtr ~["Printing parents..."])
      (nest-print:prtr [%goal id.res] def-cols:hc %nest-ryte)
    ==
      ::
      ::  [%ppc h=@t]
      %ppc
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    ;:  weld
      (print-cards:prtr ~["Printing precedents..."])
      (nest-print:prtr [%goal id.res] def-cols:hc %prec-left)
    ==
      ::
      ::  [%collapse h=@t rec=?]             
      %collapse
    =*  poke-self  ~(poke-self pass:io /view-command/cp)
    =+  [msg grip]=(invalid-goal-project-error:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke-self view-action+!>([%collapse context grip rec.command]))]
      ::
      ::  [%uncollapse h=@t rec=?]             
      %uncollapse
    =*  poke-self  ~(poke-self pass:io /view-command/uc)
    =+  [msg grip]=(invalid-goal-project-error:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke-self view-action+!>([%uncollapse context grip rec.command]))]
      ::
      :: [%pa ~]
      %pa
    ~ :: (print-goal-list:prtr ~(tap in ~(key by goals)) def-cols:hc)
      ::
      :: [%ps ~]
      %ps
    ~ :: (print-goal-list:prtr (newest-to-oldest:gols ~(tap in ~(key by goals))) def-cols:hc)
      ::
      :: [%ds ~]
      %ds
    ~  :: (print-goal-list:prtr (sooner-to-later:gols ~(tap in ~(key by goals))) def-cols:hc)
      ::
      :: [%bf h=@t]
      %bf
    ~
    :: =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    :: (print-goal-list:prtr ~(tap in befs.goal.res) def-cols:hc)
      ::
      :: [%af h=@t]
      %af
    ~
    :: =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    :: (print-goal-list:prtr ~(tap in afts.goal.res) def-cols:hc)
      ::
      :: [%hv h=@t]
      %hv
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    =/  pin  (~(got by directory.store) id.res)
    =/  project  (~(got by projects.store) pin)
    (print-goal-list:prtr ~(tap in (~(left-preceded pr pin project) id.res)) def-cols:hc)
    :: ?-  hv-flag.command
    ::     %actionable
    ::   ;:  weld
    ::     (print-cards:prtr ~["Harvesting actionable from {(trip h.command)}:"])
    ::     (print-goal-list:prtr ~(tap in (harvest-actionable-active:gols id.res)) def-cols:hc)
    ::   ==
    ::     %completed
    ::   ;:  weld
    ::     (print-cards:prtr ~["Harvesting completed from {(trip h.command)}:"])
    ::     (print-goal-list:prtr ~(tap in (harvest-completed:gols id.res)) def-cols:hc)
    ::   ==
    ::     %unpreceded
    ::   ;:  weld
    ::     (print-cards:prtr ~["Harvesting unpreceded from {(trip h.command)}:"])
    ::     (print-goal-list:prtr ~(tap in (harvest-unpreceded:gols id.res)) def-cols:hc)
    ::   ==
    :: ==
      ::
      :: [%mark-actionable h=@t]
      %mark-actionable
    =*  poke  ~(poke pass:io /command/mark-actionable)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke [owner.id.res %goal-store] goal-action+!>([%mark-actionable id.res]))]~
      ::
      :: [%unmark-actionable h=@t]
      %unmark-actionable
    =*  poke  ~(poke pass:io /command/mark-actionable)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke [owner.id.res %goal-store] goal-action+!>([%unmark-actionable id.res]))]~
      ::
      :: [%mark-complete h=@t]
      %mark-complete
    =*  poke  ~(poke pass:io /command/mark-complete)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke [owner.id.res %goal-store] goal-action+!>([%mark-complete id.res]))]~
      ::
      :: [%unmark-complete h=@t]
      %unmark-complete
    =*  poke  ~(poke pass:io /command/unmark-complete)
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
    prtr  ~(. gol-cli-printer store handles views context utc-offset bowl)
    gols  ~(. gol-cli-goals store)
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
++  def-cols  ~[%handle %level %deadline %priority]
++  yoke-command
  |=  [command=[yoke-tag:gol l=@t r=@t] =yoke-tag:gol]
  ^-  (list card)
  =*  poke  ~(poke pass:io [%command yoke-tag ~])
  =+  [msg l]=(invalid-goal-error:prtr l.command)  ?.  =(~ msg)  msg
  =+  [msg r]=(invalid-goal-error:prtr r.command)  ?.  =(~ msg)  msg
  ?.  =(owner.id.l owner.id.r)  (print-cards:prtr ~["diff-ownr"])
  =/  pin  (~(got by directory.store) id.l)
  =/  project  (~(got by projects.store) pin)
  =/  check  (~(apply-sequence pr pin project) our.bowl [yoke-tag id.l id.r]~)
  ?-    -.check
    %|  (print-cards:prtr ~[(trip (scot %tas +.check))])
    %&  [(poke [owner.id.l %goal-store] goal-action+!>([%yoke-sequence pin [yoke-tag id.l id.r]~]))]~
  ==
--