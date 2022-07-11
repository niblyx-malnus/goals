/-  nest
|_  =goals:nest
::
:: create unique goal id based on source ship and creation time
++  unique-id
  |=  =bowl:gall 
  ?.  (~(has by goals) [our.bowl now.bowl])
    [our.bowl now.bowl]
  $(now.bowl (add now.bowl ~s0..0001))
::
:: create a new goal and add to goals, nesting under par
++  add-goal
  |=  [=id:nest desc=@t par=(unit id:nest)]
  =|  =goal:nest
  =.  desc.goal        desc
  =.  actionable.goal  %.n
  =.  status.goal      %active
  =.  goals  (~(put by goals) id goal)
  ?~  par  goals
  (nestify u.par id)
::
:: get roots
++  roots
  ^-  (list id:nest)
  %:  turn
  (skim ~(tap by goals) |=([id:nest =goal:nest] =(0 ~(wyt in pars.goal))))
  |=([=id:nest goal:nest] id)
  ==
::
:: get leaves
++  leaves
  ^-  (list id:nest)
  %:  turn
  (skim ~(tap by goals) |=([id:nest =goal:nest] =(0 ~(wyt in kids.goal))))
  |=([=id:nest goal:nest] id)
  ==
::
:: Check if did is descendent of aid (avoids cycles)
++  descends
  |=  [aid=id:nest did=id:nest]
  ^-  ?
  ?.  (~(has in ~(key by goals)) aid)  ~&('Invalid aid.' !!)
  ?.  (~(has in ~(key by goals)) did)  ~&('Invalid did.' !!)
  =/  kids  kids:(~(got by goals) aid)
  ?:  =(0 ~(wyt in kids))   %.n  :: if a has no children, d is not descendent
  ?:  (~(has in kids) did)  %.y  :: if d is child of a, d is descendent
  (~(any in kids) (curr descends did))  :: apply descends to all children
::
:: Check if lid is precedent of rid (avoids cycles)
++  precedes
  |=  [rid=id:nest lid=id:nest]
  ^-  ?
  ?.  (~(has in ~(key by goals)) rid)  ~&('Invalid rid.' !!)
  ?.  (~(has in ~(key by goals)) lid)  ~&('Invalid lid.' !!)
  =/  befs  befs:(~(got by goals) rid)
  ?:  =(0 ~(wyt in befs))   %.n  :: if r has no .befs, l is not precedent
  ?:  (~(has in befs) lid)  %.y  :: if l is in .befs of r, l is precedent
  (~(any in befs) (curr precedes lid))  :: apply precedes to all .befs
::
::  
++  put-kids
  |=  [pid=id:nest cid=id:nest]
  (~(jab by goals) pid |=(=goal:nest goal(kids (~(put in kids.goal) cid))))
::
::
++  del-kids
  |=  [pid=id:nest cid=id:nest]
  (~(jab by goals) pid |=(=goal:nest goal(kids (~(del in kids.goal) cid))))
::
::
++  put-pars
  |=  [cid=id:nest pid=id:nest]
  (~(jab by goals) cid |=(=goal:nest goal(pars (~(put in pars.goal) pid))))
::
::
++  del-pars
  |=  [cid=id:nest pid=id:nest]
  (~(jab by goals) cid |=(=goal:nest goal(pars (~(del in pars.goal) pid))))
::
::
++  put-befs
  |=  [rid=id:nest lid=id:nest]
  (~(jab by goals) rid |=(=goal:nest goal(befs (~(put in befs.goal) lid))))
::
::
++  del-befs
  |=  [rid=id:nest lid=id:nest]
  (~(jab by goals) rid |=(=goal:nest goal(befs (~(del in befs.goal) lid))))
::
::
++  put-afts
  |=  [lid=id:nest rid=id:nest]
  (~(jab by goals) lid |=(=goal:nest goal(afts (~(put in afts.goal) rid))))
::
::
++  del-afts
  |=  [lid=id:nest rid=id:nest]
  (~(jab by goals) lid |=(=goal:nest goal(afts (~(del in afts.goal) rid))))
::
:: Nest cid under pid
++  nestify
  |=  [pid=id:nest cid=id:nest]
  ?:  =(pid cid)  ~&('Cannot nest goal under itself.' !!)
  ?.  (~(has in ~(key by goals)) pid)  ~&('Invalid pid.' !!)
  ?.  (~(has in ~(key by goals)) cid)  ~&('Invalid cid.' !!)
  ?:  (descends cid pid)  ~&('Cyclical id pair.' !!)
  ?:  actionable:(~(got by goals) pid)  ~&('Parent is actionable.' !!)
  =.  goals  (put-kids pid cid)  (put-pars cid pid)
::
:: Unnest cid from under pid
++  unnest
  |=  [pid=id:nest cid=id:nest]
  =.  goals  (del-kids pid cid)  (del-pars cid pid)
::
:: Precede rid by lid
++  precede
  |=  [rid=id:nest lid=id:nest]
  ?:  =(rid lid)  ~&('Cannot precede goal by itself.' !!)
  ?.  (~(has in ~(key by goals)) rid)  ~&('Invalid rid.' !!)
  ?.  (~(has in ~(key by goals)) lid)  ~&('Invalid lid.' !!)
  ?:  (precedes lid rid)  ~&('Cyclical id pair.' !!)
  ?:  (descends lid rid)  ~&('Cyclical id pair.' !!)
  =.  goals  (put-befs rid lid)  (put-afts lid rid)
::
:: Unprecede rid by lid
++  unprecede
  |=  [rid=id:nest lid=id:nest]
  =.  goals  (del-befs rid lid)  (del-afts lid rid)
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
++  anchor  +((roll (turn roots plumb) max))
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
:: get the number representing the deepest path to a leaf node
++  get-lvl
  |=  [id=(unit id:nest) dir=?(%p %c)]
  ^-  @
  ?-  dir
      %p
    ?~  id  !!
    (plumb u.id)
      %c
    ?~  id  anchor
    (plumb u.id)
  ==
::
:: get either the children or the parents depending on dir
++  get-fam
  |=  [id=(unit id:nest) dir=?(%p %c)]
  ^-  (list id:nest)
  ?-  dir
      %p  
    ?~  id  leaves
    =/  goal  (~(got by goals) u.id)
    ~(tap in pars.goal)
      %c
    ?~  id  roots
    =/  goal  (~(got by goals) u.id)
    ~(tap in kids.goal)
  ==
::
::
++  harvest-unpreceded
  |^
  |=  =id:nest
  ^-  (set id:nest)
  =/  goal  (~(got by goals) id)
  =/  kids-list  ~(tap in kids.goal)
  =/  out  (~(gas in *(set id:nest)) (skim kids-list childless))
  =/  idx  0
  |-
  ?:  =(idx (lent kids-list))
    out
  =/  kid  (snag idx kids-list)
  $(idx +(idx), out (~(uni in out) (harvest-unpreceded kid)))
  ++  childless
    |=  =id:nest
    =/  goal  (~(got by goals) id)
    =(0 ~(wyt in kids.goal))
  --
::
::
++  later-to-sooner
  |=  lst=(list id:nest)
  |^  (sort lst cmp)
  ++  cmp
    |=  [a=id:nest b=id:nest]
    (unit-lth deadline:(inherit-deadline b) deadline:(inherit-deadline a))
  --
::
::
++  sooner-to-later
  |=  lst=(list id:nest)
  |^  (sort lst cmp)
  ++  cmp
    |=  [a=id:nest b=id:nest]
    (unit-lth deadline:(inherit-deadline a) deadline:(inherit-deadline b))
  --
::
::
++  newest-to-oldest
  |=  lst=(list =id:nest)
  (sort lst |=([a=[@p d=@da] b=[@p d=@da]] (gth d.a d.b)))
::
::
++  oldest-to-newest
  |=  lst=(list =id:nest)
  (sort lst |=([a=[@p d=@da] b=[@p d=@da]] (lth d.a d.b)))
::
:: inherit deadline
++  inherit-deadline
  |=  =id:nest
  ^-  [deadline=(unit @da) hereditor=id:nest]
  =/  goal  (~(got by goals) id)
  ?:  &(=(0 ~(wyt in pars.goal)) =(0 ~(wyt in afts.goal)))
    [deadline.goal id]
  %-  list-min-head
  %+  weld
    ~[[deadline.goal id]]
  %+  turn
    (weld ~(tap in afts.goal) ~(tap in pars.goal))
  inherit-deadline
::
::
++  unit-lth
  |=  [a=(unit @) b=(unit @)]
  ?~  a  %.n
  ?~  b  %.y
  (lth u.a u.b)
::
::
++  list-min-head
  |*  lst=(list [(unit @) *])
  %+  roll
    ^+  lst  +.lst
  |:  [a=i.-.lst b=i.-.lst]
  ?:  (unit-lth -.a -.b)  a  b
::
:: make a goal actionable
++  actionate
  |=  =goal:nest
  ?:  =(0 ~(wyt in kids.goal)) :: cannot have children
    goal(actionable %.y)
  ~&('Cannot make actionable; has children.' goal)
::
:: mark a goal complete
++  complete
  |=  =goal:nest
  |^
  ?:  &(befs-complete kids-complete)
    goal(status %completed)
  ~&('Cannot mark complete; children or precedents uncompleted.' goal)
  ++  befs-complete  (~(all in befs.goal) completed)
  ++  kids-complete  (~(all in kids.goal) completed)
  ++  completed  |=(=id:nest =(%completed status:(~(got by goals) id)))
  --
::
:: mark a goal active
++  activate
  |=  =goal:nest
  |^
  ?:  &(afts-active pars-active)
    goal(status %active)
  ~&('Cannot mark active; parents or successors uncompleted.' goal)
  ++  afts-active  (~(all in afts.goal) activated)
  ++  pars-active  (~(all in pars.goal) activated)
  ++  activated  |=(=id:nest =(%active status:(~(got by goals) id)))
  --
--
