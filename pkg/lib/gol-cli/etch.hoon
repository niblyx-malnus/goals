/-  gol=goal
/+  pl=gol-cli-pool, tv=gol-cli-traverse, *gol-cli-util,
    fl=gol-cli-inflater
:: apply (etch) updates received from foreign pools
::
|_  =store:gol
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
    =/  p=pool:gol   (pile pin)
    =.  index.store  (put:idx-orm:gol index.store id.upd pin)
    =.  pools.store  (~(put by pools.store) pin (pool-etch p upd))
    store(order.local fix-order)
    ::
      %waste-goal
    =/  p=pool:gol   (pile pin)
    =.  index.store  (gus-idx-orm index.store ~(tap in waz.upd))
    =.  pools.store  (~(put by pools.store) pin (pool-etch p upd))
    store(order.local fix-order)
    ::
      %trash-goal
    =/  p=pool:gol   (pile pin)
    =/  prog         ~(tap in (~(progeny tv cache.p) id.upd))
    =.  index.store  (gus-idx-orm index.store prog)
    =.  pools.store  (~(put by pools.store) pin (pool-etch p upd))
    store(order.local fix-order)
    ::
      $?  %cache-goal  %renew-goal
          %pool-perms  %pool-hitch  %pool-nexus
          %goal-perms  %goal-hitch  %goal-togls  %goal-dates
          %goal-young  %goal-roots
      ==
    =/  p=pool:gol  (pile pin)
    store(pools (~(put by pools.store) pin (pool-etch p upd)))
  ==
++  cools  `pools:gol`(~(uni by pools.store) cache.store)
++  pile   |=(=pin:gol `pool:gol`(~(got by cools) pin))
++  coals
  |=  =pin:gol
  ^-  goals:gol
  =/  =pool:gol  (~(got by cools) pin)
  (~(uni by cache.pool) goals.pool)
::
++  coals-keys  |=(=pin:gol `(list id:gol)`~(tap in ~(key by (coals pin))))
::
++  all-goals  
  ^-  goals:gol
  =/  pools  ~(val by pools.store)
  =|  =goals:gol
  |-  ?~  pools  goals
  %=  $
    pools  t.pools
    goals  (~(uni by goals) goals.i.pools)
  ==
::
++  fix-order
  ^-  (list id:gol)
  =/  d-k-precs  (~(precedents-map tv all-goals) %d %k)
  %-  ~(fix-list tv all-goals)
  [%p d-k-precs order.local.store ~(key by all-goals)]
::
++  life-cycle
  |%
  ++  spawn-pool
    |=  [=pin:gol =pool:gol]
    ^-  store:gol
    =.  pools.store  (~(put by pools.store) pin pool)
    =/  pinds=(list [id:gol pin:gol])
      (turn (coals-keys pin) |=(=id:gol [id pin]))
    =.  index.store  (gas:idx-orm:gol index.store pinds)
    store(order.local fix-order)
  ::
  ++  cache-pool
    |=  =pin:gol
    ^-  store:gol
    =/  =pool:gol  (~(got by pools.store) pin)
    =.  cache.store  (~(put by cache.store) pin pool)
    =.  pools.store  (~(del by pools.store) pin)
    store(order.local fix-order)
  ::
  ++  renew-pool
    |=  =pin:gol
    ^-  store:gol
    =/  =pool:gol  (~(got by cache.store) pin)
    =.  pools.store  (~(put by pools.store) pin pool)
    =.  cache.store  (~(del by cache.store) pin)
    store(order.local fix-order)
  ::
  ++  waste-pool
    |=  =pin:gol
    ^-  store:gol
    =.  index.store  (gus-idx-orm index.store (coals-keys pin))
    =.  pools.store  (~(del by pools.store) pin)
    store(order.local fix-order)
  ::
  ++  trash-pool
    |=  =pin:gol
    ^-  store:gol
    =.  index.store  (gus-idx-orm index.store (coals-keys pin))
    =.  cache.store  (~(del by cache.store) pin)
    store(order.local fix-order)
  --
::
++  pool-etch
  |=  [p=pool:gol upd=update:gol]
  ^-  pool:gol
  |^
  ?+    +.upd  !!
    :: ------------------------------------------------------------------------
    :: spawn/trash
    ::
      [%spawn-goal *]
    (spawn-goal:life-cycle [pex nex id goal]:upd)
    ::
      [%waste-goal *]
    (waste-goal:life-cycle [pex nex id waz]:upd)
    ::
      [%cache-goal *]
    (cache-goal:life-cycle [pex nex id cas]:upd)
    ::
      [%renew-goal *]
    (renew-goal:life-cycle [pex id]:upd)
    ::
      [%trash-goal *]
    (trash-goal:life-cycle [pex id]:upd)
    :: ------------------------------------------------------------------------
    :: pool-perms
    ::
      [%pool-perms *]
    (pool-perms [pex nex new]:upd)
    ::
    :: ------------------------------------------------------------------------
    :: pool-hitch
    ::
      [%pool-hitch %title *]
    (title:pool-hitch title.upd)
    ::
      [%pool-hitch %note *]
    (note:pool-hitch note.upd)
    ::
      [%pool-hitch %add-field-type *]
    (add-field-type:pool-hitch [field field-type]:upd)
    ::
      [%pool-hitch %del-field-type *]
    (del-field-type:pool-hitch field.upd)
    :: ------------------------------------------------------------------------
    :: pool-nexus
    ::
      [%pool-nexus %yoke *]
    =.  p  p(trace pex.upd)
    (apply-nex p nex.upd)
    :: ------------------------------------------------------------------------
    :: goal-dates
    ::
      [%goal-dates *]
    =.  p  p(trace pex.upd)
    (apply-nex p nex.upd)
    :: ------------------------------------------------------------------------
    :: goal-perms
    ::
      [%goal-perms *]
    =.  p  p(trace pex.upd)
    (apply-nex p nex.upd)
    :: ------------------------------------------------------------------------
    :: goal-young
    ::
      [%goal-young *]
    =/  =goal:gol  (~(got by goals.p) id.upd)
    =.  goal  goal(young young.upd)
    p(goals (~(put by goals.p) id.upd goal))
    :: ------------------------------------------------------------------------
    :: goal-roots
    ::
      [%goal-roots *]
    p(trace pex.upd)
    :: ------------------------------------------------------------------------
    :: goal-hitch
    ::
      [%goal-hitch id:gol %desc *]
    (desc:goal-hitch [id desc]:upd)
    ::
      [%goal-hitch id:gol %note *]
    (note:goal-hitch [id note]:upd)
    ::
      [%goal-hitch id:gol %add-tag *]
    (add-tag:goal-hitch [id tag]:upd)
    ::
      [%goal-hitch id:gol %del-tag *]
    (del-tag:goal-hitch [id tag]:upd)
    ::
      [%goal-hitch id:gol %put-tags *]
    (put-tags:goal-hitch [id tags]:upd)
    ::
      [%goal-hitch id:gol %add-field-data *]
    (add-field-data:goal-hitch [id field field-data]:upd)
    ::
      [%goal-hitch id:gol %del-field-data *]
    (del-field-data:goal-hitch [id field]:upd)
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
  ++  apply-nex
    |=  [=pool:gol =nex:gol]
    ^-  pool:gol
    %=  pool
      goals
        %-  ~(gas by goals.pool)
        %+  turn  ~(tap by nex)
        |=  [=id:gol =nux:gol]
        ^-  [id:gol goal:gol]
        =/  =ngoal:gol  (~(got by goals.pool) id)
        [id ngoal(nexus -.nux, trace +.nux)]
    ==
  ::
  ++  life-cycle
    |%
    ++  spawn-goal
      |=  [=pex:gol =nex:gol =id:gol =goal:gol]
      ^-  pool:gol
      =.  goals.p  (~(put by goals.p) id goal)
      =.  p  p(trace pex)
      (apply-nex p nex)
    ::
    ++  waste-goal
      |=  [=pex:gol =nex:gol =id:gol waz=(set id:gol)]
      ^-  pool:gol
      =.  p  p(trace pex)
      =.  p  (apply-nex p nex)
      p(goals (gus-by goals.p ~(tap in waz)))
    ::
    ++  cache-goal
      |=  [=pex:gol =nex:gol =id:gol cas=(set id:gol)]
      ^-  pool:gol
      =.  p  (apply-nex p nex)
      %=  p
        trace  pex
        goals  (gus-by goals.p ~(tap in cas))
        cache
          %-  ~(uni by cache.p)
          `goals:gol`(gat-by goals.p ~(tap in cas))
      ==
    ::
    ++  renew-goal
      |=  [=pex:gol =id:gol]
      ^-  pool:gol
      =/  prog  ~(tap in (~(progeny tv cache.p) id))
      %=  p
        trace  pex
        cache  (gus-by cache.p prog)
        goals  (~(uni by goals.p) `goals:gol`(gat-by cache.p prog))
      ==
    ::
    ++  trash-goal
      |=  [=pex:gol =id:gol]
      ^-  pool:gol
      =/  prog  ~(tap in (~(progeny tv cache.p) id))
      p(trace pex, cache (gus-by cache.p prog))
    --
  ::
  ++  pool-perms
    |=  [=pex:gol =nex:gol perms=pool-perms:gol]
    ^-  pool:gol
    =.  p  (apply-nex p nex)
    %=  p
      trace  pex
      perms  perms
    ==
  ::
  ++  pool-hitch
    |%
    ++  note   |=(note=@t `pool:gol`p(note note))
    ++  title  |=(title=@t `pool:gol`p(title title))
    ++  add-field-type
      |=  [field=@t =field-type:gol]
      ^-  pool:gol
      p(fields (~(put by fields.p) field field-type))
    ++  del-field-type
      |=  field=@t
      ^-  pool:gol
      ::
      =.  goals.p
        %-  ~(gas by *goals:gol)
        %+  turn  ~(tap by goals.p)
        |=  [=id:gol =goal:gol]
        ^-  [id:gol goal:gol]
        [id goal(fields (~(del by fields.goal) field))]
      ::
      p(fields (~(del by fields.p) field))
    --
  ::
  ++  goal-hitch
    |%
    ++  note
      |=  [=id:gol note=@t]
      ^-  pool:gol
      =/  goal  (~(got by goals.p) id)
      p(goals (~(put by goals.p) id goal(note note)))
    ++  desc
      |=  [=id:gol desc=@t]
      ^-  pool:gol
      =/  goal  (~(got by goals.p) id)
      p(goals (~(put by goals.p) id goal(desc desc)))
    ++  add-tag
      |=  [=id:gol =tag:gol]
      ^-  pool:gol
      =/  goal  (~(got by goals.p) id)
      %=    p
          goals
        (~(put by goals.p) id goal(tags (~(put in tags.goal) tag)))
      ==
    ++  del-tag
      |=  [=id:gol =tag:gol]
      ^-  pool:gol
      =/  goal  (~(got by goals.p) id)
      %=    p
          goals
        (~(put by goals.p) id goal(tags (~(del in tags.goal) tag)))
      ==
    ++  put-tags
      |=  [=id:gol tags=(set tag:gol)]
      ^-  pool:gol
      =.  tags
        %-  ~(gas in *(set tag:gol))
        %+  murn  ~(tap in tags)
        |=  =tag:gol
        ?:(private.tag ~ (some tag))
      =/  goal  (~(got by goals.p) id)
      %=    p
          goals
        (~(put by goals.p) id goal(tags tags))
      ==
    ++  add-field-data  
      |=  [=id:gol field=@t =field-data:gol]
      ^-  pool:gol
      =/  goal  (~(got by goals.p) id)
      %=    p
          goals
        %+  ~(put by goals.p)  id
        goal(fields (~(put by fields.goal) field field-data))
      ==
    ++  del-field-data
      |=  [=id:gol field=@t]
      ^-  pool:gol
      =/  goal  (~(got by goals.p) id)
      %=    p
          goals
        %+  ~(put by goals.p)  id
        goal(fields (~(del by fields.goal) field))
      ==
    --
  ::
  ++  goal-togls
    |%
    ++  complete
      |=  [=id:gol complete=?(%.y %.n)]
      ^-  pool:gol
      =/  goal  (~(got by goals.p) id)
      =.  goals.p  (~(put by goals.p) id goal(complete complete))
      (inflate-pool:fl p)  :: keeping track of complete/total
    ::
    ++  actionable
      |=  [=id:gol actionable=?(%.y %.n)]
      ^-  pool:gol
      =/  goal  (~(got by goals.p) id)
      p(goals (~(put by goals.p) id goal(actionable actionable)))
    --
  --
::
++  gus-idx-orm
  |=  [=index:gol ids=(list id:gol)]
  ^-  index:gol
  |-  ?~  ids  index
  $(ids t.ids, index +:(del:idx-orm:gol index i.ids))
--
