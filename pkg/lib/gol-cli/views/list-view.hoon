/-  gol=goal, vyu=views
/+  gol-cli-etch, gol-cli-node, gol-cli-traverse, j=gol-cli-json
|_  [=store:gol =bowl:gall]
+*  etch  ~(. gol-cli-etch store)
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
          [[=pin:gol mod=ship pid=@] upd=update:gol]
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
  (some [[pin mod pid] %replace atad])
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
  =,  dejs:format
  |%
  ++  view-parm
    ^-  $-(json parm:list-view:vyu)
    %-  ot
    :~  type+type
        first-gen-only+bo
        actionable-only+bo
        method+method
        tags+(as tag:dejs:j)
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
        pool+pin:dejs:j
        goal+(ot ~[id+id:dejs:j ignore-virtual+bo])
    ==
  --
::
++  enjs
  =,  enjs:format
  |%
  ++  view-data
    |=  =data:list-view:vyu
    ^-  json
    a+(turn goals.data id-pack)
  ::
  ++  id-pack
    |=  [=id:gol =pack:list-view:vyu]
    ^-  json
    %-  pairs
    :~  [%id (enjs-id:j id)]
        [%pin (enjs-pin:j pin.pack)]
        [%pool-role ?~(pool-role.pack ~ s+u.pool-role.pack)]
        [%goal (enjs-goal:j +>.pack)]
    ==
  ::
  ++  view-diff
    |=  =diff:list-view:vyu
    ^-  json
    %-  pairs
    :~  :-  %hed
        %-  pairs
        :~  [%pin (enjs-pin:j pin.diff)]
            [%mod (ship mod.diff)]
            [%pid s+`@t`pid.diff]
        ==
        :-  %tel
        %+  frond  %list-view
        ?>  ?=(%replace +<.diff)
        :-  %a
        %+  turn
          `(list [id:gol pack:list-view:vyu])`+>.diff
        id-pack
    ==
  ::
  ++  view-parm
    |=  =parm:list-view:vyu
    ^-  json
    %-  pairs
    :~  [%type (type type.parm)]
        [%first-gen-only b+first-gen-only.parm]
        [%actionable-only b+actionable-only.parm]
        [%method s+method.parm]
        [%tags a+(turn ~(tap in tags.parm) enjs-tag:j)]
    ==
  ++  type
    |=  =type:list-view:vyu
    ^-  json
    ?-    -.type
      %main  (frond %main ~)
      %pool  (frond %pool (enjs-pin:j pin.type))
      ::
        %goal
      %+  frond  %goal
      %-  pairs
      :~  [%id (enjs-id:j id.type)]
          [%ignore-virtual b+ignore-virtual.type]
      ==
    ==
  --
--
