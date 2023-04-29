/-  gol=goal
/+  jon=gol-cli-json, gol-cli-traverse, gol-cli-node, gol-cli-etch
|=  [[now=@da eny=@uvJ bec=beak] ~ ~]
|=  [authenticated=? =request:http]
^-  simple-payload:http
=/  =ask:gol
  ~|  "unexpected ask to {(trip url.request)}"
  ?>  ?=(^ body.request)
  (dejs-ask:jon (fall (de-json:html q.u.body.request) ~))
=;  =say:gol
  :-  [200 ['Content-Type' 'application/json']~]
  [~ (as-octs:mimes:html (crip (en-json:html (enjs-say:jon say))))]
:: import main state
::
=/  =store:gol  +:.^([%store store:gol] %gx (en-beam bec(q %goal-store) /store/goal-peek))
=*  etch  ~(. gol-cli-etch store)
::
?-    -.ask
    %harvest
  ?-    -.type.ask
      %main
    =/  tv  ~(. gol-cli-traverse all-goals:etch)
    =/  goals=(list [id:gol goal:gol])
      (full-goals-harvest:tv order.local.store)
    goals-list+(full-goals-harvest:tv order.local.store)
    ::
      %pool
    =/  pool  (~(got by pools.store) pin.type.ask)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    goals-list+(full-goals-harvest:tv order.local.store)
    ::
      %goal
    =/  =pin:gol  (got:idx-orm:gol index.store id.type.ask)
    =/  pool  (~(got by pools.store) pin)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    goals-list+(full-harvest:tv id.type.ask order.local.store)
  ==
  ::
    %list-view
  |^
  ?-    -.type.ask
      %main
    =/  all-goals  (unify-tags all-goals:etch)
    =/  tv  ~(. gol-cli-traverse all-goals)
    =/  nd  ~(. gol-cli-node all-goals)
    ::
    =/  goals=(list [id:gol goal:gol])
      :: first-gen-only?
      ::
      ?:  first-gen-only.ask
        %+  turn  (waif-goals:nd)
        |=  =id:gol
        [id (~(got by all-goals) id)]
      ~(tap by all-goals)
    :: actionable-only?
    ::
    =?  goals  actionable-only.ask
      %+  murn  goals
      |=  [=id:gol =goal:gol]
      ?.(actionable.goal ~ (some +<))
    :: filter tags
    ::
    =.  goals
      %+  murn  goals
      |=  [=id:gol =goal:gol]
      ?-    method.ask
          %any
        ?:  =(~ (~(int in tags.ask) tags.goal))
          ~
        (some [id goal])
        ::
          %all
        ?.  =(tags.ask (~(int in tags.ask) tags.goal))
          ~
        (some [id goal])
      ==
    :: order according to order.local.store
    ::
    [%goals-list goals]
    ::
      %pool
    =/  pool  (~(got by pools.store) pin.type.ask)
    =.  goals.pool  (unify-tags goals.pool)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    =/  nd  ~(. gol-cli-node goals.pool)
    ::
    =/  goals=(list [id:gol goal:gol])
      :: first-gen-only?
      ::
      ?:  first-gen-only.ask
        %+  turn  (waif-goals:nd)
        |=  =id:gol
        [id (~(got by goals.pool) id)]
      ~(tap by goals.pool)
    :: actionable-only?
    ::
    =?  goals  actionable-only.ask
      %+  murn  goals
      |=  [=id:gol =goal:gol]
      ?.(actionable.goal ~ (some +<))
    :: filter tags
    ::
    =.  goals
      %+  murn  goals
      |=  [=id:gol =goal:gol]
      ?-    method.ask
          %any
        ?:  =(~ (~(int in tags.ask) tags.goal))
          ~
        (some [id goal])
        ::
          %all
        ?.  =(tags.ask (~(int in tags.ask) tags.goal))
          ~
        (some [id goal])
      ==
    :: order according to order.local.store
    ::
    [%goals-list goals]
    ::
      %goal
    =/  =pin:gol  (got:idx-orm:gol index.store id.type.ask)
    =/  pool  (~(got by pools.store) pin)
    =.  goals.pool  (unify-tags goals.pool)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    =/  nd  ~(. gol-cli-node goals.pool)
    ::
    =/  goals=(list [id:gol goal:gol])
      =;  ids=(set id:gol)
        %+  turn  ~(tap in ids)
        |=  =id:gol
        [id (~(got by goals.pool) id)]
      :: first-gen-only? ignore-virtual?
      ::
      ?:  =([& &] [first-gen-only ignore-virtual.type]:ask)
        kids:(~(got by goals.pool) id.type.ask)
      ?:  =([& |] [first-gen-only ignore-virtual.type]:ask)
        (young:nd id.type.ask)
      ?:  =([| &] [first-gen-only ignore-virtual.type]:ask)
        (progeny:tv id.type.ask)
      ?>  =([| |] [first-gen-only ignore-virtual.type]:ask)
      (virtual-progeny:tv id.type.ask)
    :: actionable-only?
    ::
    =?  goals  actionable-only.ask
      %+  murn  goals
      |=  [=id:gol =goal:gol]
      ?.(actionable.goal ~ (some +<))
    :: filter tags
    ::
    =.  goals
      %+  murn  goals
      |=  [=id:gol =goal:gol]
      ?-    method.ask
          %any
        ?:  =(~ (~(int in tags.ask) tags.goal))
          ~
        (some [id goal])
        ::
          %all
        ?.  =(tags.ask (~(int in tags.ask) tags.goal))
          ~
        (some [id goal])
      ==
    :: order according to order.local.store
    ::
    [%goals-list goals]
  ==
  ++  unify-tags
    |=  =goals:gol
    ^-  goals:gol
    %-  ~(gas by *goals:gol)
    %+  turn  ~(tap by goals)
    |=  [=id:gol =goal:gol]
    ^-  [id:gol goal:gol]
    :-  id
    %=    goal
        tags
     %-  ~(uni in tags.goal)
     ?~  get=(~(get by goals.local.store) id)
       ~
     tags.u.get
    ==
  --
==
