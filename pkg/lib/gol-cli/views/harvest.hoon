/-  gol=goal
/+  gol-cli-etch, gol-cli-traverse
|_  =store:gol
+*  vyu   views:gol
    etch  ~(. gol-cli-etch store)
++  view-data
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
++  view-diff
  |=  $:  =parm:harvest:vyu
          =data:harvest:vyu
          upd=home-update:gol
      ==
  ^-  (unit diff:harvest:vyu)
  =;  diff=(unit diff:harvest:vyu)
    ~|  "non-equivalent-harvest-view-diff"
    =/  check=?
      ?~  diff  =(data (view-data parm))
      =((view-data parm) (etch-diff data u.diff))
    ?>(check diff)
  =/  atad=data:harvest:vyu  (view-data parm)
  ?:  =(data atad)  ~
  (some [[pin mod pid]:upd %replace atad])
::
++  etch-diff
  |=  [=data:harvest:vyu =diff:harvest:vyu]
  ^-  data:harvest:vyu
  ?>(?=(%replace +<.diff) +>.diff)
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
