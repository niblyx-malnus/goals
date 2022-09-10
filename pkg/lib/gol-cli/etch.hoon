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
    %=  store
      directory
        %-  ~(gas by directory.store)
        (turn ~(tap in ~(key by goals.pool)) |=(=id:gol [id pin]))
      pools  (~(put by pools.store) pin pool)
    ==
  ::
  ++  trash-goal
    |=  [=pin:gol =id:gol]
    ^-  store:gol
    =/  pool  (~(got by pools.store) pin)
    :-  (~(del by directory.store) id)
    (~(put by pools.store) pin pool(goals (purge-goals:gols goals.pool id)))
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
  ++  viewer
    |=  [=pin:gol invitee=ship]
    ^-  store:gol
    =/  pool  (~(got by pools.store) pin)
    =/  viewers  (~(put in viewers.pool) invitee)
    store(pools (~(put by pools.store) pin pool(viewers viewers)))
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
  ++  chef
    |=  [=id:gol chef=ship]
    ^-  store:gol
    =/  goal  (got-goal:gols id)
    =+  [pin pool]=(put-goal:gols id goal(chefs (~(put in chefs.goal) chef)))
    store(pools (~(put by pools.store) pin pool))
  ::
  ++  peon
    |=  [=id:gol peon=ship]
    ^-  store:gol
    =/  goal  (got-goal:gols id)
    =+  [pin pool]=(put-goal:gols id goal(peons (~(put in peons.goal) peon)))
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
