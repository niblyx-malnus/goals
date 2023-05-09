/-  gol=goal
/+  gol-cli-etch, gol-cli-node, gol-cli-traverse, gol-cli-json
|_  [=store:gol =bowl:gall]
+*  vyu   views:gol
    etch  ~(. gol-cli-etch store)
++  view-data
  |=  =parm:list-view:vyu
  ^-  data:list-view:vyu
  ?-    -.type.parm
      %main
    =/  tv  ~(. gol-cli-traverse all-goals:etch)
    =/  nd  ~(. gol-cli-node all-goals:etch)
    ::
    =/  goals=(list [id:gol pack:list-view:vyu])
      :: first-gen-only?
      ::
      ?:  first-gen-only.parm
        (turn (waif-goals:nd) |=(=id:gol [id (id-to-pack id)]))
      %+  turn  ~(tap in ~(key by all-goals:etch))
      |=(=id:gol [id (id-to-pack id)])
    :: actionable-only?
    ::
    =?  goals  actionable-only.parm
      %+  murn  goals
      |=  [id:gol pack:list-view:vyu]
      ?.(actionable ~ (some +<))
    ::
    =?  goals  !=(~ tags.parm)
      %+  murn  goals
      |=  [=id:gol =pack:list-view:vyu]
      ?.  (filter-tags id method.parm tags.parm)  ~
      (some [id pack]) 
    :: order according to order.local.store
    ::
    goals
    ::
      %pool
    =/  pool  (~(got by pools.store) pin.type.parm)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    =/  nd  ~(. gol-cli-node goals.pool)
    ::
    =/  goals=(list [id:gol pack:list-view:vyu])
      :: first-gen-only?
      ::
      ?:  first-gen-only.parm
        (turn (waif-goals:nd) |=(=id:gol [id (id-to-pack id)]))
      %+  turn  ~(tap in ~(key by goals.pool))
      |=(=id:gol [id (id-to-pack id)])
    :: actionable-only?
    ::
    =?  goals  actionable-only.parm
      %+  murn  goals
      |=  [id:gol pack:list-view:vyu]
      ?.(actionable ~ (some +<))
    ::
    =?  goals  !=(~ tags.parm)
      %+  murn  goals
      |=  [=id:gol =pack:list-view:vyu]
      ?.  (filter-tags id method.parm tags.parm)  ~
      (some [id pack]) 
    :: order according to order.local.store
    ::
    goals
    ::
      %goal
    =/  =pin:gol  (got:idx-orm:gol index.store id.type.parm)
    =/  pool  (~(got by pools.store) pin)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    =/  nd  ~(. gol-cli-node goals.pool)
    ::
    =/  goals=(list [id:gol pack:list-view:vyu])
      =;  ids=(set id:gol)
        (turn ~(tap in ids) |=(=id:gol [id (id-to-pack id)]))
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
      |=  [id:gol pack:list-view:vyu]
      ?.(actionable ~ (some +<))
    ::
    =?  goals  !=(~ tags.parm)
      %+  murn  goals
      |=  [=id:gol =pack:list-view:vyu]
      ?.  (filter-tags id method.parm tags.parm)  ~
      (some [id pack]) 
    :: order according to order.local.store
    ::
    goals
  ==
::
++  view-diff
  |=  $:  =parm:list-view:vyu
          =data:list-view:vyu
          upd=home-update:gol
      ==
  ^-  (unit diff:list-view:vyu)
  =;  diff=(unit diff:list-view:vyu)
    ~|  "non-equivalent-list-view-diff"
    =/  check=?
      ?~  diff  =(data (view-data parm))
      =((view-data parm) (etch-diff data u.diff))
    ?>(check diff)
  =/  atad=data:list-view:vyu  (view-data parm)
  ?:  =(data atad)  ~
  (some [[pin mod pid]:upd %replace atad])
::
++  etch-diff
  |=  [=data:list-view:vyu =diff:list-view:vyu]
  ^-  data:list-view:vyu
  ?>(?=(%replace +<.diff) +>.diff)
::
++  unify-tags
  |=  =id:gol
  ^-  goal:gol
  =/  =pin:gol  (got:idx-orm:gol index.store id)
  =/  =pool:gol  (~(got by pools.store) pin)
  =/  =goal:gol  (~(got by goals.pool) id)
  %=    goal
      tags
    %-  ~(uni in tags:(~(got by goals.pool) id))
    =+  get=(~(get by goals.local.store) id)
    ?~(get ~ tags.u.get)
  ==
::
++  id-to-pack
  |=  =id:gol
  ^-  pack:list-view:vyu
  =/  =pin:gol  (got:idx-orm:gol index.store id)
  =/  =pool:gol  (~(got by pools.store) pin)
  =/  pool-role=(unit ?(%owner pool-role:gol))
    ?:  =(our.bowl owner.pin)  (some %owner)
    (~(got by perms.pool) our.bowl)
  [pin pool-role (unify-tags id)]
::
++  filter-tags
  |=  $:  =id:gol
          method=?(%any %all)
          tags=(set tag:gol)
      ==
  ^-  ?
  =/  =pin:gol   (got:idx-orm:gol index.store id)
  =/  =pool:gol  (~(got by pools.store) pin)
  =/  =goal:gol  (~(got by goals.pool) id)
  ?-  method
    %any  !=(~ (~(int in tags) tags.goal))
    %all  =(tags (~(int in tags) tags.goal))
  ==
::
++  dejs
  =,  gol-cli-json
  =,  dejs:format
  |%
  ++  view-parm
    ^-  $-(json parm:list-view:vyu)
    %-  ot
    :~  type+type
        first-gen-only+bo
        actionable-only+bo
        method+method
        tags+(as dejs-tag)
    ==
  ::
  ++  method
    ^-  $-(json ?(%any %all))
    =/  cuk  |=(=@t ;;(?(%any %all) t))
    =/  par  ;~(pose (jest 'any') (jest 'all'))
    (su (cook cuk par))
  ::
  ++  type
    ^-  $-(json type:list-view:vyu)
    %-  of
    :~  main+|=(jon=json ?>(?=(~ jon) ~))
        pool+dejs-pin
        goal+(ot ~[id+dejs-id ignore-virtual+bo])
    ==
  --
::
++  enjs
  =,  gol-cli-json
  =,  enjs:format
  |%
  ++  view-data
    |=  =data:list-view:vyu
    ^-  json
    a+(turn goals.data id-pack)
  ::
  ++  id-pack
    |=  [=id =pack:list-view:vyu]
    ^-  json
    %-  pairs
    :~  [%id (enjs-id id)]
        [%pin (enjs-pin pin.pack)]
        [%pool-role ?~(pool-role.pack ~ s+u.pool-role.pack)]
        [%goal (enjs-goal +>.pack)]
    ==
  ::
  ++  view-diff
    |=  =diff:list-view:vyu
    ^-  json
    %-  pairs
    :~  :-  %hed
        %-  pairs
        :~  [%pin (enjs-pin pin.diff)]
            [%mod (ship mod.diff)]
            [%pid s+`@t`pid.diff]
        ==
        :-  %tel
        %+  frond  %list-view
        ?>  ?=(%replace +<.diff)
        :-  %a
        %+  turn
          `(list [id pack:list-view:views])`+>.diff
        id-pack
    ==
  --
--
