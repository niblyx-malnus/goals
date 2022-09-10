/-  gol=goal
/+  *gol-cli-goal, gol-cli-goals
|_  p=pool:gol
::
++  spawn-goal
  |=  $:  =id:gol
          desc=@t
          actionable=?(%.y %.n)  
          =goal-perms:gol
      ==
    ^-  goal:gol
    =|  =goal:gol
    =.  owner.goal       owner.id            =.  birth.goal  birth.id
    =.  desc.goal        desc          
    =.  actionable.goal  actionable
    =.  peons.goal       peons.goal-perms    =.  chefs.goal  chefs.goal-perms        
    :: 
    :: Initialize edges
    =.  outflow.kickoff.goal  (~(put in *(set eid:gol)) [%d id])
    =.  inflow.deadline.goal  (~(put in *(set eid:gol)) [%k id])
    goal
::
++  got-edge
  |=  =eid:gol
  ^-  edge:gol
  =/  goal  (~(got by goals.p) id.eid)
  ?-  -.eid
    %k  kickoff.goal
    %d  deadline.goal
  ==
::
++  update-edge
  |=  [=eid:gol =edge:gol]
  ^-  goal:gol
  =/  goal  (~(got by goals.p) id.eid)
  ?-  -.eid
    %k  goal(kickoff edge)
    %d  goal(deadline edge)
  ==
::
:: think of ~ as +inf in the case of lth and -inf in case of gth
++  unit-cmp
  |=  cmp=$-([@ @] ?)
  |=  [a=(unit @) b=(unit @)]
  ?~  a  %.n
  ?~  b  %.y
  (cmp u.a u.b)
::
++  unit-lth  (unit-cmp lth)
++  unit-gth  (unit-cmp gth)
::
++  sort-by-head
  |=  cmp=$-([(unit @) (unit @)] ?)
  |*  lst=(list [(unit @) *])
  %+  roll
    ^+  lst  +.lst
  |:  [a=i.-.lst b=i.-.lst]
  ?:  (cmp -.a -.b)  a  b
::
++  list-min-head  (sort-by-head unit-lth)
++  list-max-head  (sort-by-head unit-gth)
::
++  ryte-bound
  |=  =eid:gol
  ^-  [moment=(unit @da) hereditor=eid:gol]
  =/  edge  (got-edge eid)
  ?:  =(0 ~(wyt in outflow.edge))
    [moment.edge eid]
  %-  list-min-head
  %+  weld
    ~[[moment.edge eid]]
  %+  turn
    ~(tap in outflow.edge)
  ryte-bound
::
++  left-bound
  |=  =eid:gol
  ^-  [moment=(unit @da) hereditor=eid:gol]
  =/  edge  (got-edge eid)
  ?:  =(0 ~(wyt in inflow.edge))
    [moment.edge eid]
  %-  list-max-head
  %+  weld
    ~[[moment.edge eid]]
  %+  turn
    ~(tap in inflow.edge)
  left-bound
::
++  left-uncompleted
  |=  =id:gol
  ^-  ?
  |^
  =/  idx  0
  =/  inflow  ~(tap in inflow:(got-edge [%d id]))
  |-
  ?:  =(idx (lent inflow))
    %|
  ?:  -:(left-uncompleted (snag idx inflow) [%d id]~ (sy [%d id]~))
    %&
  $(idx +(idx))
  ++  left-uncompleted
    |=  $:  =eid:gol
            path=(list eid:gol)
            visited=(set eid:gol)
        ==
    ^-  [? visited=(set eid:gol)]
    =/  new-path=(list eid:gol)  [eid path]
    =/  i  (find [eid]~ path) 
    ?.  =(~ i)  ?~(i !! ~&([%cycle (flop (scag u.i new-path))] !!))
    ?:  &(=(-.eid %d) !complete:(~(got by goals.p) id.eid))  [%& visited]
    =.  visited  (~(put in visited) eid)
    =/  idx  0
    =/  inflow  ~(tap in inflow:(got-edge eid))
    |-
    ?:  =(idx (lent inflow))
      [%| visited]
    ?:  (~(has in visited) (snag idx inflow))
      $(idx +(idx))
    =/  cmp  (left-uncompleted (snag idx inflow) new-path visited)
    ?:  -.cmp
      [%& visited.cmp]
    $(idx +(idx), visited visited.cmp)
  --
::
++  ryte-completed
  |=  =id:gol
  ^-  ?
  |^
  =/  idx  0
  =/  outflow  ~(tap in outflow:(got-edge [%d id]))
  |-
  ?:  =(idx (lent outflow))
    %|
  ?:  -:(ryte-completed (snag idx outflow) [%d id]~ (sy [%d id]~))
    %&
  $(idx +(idx))
  ++  ryte-completed
    |=  $:  =eid:gol
            path=(list eid:gol)
            visited=(set eid:gol)
        ==
    ^-  [? visited=(set eid:gol)]
    =/  new-path=(list eid:gol)  [eid path]
    =/  i  (find [eid]~ path) 
    ?.  =(~ i)  ?~(i !! ~&([%cycle (flop (scag u.i new-path))] !!))
    ?:  &(=(-.eid %d) complete:(~(got by goals.p) id.eid))  [%& visited]
    =.  visited  (~(put in visited) eid)
    =/  idx  0
    =/  outflow  ~(tap in outflow:(got-edge eid))
    |-
    ?:  =(idx (lent outflow))
      [%| visited]
    ?:  (~(has in visited) (snag idx outflow))
      $(idx +(idx))
    =/  cmp  (ryte-completed (snag idx outflow) new-path visited)
    ?:  -.cmp
      [%& visited.cmp]
    $(idx +(idx), visited visited.cmp)
  --
::
:: if %k and =(0 ~(wyt in inflow)), then return ~
:: if %k and union of left-preceded of inflow returns ~, return ~
:: if %d and union of left-preceded of inflow returns ~, return set with id.eid
:: if union of left-preceded of inflow is non-null, return this set
:: visited is (map eid:gol (set id:gol))
++  leaf-precedents
  |=  =id:gol
  ^-  (set id:gol)
  |^
  descendents:(leaf-precedents [%d id] ~ ~)
  ++  leaf-precedents
    |=  $:  =eid:gol
            path=(list eid:gol)
            visited=(map eid:gol (set id:gol))
        ==
    ^-  [descendents=(set id:gol) visited=(map eid:gol (set id:gol))]
    =/  new-path=(list eid:gol)  [eid path]
    =/  i  (find [eid]~ path) 
    ?.  =(~ i)  ?~(i !! ~&([%cycle (flop (scag u.i new-path))] !!))
    =/  inflow  inflow:(got-edge eid)
    =/  idx  0
    =/  inflow  ~(tap in inflow)
    =/  descendents  *(set id:gol)
    |-
    ?:  =(idx (lent inflow))
      =/  descendents
        ?.  &(=(~ descendents) =(%d -.eid))  descendents
        (~(put in *(set id:gol)) id.eid)
      [descendents (~(put by visited) eid descendents)]
    ?:  (~(has by visited) (snag idx inflow))
      %=  $
        idx  +(idx)
        descendents  (~(uni in descendents) (~(got by visited) (snag idx inflow)))
      ==
    =/  cmp  (leaf-precedents (snag idx inflow) new-path visited)
    %=  $
      idx  +(idx)
      descendents  (~(uni in descendents) descendents.cmp)
      visited  visited.cmp
    ==
  --
::
::  get depth of a given goal (lowest level is depth of 1)
++  plumb
  |=  =id:gol
  ^-  @ud
  =/  goal  (~(got by goals.p) id)
  =/  lvl  1
  =/  gots  (yung goal)
  ?:  =(0 ~(wyt in gots))  lvl :: if childless, depth of 1
  =/  idx  0
  =/  gots  ~(tap in gots)
  |-
  ?:  =(idx (lent gots))  +(lvl) :: add 1 to maximum child depth
  $(idx +(idx), lvl (max lvl (plumb (snag idx gots))))
::
:: get roots
++  roots
  ^-  (list id:gol)
  %+  turn
    %+  skim  ~(tap by goals.p)
    |=  [id:gol =goal:gol]
    ?&  =(~ par.goal)
        .=  0
        %-  lent
        %+  murn
          ~(tap in outflow.deadline.goal)
        |=  =eid:gol
        ?-  -.eid
          %k  ~
          %d  (some id.eid)
        ==
    ==
  |=([=id:gol goal:gol] id)
::
++  uncompleted-roots
  %+  murn  roots
  |=  =id:gol
  ?:  complete:(~(got by goals.p) id)
    ~
  (some id)
::
:: get max depth + 1; depth of "virtual" root node
++  anchor  
  ^-  @ud
  +((roll (turn roots plumb) max))
::
++  empt
  |=  getter=$-(goal:gol (set id:gol))
  |=  =id:gol
  =(0 ~(wyt in (getter (~(got by goals.p) id))))
::
++  uncompleted
  |=  getter=$-(goal:gol (set id:gol))
  |=  =goal:gol
  %-  ~(gas in *(set id:gol))
  (skim ~(tap in (getter goal)) |=(=id:gol !complete:(~(got by goals.p) id)))
::
:: get priority of a given goal (highest priority is 0)
:: priority is the number of goals prioritized ahead of a given goal
++  priority
  |=  =id:gol
  |^
  ~(wyt in (priors id ~))
  ++  priors
    |=  [=id:gol path=(list id:gol)]
    ^-  (set id:gol)
    =/  new-path=(list id:gol)  [id path]
    =/  i  (find [id]~ path) 
    ?.  =(~ i)  ?~(i !! ~&([%cycle (flop (scag u.i new-path))] !!))
    =/  goal  (~(got by goals.p) id)
    =/  prio  (prio goal)
    =/  idx  0
    =/  output  prio
    =/  prio  ~(tap in prio)
    |-
    ?:  =(idx (lent prio))
      output
    $(idx +(idx), output (~(uni in output) (priors (snag idx prio) new-path)))
  --
::
:: highest to lowest priority (highest being smallest number)
++  hi-to-lo
  |=  lst=(list id:gol)
  %+  sort  lst
  |=  [a=id:gol b=id:gol]
  (lth (priority a) (priority b))
::
:: is e1 before e2
++  before
  |=  [e1=eid:gol e2=eid:gol]
  ^-  ?
  |^
  -:(before e1 e2 ~ ~)
  ++  before
    |=  $:  e1=eid:gol
            e2=eid:gol
            path=(list eid:gol)
            visited=(set eid:gol)
        ==
    ^-  [? visited=(set eid:gol)]
    =/  new-path=(list eid:gol)  [e2 path]
    =/  i  (find [e2]~ path) 
    ?.  =(~ i)  ?~(i !! ~&([%cycle (flop (scag u.i new-path))] !!))
    =/  inflow  inflow:(got-edge e2)
    ?:  (~(has in inflow) e1)  [%& visited]
    =.  visited  (~(put in visited) e2)
    =/  idx  0
    =/  inflow  ~(tap in inflow)
    |-
    ?:  =(idx (lent inflow))
      [%| visited]
    ?:  (~(has in visited) (snag idx inflow))
      $(idx +(idx))
    =/  cmp  (before e1 (snag idx inflow) new-path visited)
    ?:  -.cmp
      [%& visited.cmp]
    $(idx +(idx), visited visited.cmp)
  --
::
:: find the oldest ancestor of this goal for which you are a chef
++  seniority
  |=  [mod=ship =id:gol cp=?(%c %p)]
  |^
  (seniority mod id ~ ~ cp)
  ++  seniority
    |=  [mod=ship =id:gol senior=(unit id:gol) path=(list id:gol) cp=?(%c %p)]
    ^-  senior=(unit id:gol)
    =/  new-path=(list id:gol)  [id path]
    =/  i  (find [id]~ path) 
    ?.  =(~ i)  ?~(i !! ~&([%cycle (flop (scag u.i new-path))] !!))
    =/  goal  (~(got by goals.p) id)
    =.  senior
      ?-    cp
          %c
        ?:  (~(has in chefs.goal) mod)
          (some id)
        senior
          %p
        ?:  (~(has in peons.goal) mod)
          (some id)
        senior
      ==
    =/  par  par.goal
    ?~  par  senior
    (seniority mod u.par senior path cp)
  --
::
++  check-pool-perm
  |=  mod=ship
  ^-  ?
  ?:  |(=(owner.p mod) (~(has in chefs.p) mod))  %&  %|
::
++  check-goal-perm
  |=  [=id:gol mod=ship]
  ^-  (each ? term)
  ?:  (check-pool-perm mod)  [%& %&]
  =/  s  (seniority mod id %c)
  ?~  senior.s  [%| %null-sen-perm-fail]  [%& %&]
::
++  check-pair-perm
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each ? term)
  ?:  (check-pool-perm mod)  [%& %&]
  =/  l  (seniority mod lid %c)
  =/  r  (seniority mod rid %c)
  ?.  =(senior.l senior.r)  [%| %diff-sen-perm-fail]
  ?~  senior.l  [%| %null-sen-perm-fail]  [%& %&]
::
++  dag-yoke
  |=  [e1=eid:gol e2=eid:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  ::
  :: Check mod permissions
  =/  perm  (check-pair-perm id.e1 id.e2 mod)
  ?-    -.perm
    %|  perm
      %&
    ::
    :: Cannot relate goal to itself
    ?:  =(id.e1 id.e2)  [%| %same-goal]
    =/  edge1  (got-edge e1)
    =/  edge2  (got-edge e2)
    ::
    :: Cannot create relationship where a completed goal is to the right
    :: and an uncompleted goal is to the left
    ?:  ?&  complete:(~(got by goals.p) id.e2)
            !complete:(~(got by goals.p) id.e1)
        ==
      [%| %incomplete-complete]
    ::
    :: Cannot create relationship with the deadline of the right id
    :: if the right id is an actionable goal
    ?:  ?&  =(-.e2 %d)
            actionable:(~(got by goals.p) id.e2)
        ==
      [%| %right-actionable]
    ::
    :: e2 must not come before e1
    ?:  (before e2 e1)  [%| %before-e2-e1]
    ::
    :: there must be no bound mismatch between e1 and e2
    ?:  (unit-gth moment.edge1 -:(ryte-bound e2))  [%| %bound-mismatch]
    ?:  (unit-lth moment.edge2 -:(left-bound e1))  [%| %bound-mismatch]
    ::
    :: dag-yoke
    =.  outflow.edge1  (~(put in outflow.edge1) e2)
    =.  inflow.edge2  (~(put in inflow.edge2) e1)
    =.  goals.p  (~(put by goals.p) id.e1 (update-edge e1 edge1))
    =.  goals.p  (~(put by goals.p) id.e2 (update-edge e2 edge2))
    [%& p (~(gas in *(set id:gol)) ~[id.e1 id.e2])]
  ==
::
++  dag-rend
  |=  [e1=eid:gol e2=eid:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  ::
  :: Check mod permissions
  =/  perm  (check-pair-perm id.e1 id.e2 mod)
  ?-    -.perm
    %|  perm
      %&
    ::
    :: Cannot unrelate goal from itself
    ?:  =(id.e1 id.e2)  [%| %same-goal]
    ::
    :: Cannot destroy containment of an owned goal
    =/  l  (~(got by goals.p) id.e1)
    =/  r  (~(got by goals.p) id.e2)
    ?:  ?|  &(=(-.e1 %d) =(-.e2 %d) (~(has in kids.r) id.e1))
            &(=(-.e1 %k) =(-.e2 %k) (~(has in kids.l) id.e2))
        ==
      [%| %owned-goal]
    ::
    :: dag-rend
    ~&  "dag-rend"
    =/  edge1  (got-edge e1)
    =/  edge2  (got-edge e2)
    =.  outflow.edge1  (~(del in outflow.edge1) e2)
    =.  inflow.edge2  (~(del in inflow.edge2) e1)
    =.  goals.p  (~(put by goals.p) id.e1 (update-edge e1 edge1))
    =.  goals.p  (~(put by goals.p) id.e2 (update-edge e2 edge2))
    [%& p (~(gas in *(set id:gol)) ~[id.e1 id.e2])]
  ==
::
++  prio-yoke
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  (dag-yoke [%k lid] [%k rid] mod)
::
++  prio-rend
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  (dag-rend [%k lid] [%k rid] mod)
::
++  prec-yoke
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  (dag-yoke [%d lid] [%k rid] mod)
::
++  prec-rend
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  (dag-rend [%d lid] [%k rid] mod)
::
++  nest-yoke
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  (dag-yoke [%d lid] [%d rid] mod)
::
++  nest-rend
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  (dag-rend [%d lid] [%d rid] mod)
::
++  hook-yoke
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  (dag-yoke [%k lid] [%d rid] mod)
::
++  hook-rend
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  (dag-rend [%k lid] [%d rid] mod)
::
++  held-yoke
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  %+  apply-sequence  mod
  :~  [%dag-yoke [%d lid] %d rid]
      [%dag-yoke [%k rid] %k lid]
  ==
::
++  held-rend
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  %+  apply-sequence  mod
  :~  [%dag-rend [%d lid] %d rid]
      [%dag-rend [%k rid] %k lid]
  ==
::
++  move-goal
  |=  [lid=id:gol urid=(unit id:gol) mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  =/  l  (~(got by goals.p) lid)
  ::
  :: If par.l is non-null, end this relationship
  =/  out=(each [=pool:gol =(set id:gol)] term)
    ?~  par.l  [%& p ~]
    =/  q  (~(got by goals.p) u.par.l)
    =.  goals.p  (~(put by goals.p) u.par.l q(kids (~(del in kids.q) lid)))
    (held-rend lid u.par.l mod)
  ?-    -.out
    %|  out
      %&
    =.  p  pool.p.out
    =.  l  (~(got by goals.p) lid) :: l has changed
    =.  goals.p  (~(put by goals.p) lid l(par urid))
    ::
    :: If urid is non-null, create this relationship
    ?~  urid  
      ?.  (check-pool-perm mod)  [%| %pool-perm-fail]
      [%& p set.p.out]
    =/  r  (~(got by goals.p) u.urid)
    =.  goals.p  (~(put by goals.p) u.urid r(kids (~(put in kids.r) lid)))
    (held-yoke lid u.urid mod)
  ==
::
++  apply-sequence
  |=  [mod=ship seq=yoke-sequence:gol]
  ^-  (each [=pool:gol =(set id:gol)] term)
  =/  id-set  *(set id:gol)
  |-
  ?~  seq
    [%& p id-set]
  =/  yoke-output=(each [=pool:gol =(set id:gol)] term)
    ?-  -.i.seq
      %dag-yoke   (dag-yoke e1.i.seq e2.i.seq mod)
      %dag-rend   (dag-rend e1.i.seq e2.i.seq mod)
      %prio-rend  (prio-rend lid.i.seq rid.i.seq mod)
      %prio-yoke  (prio-yoke lid.i.seq rid.i.seq mod)
      %prec-rend  (prec-rend lid.i.seq rid.i.seq mod)
      %prec-yoke  (prec-yoke lid.i.seq rid.i.seq mod) 
      %nest-rend  (nest-rend lid.i.seq rid.i.seq mod) 
      %nest-yoke  (nest-yoke lid.i.seq rid.i.seq mod) 
      %held-rend  (held-rend lid.i.seq rid.i.seq mod) 
      %held-yoke  (held-yoke lid.i.seq rid.i.seq mod) 
      %move-goal  !!
    ==
  ?-    -.yoke-output
    %|  yoke-output
      %&
      %=  $
        seq  t.seq
        p  pool.p.yoke-output
        id-set  (~(uni in id-set) set.p.yoke-output)
      ==
  ==
::
++  mark-actionable
  |=  [=id:gol mod=ship]
  ^-  (each pool:gol term)
  =/  perm  (check-goal-perm id mod)
  ?-    -.perm
    %|  perm
      %&
    =/  goal  (~(got by goals.p) id)
    ?.  .=  0
        %+  murn
        ~(tap in inflow.deadline.goal) 
        |=(=eid:gol ?:(=(id id.eid) ~ (some eid)))
      [%| %has-nested]
    =.  goals.p  (~(put by goals.p) id goal(actionable %&))
    [%& p]
  ==
::
++  mark-complete
  |=  [=id:gol mod=ship]
  ^-  (each pool:gol term)
  =/  perm  (check-goal-perm id mod)
  ?-    -.perm
    %|  perm
      %&
    =/  goal  (~(got by goals.p) id)
    ?:  (left-uncompleted id)  [%| %left-uncompleted]
    =.  goals.p  (~(put by goals.p) id goal(complete %&))
    [%& p]
  ==
::
++  unmark-actionable
  |=  [=id:gol mod=ship]
  ^-  (each pool:gol term)
  =/  perm  (check-goal-perm id mod)
  ?-    -.perm
    %|  perm
      %&
    =/  goal  (~(got by goals.p) id)
    =.  goals.p  (~(put by goals.p) id goal(actionable %|))
    [%& p]
  ==
::
++  unmark-complete
  |=  [=id:gol mod=ship]
  ^-  (each pool:gol term)
  =/  perm  (check-goal-perm id mod)
  ?-    -.perm
    %|  perm
      %&
    =/  goal  (~(got by goals.p) id)
    ?:  (ryte-completed id)  [%| %ryte-completed]
    =.  goals.p  (~(put by goals.p) id goal(complete %|))
    [%& p]
  ==
::
++  set-deadline
  |=  [=id:gol moment=(unit @da) mod=ship]
  ^-  (each pool:gol term)
  =/  perm  (check-goal-perm id mod)
  ?-    -.perm
    %|  perm
      %&
    =/  rb  (ryte-bound [%d id])
    =/  lb  (left-bound [%d id])
    ?:  &(!=(+.lb [%d id]) (unit-lth moment -:lb))  [%| %bound-left]
    ?:  &(!=(+.rb [%d id]) (unit-gth moment -:rb))  [%| %bound-ryte]
    =/  goal  (~(got by goals.p) id)
    =.  goals.p  (~(put by goals.p) id goal(moment.deadline moment))
    [%& p]
  ==
::
++  set-kickoff
  |=  [=id:gol moment=(unit @da) mod=ship]
  ^-  (each pool:gol term)
  =/  perm  (check-goal-perm id mod)
  ?-    -.perm
    %|  perm
      %&
    =/  rb  (ryte-bound [%k id])
    =/  lb  (left-bound [%k id])
    ?:  &(!=(+.lb [%k id]) (unit-lth moment -:lb))  [%| %bound-left]
    ?:  &(!=(+.rb [%k id]) (unit-gth moment -:rb))  [%| %bound-ryte]
    =/  goal  (~(got by goals.p) id)
    =.  goals.p  (~(put by goals.p) id goal(moment.kickoff moment))
    [%& p]
  ==
--
