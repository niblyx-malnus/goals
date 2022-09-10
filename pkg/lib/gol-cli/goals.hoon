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
  =.  owner.pool  owner.pin
  =.  birth.pool  birth.pin
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
--
