/-  nest
|_  =goals:nest
:: TODOS:
:: - Need cycle catching/purging tools
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
  (nest-yoke id u.par %0)
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
:: immediate precedents
++  prec
  |=  =goal:nest
  (~(uni in kids.goal) befs.goal)
::
:: immediate successors
++  succ
  |=  =goal:nest
  (~(uni in pars.goal) afts.goal)
::
:: goals immediately prioritized over this goal
++  prio
  |=  =goal:nest
  (~(uni in (prec goal)) moar.goal)
::
:: goals which this goal is immediately prioritized over ("demoted")
++  demo
  |=  =goal:nest
  (~(uni in (succ goal)) less.goal)
::
:: is left id nest-left of right id?
++  nest-left
  |=  [lid=id:nest rid=id:nest]
  ^-  ?
  =/  kids  kids:(~(got by goals) rid)
  ?:  =(0 ~(wyt in kids))   %.n  :: if r has no .kids, l is not nest-left
  ?:  (~(has in kids) lid)  %.y  :: if l is child of r, l is nest-left
  (~(any in kids) (cury nest-left lid))  :: apply nest-left to all .kids
::
:: is left id prec-left of right id?
++  prec-left
  |=  [lid=id:nest rid=id:nest]
  ^-  ?
  =/  prec  (prec (~(got by goals) rid)) :: set of right goal's prec-left goal ids
  ?:  =(0 ~(wyt in prec))   %.n       :: if r has no prec, l is not prec-left of r
  ?:  (~(has in prec) lid)  %.y       :: if l is in prec of r, l is prec-left of r
  (~(any in prec) (cury prec-left lid))  :: apply prec-left to all prec
::
:: is left id prio-left of right id?
++  prio-left
  |=  [lid=id:nest rid=id:nest]
  ^-  ?
  =/  r  (~(got by goals) rid)
  =/  prio  (prio (~(got by goals) rid))
  ?:  =(0 ~(wyt in prio))   %.n
  ?:  (~(has in prio) lid)  %.y
  (~(any in prio) (cury prio-left lid))
::
::
++  put-kids
  |=  =id:nest
  |=(=goal:nest goal(kids (~(put in kids.goal) id)))
::
::
++  del-kids
  |=  =id:nest
  |=(=goal:nest goal(kids (~(del in kids.goal) id)))
::
::
++  uni-kids
  |=  set=(set id:nest)
  |=(=goal:nest goal(kids (~(uni in kids.goal) set)))
::
::
++  dif-kids
  |=  set=(set id:nest)
  |=(=goal:nest goal(kids (~(dif in kids.goal) set)))
::
::
++  put-pars
  |=  =id:nest
  |=(=goal:nest goal(pars (~(put in pars.goal) id)))
::
::
++  del-pars
  |=  =id:nest
  |=(=goal:nest goal(pars (~(del in pars.goal) id)))
::
::
++  uni-pars
  |=  set=(set id:nest)
  |=(=goal:nest goal(pars (~(uni in pars.goal) set)))
::
::
++  dif-pars
  |=  set=(set id:nest)
  |=(=goal:nest goal(pars (~(dif in pars.goal) set)))
::
::
++  put-befs
  |=  =id:nest
  |=(=goal:nest goal(befs (~(put in befs.goal) id)))
::
::
++  del-befs
  |=  =id:nest
  |=(=goal:nest goal(befs (~(del in befs.goal) id)))
::
::
++  uni-befs
  |=  set=(set id:nest)
  |=(=goal:nest goal(befs (~(uni in befs.goal) set)))
::
::
++  dif-befs
  |=  set=(set id:nest)
  |=(=goal:nest goal(befs (~(dif in befs.goal) set)))
::
::
++  put-afts
  |=  =id:nest
  |=(=goal:nest goal(afts (~(put in afts.goal) id)))
::
::
++  del-afts
  |=  =id:nest
  |=(=goal:nest goal(afts (~(del in afts.goal) id)))
::
::
++  uni-afts
  |=  set=(set id:nest)
  |=(=goal:nest goal(afts (~(uni in afts.goal) set)))
::
::
++  dif-afts
  |=  set=(set id:nest)
  |=(=goal:nest goal(afts (~(dif in afts.goal) set)))
::
::
++  put-moar
  |=  =id:nest
  |=(=goal:nest goal(moar (~(put in moar.goal) id)))
::
::
++  del-moar
  |=  =id:nest
  |=(=goal:nest goal(moar (~(del in moar.goal) id)))
::
::
++  uni-moar
  |=  set=(set id:nest)
  |=(=goal:nest goal(moar (~(uni in moar.goal) set)))
::
::
++  dif-moar
  |=  set=(set id:nest)
  |=(=goal:nest goal(moar (~(dif in moar.goal) set)))
::
::
++  put-less
  |=  =id:nest
  |=(=goal:nest goal(less (~(put in less.goal) id)))
::
::
++  del-less
  |=  =id:nest
  |=(=goal:nest goal(less (~(del in less.goal) id)))
::
::
++  uni-less
  |=  set=(set id:nest)
  |=(=goal:nest goal(less (~(uni in less.goal) set)))
::
::
++  dif-less
  |=  set=(set id:nest)
  |=(=goal:nest goal(less (~(dif in less.goal) set)))
::
::
++  jab
  |=  modify=$-(goal:nest goal:nest)
  |=  [id=id:nest]
  (~(jab by goals) id modify)
::
::
++  jab-set
  |=  modify=$-(goal:nest goal:nest)
  |=  set=(set id:nest)
  ^-  goals:nest
  =/  lst  ~(tap in set)
  =/  output  goals
  =/  idx  0
  |-
  ?:  =(idx (lent lst))
    output
  $(idx +(idx), output (~(jab by output) (snag idx lst) modify))
::
:: nest-yoke left goal to right goal
++  nest-yoke
  |=  [lid=id:nest rid=id:nest timidity=?(%3 %2 %1 %0)]
  ?:  =(lid rid)  ~&('Cannot nest-yoke goal to itself.' goals)
  ?:  actionable:(~(got by goals) rid)  ~&('Cannot nest-yoke: R is actionable.' goals)
  ?-  timidity
      %3
    ?:  (prio-left rid lid)  ~&('Cannot nest-yoke: R prio-left of L.' goals)
    =.  goals  ((jab (put-kids lid)) rid)  ((jab (put-pars rid)) lid)
      %2
    ?:  (prec-left rid lid)  ~&('Cannot nest-yoke: R prec-left of L.' goals)
    =.  goals  ((jab (put-kids lid)) rid)
    =.  goals  ((jab (put-pars rid)) lid)
    ?:  (prio-left rid lid)  (prio-yoke-force lid rid)  goals
      %1
    ?:  (nest-left rid lid)  ~&('Cannot nest-yoke: R nest-left of L.' goals)
    =.  goals  ((jab (put-kids lid)) rid)
    =.  goals  ((jab (put-pars rid)) lid)
    ?:  (prec-left rid lid)  (prec-yoke-force lid rid)
    ?:  (prio-left rid lid)  (prio-yoke-force lid rid)  goals
      %0
    ?:  (nest-left rid lid)  (nest-yoke-force lid rid)
    =.  goals  ((jab (put-kids lid)) rid)
    =.  goals  ((jab (put-pars rid)) lid)
    ?:  (prec-left rid lid)  (prec-yoke-force lid rid)
    ?:  (prio-left rid lid)  (prio-yoke-force lid rid)  goals
  ==
::
:: nest-rend left goal from right goal
++  nest-rend
  |=  [lid=id:nest rid=id:nest]
  =.  goals  ((jab (del-kids lid)) rid)  ((jab (del-pars rid)) lid)
::
:: prec-yoke left goal to right goal
++  prec-yoke
  |=  [lid=id:nest rid=id:nest timidity=?(%2 %1 %0)]
  ?:  =(lid rid)  ~&('Cannot prec-yoke goal to itself.' goals)
  ?-  timidity
      %2
    ?:  (prio-left rid lid)  ~&('Cannot prec-yoke: R prio-left of L.' goals)
    =.  goals  ((jab (put-befs lid)) rid)  ((jab (put-afts rid)) lid)
      %1
    ?:  (prec-left rid lid)  ~&('Cannot prec-yoke: R prec-left of L.' goals)
    =.  goals  ((jab (put-befs lid)) rid)
    =.  goals  ((jab (put-afts rid)) lid)
    ?:  (prio-left rid lid)  (prio-yoke-force lid rid)  goals
      %0
    ?:  (prec-left rid lid)  (prec-yoke-force lid rid)
    =.  goals  ((jab (put-befs lid)) rid)
    =.  goals  ((jab (put-afts rid)) lid)
    ?:  (prio-left rid lid)  (prio-yoke-force lid rid)  goals
  ==
::
:: prec-rend left goal from right goal
++  prec-rend
  |=  [lid=id:nest rid=id:nest]
  =.  goals  ((jab (del-befs lid)) rid)  ((jab (del-afts rid)) lid)
::
:: prio-yoke left goal to right goal
:: so that left goal is prio-left of right goal
++  prio-yoke
  |=  [lid=id:nest rid=id:nest timidity=?(%1 %0)]
  ?:  =(lid rid)  ~&('Cannot prio-yoke goal to itself.' goals)
  ?-  timidity
      %1
    ?:  (prio-left rid lid)  ~&('Cannot prio-yoke: R prio-left of L.' goals)
    =.  goals  ((jab (put-moar lid)) rid)  ((jab (put-less rid)) lid)
      %0
    ?:  (prio-left rid lid)  (prio-yoke-force lid rid)
    =.  goals  ((jab (put-moar lid)) rid)  ((jab (put-less rid)) lid)
    
  ==
::
:: prio-rend left goal from right goal
++  prio-rend
  |=  [lid=id:nest rid=id:nest]
  =.  goals  ((jab (del-moar lid)) rid)  ((jab (del-less rid)) lid)
::
::
++  prio-yoke-force
  |=  [lid=id:nest rid=id:nest]
  |^
  ?>  (prio-left rid lid)
  ?:  (prec-left rid lid)  ~&('Cannot prio-yoke: R prec-left L.' goals)
  :: if r prio-left goals which are prec-left of l
  =/  l  (~(got by goals) lid)
  ?:  (~(any in (prec l)) (cury prio-left rid))
    ~&('Cannot prio-yoke: R prio-left of goals prec-left of L.' goals)
  =/  r  (~(got by goals) rid)
  :: ids in moar.l which are prio-ryte of r
  =/  morr  (sy (skim ~(tap in moar.l) r-check))
  :: purge r from moar.l
  =.  goals  ((jab (del-moar rid)) lid)
  :: purge l from less.r
  =.  goals  ((jab (del-less lid)) rid)
  :: remove morr from moar.l
  =.  goals  ((jab (dif-moar morr)) lid)
  :: for each id in morr, remove lid from less
  =.  goals  ((jab-set (del-less lid)) morr)
  :: for each id in morr, add (demo l) to less
  =.  goals  ((jab-set (uni-less (demo l))) morr)
  :: for each id in (demo l), add morr to moar
  =.  goals  ((jab-set (uni-moar morr)) (demo l))
  :: for each id in (prio r), add lid to less
  =.  goals  ((jab-set (put-less lid)) (prio r))
  :: add (prio r) to moar.l
  =.  goals  ((jab (uni-moar (prio r))) lid)
  :: add lid to moar.r
  =.  goals  ((jab (put-moar lid)) rid)
  :: add rid to less.l
  =.  goals  ((jab (put-less rid)) lid)
  :: assert successful flip
  ?>  (prio-left lid rid)  goals
  ::
  :: check if an id is rid or if rid is prio-left of a given id
  ++  r-check
    |=  =id:nest
    ?:  =(id rid)  %.y
    (prio-left rid id)
  --
::
:: Force precedent, only swapping precedence relationship
++  prec-yoke-force
  |=  [lid=id:nest rid=id:nest]
  |^
  ?>  (prec-left rid lid)
  ?:  (nest-left rid lid)  ~&('Cannot prec-yoke: R nest-left L.' goals)
  :: if r prec-left goals which are nest-left of l
  =/  l  (~(got by goals) lid)
  ?:  (~(any in kids.l) (cury prec-left rid))
    ~&('Cannot prec-yoke: R prec-left of goals nest-left of L.' goals)
  =/  r  (~(got by goals) rid)
  :: ids in befs.l which are prec-ryte of r
  =/  befr  (sy (skim ~(tap in befs.l) r-check))
  :: purge r from befs.l
  =.  goals  ((jab (del-befs rid)) lid)
  :: purge l from afts.r
  =.  goals  ((jab (del-afts lid)) rid)
  :: remove befr from befs.l
  =.  goals  ((jab (dif-befs befr)) lid)
  :: for each id in befr, remove lid from afts
  =.  goals  ((jab-set (del-afts lid)) befr)
  :: for each id in befr, add (succ l) to afts
  =.  goals  ((jab-set (uni-afts (succ l))) befr)
  :: for each id in (succ l), add befr to befs
  =.  goals  ((jab-set (uni-befs befr)) (succ l))
  :: for each id in (prec r), add lid to afts
  =.  goals  ((jab-set (put-afts lid)) (prec r))
  :: add (prec r) to befs.l
  =.  goals  ((jab (uni-befs (prec r))) lid)
  :: add lid to befs.r
  =.  goals  ((jab (put-befs lid)) rid)
  :: add rid to afts.l
  =.  goals  ((jab (put-afts rid)) lid)
  :: assert successful flip
  ?>  (prec-left lid rid)
  :: if necessary, prio-yoke-force
  ?:  (prio-left rid lid)  (prio-yoke-force lid rid)
  goals
  ::
  :: check if an id is rid or if rid is prio-left of a given id
  ++  r-check
    |=  =id:nest
    ?:  =(id rid)  %.y
    (prec-left rid id)
  --
::
:: Force nest, only swapping nesting relationship
++  nest-yoke-force
  |=  [lid=id:nest rid=id:nest]
  |^
  ?>  (nest-left rid lid)
  =/  l  (~(got by goals) lid)
  =/  r  (~(got by goals) rid)
  :: ids in kids.l which are nest-ryte of r
  =/  kidr  (sy (skim ~(tap in kids.l) r-check))
  :: purge r from kids.l
  =.  goals  ((jab (del-kids rid)) lid)
  :: purge l from pars.r
  =.  goals  ((jab (del-pars lid)) rid)
  :: remove kidr from kids.l
  =.  goals  ((jab (dif-kids kidr)) lid)
  :: for each id in kidr, remove lid from pars
  =.  goals  ((jab-set (del-pars lid)) kidr)
  :: for each id in kidr, add pars.l to pars
  =.  goals  ((jab-set (uni-pars pars.l)) kidr)
  :: for each id in pars.l, add kidr to kids
  =.  goals  ((jab-set (uni-kids kidr)) pars.l)
  :: for each id in kids.r, add lid to pars
  =.  goals  ((jab-set (put-pars lid)) kids.r)
  :: add kids.r to kids.l
  =.  goals  ((jab (uni-kids kids.r)) lid)
  :: add lid to kids.r
  =.  goals  ((jab (put-kids lid)) rid)
  :: add rid to pars.l
  =.  goals  ((jab (put-pars rid)) lid)
  :: assert successful flip
  ?>  (nest-left lid rid)
  :: if necessary, prec-yoke-force
  ?:  (prec-left rid lid)  (prec-yoke-force lid rid)
  goals
  ::
  :: check if an id is rid or if rid is prio-left of a given id
  ++  r-check
    |=  =id:nest
    ?:  =(id rid)  %.y
    (nest-left rid id)
  --
::
:: 
++  kids  |=(=goal:nest kids.goal)
++  pars  |=(=goal:nest pars.goal)
++  befs  |=(=goal:nest befs.goal)
++  afts  |=(=goal:nest afts.goal)
++  moar  |=(=goal:nest moar.goal)
++  less  |=(=goal:nest less.goal)
::
::  get depth of a given goal (lowest level is depth of 1)
++  plumb
  |=  [=id:nest getter=$-(goal:nest (set id:nest))]
  ^-  @
  =/  =goal:nest  (~(got by goals) id)
  =/  lvl=@  1
  =/  buds  (getter goal)
  ?:  =(0 ~(wyt in buds))  lvl :: if childless, depth of 1
  =/  idx=@  0
  =/  buds  ~(tap in buds)
  |-
  ?:  =(idx (lent buds))  (add 1 lvl) :: add 1 to maximum child depth
  $(idx +(idx), lvl (max lvl (plumb (snag idx buds) getter)))
::
::
++  nest-plumb  |=(=id:nest (plumb id kids))
++  prec-plumb  |=(=id:nest (plumb id prec))
::
:: get max depth + 1; depth of "virtual" root node
++  anchor  +((roll (turn roots nest-plumb) max))
::
:: get priority of a given goal (highest priority is 0)
:: priority is the number of goals prioritized ahead of a given goal
++  priority
  |=  =id:nest
  |^
  ~(wyt in (prios id))
  ++  prios
    |=  =id:nest
    ^-  (set id:nest)
    =/  =goal:nest  (~(got by goals) id)
    =/  prio  (~(uni in (~(uni in kids:goal) befs:goal)) moar:goal)
    =/  idx=@  0
    =/  output  prio
    =/  prio  ~(tap in prio)
    |-
    ?:  =(idx (lent prio))  output
    =/  temp  (prios (snag idx prio))
    $(idx +(idx), output (~(uni in output) temp))
  --
::
:: get lowest priority; priority of "virtual" root node
++  lowpri  ~(wyt by goals)
::
:: purge goal from goals and from kids/pars/befs/afts/moar/less
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
        befs  (~(del in befs.goal) id)
        afts  (~(del in afts.goal) id)
        moar  (~(del in moar.goal) id)
        less  (~(del in less.goal) id)
      ==
  id
::
:: get the number representing the deepest path to a leaf node
++  get-lvl
  |=  [id=(unit id:nest) =dir:nest]
  ^-  @
  ?-  dir
      %nest-ryte
    ?~  id  !!
    (nest-plumb u.id)
      %nest-left
    ?~  id  anchor
    (nest-plumb u.id)
      %prec-ryte
    ?~  id  !!
    (prec-plumb u.id)
      %prec-left
    ?~  id  !!
    (prec-plumb u.id)
    %prio-ryte  !!
    %prio-left  !!
  ==
::
:: get either the children or the parents depending on dir
++  get-fam
  |=  [id=(unit id:nest) =dir:nest]
  ^-  (list id:nest)
  ?-  dir
      %nest-ryte
    ?~  id  leaves
    =/  goal  (~(got by goals) u.id)
    ~(tap in pars.goal)
      %nest-left
    ?~  id  roots
    =/  goal  (~(got by goals) u.id)
    ~(tap in kids.goal)
    %prec-ryte
    ?~  id  !!
    =/  goal  (~(got by goals) u.id)
    ~(tap in (succ goal))
      %prec-left
    ?~  id  !!
    =/  goal  (~(got by goals) u.id)
    ~(tap in (prec goal))
    %prio-ryte  !!
    %prio-left  !!
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
:: highest to lowest priority (highest being smallest number)
++  hi-to-lo
  |=  lst=(list id:nest)
  |^  (sort lst cmp)
  ++  cmp
    |=  [a=id:nest b=id:nest]
    (lth (priority a) (priority b))
  --
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
