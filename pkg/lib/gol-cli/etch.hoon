/-  gol=goal, goal-store
/+  pl=gol-cli-pool
:: apply (etch) updates received from foreign pools
::
|_  =store:gol
++  etch
  |=  [=pin:gol upds=(list update:goal-store)]
  ^-  store:gol
  |^
  =/  idx  0
  |-
  ?:  =(idx (lent upds))
    store
  $(idx +(idx), store (etch pin (snag idx upds)))
  ++  etch
    |=  [=pin:gol upd=update:goal-store]
    ?-    -.upd
      %spawn-pool  (spawn-pool:life-cycle pin pool.upd)
      %cache-pool  (cache-pool:life-cycle pin)
      %renew-pool  (renew-pool:life-cycle pin)
      %trash-pool  (trash-pool:life-cycle pin)
        ::
        %spawn-goal
      =/  pool  (~(got by pools.store) pin)
      =/  pore  (apex:pl pool)
      %=  store
        index  (~(put by index.store) id.upd pin)
        pools  (~(put by pools.store) pin pool:abet:(etch:pore upd))
      ==
      ::
        %waste-goal
      =/  pool  (~(got by pools.store) pin)
      =/  pore  (apex:pl pool)
      %=  store
        index  (gus-by-index ~(tap in waz.upd))
        pools  (~(put by pools.store) pin pool:abet:(etch:pore upd))
      ==
      ::
        %trash-goal
      =/  pool  (~(got by pools.store) pin)
      =/  pore  (apex:pl pool)
      %=  store
        index  (gus-by-index ~(tap in ~(key by (~(got by cache.pool) id.upd))))
        pools  (~(put by pools.store) pin pool:abet:(etch:pore upd))
      ==
      ::
        $?  %cache-goal  %renew-goal
            %pool-perms  %pool-hitch  %pool-nexus
            %goal-perms  %goal-hitch  %goal-nexus  %goal-togls
        ==
      =/  pool  (~(got by pools.store) pin)
      =/  pore  (apex:pl pool)
      store(pools (~(put by pools.store) pin pool:abet:(etch:pore upd)))
    ==
  ::
  ++  life-cycle
    |%
    ++  spawn-pool
      |=  [=pin:gol =pool:gol]
      ^-  store:gol
      %=  store
        index
          %-  ~(gas by index.store)
          (turn ~(tap in ~(key by goals.pool)) |=(=id:gol [id pin]))
        pools  (~(put by pools.store) pin pool)
      ==
    ::
    ++  cache-pool
      |=  =pin:gol
      ^-  store:gol
      %=  store
        pools  (~(del by pools.store) pin)
        cache  (~(put by cache.store) pin (~(got by pools.store) pin))
      ==
    ::
    ++  renew-pool
      |=  =pin:gol
      ^-  store:gol
      %=  store
        pools  (~(put by pools.store) pin (~(got by cache.store) pin))
        cache  (~(del by cache.store) pin)
      ==
    ::
    ++  trash-pool
      |=  =pin:gol
      ^-  store:gol
      %=  store
        index
          (gus-by-index ~(tap in ~(key by goals:(~(got by pools.store) pin))))
        pools  (~(del by pools.store) pin)
        cache  (~(del by cache.store) pin)
      ==
    --
  ++  gus-by-index
    |=  ids=(list id:gol)
    =/  idx  0
    |-
    ?:  =(idx (lent ids))
      index.store
    $(idx +(idx), index.store (~(del by index.store) (snag idx ids)))
  --
--
