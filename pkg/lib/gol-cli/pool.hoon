/-  gol=goal
/+  *gol-cli-goal
|_  [=pin:gol p=pool:gol]
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
  ^-  (each ? term)
  =/  pool-owner  +<:pin
  =/  pool-chefs  chefs.p
  ?:  |(=(pool-owner mod) (~(has in pool-chefs) mod))  [%& %.y]
  [%| %perm-fail]
::
++  check-pair-perm
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each ? term)
  =/  pool-owner  +<:pin
  =/  pool-chefs  chefs.p
  ?:  |(=(pool-owner mod) (~(has in pool-chefs) mod))  [%& %.y]
  =/  l  (seniority mod lid %c)
  =/  r  (seniority mod rid %c)
  ?.  =(senior.l senior.r)  [%| %diff-sen-perm-fail]
  ?~  senior.l  [%| %null-sen-perm-fail]
  ?:  =(lid u.senior.l)  [%| %no-left-perm-fail]  [%& %.y]

::
++  own-yoke
  |=  [lid=id:gol rid=id:gol]
  ^-  (each [=pool:gol =(set id:gol)] term)
  =/  l  (~(got by goals.p) lid)
  =/  r  (~(got by goals.p) rid)
  =/  output=(each [=pool:gol =(set id:gol)] term)
    ?~  par.l
      [%& p ~]
    (own-rend lid u.par.l)
  ?-    -.output
    %|  output
      %&
    =.  p  pool.p.output
    =.  goals.p  (~(put by goals.p) lid l(par (some rid)))
    =.  goals.p  (~(put by goals.p) rid r(kids (~(put in kids.r) lid)))
    [%& p (~(gas in set.p.output) ~[lid rid])]
  ==
::
++  own-rend
  |=  [lid=id:gol rid=id:gol]
  ^-  (each [=pool:gol =(set id:gol)] term)
  =/  l  (~(got by goals.p) lid)
  =/  r  (~(got by goals.p) rid)
  =.  goals.p  (~(put by goals.p) lid l(par ~))
  =.  goals.p  (~(put by goals.p) rid r(kids (~(del in kids.r) lid)))
  [%& p (~(gas in *(set id:gol)) ~[lid rid])]
::
++  dag-yoke
  |=  [e1=eid:gol e2=eid:gol]
  ^-  (each [=pool:gol =(set id:gol)] term)
  =/  edge1  (got-edge e1)
  =/  edge2  (got-edge e2)
  ?:  complete:(~(got by goals.p) id.e2)  [%| %complete]
  ?:  (before e2 e1)  [%| %before-e2-e1]
  ?:  (unit-gth moment.edge1 -:(ryte-bound e2))  [%| %bound-mismatch]
  ?:  (unit-lth moment.edge2 -:(left-bound e1))  [%| %bound-mismatch]
  =.  outflow.edge1  (~(put in outflow.edge1) e2)
  =.  inflow.edge2  (~(put in inflow.edge2) e1)
  =.  goals.p  (~(put by goals.p) id.e1 (update-edge e1 edge1))
  =.  goals.p  (~(put by goals.p) id.e2 (update-edge e2 edge2))
  [%& p (~(gas in *(set id:gol)) ~[id.e1 id.e2])]
::
++  dag-rend
  |=  [e1=eid:gol e2=eid:gol]
  ^-  (each [=pool:gol =(set id:gol)] term)
  =/  l  (~(got by goals.p) id.e1)
  =/  r  (~(got by goals.p) id.e2)
  =/  edge1  (got-edge e1)
  =/  edge2  (got-edge e2)
  ?:  =(id.e1 id.e2)  [%| %same-goal]
  ?:  ?|  &(=(-.e1 %d) =(-.e2 %d) (~(has in kids.r) id.e1))
          &(=(-.e1 %k) =(-.e2 %k) (~(has in kids.l) id.e2))
      ==
    [%| %owned-goal]
  =.  outflow.edge1  (~(del in outflow.edge1) e2)
  =.  inflow.edge2  (~(del in inflow.edge2) e1)
  =.  goals.p  (~(put by goals.p) id.e1 (update-edge e1 edge1))
  =.  goals.p  (~(put by goals.p) id.e2 (update-edge e2 edge2))
  [%& p (~(gas in *(set id:gol)) ~[id.e1 id.e2])]
::
++  prio-yoke
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  =/  perm  (check-pair-perm lid rid mod)
  ?-    -.perm
    %|  perm
      %&
    ?:  =(lid rid)  [%| %yoke-self]
    ?:  |(complete:(~(got by goals.p) lid) complete:(~(got by goals.p) rid))
      [%| %complete]
    (dag-yoke [%k lid] [%k rid])
  ==
::
++  prio-rend
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  =/  perm  (check-pair-perm lid rid mod)
  ?-    -.perm
    %|  perm
      %&
    ?:  =(lid rid)  [%| %rend-self]
    (dag-rend [%k lid] [%k rid])
  ==
::
++  prec-yoke
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  =/  perm  (check-pair-perm lid rid mod)
  ?-    -.perm
    %|  perm
      %&
    ?:  =(lid rid)  [%| %yoke-self]
    ?:  |(complete:(~(got by goals.p) lid) complete:(~(got by goals.p) rid))
      [%| %complete]
    (dag-yoke [%d lid] [%k rid])
  ==
::
++  prec-rend
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  =/  perm  (check-pair-perm lid rid mod)
  ?-    -.perm
    %|  perm
      %&
    ?:  =(lid rid)  [%| %rend-self]
    (dag-rend [%d lid] [%k rid])
  ==
::
++  nest-yoke
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  =/  perm  (check-pair-perm lid rid mod)
  ?-    -.perm
    %|  perm
      %&
    ?:  =(lid rid)  [%| %yoke-self]
    =/  l  (~(got by goals.p) lid)
    =/  r  (~(got by goals.p) rid)
    ?:  |(complete.l complete.r)
      [%| %complete]
    ?:  actionable.r
      [%| %actionable]
    (dag-yoke [%d lid] [%d rid])
  ==
::
++  nest-rend
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  =/  perm  (check-pair-perm lid rid mod)
  ?-    -.perm
    %|  perm
      %&
    ?:  =(lid rid)  [%| %rend-self]
    (dag-rend [%d lid] [%d rid])
  ==
::
++  held-yoke
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  =/  perm  (check-pair-perm lid rid mod)
  ?-    -.perm
    %|  perm
      %&
    ?:  =(lid rid)  [%| %yoke-self]
    =/  l  (~(got by goals.p) lid)
    =/  r  (~(got by goals.p) rid)
    ?:  |(complete.l complete.r)
      [%| %complete]
    ?:  actionable.r
      [%| %actionable]
    =|  output=(each [=pool:gol =(set id:gol)] term)
    =.  output
      ?~  par.l
        [%& p ~]
      (held-rend lid u.par.l mod)
    ?-    -.output
      %|  output
        %&
      =.  p  pool.p.output
      %+  apply-sequence  mod
      :~  [%own-yoke lid rid]
          [%dag-yoke [%d lid] %d rid]
          [%dag-yoke [%k rid] %k lid]
      ==
    ==
  ==
::
++  held-rend
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  =/  perm  (check-pair-perm lid rid mod)
  ?-    -.perm
    %|  perm
      %&
    ?:  =(lid rid)  [%| %rend-self]
    %+  apply-sequence  mod
    :~  [%own-rend lid rid]
        [%dag-rend [%d lid] %d rid]
        [%dag-rend [%k rid] %k lid]
    ==
  ==
::
++  held-rend-strict
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each [=pool:gol =(set id:gol)] term)
  :: only allow held-rend for mod with pool permissions
  =/  perm  (check-pool-perm mod)
  ?-    -.perm
    %|  perm
    %&  (held-rend lid rid mod)
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
      %dag-yoke   (dag-yoke e1.i.seq e2.i.seq)
      %dag-rend   (dag-rend e1.i.seq e2.i.seq)
      %own-yoke   (own-yoke lid.i.seq rid.i.seq)
      %own-rend   (own-rend lid.i.seq rid.i.seq)
      %prio-rend  (prio-rend lid.i.seq rid.i.seq mod)
      %prio-yoke  (prio-yoke lid.i.seq rid.i.seq mod)
      %prec-rend  (prec-rend lid.i.seq rid.i.seq mod)
      %prec-yoke  (prec-yoke lid.i.seq rid.i.seq mod) 
      %nest-rend  (nest-rend lid.i.seq rid.i.seq mod) 
      %nest-yoke  (nest-yoke lid.i.seq rid.i.seq mod) 
      %held-rend  (held-rend lid.i.seq rid.i.seq mod) 
      %held-rend-strict  (held-rend-strict lid.i.seq rid.i.seq mod) 
      %held-yoke  (held-yoke lid.i.seq rid.i.seq mod) 
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
++  get-nex
  |=  =(set id:gol)
  ^-  nex:gol
  =|  =nex:gol
  =/  idx  0
  =/  list  ~(tap in set)
  |-
  ?:  =(idx (lent list))
    nex
  =/  id  (snag idx list)
  =/  goal  (~(got by goals.p) id)
  =|  =nexus:gol
  =.  par.nexus  par.goal
  =.  kids.nexus  kids.goal
  =.  kickoff.nexus  kickoff.goal
  =.  deadline.nexus  deadline.goal
  $(idx +(idx), nex (~(put in nex) id nexus))
::
++  apply-nexus
  |=  [=id:gol =nexus:gol]
  ^-  pool:gol
  =/  goal  (~(got by goals.p) id)
  =.  par.goal  par.nexus
  =.  kids.goal  kids.nexus
  =.  kickoff.goal  kickoff.nexus
  =.  deadline.goal  deadline.nexus
  p(goals (~(put by goals.p) id goal))
::
++  apply-nex
  |=  =nex:gol
  ^-  pool:gol
  =/  idx  0
  =/  ids  ~(tap in ~(key by nex))
  |-
  ?:  =(idx (lent ids))
    p
  =/  id  (snag idx ids)
  $(idx +(idx), p (apply-nexus id (~(got by nex) id)))
::
++  mark-actionable
  |=  [=id:gol mod=ship]
  ^-  (each pool:gol term)
  =/  perm  (check-pair-perm id id mod)
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
  =/  perm  (check-pair-perm id id mod)
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
  =/  perm  (check-pair-perm id id mod)
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
  =/  perm  (check-pair-perm id id mod)
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
  =/  perm  (check-pair-perm id id mod)
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
  =/  perm  (check-pair-perm id id mod)
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
