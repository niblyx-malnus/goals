::
/-  nest
/+  shoe, verb, dbug, default-agent, handle
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 =goals:nest =handles:nest =context:nest]
+$  command
  $?  [%clearall ~]
      [%ng c=(unit @t) p=(unit @t)] :: perhaps better ns?
      [%fg c=(unit @t) p=(unit @t)] :: perhaps better un?
      [%ag desc=@t]
      [%rg h=(unit @t)]
      [%cc c=(unit @t)]
      [%pg h=(unit @t)]
      [%pp h=(unit @t)]
      :: %eg  edit goal
      :: %cp  collapse goal
      :: %uc  uncollapse goal
      :: %hd  hide goal
      :: %uh  unhide goal
      :: %ph  print hidden
      :: %mv  move (nest and unnest simultaneously)
      :: %pr  print progenitors (unpreceded, actionable goals)
      :: %pd  print deadline
      [%pc ~]
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
    qo    ~(. +> bowl)
::
++  on-init
  ^-  (quip card _this)
  `this
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
      =/  gol  *goal:nest
      =.  desc.gol  desc.action
      ?:  (~(has by goals) [our.bowl now.bowl])
        $(now.bowl (add now.bowl ~s0..0001))
      =/  gid  [our.bowl now.bowl]
      =/  hdl  (make-handle gid)
      :-  ~
      %=  this
        goals  ?~  par.action  (~(put by goals) gid gol)
               (nestify (~(put by goals) gid gol) u.par.action gid)
        hi.handles  (~(put by hi.handles) hdl gid)
        ih.handles  (~(put by ih.handles) gid hdl)
      ==
        %del
      :-  ~
      %=  this
        goals  (purge-goals id.action)
        handles  (purge-handles id.action)
      ==
        %nest
      `this(goals (nestify goals par.action kid.action))
        %flee
      `this(goals (unnest goals par.action kid.action))
        %clearall
      `this(state *state-0)
        %cc
      `this(context c.action)
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
  |=  sole-id=@ta  :: takes a session id
  ^+  |~(nail *(like [? command]))  
  %+  stag  |
  ;~  pose
    (cold [%clearall ~] (jest 'clearall'))
    ;~((glue ace) (cold %ag (jest 'ag')) qut)
    ;~((glue ace) (cold %ng (jest 'ng')) (parse-hndl) (parse-hndl))
    ;~((glue ace) (cold %fg (jest 'fg')) (parse-hndl) (parse-hndl))
    ;~((glue ace) (cold %rg (jest 'rg')) (parse-hndl))
    ;~((glue ace) (cold %cc (jest 'cc')) (parse-hndl))
    ;~((glue ace) (cold %pg (jest 'pg')) (parse-hndl))
    ;~((glue ace) (cold %pp (jest 'pp')) (parse-hndl))
    (cold [%pc ~] (jest ''))
  ==
   
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
  ==
::
++  on-command
  |=  [sole-id=@ta =command]
  ^-  (quip card _this)
  =;  cards=(list card)
    [cards this]
  ?-  -.command
      %clearall
    ;:  weld
      (print-cards ~["Cleared data structure...."])
      (poke-cards ~[[/clearall/wire [%clearall ~]]])
    ==
      %ag
    ;:  weld
      (poke-cards ~[[/ag/wire [%add desc.command context]]])
      %-  print-cards
      :~  "Adding goal:"
          "   {(trip desc.command)}"
      ==
    ==
      %ng
    ?~  p.command  (print-cards ~["ERROR: Null parent handle." ""])
    ?~  c.command  (print-cards ~["ERROR: Null child handle." ""])
    =/  p=(unit [=id:nest =goal:nest])  (hg-catch u.p.command)
    =/  c=(unit [=id:nest =goal:nest])  (hg-catch u.c.command)
    ?~  p  (print-cards ~["ERROR: Invalid parent handle." ""])
    ?~  c  (print-cards ~["ERROR: Invalid child handle." ""])
    ;:  weld
      %-  print-cards
      :~  "Nesting goal:   [{(trip u.c.command)}]   {(trip desc.goal.u.c)}"
          "under goal:     [{(trip u.p.command)}]   {(trip desc.goal.u.p)}"
      ==
      (poke-cards ~[[/ng/wire [%nest id.u.p id.u.c]]])
    ==
      %fg
    ?~  p.command  (print-cards ~["ERROR: Null parent handle." ""])
    ?~  c.command  (print-cards ~["ERROR: Null child handle." ""])
    =/  p=(unit [=id:nest =goal:nest])  (hg-catch u.p.command)
    =/  c=(unit [=id:nest =goal:nest])  (hg-catch u.c.command)
    ?~  p  (print-cards ~["ERROR: Invalid parent handle." ""])
    ?~  c  (print-cards ~["ERROR: Invalid child handle." ""])
    ;:  weld
      %-  print-cards
      :~  "Unnesting goal:    [{(trip u.c.command)}]   {(trip desc.goal.u.c)}"
          "from under goal:   [{(trip u.p.command)}]   {(trip desc.goal.u.p)}"
      ==
      (poke-cards ~[[/ng/wire [%flee id.u.p id.u.c]]])
    ==
      %rg
    ?~  h.command  (print-cards ~["ERROR: Null goal." ""])
    =/  g=(unit [=id:nest =goal:nest])  (hg-catch u.h.command)
    ?~  g  (print-cards ~["ERROR: Invalid handle." ""])
    ;:  weld
      %-  print-cards
      :~  "Removing:"
          "   [hdl]"
          "   [{(trip u.h.command)}]   {(trip desc.goal.u.g)}"
      ==
      (poke-cards ~[[/rg/wire [%del id.u.g]]])
    ==
      %pc
    (print context %c)
      %cc
    ?~  c.command  
      %+  weld
        (poke-cards ~[[/cc/wire [%cc ~]]])
      %-  print-cards
      :~  "Context changed to:"
          "   [hdl]"
          "   [ ~ ]   All"
      ==
    =/  g=(unit [=id:nest =goal:nest])  (hg-catch u.c.command)
    ?~  g  (print-cards ~["ERROR: Invalid handle."])
    ;:  weld
      (poke-cards ~[[/cc/wire [%cc [~ id.u.g]]]])
      %-  print-cards
      :~  "Context changed to:"
          "   [hdl]"
          "   [{(trip u.c.command)}   {(trip desc.goal.u.g)}"
      ==
    ==
      %pg
    ?~  h.command
      (print ~ %c)
    =/  g=(unit [=id:nest =goal:nest])  (hg-catch u.h.command)
    ?~  g  (print-cards ~["ERROR: Invalid handle."])
    (print [~ id.u.g] %c)
      %pp
    ?~  h.command
      (weld (print-cards ~["Printing parents..."]) (print ~ %p))
    =/  g=(unit [=id:nest =goal:nest])  (hg-catch u.h.command)
    ?~  g  (print-cards ~["ERROR: Invalid handle."])
    (weld (print-cards ~["Printing parents..."]) (print [~ id.u.g] %p))
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
::
::
++  parse-hndl
  |.  
  ;~  pose
    (cook |=(a=tape [~ (crip a)]) (stun [3 100] (shim 33 126)))
    (cold %~ (just '~'))
  ==
::
:: make a unique handle based on the goal id
++  make-handle
  |=  =id:nest 
  ^-  @t
  =/  grp=tape  (grip:handle id)
  =/  idx=@  3
  |-
  ?:  =(idx (lent grp))  ~&('Handle uniqueness error!' !!)
  ?:  (~(has by hi.handles) (crip (swag [0 idx] grp)))
    $(idx +(idx))
  (crip (swag [0 idx] grp))
::
:: get goal from handle ([gid gol]) and crash if does not exist
++  hg-crash
  |=  hdl=@t
  ^-  [id:nest goal:nest]
  =/  gid  (~(got by hi.handles) hdl)
  [gid (~(got by goals) gid)]
::
:: get goal from handle (?(~ [~ [gid gol]])) returning null if does not
:: exist
++  hg-catch
  |=  hdl=@t
  ^-  (unit [id:nest goal:nest])
  =/  gid  (~(get by hi.handles) hdl)
  ?~  gid  ~
  [~ u.gid (~(got by goals) u.gid)]
::
:: get roots
++  roots
  |.
  ^-  (list id:nest)
  %:  turn
  (skim ~(tap by goals) |=([=id:nest =goal:nest] =(0 ~(wyt in pars.goal))))
  |=(a=[id:nest goal:nest] -.a)
  ==
::
:: get leaves
++  leaves
  |.
  ^-  (list id:nest)
  %:  turn
  (skim ~(tap by goals) |=([=id:nest =goal:nest] =(0 ~(wyt in kids.goal))))
  |=(a=[id:nest goal:nest] -.a)
  ==
::
:: Check if did is descendent of aid
++  descends
  |=  [=goals:nest aid=id:nest did=id:nest]
  =/  anc  (~(get by goals) aid)
  ?~  anc  ~&('Invalid aid.' !!)
  ?~  (~(get by goals) did)  ~&('Invalid did.' !!)
  ^-  ?
  ?:  =(0 ~(wyt in kids.u.anc))  %.n  :: if a has no children, d not descendent
  ?:  (~(has in kids.u.anc) did)  %.y  :: if d is child of a, d is descendent
  (~(any in kids.u.anc) (curr (cury descends goals) did))  :: apply descends to all children
::
:: Nest cid under pid
++  nestify
 |=  [=goals:nest pid=id:nest cid=id:nest]
 ?:  =(pid cid)  ~&('Cannot nest goal under itself.' !!)
 =/  par  (~(get by goals) pid)
 ?~  par  ~&('Invalid pid.' !!) :: pid must exist in goals
 ?~  (~(get by goals) cid)  ~&('Invalid cid.' !!) :: cid must exist in goals
 ?:  (~(has in kids.u.par) cid)  goals  :: if already nested, leave unchanged
 ?:  (descends goals cid pid)  !!  :: if p is descendent of c, cannot nest
 :: if already nested, does nothing
 :: return goals updated with nesting
 %-
 %~  jab  by
 (~(jab by goals) pid |=(par=goal:nest par(kids (~(put in kids.par) cid))))
 :-  cid
 |=(kid=goal:nest kid(pars (~(put in pars.kid) pid)))
::
:: Unnest cid from under pid
++  unnest
  |=  [=goals:nest pid=id:nest cid=id:nest]
  %-
  %~  jab  by
  (~(jab by goals) pid |=(par=goal:nest par(kids (~(del in kids.par) cid))))
  :-  cid
  |=(kid=goal:nest kid(pars (~(del in pars.kid) pid)))
::
::  get depth of a given goal (lowest level is depth of 1)
++  plumb
  |=  =id:nest
  =/  gol=(unit goal:nest)  (~(get by goals) id)
  ?~  gol  ~&('Goal does not exist.' !!)
  ^-  @
  =/  upr=@  1
  ?:  =(0 ~(wyt in kids.u.gol))
    upr
  =/  idx=@  0
  =/  kids  ~(tap in kids.u.gol)
  |-
  ?:  =(idx (lent kids))
    (add 1 upr)
  $(idx +(idx), upr (max upr (plumb (snag idx kids))))
::
:: get max depth + 1
++  anchor
  |.
  +((roll (turn (roots) plumb) max))
::
:: purge goal from goals and from children and parents
++  purge-goals
  |=  =id:nest
  ^-  goals:nest
  %-  %~  del
        by
      %-  ~(run by goals)
      |=  =goal:nest
      %=  goal
        kids  (~(del in kids.goal) id)
        pars  (~(del in pars.goal) id)
      ==
  id
::
:: purge goal from handles
++  purge-handles
  |=  =id:nest
  ^-  handles:nest
  :_  (~(del by ih.handles) id)
      (~(del by hi.handles) (~(got by ih.handles) id))
::
:: get cards to print goal substructure, catch if goal does not exist
++  print-catch
  |=  [id=(unit id:nest) dir=?(%p %c)]
  ?~  id  (print id dir)
    ?:  (~(has in ~(key by goals)) u.id)
      (print id dir)
    (print-cards ~["" "Specified goal does not exist."])
::
:: get cards to print goal substructure, crash if goal does not exist
++  print
  |=  [id=(unit id:nest) dir=?(%p %c)]
  ^-  (list card)
  %-  print-cards 
  =/  lvl
    ?-  dir
      %p  (dec (get-lvl id dir))
      %c  +((get-lvl id dir))
    ==
  ;:  weld
    :~  `tape`(reap 80 '-')
        "   [hdl]"
    ==
    (print-family id %.y dir "" lvl)
    ~[`tape`(reap 80 '-')]
  ==
::
::
++  poke-cards
  |=  pokes=(list [wire action:nest])
  ^-  (list card)
  %+  turn
    pokes
  |=([=wire =action:nest] [%pass wire %agent [our.bowl %gol-cli] %poke %nest-action !>(action)])
::
::
++  print-cards
  |=  tapes=(list tape)
  ^-  (list card)
  (turn tapes |=(=tape [%shoe ~ %sole %klr [[~ ~ `%w] [(crip tape)]~]~]))
::
::
++  print-family
  |=  [id=(unit id:nest) last=? dir=?(%p %c) indent=tape lvl=@]
  ^-  (list tape)
  =/  line  (liner id last dir indent lvl)
  =/  indent  (indenter id last dir indent lvl)
  =/  fam  (get-fam id dir)
  =/  lvl  (get-lvl id dir)
  =/  output=(list tape)  ~[line]
  ?~  fam
    ?.  last
      output
    ?:  (levy indent |=(a=@t =(a ' ')))
      output
    (weld output ~[(weld "           " indent)])
  =/  idx=@  0
  |-
  =/  id  [~ (snag idx `(list id:nest)`fam)]
  ?:  =(+(idx) (lent fam))
    (weld output (print-family id %.y dir indent lvl))
  $(idx +(idx), output (weld output (print-family id %.n dir indent lvl)))
::
::
++  spacer  3
::
::
++  get-lvl
  |=  [id=(unit id:nest) dir=?(%p %c)]
  ^-  @
  ?-  dir
      %p
    ?~  id  !!
    (plumb u.id)
      %c
    ?~  id  (anchor)
    (plumb u.id)
  ==
::
::
++  get-fam
  |=  [id=(unit id:nest) dir=?(%p %c)]
  ^-  (list id:nest)
  ?-  dir
      %p  
    ?~  id  (leaves)
    =/  goal  (~(got by goals) u.id)
    ~(tap in pars.goal)
      %c
    ?~  id  (roots)
    =/  goal  (~(got by goals) u.id)
    ~(tap in kids.goal)
  ==
::
::
++  liner
  |=  [id=(unit id:nest) last=? dir=?(%p %c) indent=tape lvl=@]
  ^-  tape
  (weld (prefix id dir) (brancher id last dir indent lvl))
::
::
++  prefix
  |=  [id=(unit id:nest) dir=?(%p %c)]
  ^-  tape
  ?~  id
    ?-  dir
      %p  !!
      %c  (weld "   [ ~ ]" (reap spacer ' '))
    ==
  =/  hndl  (~(got by ih.handles) u.id)
  (weld "   [{(trip hndl)}]" (reap spacer ' '))
::
:: branch structure based status as last subgoal and level shift
++  brancher
  |=  [id=(unit id:nest) last=? dir=?(%p %c) indent=tape lvl=@]
  ^-  tape
  ?~  id
    ?-  dir
      %p  !!
      %c  "\\--All"
    ==
  =/  goal  (~(got by goals) u.id)
  =/  output
    ?:  last
      :(weld indent "\\" (reap (dec (shift u.id dir lvl)) '-'))
    :(weld indent "|" (reap (dec (shift u.id dir lvl)) '-'))
  (weld output (trip desc.goal))
::
:: indent structure based on ancestors
++  indenter
  |=  [id=(unit id:nest) last=? dir=?(%p %c) indent=tape lvl=@]
  ^-  tape
  ?~  id
    ?-  dir
      %p  !!
      %c  (reap spacer ' ')
    ==
  ?:  last
    (weld indent (reap (shift u.id dir lvl) ' '))
  :(weld indent "|" (reap (dec (shift u.id dir lvl)) ' '))
::
:: shift based on level difference from parent
++  shift
  |=  [=id:nest dir=?(%p %c) lvl=@]
  ^-  @
  ?-  dir
      %p
    (mul spacer (sub (plumb id) lvl))
      %c
    (mul spacer (sub lvl (plumb id)))
  ==
--
