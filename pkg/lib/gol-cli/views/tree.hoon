/-  gol=goal
/+  gol-cli-traverse
|_  =store:gol
+*  vyu   views:gol
:: TODO: Sever this data structure from the core backend data
:: structure
++  view-data
  |=  =parm:tree:vyu
  ^-  data:tree:vyu
  ?-    -.type.parm
    %main  [(unify-pools-tags pools) (unify-pools-tags cache)]:[store .]
    ::
      %pool
    :_  ~
    %-  unify-pools-tags
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
    :_(~ (unify-pools-tags (~(put by *pools:gol) pin pool(goals goals))))
  ==
++  view-diff
  |=  $:  =parm:tree:vyu
          =data:tree:vyu
          upd=home-update:gol
      ==
  ^-  (unit diff:tree:vyu)
  =;  diff=(unit diff:tree:vyu)
    :: temporarily remove this check
    ::
    :: ~|  "non-equivalent-tree-view-diff"
    :: =/  check=?
    ::   ?~  diff  =(data (view-data parm))
    ::   =((view-data parm) (etch-diff data u.diff))
    :: ?>(check diff)
    diff
  (some upd)
::
++  etch-diff
  |=  [=data:tree:vyu =diff:tree:vyu]
  ^-  data:tree:vyu
  *data:tree:vyu
::
++  unify-pools-tags
  |=  =pools:gol
  ^-  pools:gol
  %-  ~(gas by *pools:gol)
  %+  turn  ~(tap by pools)
  |=  [=pin:gol =pool:gol]
  [pin pool(goals (unify-tags goals.pool))]
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
