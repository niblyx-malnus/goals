/-  nest
/+  shoe, verb, dbug, default-agent, agentio
/+  gol-cli-goals, gol-cli-handles, gol-cli-views, gol-cli-printer
/+  dates=gol-cli-dates, compar=gol-cli-command-parser
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  $:  %0 
      =goals:nest
      =handles:nest
      =views:nest
      context=(unit id:nest)
      utc-offset=[hours=@dr ahead=?]
  ==
+$  command
  $?  [%clearall ~]                 :: clearall
      [%cc c=(unit @t)]             :: change context
      [%pg h=(unit @t)]             :: print goal
      [%ng c=@t p=@t]               :: nest goal (perhaps better ns?)
      [%fg c=@t p=@t]               :: flee/unnest goal (perhaps better un?)
      [%ap l=@t r=@t]               :: precede goal (add precedence)
      [%rp l=@t r=@t]               :: unprecede goal (remove precedence)
      [%ag desc=@t]                 :: add goal
      [%rg h=@t]                    :: remove goal
      [%pp h=@t]                    :: print parents
      [%cp h=@t rec=?]              :: collapse goal with respect to current context
      [%uc h=@t rec=?]              :: uncollapse goal
      [%sd h=@t d=(unit @d)]        :: set deadline
      [%tz hours=@dr ahead=?]       :: change utc-offset
      [%bf h=@t]                    :: print befores
      [%af h=@t]                    :: print afters
      [%hv h=@t]                    :: print harvest
      [%an h=@t]                    :: actionate goal
      [%ct h=@t]                    :: mark goal completed
      [%av h=@t]                    :: activate goal
      :: %eg                        :: edit goal
      :: %hd                        :: hide goal
      :: %uh                        :: unhide goal
      :: %ph                        :: print hidden
      :: %mv                        :: move (nest and unnest simultaneously)
      :: %pd                        :: print deadline (or other
      ::                            ::   goal-specific information)
      [%pc ~]                       :: print context
      [%pz ~]                       :: print current utc-offset
      [%pa ~]                       :: print all as list
      [%ps ~]                       :: print all sorted
      [%ds ~]                       :: sort by deadline
  ==
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
    qo    ~(. +> bowl)
    gols  ~(. gol-cli-goals goals)
    hdls  ~(. gol-cli-handles goals handles)
    vyuz  ~(. gol-cli-views goals views)
    prtr  ~(. gol-cli-printer goals handles views context utc-offset)
::
++  on-init
  ^-  (quip card _this)
  `this(views (~(put by views) ~ *goal-view:nest))
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  ?-  -.old
    %0  `this(state old)
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+  mark  (on-poke:def mark vase)
      %nest-action
    =/  action  !<(action:nest vase)
    ?-  -.action
        %add
      =/  id  (unique-id:gols bowl)
      =/  hdl  (make-handle:hdls id)
      :-  ~
      %=  this
        goals  (add-goal:gols id desc.action par.action)
        hi.handles  (~(put by hi.handles) hdl id)
        ih.handles  (~(put by ih.handles) id hdl)
        views  (~(put by views) (some id) *goal-view:nest)
      ==
        %del
      :-  ~
      %=  this
        goals  (purge-goals:gols id.action)
        handles  (purge-handles:hdls id.action)
        views  (~(del by views) id.action)
      ==
        %nest
      `this(goals (nestify:gols par.action kid.action))
        %flee
      `this(goals (unnest:gols par.action kid.action))
        %prec
      `this(goals (precede:gols ryt.action lef.action))
        %unpr
      `this(goals (unprecede:gols ryt.action lef.action))
        %clearall
      `this(state *state-0)
        %cc
      `this(context c.action)
        %clps
      `this(views (collapsify:vyuz ctx.action clp.action rec.action %.n))
        %uncl
      `this(views (collapsify:vyuz ctx.action clp.action rec.action %.y))
        %tz
      `this(utc-offset utc-offset.action)
        %sd
      :-  ~
      %=  this
        goals   %+  ~(jab by goals)  id.action
                |=(=goal:nest goal(deadline deadline.action))
      ==
        %actionate
      `this(goals (~(jab by goals) id.action actionate:gols))
        %complete
      `this(goals (~(jab by goals) id.action complete:gols))
        %activate
      `this(goals (~(jab by goals) id.action activate:gols))
      ==
  ==
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
::
++  command-parser
  |=  sole-id=@ta
  ^+  |~(nail *(like [? command]))  
  %+  stag  |
  ;~  pose
    parse-clearall:compar                            :: %clearall
    parse-add-goal:compar                            :: %ag
    parse-nest-goal:compar                           :: %ng
    parse-flee-goal:compar                           :: %fg
    parse-precede-goal:compar                        :: %ap
    parse-unprecede-goal:compar                      :: %rp
    parse-remove-goal:compar                         :: %rg
    parse-change-context:compar                      :: %cc
    parse-change-utc-offset:compar                   :: %tz
    parse-print-goal:compar                          :: %pg
    parse-print-parents:compar                       :: %pp
    parse-collapse:compar                            :: %cp
    parse-uncollapse:compar                          :: %uc
    (parse-set-deadline:compar now.bowl utc-offset)  :: %sd
    parse-print-utc-offset:compar                    :: %pz
    parse-print-all:compar                           :: %pa
    parse-print-sorted:compar                        :: %ps
    parse-deadline-sort:compar                       :: %ds
    parse-print-befs:compar                          :: %bf
    parse-print-afts:compar                          :: %af
    parse-actionate:compar                           :: %an
    parse-complete:compar                            :: %ct
    parse-activate:compar                            :: %av
    parse-harvest-progenitors:compar                 :: %hv
    parse-print-context:compar                       :: %pc
  ==
::
::
++  tab-list
  |=  sole-id=@ta
  ^-  (list [@t tank])
  :~  ['clearall' leaf+"clear data structure"]
      ['ag' leaf+"add goal"]
      ['ng' leaf+"nest goal"]
      ['fg' leaf+"flee goal"]
      ['rg' leaf+"del goal"]
      ['cc' leaf+"change context goal"]
      ['pg' leaf+"print goal substructure"]
      ['pp' leaf+"print parents"]
      ['sd' leaf+"set deadline"]
      ['tz' leaf+"change utc-offset"]
      ['pz' leaf+"print utc-offset"]
      ['ap' leaf+"add precedence"]
      ['rp' leaf+"remove precedence"]
      ['pa' leaf+"print all"]
      ['bf' leaf+"print befs"]
      ['af' leaf+"print afts"]
      ['an' leaf+"actionate"]
      ['av' leaf+"activate"]
      ['ct' leaf+"complete"]
      ['hv' leaf+"harvest progenitors"]
  ==
::
++  on-command
  |=  [sole-id=@ta =command]
  ^-  (quip card _this)
  =;  cards=(list card)
    [cards this]
  ?-  -.command
      ::
      ::  [%clearall ~]                
      %clearall
    =*  poke-self  ~(poke-self pass:io /clearall/wire)
    ;:  weld
      ~[(poke-self nest-action+!>([%clearall ~]))]
      (print-cards:prtr ~["Cleared data structure...."])
    ==
      ::
      ::  [%ag desc=@t]                
      %ag
    =*  poke-self  ~(poke-self pass:io /ag/wire)
    ;:  weld
      ~[(poke-self nest-action+!>([%add desc.command context]))]
      %-  print-cards:prtr
      :~  "Adding goal:"
          "   {(trip desc.command)}"
      ==
    ==
      ::
      ::  [%ng c=@t p=@t]
      %ng
    =*  poke-self  ~(poke-self pass:io /ng/wire)
    =+  [msg p]=(catch-handle:prtr p.command)  ?.  =(~ msg)  msg
    =+  [msg c]=(catch-handle:prtr c.command)  ?.  =(~ msg)  msg
    ;:  weld
      ~[(poke-self nest-action+!>([%nest id.p id.c]))]
      %-  print-cards:prtr
      :~  "Nesting goal:   [{(trip c.command)}]   {(trip desc.goal.c)}"
          "under goal:     [{(trip p.command)}]   {(trip desc.goal.p)}"
      ==
    ==
      ::
      ::  [%ap l=@t r=@t]
      %ap
    =*  poke-self  ~(poke-self pass:io /ap/wire)
    =+  [msg r]=(catch-handle:prtr r.command)  ?.  =(~ msg)  msg
    =+  [msg l]=(catch-handle:prtr l.command)  ?.  =(~ msg)  msg
    ;:  weld
      ~[(poke-self nest-action+!>([%prec id.r id.l]))]
      %-  print-cards:prtr
      :~  "Preceding goal:   [{(trip l.command)}]   {(trip desc.goal.l)}"
          "ahead of goal:     [{(trip r.command)}]   {(trip desc.goal.r)}"
      ==
    ==
      ::
      ::  [%fg c=@t p=@t]
      %fg
    =*  poke-self  ~(poke-self pass:io /fg/wire)
    =+  [msg p]=(catch-handle:prtr p.command)  ?.  =(~ msg)  msg
    =+  [msg c]=(catch-handle:prtr c.command)  ?.  =(~ msg)  msg
    ;:  weld
      ~[(poke-self nest-action+!>([%flee id.p id.c]))]
      %-  print-cards:prtr
      :~  "Unnesting goal:    [{(trip c.command)}]   {(trip desc.goal.c)}"
          "from under goal:   [{(trip p.command)}]   {(trip desc.goal.p)}"
      ==
    ==
      ::
      ::  [%rp l=@t r=@t]
      %rp
    =*  poke-self  ~(poke-self pass:io /rp/wire)
    =+  [msg r]=(catch-handle:prtr r.command)  ?.  =(~ msg)  msg
    =+  [msg l]=(catch-handle:prtr l.command)  ?.  =(~ msg)  msg
    ;:  weld
      ~[(poke-self nest-action+!>([%unpr id.r id.l]))]
      %-  print-cards:prtr
      :~  "Unpreceding goal:    [{(trip l.command)}]   {(trip desc.goal.l)}"
          "from ahead of goal:   [{(trip r.command)}]   {(trip desc.goal.r)}"
      ==
    ==
      ::
      ::  [%rg h=@t]            
      %rg
    =*  poke-self  ~(poke-self pass:io /rg/wire)
    =+  [msg res]=(catch-handle:prtr h.command)  ?.  =(~ msg)  msg
    ;:  weld
      ~[(poke-self nest-action+!>([%del id.res]))]
      %-  print-cards:prtr
      :~  "Removing:"
          "   [hdl]"
          "   [{(trip h.command)}]   {(trip desc.goal.res)}"
      ==
    ==
      ::
      :: [%pc ~]
      %pc
    (print:prtr context %c)
      ::
      ::  [%cc c=(unit @t)]            
      %cc
    =*  poke-self  ~(poke-self pass:io /cc/wire)
    ::
    :: ~ context
    ?~  c.command  
      ;:  weld
        ~[(poke-self nest-action+!>([%cc ~]))]
        %-  print-cards:prtr
        :~  "Context changed to:"
            "   [hdl]"
            "   [ ~ ]   All"
        ==
      ==
    =+  [msg res]=(catch-handle:prtr u.c.command)  ?.  =(~ msg)  msg
    ;:  weld
      ~[(poke-self nest-action+!>([%cc ~ id.res]))]
      %-  print-cards:prtr
      :~  "Context changed to:"
          "   [hdl]"
          "   [{(trip u.c.command)}]   {(trip desc.goal.res)}"
      ==
    ==
      ::
      ::  [%pg h=(unit @t)]            
      %pg
    ?~  h.command  (print:prtr ~ %c)
    =+  [msg res]=(catch-handle:prtr u.h.command)  ?.  =(~ msg)  msg
    (print:prtr [~ id.res] %c)
      ::
      ::  [%pp h=@t]
      %pp
    =+  [msg res]=(catch-handle:prtr h.command)  ?.  =(~ msg)  msg
    (weld (print-cards:prtr ~["Printing parents..."]) (print:prtr [~ id.res] %p))
      ::
      ::  [%cp h=@t rec=?]             
      %cp
    =*  poke-self  ~(poke-self pass:io /cp/wire)
    =+  [msg res]=(catch-handle:prtr h.command)  ?.  =(~ msg)  msg
    ;:  weld
      ~[(poke-self nest-action+!>([%clps context id.res rec.command]))]
      (print-cards:prtr ~["Collapsed {(trip h.command)}."])
    ==
      ::
      ::  [%uc h=@t rec=?]             
      %uc
    =*  poke-self  ~(poke-self pass:io /uc/wire)
    =+  [msg res]=(catch-handle:prtr h.command)  ?.  =(~ msg)  msg
    ;:  weld
      ~[(poke-self nest-action+!>([%uncl context id.res rec.command]))]
      (print-cards:prtr ~["Uncollapsed {(trip h.command)}."])
    ==
      ::
      ::  [%sd h=@t d=(unit @da)]
      %sd
    =*  poke-self  ~(poke-self pass:io /sd/wire)
    =+  [msg res]=(catch-handle:prtr h.command)  ?.  =(~ msg)  msg
    =/  date  (format-local-udate:dates d.command utc-offset)
    ;:  weld
      ~[(poke-self nest-action+!>([%sd id.res d.command]))]
      (print-cards:prtr ~[date])
    ==
      ::
      :: [%tz hours=@dr ahead=?]
      %tz
    =*  poke-self  ~(poke-self pass:io /tz/wire)
    ;:  weld
      ~[(poke-self nest-action+!>([%tz hours.command ahead.command]))]
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
    (print-goal-list:prtr ~(tap in ~(key by goals)))
      ::
      :: [%ps ~]
      %ps
    (print-goal-list:prtr (newest-to-oldest:gols ~(tap in ~(key by goals))))
      ::
      :: [%ds ~]
      %ds
    (print-goal-list:prtr (sooner-to-later:gols ~(tap in ~(key by goals))))
      ::
      :: [%bf h=@t]
      %bf
    =+  [msg res]=(catch-handle:prtr h.command)  ?.  =(~ msg)  msg
    (print-goal-list:prtr ~(tap in befs.goal.res))
      ::
      :: [%af h=@t]
      %af
    =+  [msg res]=(catch-handle:prtr h.command)  ?.  =(~ msg)  msg
    (print-goal-list:prtr ~(tap in afts.goal.res))
      ::
      :: [%hv h=@t]
      %hv
    =+  [msg res]=(catch-handle:prtr h.command)  ?.  =(~ msg)  msg
    (print-goal-list:prtr ~(tap in (harvest-unpreceded:gols id.res)))
      ::
      :: [%an h=@t]
      %an
    =*  poke-self  ~(poke-self pass:io /an/wire)
    =+  [msg res]=(catch-handle:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke-self nest-action+!>([%actionate id.res]))]
      ::
      :: [%ct h=@t]
      %ct
    =*  poke-self  ~(poke-self pass:io /ct/wire)
    =+  [msg res]=(catch-handle:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke-self nest-action+!>([%complete id.res]))]
      ::
      :: [%av h=@t]
      %av
    =*  poke-self  ~(poke-self pass:io /av/wire)
    =+  [msg res]=(catch-handle:prtr h.command)  ?.  =(~ msg)  msg
    ~[(poke-self nest-action+!>([%activate id.res]))]
  ==
::
++  can-connect
|=  sole-id=@ta
^-  ?
?|  =(~zod src.bowl)
    (team:title [our src]:bowl)
==
::
++  on-connect      on-connect:des
++  on-disconnect   on-disconnect:des
--
::
::
|_  =bowl:gall
++  echo  |=(a=* a)
--
