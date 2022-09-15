/-  gol=goal, goal-store
/+  *gol-cli-goal, gol-cli-goals
=|  efx=(list update:goal-store)
|_  p=pool:gol
+*  this  .
++  apex
  |=  =pool:gol
  this(p pool)
::
++  abet
  ^-  [efx=(list update:goal-store) =pool:gol]
  [(flop efx) p]
::
++  emit
  |=  upd=update:goal-store
  this(efx [upd efx])
::
++  emot
  |=  [old=_this upd=update:goal-store]
  ?.  =(this (etch:old upd)) :: be wary of changes to efx
  ~|("non-equivalent-update" !!)
  (emit upd)
::
++  init-goal
  |=  =id:gol
  ^-  goal:gol
  =|  =goal:gol
  =.  owner.goal  owner.id
  =.  birth.goal  birth.id
  :: 
  :: Initialize edges
  =.  outflow.kickoff.goal  (~(put in *(set eid:gol)) [%d id])
  =.  inflow.deadline.goal  (~(put in *(set eid:gol)) [%k id])
  goal
::
++  make-nex
  |=  ids=(set id:gol)
  ^-  nex:gol
  =|  =nex:gol
  %-  ~(gas by nex)
  %+  turn  ~(tap in ids)
  |=  =id:gol
  [id nexus:`ngoal:gol`(~(got by goals.p) id)]
::
++  apply-nex
  |=  =nex:gol
  ^-  _this
    %=  this
      goals.p
      %-  ~(gas by goals.p)
      %+  turn  ~(tap by nex)
      |=  [=id:gol =goal-nexus:gol]
      ^-  [id:gol goal:gol]
      =/  =ngoal:gol  (~(got by goals.p) id)
      [id ngoal(nexus goal-nexus)]
    ==
::
++  spawn-goal
  |=  [=id:gol upid=(unit id:gol) mod=ship]
  ^-  _this
  ::
  :: Initialize goal
  =/  goal  (init-goal id)
  =.  goal  goal(captains (~(put in captains.goal) mod))
  ::
  :: Check mod permissions
  =/  par-perm
    ?~  upid
      (check-root-spawn-perm mod)
    (check-goal-perm u.upid mod)
  ?>  par-perm
  ::
  :: Put goal in goals and move under upid
  =.  goals.p  (~(put by goals.p) id goal)
  =/  pore  (move-goal id upid owner.p) :: divine intervention (owner)
  ::
  =+  pore(efx efx) :: ignore accumulated updates
  ?~  upid
    (emot ^this [%spawn-goal *nex:gol id (~(got by goals.p) id)])
  %+  emot
    ^this
  [%spawn-goal (make-nex (sy ~[u.upid])) id (~(got by goals.p) id)]
::
:: wit all da fixin's
++  spawn-goal-fixns
  |=  $:  =id:gol
          upid=(unit id:gol)
          desc=@t
          actionable=?(%.y %.n)
          =goal-perms:gol
          mod=ship
      ==
  ^-  _this
  =/  pore  (spawn-goal id upid mod)
  =.  pore  (edit-goal-desc:pore id desc mod)
  =.  pore
    ?:  actionable
      (mark-actionable:pore id mod)
    (unmark-actionable:pore id mod)
  =.  pore  (add-goal-captains:pore id captains.goal-perms mod)
  =.  pore  (add-goal-peons:pore id peons.goal-perms mod)
  ::
  =+  pore(efx efx) :: ignore accumulated updates
  =/  nex
    ?~  upid
      *nex:gol
    (make-nex (sy ~[u.upid]))
  (emot ^this [%spawn-goal nex id (~(got by goals.p) id)])
::
:: All descendents including self
++  progeny
  |=  =id:gol
  ^-  (set id:gol)
  =/  output  (~(put in *(set id:gol)) id)
  =/  goal  (~(got by goals.p) id)
  =/  kids  ~(tap in kids.goal)
  =/  idx  0
  |-
  ?:  =(idx (lent kids))
    output
  $(idx +(idx), output (~(uni in output) (progeny (snag idx kids))))
::
:: purge goal from goals
++  purge-goal
  |=  =id:gol
  ^-  _this
  =;  goals
    this(goals.p goals)
  %.  id
  %~  del
    by
  %-  ~(run by goals.p)
  |=  =goal:gol
  %=  goal
    par   ?~(par.goal ~ ?:(=(u.par.goal id) ~ par.goal))
    kids  (~(del in kids.goal) id)
    inflow.kickoff
      (~(del in (~(del in inflow.kickoff.goal) [%k id])) [%d id])
    outflow.kickoff
      (~(del in (~(del in outflow.kickoff.goal) [%k id])) [%d id])
    inflow.deadline
      (~(del in (~(del in inflow.deadline.goal) [%k id])) [%d id])
    outflow.deadline
      (~(del in (~(del in outflow.deadline.goal) [%k id])) [%d id])
  ==
::
:: Get all goals to which this goal is related
++  get-overlaps
  |=  =id:gol
  ^-  (set id:gol)
  =/  goal  (~(got by goals.p) id)
  =/  output  *(set id:gol)
  =.  output  
    ?~  par.goal  
      output
    (~(put in output) u.par.goal)
  =.  output  (~(uni in output) kids.goal)
  =.  output  %-  ~(uni in output)
              ^-  (set id:gol)
              (~(run in inflow.kickoff.goal) |=(=eid:gol id.eid))
  =.  output  %-  ~(uni in output)
              ^-  (set id:gol)
              (~(run in outflow.kickoff.goal) |=(=eid:gol id.eid))
  =.  output  %-  ~(uni in output)
              ^-  (set id:gol)
              (~(run in inflow.deadline.goal) |=(=eid:gol id.eid))
  %-  ~(uni in output)
  `(set id:gol)`(~(run in outflow.deadline.goal) |=(=eid:gol id.eid))
::
++  delete-goal
  |=  [=id:gol mod=ship]
  ^-  _this
  ?>  (check-pool-perm mod)
  =/  prog  ~(tap in (progeny id))
  =/  ovlp  *(set id:gol)
  =/  pore  this
  =/  idx  0
  |-
  ?:  =(idx (lent prog))
    =+  pore
    %+  emot
      ^this
    [%trash-goal (make-nex (~(dif in ovlp) (sy prog))) (sy prog)]
  %=  $
    idx  +(idx)
    ovlp  (~(uni in ovlp) (get-overlaps:pore (snag idx prog)))
    pore  (purge-goal:pore (snag idx prog))
  ==
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
:: find the oldest ancestor of this goal for which you are a captain
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
        ?:  (~(has in captains.goal) mod)
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
:: Permission gates return %& or crash with error output
++  check-pool-perm
  |=  mod=ship
  ^-  ?
  ?:  |(=(owner.p mod) (~(has in admins.p) mod))
    %&
  ~|("pool-perm-fail" !!)
::
++  check-root-spawn-perm
  |=  mod=ship
  ^-  ?
  ?:  ?|  =(owner.p mod)
          (~(has in admins.p) mod)
          (~(has in captains.p) mod)
      ==
    %&
  ~|("root-spawn-perm-fail" !!)
::
++  check-goal-perm
  |=  [=id:gol mod=ship]
  ^-  ?
  ?:  (check-pool-perm mod)  %&
  =/  s  (seniority mod id %c)
  ?~  senior.s  ~|("null-sen-perm-fail" !!)  %&
::
++  check-peon-perm
  |=  [=id:gol mod=ship]
  ^-  ?
  ?:  (check-goal-perm id mod)  %&
  =/  s  (seniority mod id %p)
  ?~  senior.s  ~|("peon-perm-fail" !!)  %&
::
++  check-pair-perm
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  ?
  ?:  (check-pool-perm mod)  %&
  =/  l  (seniority mod lid %c)
  =/  r  (seniority mod rid %c)
  ?.  =(senior.l senior.r)  ~|("diff-sen-perm-fail" !!)
  ?~  senior.l  ~|("null-sen-perm-fail" !!)  %&
::
++  dag-yoke
  |=  [e1=eid:gol e2=eid:gol mod=ship]
  ^-  _this
  ::
  :: Check mod permissions
  ?>  (check-pair-perm id.e1 id.e2 mod)
  ::
  :: Cannot relate goal to itself
  ?:  =(id.e1 id.e2)  ~|("same-goal" !!)
  =/  edge1  (got-edge e1)
  =/  edge2  (got-edge e2)
  ::
  :: Cannot create relationship where a completed goal is to the right
  :: and an uncompleted goal is to the left
  ?:  ?&  complete:(~(got by goals.p) id.e2)
          !complete:(~(got by goals.p) id.e1)
      ==
    ~|("incomplete-complete" !!)
  ::
  :: Cannot create relationship with the deadline of the right id
  :: if the right id is an actionable goal
  ?:  ?&  =(-.e2 %d)
          actionable:(~(got by goals.p) id.e2)
      ==
    ~|("right-actionable" !!)
  ::
  :: e2 must not come before e1
  ?:  (before e2 e1)  ~|("before-e2-e1" !!)
  ::
  :: there must be no bound mismatch between e1 and e2
  ?:  (unit-gth moment.edge1 -:(ryte-bound e2))  ~|("bound-mismatch" !!)
  ?:  (unit-lth moment.edge2 -:(left-bound e1))  ~|("bound-mismatch" !!)
  ::
  :: dag-yoke
  =.  outflow.edge1  (~(put in outflow.edge1) e2)
  =.  inflow.edge2  (~(put in inflow.edge2) e1)
  =.  goals.p  (~(put by goals.p) id.e1 (update-edge e1 edge1))
  =.  goals.p  (~(put by goals.p) id.e2 (update-edge e2 edge2))
  this
::
++  dag-rend
  |=  [e1=eid:gol e2=eid:gol mod=ship]
  ^-  _this
  ::
  :: Check mod permissions
  ?>  (check-pair-perm id.e1 id.e2 mod)
  ::
  :: Cannot unrelate goal from itself
  ?:  =(id.e1 id.e2)  ~|("same-goal" !!)
  ::
  :: Cannot destroy containment of an owned goal
  =/  l  (~(got by goals.p) id.e1)
  =/  r  (~(got by goals.p) id.e2)
  ?:  ?|  &(=(-.e1 %d) =(-.e2 %d) (~(has in kids.r) id.e1))
          &(=(-.e1 %k) =(-.e2 %k) (~(has in kids.l) id.e2))
      ==
    ~|("owned-goal" !!)
  ::
  :: dag-rend
  =/  edge1  (got-edge e1)
  =/  edge2  (got-edge e2)
  =.  outflow.edge1  (~(del in outflow.edge1) e2)
  =.  inflow.edge2  (~(del in inflow.edge2) e1)
  =.  goals.p  (~(put by goals.p) id.e1 (update-edge e1 edge1))
  =.  goals.p  (~(put by goals.p) id.e2 (update-edge e2 edge2))
  this
::
++  yoke
  |=  [yok=exposed-yoke:gol mod=ship]
  ^-  _this
  =,  yok
  =/  pore
    ?-  -.yok
      %prio-yoke  (dag-yoke [%k lid] [%k rid] mod)
      %prio-rend  (dag-rend [%k lid] [%k rid] mod)
      %prec-yoke  (dag-yoke [%d lid] [%k rid] mod)
      %prec-rend  (dag-rend [%d lid] [%k rid] mod)
      %nest-yoke  (dag-yoke [%d lid] [%d rid] mod)
      %nest-rend  (dag-rend [%d lid] [%d rid] mod)
      %hook-yoke  (dag-yoke [%k lid] [%d rid] mod)
      %hook-rend  (dag-rend [%k lid] [%d rid] mod)
        %held-yoke  
      =/  pore  (dag-yoke [%d lid] [%d rid] mod)
      (dag-yoke:pore [%k rid] [%k lid] mod)
        %held-rend  
      =/  pore  (dag-rend [%d lid] [%d rid] mod)
      (dag-rend:pore [%k rid] [%k lid] mod)
    ==
  (emot ^this [%pool-nexus %yoke (make-nex (sy ~[lid rid]))]):[pore .]
::
++  move-goal
  |=  [lid=id:gol urid=(unit id:gol) mod=ship]
  ^-  _this
  ::
  :: Check mod permissions
  =/  par-perm
    ?~  urid  
      (check-pool-perm mod)
    (check-pair-perm lid u.urid mod)
  ?>  par-perm
  ::
  :: Identify ids to be modified (nux)
  =/  l  (~(got by goals.p) lid)
  =/  nux=(set id:gol)
    ?~  par.l
      (sy ~[lid])
    (sy ~[lid u.par.l])
  =.  nux
    ?~  urid
      nux
    (~(put in nux) u.urid)
  ::
  :: If par.l is non-null, remove lid from its kids
  =/  pore
    ?~  par.l
      this
    =/  q  (~(got by goals.p) u.par.l)
    =.  goals.p  (~(put by goals.p) u.par.l q(kids (~(del in kids.q) lid)))
    (yoke [%held-rend lid u.par.l] mod)
  ::
  :: Replace lid's par with urid (null or unit of id)
  =.  l  (~(got by goals.p.pore) lid) :: l has changed
  =.  goals.p.pore  (~(put by goals.p.pore) lid l(par urid))
  ::
  :: If urid is non-null, put lid in u.urid's kids
  =.  pore
    ?~  urid  
      pore
    =/  r  (~(got by goals.p.pore) u.urid)
    =.  goals.p.pore
      (~(put by goals.p.pore) u.urid r(kids (~(put in kids.r) lid)))
    (yoke:pore [%held-yoke lid u.urid] mod)
  (emot ^this [%pool-nexus %yoke (make-nex nux)]):[pore(efx efx) .]
::
++  mark-actionable
  |=  [=id:gol mod=ship]
  ^-  _this
  ?>  (check-goal-perm id mod)
  =/  goal  (~(got by goals.p) id)
  ?.  .=  0
      %+  murn
      ~(tap in inflow.deadline.goal) 
      |=(=eid:gol ?:(=(id id.eid) ~ (some eid)))
    ~|("has-nested" !!)
  =.  goals.p  (~(put by goals.p) id goal(actionable %&))
  (emot this [%goal-togls id %actionable %.y])
::
++  mark-complete
  |=  [=id:gol mod=ship]
  ^-  _this
  ?>  (check-peon-perm id mod)
  =/  goal  (~(got by goals.p) id)
  ?:  (left-uncompleted id)  ~|("left-uncompleted" !!)
  =.  goals.p  (~(put by goals.p) id goal(complete %&))
  (emot this [%goal-togls id %complete %.y])
::
++  unmark-actionable
  |=  [=id:gol mod=ship]
  ^-  _this
  ?>  (check-goal-perm id mod)
  =/  goal  (~(got by goals.p) id)
  =.  goals.p  (~(put by goals.p) id goal(actionable %|))
  (emot this [%goal-togls id %actionable %.n])
::
++  unmark-complete
  |=  [=id:gol mod=ship]
  ^-  _this
  ?>  (check-peon-perm id mod)
  =/  goal  (~(got by goals.p) id)
  ?:  (ryte-completed id)  ~|("ryte-completed" !!)
  =.  goals.p  (~(put by goals.p) id goal(complete %|))
  (emot this [%goal-togls id %complete %.n])
::
++  set-deadline
  |=  [=id:gol moment=(unit @da) mod=ship]
  ^-  _this
  ?>  (check-goal-perm id mod)
  =/  rb  (ryte-bound [%d id])
  =/  lb  (left-bound [%d id])
  ?:  &(!=(+.lb [%d id]) (unit-lth moment -:lb))  ~|("bound-left" !!)
  ?:  &(!=(+.rb [%d id]) (unit-gth moment -:rb))  ~|("bound-ryte" !!)
  =/  goal  (~(got by goals.p) id)
  =.  goals.p  (~(put by goals.p) id goal(moment.deadline moment))
  (emot this [%goal-nexus id %deadline moment])
::
++  set-kickoff
  |=  [=id:gol moment=(unit @da) mod=ship]
  ^-  _this
  ?>  (check-goal-perm id mod)
  =/  rb  (ryte-bound [%k id])
  =/  lb  (left-bound [%k id])
  ?:  &(!=(+.lb [%k id]) (unit-lth moment -:lb))  ~|("bound-left" !!)
  ?:  &(!=(+.rb [%k id]) (unit-gth moment -:rb))  ~|("bound-ryte" !!)
  =/  goal  (~(got by goals.p) id)
  this(goals.p (~(put by goals.p) id goal(moment.kickoff moment)))
::
++  add-pool-viewers
  |=  [viewers=(set ship) mod=ship]
  ^-  _this
  ?>  (check-pool-perm mod)
  =.  viewers.p  (~(uni in viewers.p) viewers)
  (emot this [%pool-perms %add-pool-viewers viewers])
::
++  rem-pool-viewers
  |=  [viewers=(set ship) mod=ship]
  ^-  _this
  ?>  (check-pool-perm mod)
  this(viewers.p (~(dif in viewers.p) viewers))
::
++  add-pool-admins
  |=  [admins=(set ship) mod=ship]
  ^-  _this
  ?>  (check-pool-perm mod)
  =.  viewers.p  (~(uni in viewers.p) admins)
  =.  admins.p  (~(uni in admins.p) admins)
  (emot this [%pool-perms %add-pool-admins admins])
::
++  rem-pool-admins
  |=  [admins=(set ship) mod=ship]
  ^-  _this
  ?.  =(owner.p mod)  ~|("pool-owner-fail" !!) :: only owner can remove admin
  this(admins.p (~(dif in admins.p) admins))
::
++  add-pool-captains
  |=  [captains=(set ship) mod=ship]
  ^-  _this
  ?>  (check-pool-perm mod)
  =.  viewers.p  (~(uni in viewers.p) captains)
  =.  captains.p  (~(uni in captains.p) captains)
  (emot this [%pool-perms %add-pool-captains captains])
::
++  rem-pool-captains
  |=  [captains=(set ship) mod=ship]
  ^-  _this
  ?>  (check-pool-perm mod)
  this(captains.p (~(dif in captains.p) captains))
::
++  add-goal-captains
  |=  [=id:gol captains=(set ship) mod=ship]
  ^-  _this
  ?>  (check-goal-perm id mod)
  ?.  =(0 ~(wyt in (~(dif in captains) viewers.p)))
    ~|("goal-captain-non-viewer" !!)
  =/  goal  (~(got by goals.p) id)
  =.  captains.goal  (~(uni in captains.goal) captains)
  =.  goals.p  (~(put by goals.p) id goal)
  (emot this [%goal-perms id %add-goal-captains captains])
::
++  rem-goal-captains
  |=  [=id:gol captains=(set ship) mod=ship]
  ^-  _this
  ?>  (check-goal-perm id mod)
  =/  goal  (~(got by goals.p) id)
  =.  captains.goal  (~(dif in captains.goal) captains)
  this(goals.p (~(put by goals.p) id goal))
::
++  add-goal-peons
  |=  [=id:gol peons=(set ship) mod=ship]
  ^-  _this
  ?>  (check-goal-perm id mod)
  ?.  =(0 ~(wyt in (~(dif in peons) viewers.p)))
    ~|("goal-peon-non-viewer" !!)
  =/  goal  (~(got by goals.p) id)
  =.  peons.goal  (~(uni in peons.goal) peons)
  =.  goals.p  (~(put by goals.p) id goal)
  (emot this [%goal-perms id %add-goal-peons peons])
::
++  rem-goal-peons
  |=  [=id:gol peons=(set ship) mod=ship]
  ^-  _this
  ?>  (check-goal-perm id mod)
  =/  goal  (~(got by goals.p) id)
  =.  peons.goal  (~(dif in peons.goal) peons)
  this(goals.p (~(put by goals.p) id goal))
::
++  add-pool-perms
  |=  $:  viewers=(set ship)
          admins=(set ship)
          captains=(set ship)
          mod=ship
      ==
  ^-  _this
  =/  pore  (add-pool-viewers viewers mod)
  =.  pore  (add-pool-admins:pore admins mod)
  =.  pore  (add-pool-captains:pore captains mod)
  (emot:pore(efx efx) this [%pool-perms %add-perms admins captains viewers])
::
++  edit-goal-desc
  |=  [=id:gol desc=@t mod=ship]
  ^-  _this
  ?>  (check-goal-perm id mod)
  =/  goal  (~(got by goals.p) id)
  =.  goals.p  (~(put by goals.p) id goal(desc desc))
  (emot this [%goal-hitch id %desc desc])
:: 
++  edit-pool-title
  |=  [title=@t mod=ship]
  ^-  _this
  ?>  (check-pool-perm mod)
  =.  p  p(title title)
  (emot this [%pool-hitch %title title])
::
++  etch
  |=  upd=update:goal-store
  ^-  _this
  |^
  ?+    upd  !!
    :: ------------------------------------------------------------------------
    :: spawn/trash
    ::
      [%spawn-goal *]
    (spawn-goal:spawn-trash [nex id goal]:upd)
    ::
      [%trash-goal *]
    (trash-goal:spawn-trash [nex del]:upd)
    :: ------------------------------------------------------------------------
    :: pool-perms
    ::
      [%pool-perms %add-perms *]
    (add-perms:pool-perms [viewers admins captains]:upd)
    ::
      [%pool-perms %add-pool-viewers *]
    (add-pool-viewers:pool-perms viewers.upd)
    ::
      [%pool-perms %rem-pool-viewers *]
    (rem-pool-viewers:pool-perms viewers.upd)
    ::
      [%pool-perms %add-pool-captains *]
    (add-pool-captains:pool-perms captains.upd)
    ::
      [%pool-perms %rem-pool-captains *]
    (rem-pool-captains:pool-perms captains.upd)
    ::
      [%pool-perms %add-pool-admins *]
    (add-pool-admins:pool-perms admins.upd)
    ::
      [%pool-perms %rem-pool-admins *]
    (rem-pool-admins:pool-perms admins.upd)
    :: ------------------------------------------------------------------------
    :: pool-hitch
    ::
      [%pool-hitch %title *]
    (title:pool-hitch title.upd)
    :: ------------------------------------------------------------------------
    :: pool-nexus
    ::
      [%pool-nexus %yoke *]
    (yoke:pool-nexus nex.upd)
    :: ------------------------------------------------------------------------
    :: goal-perms
    ::
      [%goal-perms id:gol %add-goal-captains *]
    (add-goal-captains:goal-perms [id captains]:upd)
    ::
      [%goal-perms id:gol %rem-goal-captains *]
    (rem-goal-captains:goal-perms [id captains]:upd)
    ::
      [%goal-perms id:gol %add-goal-peons *]
    (add-goal-peons:goal-perms [id peons]:upd)
    ::
      [%goal-perms id:gol %rem-goal-peons *]
    (rem-goal-peons:goal-perms [id peons]:upd)
    :: ------------------------------------------------------------------------
    :: goal-hitch
    ::
      [%goal-hitch id:gol %desc *]
    (desc:goal-hitch [id desc]:upd)
    :: ------------------------------------------------------------------------
    :: goal-nexus
    ::
      [%goal-nexus id:gol %deadline *]
    (deadline:goal-nexus [id moment]:upd)
    :: ------------------------------------------------------------------------
    :: goal-togls
    ::
      [%goal-togls id:gol %complete *]
    (complete:goal-togls [id complete]:upd)
    ::
      [%goal-togls id:gol %actionable *]
    (actionable:goal-togls [id actionable]:upd)
  ==
  ::
  ++  spawn-trash
    |%
    ++  spawn-goal
      |=  [=nex:gol =id:gol =goal:gol]
      ^-  _this
      =.  goals.p  (~(put by goals.p) id goal)
      (apply-nex nex)
    ::
    ++  trash-goal
      |=  [=nex:gol del=(set id:gol)]
      ^-  _this
      =.  goals.p
        =/  del  ~(tap in del)
        =/  idx  0
        |-  
        ?:  =(idx (lent del))
          goals.p
        $(idx +(idx), goals.p (~(del by goals.p) (snag idx del)))
      (apply-nex nex)
    --
  ::
  ++  pool-perms
    |%
    ++  add-pool-viewers
      |=  viewers=(set ship)
      ^-  _this
      this(viewers.p (~(uni in viewers.p) viewers))
    ::
    ++  rem-pool-viewers
      |=  viewers=(set ship)
      ^-  _this
      %=  this
        viewers.p  (~(dif in viewers.p) viewers)
        admins.p  (~(dif in admins.p) viewers)
        captains.p  (~(dif in captains.p) viewers)
      ==
    ::
    ++  add-pool-captains
      |=  captains=(set ship)
      ^-  _this
      %=  this
        viewers.p  (~(uni in viewers.p) captains)
        captains.p  (~(uni in captains.p) captains)
      ==
    ::
    ++  rem-pool-captains
      |=  captains=(set ship)
      ^-  _this
      this(captains.p (~(dif in captains.p) captains))
    ::
    ++  add-pool-admins
      |=  admins=(set ship)
      ^-  _this
      %=  this
        viewers.p  (~(uni in viewers.p) admins)
        admins.p  (~(uni in admins.p) admins)
      ==
    ::
    ++  rem-pool-admins
      |=  admins=(set ship)
      ^-  _this
      this(admins.p (~(dif in admins.p) admins))
    ::
    ++  add-perms
      |=  [viewers=(set ship) admins=(set ship) captains=(set ship)]
      ^-  _this
      %=  this
        viewers.p
          %-  ~(uni in viewers.p)
          %-  ~(uni in viewers)
          (~(uni in admins) captains)
        admins.p  (~(uni in admins.p) admins)
        captains.p  (~(uni in captains.p) captains)
      ==
    --
  ::
  ++  pool-hitch
    |%
    ++  title  |=(title=@t `_this`this(p p(title title)))
    --
  ::
  ++  pool-nexus
    |%
    ++  yoke  |=(=nex:gol `_this`(apply-nex nex))
    --
  ::
  ++  goal-perms
    |%
    ++  add-goal-captains
      |=  [=id:gol captains=(set ship)]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      %=  this
        goals.p
          %+  ~(put by goals.p)
            id
          goal(captains (~(uni in captains.goal) captains))
      ==
    ::
    ++  rem-goal-captains
      |=  [=id:gol captains=(set ship)]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      %=  this
        goals.p
          %+  ~(put by goals.p)
            id
          goal(captains (~(dif in captains.goal) captains))
      ==
    ::
    ++  add-goal-peons
      |=  [=id:gol peons=(set ship)]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      %=  this
        goals.p
          (~(put by goals.p) id goal(peons (~(uni in peons.goal) peons)))
      ==
    ::
    ++  rem-goal-peons
      |=  [=id:gol peons=(set ship)]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      %=  this
        goals.p
          (~(put by goals.p) id goal(peons (~(dif in peons.goal) peons)))
      ==
    --
  ::
  ++  goal-hitch
    |%
    ++  desc
      |=  [=id:gol desc=@t]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      this(goals.p (~(put by goals.p) id goal(desc desc)))
    --
  ::
  ++  goal-nexus
    |%
    ++  deadline
      |=  [=id:gol moment=(unit @da)]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      this(goals.p (~(put by goals.p) id goal(moment.deadline moment)))
    --
  ::
  ++  goal-togls
    |%
    ++  complete
      |=  [=id:gol complete=?(%.y %.n)]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      this(goals.p (~(put by goals.p) id goal(complete complete)))
    ::
    ++  actionable
      |=  [=id:gol actionable=?(%.y %.n)]
      ^-  _this
      =/  goal  (~(got by goals.p) id)
      this(goals.p (~(put by goals.p) id goal(actionable actionable)))
    --
  --
--
