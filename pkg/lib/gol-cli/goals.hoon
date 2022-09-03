/-  gol=goal, vyu=view
/+  *gol-cli-goal
|_  store:gol
+*  store  +<
:: create unique goal id based on source ship and creation time
++  unique-id
  |=  [our=ship now=@da]
  ^-  id:gol
  ?.  ?|  (~(has by directory) [our now])
          (~(has by pools) [%pin our now])
      ==
    [our now]
  $(now (add now ~s0..0001))
::
++  new-pool
  |=  [title=@t chefs=(set ship) peons=(set ship) viewers=(set ship) own=ship now=@da]
  ^-  [pin:gol pool:gol]
  =/  pin  [%pin (unique-id own now)]
  =|  =pool:gol
  =.  title.pool  title
  =.  creator.pool  own
  =.  chefs.pool  chefs
  =.  peons.pool  peons
  =.  viewers.pool  (~(uni in viewers) (~(uni in chefs) peons))
  [pin pool]
::
++  new-ids
  |=  [=(list id:gol) our=ship now=@da]
  ^-  (map id:gol id:gol)
  =/  idx  0
  =|  =(map id:gol id:gol)
  |-
  ?:  =(idx (lent list))
    map
  =/  new-id  (unique-id our now)
  %=  $
    idx  +(idx)
    directory  (~(put by directory) new-id *pin:gol)
    map  (~(put by map) (snag idx list) new-id)
  ==
::
++  copy-pool
  |=  $:  =old=pin:gol
          title=@t
          chefs=(set ship)
          peons=(set ship)
          viewers=(set ship)
          own=ship
          now=@da
      ==
  ^-  [pin:gol pool:gol]
  =/  old-pool  (~(got by pools) old-pin)
  =+  [pin pool]=(new-pool title chefs peons viewers own now)
  =.  pools  (~(put by pools) pin pool(creator owner.old-pin))
  =/  id-map  (new-ids ~(tap in ~(key by goals.old-pool)) own now)
  :-  pin
  %=  pool
    goals
      %-  ~(gas by goals.pool)
      %+  turn  ~(tap by goals.old-pool)
      |=  [=id:gol =goal:gol]
      :-  (~(got by id-map) id)
      %=  goal
        author  own
        par  ?~(par.goal ~ (some (~(got by id-map) u.par.goal)))
        kids  (~(run in kids.goal) |=(=id:gol (~(got by id-map) id)))
        inflow.kickoff
          (~(run in inflow.kickoff.goal) |=(=eid:gol [-.eid (~(got by id-map) id.eid)]))
        outflow.kickoff
          (~(run in outflow.kickoff.goal) |=(=eid:gol [-.eid (~(got by id-map) id.eid)]))
        inflow.deadline
          (~(run in inflow.deadline.goal) |=(=eid:gol [-.eid (~(got by id-map) id.eid)]))
        outflow.deadline
          (~(run in outflow.deadline.goal) |=(=eid:gol [-.eid (~(got by id-map) id.eid)]))
      ==
  ==
::
:: purge goal from goals
++  purge-goals
  |=  [=goals:gol =id:gol]
  ^-  goals:gol
  %-  %~  del
        by
      %-  ~(run by goals)
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
  id
::
:: find the oldest ancestor of this goal for which you are a chef
++  seniority
  |=  [mod=ship =id:gol senior=(unit id:gol) path=(list id:gol) cp=?(%c %p)]
  ^-  senior=(unit id:gol)
  =/  new-path=(list id:gol)  [id path]
  =/  i  (find [id]~ path) 
  ?.  =(~ i)  ?~(i !! ~&([%cycle (flop (scag u.i new-path))] !!))
  =.  senior
    ?-    cp
        %c
      ?:  (~(has in chefs:(got-goal id)) mod)
        (some id)
      senior
        %p
      ?:  (~(has in peons:(got-goal id)) mod)
        (some id)
      senior
    ==
  =/  par  par:(got-goal id)
  ?~  par  senior
  (seniority mod u.par senior path cp)
::
++  check-pair-perm
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each ? term)
  =/  pin  (~(got by directory) lid)
  ?.  =(pin (~(got by directory) rid))  [%& %.n]
  =/  pool-owner  +<:pin
  =/  pool-chefs  chefs:(~(got by pools) pin)
  ?:  |(=(pool-owner mod) (~(has in pool-chefs) mod))  [%& %.y]
  =/  l  (seniority mod lid ~ ~ %c)
  =/  r  (seniority mod rid ~ ~ %c)
  ?.  =(senior.l senior.r)  [%| %diff-sen-perm-fail]
  ?~  senior.l  [%| %null-sen-perm-fail]
  ?:  =(lid u.senior.l)  [%| %no-left-perm-perm-fail]  [%& %.y]
::
:: gets the stored goal associated with the goal id and crashes if does
:: not exist
++  got-goal
  |=  =id:gol
  ^-  goal:gol
  =/  pin  (~(got by directory) id)
  =/  pool  (~(got by pools.store) pin)
  (~(got by goals.pool) id)
::
++  got-edge
  |=  =eid:gol
  ^-  edge:gol
  =/  pin  (~(got by directory) id.eid)
  =/  pool  (~(got by pools.store) pin)
  =/  goal  (~(got by goals.pool) id.eid)
  ?-  -.eid
    %k  kickoff.goal
    %d  deadline.goal
  ==
::
:: replace the goal at given id with given goal
++  put-goal
  |=  [=id:gol =goal:gol]
  ^-  [pin:gol pool:gol]
  =/  pin  (~(got by directory) id)
  =/  pool  (~(got by pools) pin)
  [pin pool(goals (~(put by goals.pool) id goal))]
::
:: put a new goal in a specific pool
++  put-in-pool
  |=  [=pin:gol =id:gol =goal:gol]
  ^-  store:gol
  =/  pool  (~(got by pools) pin)
  =.  goals.pool  (~(put by goals.pool) id goal)
  :_  (~(put by pools) pin pool)
  (~(put by directory) id pin)
::
:: update directory to reflect new goals in a pool
++  update-dir
  |=  [target=pin:gol sources=(set id:gol)]
  ^-  directory:gol
  =/  dir
    %-  ~(gas by *directory:gol)
    %+  murn  ~(tap by directory)
    |=  [a=id:gol b=pin:gol]
    ?:(=(b target) ~ (some [a b]))
  =/  pairs  (turn ~(tap in sources) |=(=id:gol [id target]))
  (~(gas by dir) pairs)
::
::  get depth of a given goal (lowest level is depth of 1)
++  plumb
  |=  =id:gol
  ^-  @ud
  =/  goal  (got-goal id)
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
  |=  =goals:gol
  ^-  (list id:gol)
  %+  turn
    %+  skim  ~(tap by goals)
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
  |=  =goals:gol
  %+  murn  (roots goals)
  |=  =id:gol
  ?:  complete:(~(got by goals) id)
    ~
  (some id)
::
:: get max depth + 1; depth of "virtual" root node
++  anchor  
  |=  =goals:gol
  ^-  @ud
  +((roll (turn (roots goals) plumb) max))
::
:: get priority of a given goal (highest priority is 0)
:: priority is the number of goals prioritized ahead of a given goal
++  priority
  |=  =id:gol
  |^
  ~(wyt in (prios id ~))
  ++  prios
    |=  [=id:gol path=(list id:gol)]
    ^-  (set id:gol)
    =/  new-path=(list id:gol)  [id path]
    =/  i  (find [id]~ path) 
    ?.  =(~ i)  ?~(i !! ~&([%cycle (flop (scag u.i new-path))] !!))
    =/  goal  (got-goal id)
    =/  prio  (prio goal)
    =/  idx  0
    =/  output  prio
    =/  prio  ~(tap in prio)
    |-
    ?:  =(idx (lent prio))
      output
    $(idx +(idx), output (~(uni in output) (prios (snag idx prio) new-path)))
  --
::
:: get lowest priority; priority of "virtual" root node
++  lowpri  ~(wyt by directory)
::
:: get the number representing the deepest path to a leaf node
++  get-lvl
  |=  [=grip:vyu =mode:gol]
  ^-  @
  ?+    mode  !!
      normal-mode:gol
    ?-    -.grip
      %all  ~
      %pool  (anchor goals:(~(got by pools) +.grip))
      %goal  (plumb +.grip)
    ==
  ==
::
:: get either the children or the parents depending on dir
++  get-fam
  |=  [=grip:vyu =mode:gol]
  ^-  (list grip:vyu)
  ?+    mode  !!
      %normal
    ?-    -.grip
      %all  (turn ~(tap in ~(key by pools)) |=(=pin:gol [%pool pin]))
      %pool  (turn (hi-to-lo (uncompleted-roots goals:(~(got by pools) +.grip))) |=(=id:gol [%goal id]))
        %goal
      =/  goal  (got-goal +.grip)
      (turn (hi-to-lo ~(tap in ((uncompleted yung) goal))) |=(=id:gol [%goal id]))
    ==
      %normal-completed
    ?-    -.grip
      %all  (turn ~(tap in ~(key by pools)) |=(=pin:gol [%pool pin]))
      %pool  (turn (hi-to-lo (roots goals:(~(got by pools) +.grip))) |=(=id:gol [%goal id]))
        %goal
      =/  goal  (got-goal +.grip)
      (turn (hi-to-lo ~(tap in (yung goal))) |=(=id:gol [%goal id]))
    ==
  ==
::
++  harvest-gen
  |=  [getter=$-(goal:gol (set id:gol)) check=$-(id:gol ?)]
  |=  =id:gol
  ^-  (set id:gol)
  =/  gots  ~(tap in (getter (got-goal id)))
  =/  out  (~(gas in *(set id:gol)) (skim gots check))
  =/  idx  0
  |-
  ?:  =(idx (lent gots))
    out
  $(idx +(idx), out (~(uni in out) ((harvest-gen getter check) (snag idx gots))))
::
::
++  empt
  |=  getter=$-(goal:gol (set id:gol))
  |=  =id:gol
  =(0 ~(wyt in (getter (got-goal id))))
::
::
++  uncompleted
  |=  getter=$-(goal:gol (set id:gol))
  |=  =goal:gol
  %-  ~(gas in *(set id:gol))
  (skim ~(tap in (getter goal)) |=(=id:gol !complete:(got-goal id)))
::
:: get goals with no actionable subgoals
::
::
:: ++  later-to-sooner
::   |=  lst=(list id:gol)
::   |^  (sort lst cmp)
::   ++  cmp
::     |=  [a=id:gol b=id:gol]
::     (unit-lth deadline:(inherit-deadline b) deadline:(inherit-deadline a))
::   --
:: ::
:: ::
:: ++  sooner-to-later
::   |=  lst=(list id:gol)
::   |^  (sort lst cmp)
::   ++  cmp
::     |=  [a=id:gol b=id:gol]
::     (unit-lth deadline:(inherit-deadline a) deadline:(inherit-deadline b))
::   --
::
::
++  newest-to-oldest
  |=  lst=(list =id:gol)
  (sort lst |=([a=[@p d=@da] b=[@p d=@da]] (gth d.a d.b)))
::
::
++  oldest-to-newest
  |=  lst=(list =id:gol)
  (sort lst |=([a=[@p d=@da] b=[@p d=@da]] (lth d.a d.b)))
::
:: highest to lowest priority (highest being smallest number)
++  hi-to-lo
  |=  lst=(list id:gol)
  |^  (sort lst cmp)
  ++  cmp
    |=  [a=id:gol b=id:gol]
    (lth (priority a) (priority b))
  --
--
