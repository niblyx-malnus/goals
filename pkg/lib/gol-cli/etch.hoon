/-  gol=goal
/+  pl=gol-cli-pool, em=gol-cli-emot, gol-cli-traverse, *gol-cli-util
:: apply (etch) updates received from foreign pools
::
|_  =store:gol
++  etch
  |=  [=pin:gol upds=(list update:gol)]
  ^-  store:gol
  |^
  =/  idx  0
  |-
  ?:  =(idx (lent upds))
    store
  $(idx +(idx), store (etch pin (snag idx upds)))
  ++  etch
    |=  [=pin:gol upd=update:gol]
    ^-  store:gol
    ?-    +<.upd
      %poke-error  store  :: no-op on poke-error update
      %spawn-pool  (spawn-pool:life-cycle pin pool.upd)
      %cache-pool  (cache-pool:life-cycle pin)
      %renew-pool  (renew-pool:life-cycle pin)
      %waste-pool  (waste-pool:life-cycle pin)
      %trash-pool  (trash-pool:life-cycle pin)
        ::
        %spawn-goal
      =/  pool  (~(got by pools.store) pin)
      =/  pore  (apex:em pool)
      %=  store
        index  (put:idx-orm:gol index.store id.upd pin)
        order  ?~  par=par.goal.upd
                 [id.upd order.store]
               (sloq order.store u.par id.upd)
        pools  (~(put by pools.store) pin pool:abet:(etch:pore upd))
      ==
      :: ::
        %waste-goal
      =/  pool  (~(got by pools.store) pin)
      =/  pore  (apex:em pool)
      %=  store
        index  (gus-idx-orm ~(tap in waz.upd))
        order  (purge-order-ids order.store waz.upd)
        pools  (~(put by pools.store) pin pool:abet:(etch:pore upd))
      ==
      ::
        %trash-goal
      =/  pool  (~(got by pools.store) pin)
      =/  pore  (apex:em pool)
      =/  prog  (~(progeny gol-cli-traverse cache.pool) id.upd)
      %=  store
        index  (gus-idx-orm ~(tap in prog))
        order  (purge-order-ids order.store prog)
        pools  (~(put by pools.store) pin pool:abet:(etch:pore upd))
      ==
      ::
        $?  %cache-goal  %renew-goal
            %pool-perms  %pool-hitch  %pool-nexus
            %goal-perms  %goal-hitch  %goal-togls  %goal-dates
            %updt-young
        ==
      =/  pool  (~(got by pools.store) pin)
      =/  pore  (apex:em pool)
      store(pools (~(put by pools.store) pin pool:abet:(etch:pore upd)))
    ==
  ::
  ++  life-cycle
    |%
    ++  spawn-pool
      |=  [=pin:gol =pool:gol]
      ^-  store:gol
      =.  pools.store  (~(put by pools.store) pin pool)
      %=  store
        order  (weld ~(tap in ~(key by goals.pool)) order.store)
        index  %+  gas:idx-orm:gol
                 index.store
               %+  turn  
                 (coals pin)
               |=(=id:gol [id pin])
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
    ++  waste-pool
      |=  =pin:gol
      ^-  store:gol
      %=  store
        index  (gus-idx-orm (coals pin))
        order  %+  purge-order-ids
                 order.store
               ~(key by goals:(~(got by pools.store) pin))
        pools  (~(del by pools.store) pin)
      ==
    ::
    ++  trash-pool
      |=  =pin:gol
      ^-  store:gol
      %=  store
        index  (gus-idx-orm (coals pin))
        order  %+  purge-order-ids
                 order.store
               ~(key by goals:(~(got by pools.store) pin))
        cache  (~(del by cache.store) pin)
      ==
    --
  ++  coals
    |=  =pin:gol
    ^-  (list id:gol)
    =/  pool  (~(got by pools.store) pin)
    =/  cache-keys  ~(key by cache.pool)
    =/  goals-keys  ~(key by goals.pool)
    ~(tap in (~(uni in cache-keys) goals-keys))
  ::
  ++  gus-idx-orm
    |=  ids=(list id:gol)
    =/  idx  0
    |-
    ?:  =(idx (lent ids))
      index.store
    $(idx +(idx), index.store +:(del:idx-orm:gol index.store (snag idx ids)))
  ::
  :: purge elements
  ++  purge-order-ids
    |=  [order=(list id:gol) purge=(set id:gol)]
    ^-  (list id:gol)
    =|  purged=(list id:gol)
    |-
    ?~  order
      (flop purged)
    %=  $
      order  t.order
      purged  ?:((~(has in purge) i.order) purged [i.order purged])
    ==
  --
--
