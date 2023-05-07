/-  gol=goal
/+  gol-cli-etch, gol-cli-node, gol-cli-traverse
|_  =store:gol
+*  vyu   views:gol
    etch  ~(. gol-cli-etch store)
:: Convert an update into a diff for a given view
::
++  view-diff
  |=  $:  =parm:vyu
          =data:vyu
          =update:gol
      ==
  ^-  (unit diff:vyu)
  =;  diff=(unit diff:vyu)
    ~|  "non-equivalent-view-diff"
    =/  check=?
      ?~  diff  =(data (view-data parm))
      =((view-data parm) (etch-diff data u.diff))
    ?>(check diff)
  ~
::
++  etch-diff
  |=  [=data:vyu =diff:vyu]
  ^-  data:vyu
  *data:vyu
::
++  view-data
  |=  =parm:vyu
  ^-  data:vyu
  ?-  -.parm
    %tree       [%tree (tree-view-data +.parm)]
    %harvest    [%harvest (harvest-view-data +.parm)]
    %list-view  [%list-view (list-view-data +.parm)]
  ==
::
++  tree-view-data
  |=  =parm:tree:vyu
  ^-  data:tree:vyu
  ?-    -.type.parm
    %main  pools.store
    ::
      %pool
    %+  ~(put by *pools:gol)
      pin.type.parm
    (~(got by pools.store) pin.type.parm)
    ::
      %goal
    =/  =pin:gol
      (got:idx-orm:gol index.store id.type.parm)
    =/  =pool:gol   (~(got by pools.store) pin)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    =/  descendents=(set id:gol)
      (virtual-progeny:tv id.type.parm)
    =/  =goals:gol
       %-  ~(gas by *goals:gol)
       %+  murn  ~(tap by goals.pool)
       |=  [=id:gol =goal:gol]
       ?.  (~(has in descendents) id)
         ~
       (some [id goal])
    ::
    (~(put by *pools:gol) pin pool(goals goals))
  ==
::
++  harvest-view-data
  |=  =parm:harvest:vyu
  ^-  data:harvest:vyu
  ?-    -.type.parm
      %main
    =/  all-goals  (unify-tags all-goals:etch)
    =/  tv  ~(. gol-cli-traverse all-goals)
    =/  goals=(list [id:gol pin:gol goal:gol])
      %+  turn  (full-goals-harvest:tv order.local.store)
      |=  [=id:gol =goal:gol]
      ^-  [id:gol pin:gol goal:gol]
      [id (got:idx-orm:gol index.store id) goal]
    ::
    =?  goals  !=(~ tags.parm)
      (filter-tags method.parm tags.parm goals)
    :: order according to order.local.store
    ::
    goals
    ::
      %pool
    =/  pool  (~(got by pools.store) pin.type.parm)
    =.  goals.pool  (unify-tags goals.pool)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    =/  goals=(list [id:gol pin:gol goal:gol])
      %+  turn  (full-goals-harvest:tv order.local.store)
      |=  [=id:gol =goal:gol]
      ^-  [id:gol pin:gol goal:gol]
      [id pin.type.parm goal]
    ::
    =?  goals  !=(~ tags.parm)
      (filter-tags method.parm tags.parm goals)
    :: order according to order.local.store
    ::
    goals
    ::
      %goal
    =/  =pin:gol  (got:idx-orm:gol index.store id.type.parm)
    =/  pool  (~(got by pools.store) pin)
    =.  goals.pool  (unify-tags goals.pool)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    =/  goals=(list [id:gol pin:gol goal:gol])
      %+  turn  (full-harvest:tv id.type.parm order.local.store)
      |=  [=id:gol =goal:gol]
      ^-  [id:gol pin:gol goal:gol]
      [id pin goal]
    ::
    =?  goals  !=(~ tags.parm)
      (filter-tags method.parm tags.parm goals)
    :: order according to order.local.store
    ::
    goals
  ==
::
++  list-view-data
  |=  =parm:list-view:vyu
  ^-  data:list-view:vyu
  ?-    -.type.parm
      %main
    =/  all-goals  (unify-tags all-goals:etch)
    =/  tv  ~(. gol-cli-traverse all-goals)
    =/  nd  ~(. gol-cli-node all-goals)
    ::
    =/  goals=(list [id:gol pin:gol goal:gol])
      :: first-gen-only?
      ::
      ?:  first-gen-only.parm
        %+  turn  (waif-goals:nd)
        |=  =id:gol
        [id (got:idx-orm:gol index.store id) (~(got by all-goals) id)]
      %+  turn  ~(tap by all-goals)
      |=  [=id:gol =goal:gol]
      [id (got:idx-orm:gol index.store id) goal]
    :: actionable-only?
    ::
    =?  goals  actionable-only.parm
      %+  murn  goals
      |=  [id:gol pin:gol =goal:gol]
      ?.(actionable.goal ~ (some +<))
    ::
    =?  goals  !=(~ tags.parm)
      (filter-tags method.parm tags.parm goals)
    :: order according to order.local.store
    ::
    goals
    ::
      %pool
    =/  pool  (~(got by pools.store) pin.type.parm)
    =.  goals.pool  (unify-tags goals.pool)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    =/  nd  ~(. gol-cli-node goals.pool)
    ::
    =/  goals=(list [id:gol pin:gol goal:gol])
      :: first-gen-only?
      ::
      ?:  first-gen-only.parm
        %+  turn  (waif-goals:nd)
        |=  =id:gol
        [id pin.type.parm (~(got by goals.pool) id)]
      %+  turn  ~(tap by goals.pool)
      |=  [=id:gol =goal:gol]
      [id pin.type.parm goal]
    :: actionable-only?
    ::
    =?  goals  actionable-only.parm
      %+  murn  goals
      |=  [id:gol pin:gol =goal:gol]
      ?.(actionable.goal ~ (some +<))
    ::
    =?  goals  !=(~ tags.parm)
      (filter-tags method.parm tags.parm goals)
    :: order according to order.local.store
    ::
    goals
    ::
      %goal
    =/  =pin:gol  (got:idx-orm:gol index.store id.type.parm)
    =/  pool  (~(got by pools.store) pin)
    =.  goals.pool  (unify-tags goals.pool)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    =/  nd  ~(. gol-cli-node goals.pool)
    ::
    =/  goals=(list [id:gol pin:gol goal:gol])
      =;  ids=(set id:gol)
        %+  turn  ~(tap in ids)
        |=  =id:gol
        [id pin (~(got by goals.pool) id)]
      :: first-gen-only? ignore-virtual?
      ::
      ?:  =([& &] [first-gen-only ignore-virtual.type]:parm)
        kids:(~(got by goals.pool) id.type.parm)
      ?:  =([& |] [first-gen-only ignore-virtual.type]:parm)
        (young:nd id.type.parm)
      ?:  =([| &] [first-gen-only ignore-virtual.type]:parm)
        (progeny:tv id.type.parm)
      ?>  =([| |] [first-gen-only ignore-virtual.type]:parm)
      (virtual-progeny:tv id.type.parm)
    :: actionable-only?
    ::
    =?  goals  actionable-only.parm
      %+  murn  goals
      |=  [id:gol pin:gol =goal:gol]
      ?.(actionable.goal ~ (some +<))
    ::
    =?  goals  !=(~ tags.parm)
      (filter-tags method.parm tags.parm goals)
    :: order according to order.local.store
    ::
    goals
  ==
::
++  filter-tags
  |=  $:  method=?(%any %all)
          tags=(set tag:gol)
          goals=(list [id:gol pin:gol goal:gol])
      ==
  ^-  (list [id:gol pin:gol goal:gol])
  %+  murn  goals
  |=  [=id:gol =pin:gol =goal:gol]
  ^-  (unit [id:gol pin:gol goal:gol])
  ?-    method
      %any
    =-  ?:(- ~ (some id pin goal))
    =(~ (~(int in tags) tags.goal))
    ::
      %all
    =-  ?.(- ~ (some id pin goal))
    =(tags (~(int in tags) tags.goal))
  ==
::
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
