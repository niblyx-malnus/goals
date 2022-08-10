/-  gol=goal, vyu=view, goal-store, view-store, commands
/+  shoe, verb, dbug, default-agent, agentio,
    gol-cli-goals, gol-cli-handles, gol-cli-views, gol-cli-printer,
    dates=gol-cli-dates, compar=gol-cli-command-parser
|%
+$  versioned-state
  $%  old-state
      state-4
  ==
+$  old-state  [?(%3 %2 %1 %0) *]
+$  state-4
  $:  %4
      =goals:gol
      =store:gol
      =handles:vyu
      =views:vyu
      context=grip:vyu
      =utc-offset:dates
  ==
+$  command  command:commands
+$  card  card:shoe
--
=|  state-4
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
    gols  ~(. gol-cli-goals store)
    hdls  ~(. gol-cli-handles store handles)
    vyuz  ~(. gol-cli-views store views)
    prtr  ~(. gol-cli-printer store handles views context utc-offset)
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
    %4  `this(state old)
      ?(%3 %2 %1 %0)
    =/  new-state  *state-4
    =.  views.new-state  (~(put by views.new-state) [%all ~] *view:vyu)
    :_  this(state new-state)
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
        :_  this
        (nest-print:prtr context def-cols:hc %nest-left)
        ::
        :: [%change-context c=grip]
        %change-context
      `this(context c.action)
        ::
        :: [%collapse ctx=grip clp=id rec=?]
        %collapse
      `this(views (collapsify:vyuz ctx.action [%goal clp.action] rec.action %.n))
        ::
        :: [%uncollapse ctx=grip clp=id rec=?]
        %uncollapse
      `this(views (collapsify:vyuz ctx.action [%goal clp.action] rec.action %.y))
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
        =/  update  !<(update:goal-store q.cage.sign)
        ?+    -.update  (on-agent:def wire sign)
            %store-update
          =*  poke-self  ~(poke-self pass:io /)
          :-  [(poke-self view-action+!>(print+~))]~
          %=  this
            store  +.update
            handles  (generate:hdls +.update)
            views  (update-views:vyuz +.update)
          ==
        ==
      ==
    ==
      [%command %cc ~]
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
  ?-  -.command
      ::
      :: [%held-yoke handle handle
      %hy
    =*  poke  ~(poke pass:io /command/eg)
    =+  [msg l]=(invalid-goal-error:prtr l.command)  ?.  =(~ msg)  msg
    =+  [msg r]=(invalid-goal-error:prtr r.command)  ?.  =(~ msg)  msg
    ?.  =(owner.id.l owner.id.r)  (print-cards:prtr ~["diff-ownr"])
    [(poke [owner.id.l %goal-store] goal-action+!>([%held-yoke id.l id.r]))]~
      ::
      ::  [%invite invitee=@p =id]
      %invite
    =*  poke  ~(poke pass:io /)
    =+  [msg res]=(invalid-project-error:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke [owner.pin.res %goal-store] goal-action+!>([%invite invitee.command pin.res]))]
      ::
      ::  [%mc chef=@p =id]
      %mc
    =*  poke  ~(poke pass:io /command/eg)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke [owner.id.res %goal-store] goal-action+!>([%make-chef chef.command id.res]))]
      ::
      ::  [%mp peon=@p =id]
      %mp
    ~
    :: =*  poke-self  ~(poke-self pass:io /)
    :: =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    :: ~[(poke-self view-action+!>([%make-peon peon.command id.res]))]
      ::
      :: [%np title=@t]
      %np
    =*  poke-our  ~(poke-our pass:io /command/np)
    [(poke-our %goal-store goal-action+!>([%new-project title.command ~ ~ ~]))]~
      ::
      ::  [%ag desc=@t]                
      %ag
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
      %eg
    =*  poke  ~(poke pass:io /command/eg)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    [(poke [owner.id.res %goal-store] goal-action+!>([%edit-goal-desc id.res desc.command]))]~
      ::
      ::  [%ep h=@t title=@t]
      %ep
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
      %pt
    ~
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
      :: [%pc ~]
      %pc
    (nest-print:prtr context def-cols:hc %nest-left)
      ::
      ::  [%cc c=(unit @t)]            
      %cc
    =*  poke-self  ~(poke-self pass:io /command/cc)
    ::
    :: ~ context
    ?~  c.command  
      ;:  weld
        ~[(poke-self view-action+!>([%change-context %all ~]))]
        %-  print-cards:prtr
        :~  "Context changed to ~."
        ==
      ==
    =/  grip  (~(get by hg.handles) u.c.command)
    ?~  grip  (print-cards:prtr ~["Handle does not exist."])
    ;:  weld
      ~[(poke-self view-action+!>([%change-context u.grip]))]
      %-  print-cards:prtr
      :~  "Context changed to {(trip u.c.command)}."
      ==
    ==
      ::
      ::  [%pg h=(unit @t) cpt=?]            
      %pg
    ?:  cpt.command
      ?~  h.command  (nest-print:prtr [%all ~] def-cols:hc %nest-left-completed)
      =+  [msg res]=(invalid-goal-error:prtr u.h.command)  ?.  =(~ msg)  msg
      (nest-print:prtr [%goal id.res] def-cols:hc %nest-left-completed)
    ?~  h.command  (nest-print:prtr [%all ~] def-cols:hc %nest-left)
    =+  [msg res]=(invalid-goal-error:prtr u.h.command)  ?.  =(~ msg)  msg
    (nest-print:prtr [%goal id.res] def-cols:hc %nest-left)
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
      ::  [%cp h=@t rec=?]             
      %cp
    =*  poke-self  ~(poke-self pass:io /)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    ;:  weld
      ~[(poke-self view-action+!>([%clps context id.res rec.command]))]
      (print-cards:prtr ~["Collapsed {(trip h.command)}."])
    ==
      ::
      ::  [%uc h=@t rec=?]             
      %uc
    =*  poke-self  ~(poke-self pass:io /)
    =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    ;:  weld
      ~[(poke-self view-action+!>([%uncl context id.res rec.command]))]
      (print-cards:prtr ~["Uncollapsed {(trip h.command)}."])
    ==
      ::
      ::  [%sd h=@t d=(unit @da)]
      %sd
    ~
    :: =*  poke-self  ~(poke-self pass:io /)
    :: =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    :: =/  date  (format-local-udate:dates d.command utc-offset)
    :: ;:  weld
    ::   ~[(poke-self view-action+!>([%sd id.res d.command]))]
    ::   (print-cards:prtr ~[date])
    :: ==
      ::
      :: [%tz hours=@dr ahead=?]
      %tz
    =*  poke-self  ~(poke-self pass:io /)
    ;:  weld
      ~[(poke-self view-action+!>([%tz hours.command ahead.command]))]
      %-  print-cards:prtr
      ~["UTC {(trip (~(got by utc-offsets:dates) [hours.command ahead.command]))}"]
    ==
      ::
      :: [%pz ~]
      %pz
    (print-utc:prtr)
      ::
      :: [%pa ~]
      %pa
    (print-goal-list:prtr ~(tap in ~(key by goals)) def-cols:hc)
      ::
      :: [%ps ~]
      %ps
    (print-goal-list:prtr (newest-to-oldest:gols ~(tap in ~(key by goals))) def-cols:hc)
      ::
      :: [%ds ~]
      %ds
    (print-goal-list:prtr (sooner-to-later:gols ~(tap in ~(key by goals))) def-cols:hc)
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
    ~
    :: =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
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
      :: [%an h=@t]
      %an
    ~
    :: =*  poke-self  ~(poke-self pass:io /)
    :: =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    :: ~[(poke-self view-action+!>([%actionate id.res]))]
      ::
      :: [%ct h=@t]
      %ct
    ~
    :: =*  poke-self  ~(poke-self pass:io /)
    :: =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    :: ~[(poke-self view-action+!>([%complete id.res]))]
      ::
      :: [%av h=@t]
      %av
    ~
    :: =*  poke-self  ~(poke-self pass:io /)
    :: =+  [msg res]=(invalid-goal-error:prtr h.command)  ?.  =(~ msg)  msg
    :: ~[(poke-self view-action+!>([%activate id.res]))]
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
  ++  def-cols  ~[%handle %level %deadline %priority]
--
