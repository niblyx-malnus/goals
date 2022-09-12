/-  gol=goal
/+  *gol-cli-goal, gol-cli-goals, pl=gol-cli-pool
:: apply (etch) updates received from foreign pools
::
|_  =store:gol
+*  gols   ~(. gol-cli-goals +<)  
::
++  spawn-trash
  |%
  ++  spawn-goal
    |=  [=pin:gol =nex:gol =id:gol =goal:gol]
    ^-  store:gol
    =.  store  (put-in-pool:gols pin id goal)
    =/  pool  (~(got by pools.store) pin)
    =.  goals.pool
      %-  ~(gas by goals.pool)
      %+  turn  ~(tap in nex)
      |=  [=id:gol =goal-nexus:gol]
      ^-  [id:gol goal:gol]
      =/  =ngoal:gol  (~(got by goals.pool) id)
      [id ngoal(nexus goal-nexus)]
    %=  store
      directory  (~(put by directory.store) id pin)
      pools  (~(put by pools.store) pin pool)
    ==
  ::
  ++  spawn-pool
    |=  [=pin:gol =pool:gol]
    ^-  store:gol
    ?:  (~(has by pools.store) pin)  store :: necessary?
    %=  store
      directory
        %-  ~(gas by directory.store)
        (turn ~(tap in ~(key by goals.pool)) |=(=id:gol [id pin]))
      pools  (~(put by pools.store) pin pool)
    ==
  ::
  ++  trash-goal
    |=  [=pin:gol =nex:gol del=(set id:gol)]
    ^-  store:gol
    =/  pool  (~(got by pools.store) pin)
    =.  directory.store
      =/  del  ~(tap in del)
      =/  idx  0
      |-  
      ?:  =(idx (lent del))
        directory.store
      $(idx +(idx), directory.store (~(del by directory.store) (snag idx del)))
    =.  goals.pool
      =/  del  ~(tap in del)
      =/  idx  0
      |-  
      ?:  =(idx (lent del))
        goals.pool
      $(idx +(idx), goals.pool (~(del by goals.pool) (snag idx del)))
    =.  goals.pool
      %-  ~(gas by goals.pool)
      %+  turn  ~(tap in nex)
      |=  [=id:gol =goal-nexus:gol]
      ^-  [id:gol goal:gol]
      =/  =ngoal:gol  (~(got by goals.pool) id)
      [id ngoal(nexus goal-nexus)]
    :-  directory.store
    (~(put by pools.store) pin pool)
  ::
  ++  trash-pool
    |=  =pin:gol
    ^-  store:gol
    :-  %-  ~(gas by *directory:gol)
        %+  murn  ~(tap by directory.store)
        |=  [=id:gol =pin:gol]
        ?:  =(pin ^pin)
          ~
        (some [id pin])
    (~(del by pools.store) pin)
  --
::
++  pool-perms
  |%
  ++  add-pool-viewers
    |=  [=pin:gol viewers=(set ship)]
    ^-  store:gol
    =/  pool  (~(got by pools.store) pin)
    =.  viewers.pool  (~(uni in viewers.pool) viewers)
    store(pools (~(put by pools.store) pin pool))
  ::
  ++  rem-pool-viewers
    |=  [=pin:gol viewers=(set ship)]
    ^-  store:gol
    =/  pool  (~(got by pools.store) pin)
    =.  viewers.pool  (~(dif in viewers.pool) viewers)
    store(pools (~(put by pools.store) pin pool))
  ::
  ++  add-pool-captains
    |=  [=pin:gol captains=(set ship)]
    ^-  store:gol
    =/  pool  (~(got by pools.store) pin)
    =.  viewers.pool  (~(uni in viewers.pool) captains)
    =.  captains.pool  (~(uni in captains.pool) captains)
    store(pools (~(put by pools.store) pin pool))
  ::
  ++  rem-pool-captains
    |=  [=pin:gol captains=(set ship)]
    ^-  store:gol
    =/  pool  (~(got by pools.store) pin)
    =.  captains.pool  (~(dif in captains.pool) captains)
    store(pools (~(put by pools.store) pin pool))
  ::
  ++  add-pool-admins
    |=  [=pin:gol admins=(set ship)]
    ^-  store:gol
    =/  pool  (~(got by pools.store) pin)
    =.  viewers.pool  (~(uni in viewers.pool) admins)
    =.  admins.pool  (~(uni in admins.pool) admins)
    store(pools (~(put by pools.store) pin pool))
  ::
  ++  rem-pool-admins
    |=  [=pin:gol admins=(set ship)]
    ^-  store:gol
    =/  pool  (~(got by pools.store) pin)
    =.  admins.pool  (~(dif in admins.pool) admins)
    store(pools (~(put by pools.store) pin pool))
  --
::
++  pool-hitch
  |%
  ++  title
    |=  [=pin:gol title=@t]
    ^-  store:gol
    =/  pool  (~(got by pools.store) pin)
    store(pools (~(put by pools.store) pin pool(title title)))
  --
::
++  pool-nexus
  |%
  ++  yoke
    |=  [=pin:gol =nex:gol]
    ^-  store:gol
    =/  pool  (~(got by pools.store) pin)
    =.  goals.pool
      %-  ~(gas by goals.pool)
      %+  turn  ~(tap in nex)
      |=  [=id:gol =goal-nexus:gol]
      ^-  [id:gol goal:gol]
      =/  =ngoal:gol  (~(got by goals.pool) id)
      [id ngoal(nexus goal-nexus)]
    store(pools (~(put by pools.store) pin pool))
  --
::
++  goal-perms
  |%
  ++  add-goal-captains
    |=  [=id:gol captains=(set ship)]
    ^-  store:gol
    =/  goal  (got-goal:gols id)
    =+  [pin pool]=(put-goal:gols id goal(captains (~(uni in captains.goal) captains)))
    store(pools (~(put by pools.store) pin pool))
  ::
  ++  rem-goal-captains
    |=  [=id:gol captains=(set ship)]
    ^-  store:gol
    =/  goal  (got-goal:gols id)
    =+  [pin pool]=(put-goal:gols id goal(captains (~(dif in captains.goal) captains)))
    store(pools (~(put by pools.store) pin pool))
  ::
  ++  add-goal-peons
    |=  [=id:gol peons=(set ship)]
    ^-  store:gol
    =/  goal  (got-goal:gols id)
    =+  [pin pool]=(put-goal:gols id goal(peons (~(uni in peons.goal) peons)))
    store(pools (~(put by pools.store) pin pool))
  ::
  ++  rem-goal-peons
    |=  [=id:gol peons=(set ship)]
    ^-  store:gol
    =/  goal  (got-goal:gols id)
    =+  [pin pool]=(put-goal:gols id goal(peons (~(dif in peons.goal) peons)))
    store(pools (~(put by pools.store) pin pool))
  --
::
++  goal-hitch
  |%
  ++  desc
    |=  [=pin:gol =id:gol desc=@t]
    ^-  store:gol
    =/  pool  (~(got by pools.store) pin)
    =/  goal  (~(got by goals.pool) id)
    =+  [pin pool]=(put-goal:gols id goal(desc desc))
    store(pools (~(put by pools.store) pin pool))
  --
::
++  goal-nexus
  |%
  ++  deadline
    |=  [=pin:gol =id:gol moment=(unit @da)]
    ^-  store:gol
    =/  pool  (~(got by pools.store) pin)
    =/  goal  (~(got by goals.pool) id)
    =/  deadline  deadline.goal(moment moment)
    =+  [pin pool]=(put-goal:gols id goal(deadline deadline))
    store(pools (~(put by pools.store) pin pool))
  --
::
++  goal-togls
  |%
  ++  complete
    |=  [=pin:gol =id:gol complete=?(%.y %.n)]
    ^-  store:gol
    =/  pool  (~(got by pools.store) pin)
    =/  goal  (~(got by goals.pool) id)
    =+  [pin pool]=(put-goal:gols id goal(complete complete))
    store(pools (~(put by pools.store) pin pool))
  ::
  ++  actionable
    |=  [=pin:gol =id:gol actionable=?(%.y %.n)]
    ^-  store:gol
    =/  pool  (~(got by pools.store) pin)
    =/  goal  (~(got by goals.pool) id)
    =+  [pin pool]=(put-goal:gols id goal(actionable actionable))
    store(pools (~(put by pools.store) pin pool))
  --
--
