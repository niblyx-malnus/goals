/-  gol=goal
/+  pl=gol-cli-pool, tv=gol-cli-traverse, *gol-cli-util
:: apply (etch) updates received from foreign pools
::
|_  =store:gol
++  etch
  |=  [=pin:gol upds=(list update:gol)]
  ^-  store:gol
  |^
  |-  ?~  upds  store
  $(upds t.upds, store (etch pin i.upds))
  ++  cools  (~(uni by pools.store) cache.store)
  ++  pile  |=(=pin:gol (~(got by cools) pin))
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
      =/  p=pool:gol  (pile pin)
      %=  store
        index  (put:idx-orm:gol index.store id.upd pin)
        pools  (~(put by pools.store) pin (pool-etch p upd))
      ==
      ::
        %waste-goal
      =/  p=pool:gol  (pile pin)
      %=  store
        index  (gus-idx-orm ~(tap in waz.upd))
        pools  (~(put by pools.store) pin (pool-etch p upd))
      ==
      ::
        %trash-goal
      =/  p=pool:gol  (pile pin)
      =/  prog  ~(tap in (~(progeny tv cache.p) id.upd))
      %=  store
        index  (gus-idx-orm prog)
        pools  (~(put by pools.store) pin (pool-etch p upd))
      ==
      ::
        $?  %cache-goal  %renew-goal
            %pool-perms  %pool-hitch  %pool-nexus
            %goal-perms  %goal-hitch  %goal-togls  %goal-dates
            %goal-young  %goal-roots
        ==
      =/  p=pool:gol  (pile pin)
      store(pools (~(put by pools.store) pin (pool-etch p upd)))
    ==
  ::
  ++  life-cycle
    |%
    ++  spawn-pool
      |=  [=pin:gol =pool:gol]
      ^-  store:gol
      =.  pools.store  (~(put by pools.store) pin pool)
      %=  store
        index
          %+  gas:idx-orm:gol
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
        pools  (~(del by pools.store) pin)
      ==
    ::
    ++  trash-pool
      |=  =pin:gol
      ^-  store:gol
      %=  store
        index  (gus-idx-orm (coals pin))
        cache  (~(del by cache.store) pin)
      ==
    --
  ::
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
    (renew-goal:life-cycle id.upd)
    ::
      [%trash-goal *]
    (trash-goal:life-cycle id.upd)
    :: ------------------------------------------------------------------------
    :: pool-perms
    ::
      [%pool-perms *]
    (pool-perms new.upd)
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
    (apply-nex p nex.upd)
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
      =.  p  p(trace pex)
      =.  p  (apply-nex p nex)
      %=  p
        goals  (gus-by goals.p ~(tap in cas))
        cache
          %-  ~(uni by cache.p)
          `goals:gol`(gat-by goals.p ~(tap in cas))
      ==
    ::
    ++  renew-goal
      |=  =id:gol
      ^-  pool:gol
      =/  prog  ~(tap in (~(progeny tv cache.p) id))
      %=  p
        cache  (gus-by cache.p prog)
        goals  (~(uni by goals.p) `goals:gol`(gat-by cache.p prog))
      ==
    ::
    ++  trash-goal
      |=  =id:gol
      ^-  pool:gol
      =/  prog  ~(tap in (~(progeny tv cache.p) id))
      p(cache (gus-by cache.p prog))
    --
  ::
  ++  pool-perms  |=(perms=pool-perms:gol `pool:gol`p(perms perms))
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
      p(goals (~(put by goals.p) id goal(complete complete)))
    ::
    ++  actionable
      |=  [=id:gol actionable=?(%.y %.n)]
      ^-  pool:gol
      =/  goal  (~(got by goals.p) id)
      p(goals (~(put by goals.p) id goal(actionable actionable)))
    --
  --
--
