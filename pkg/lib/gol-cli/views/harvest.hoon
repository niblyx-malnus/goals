/-  gol=goal
/+  gol-cli-etch, gol-cli-traverse, gol-cli-json
|_  [=store:gol =bowl:gall]
+*  vyu   views:gol
    etch  ~(. gol-cli-etch store)
++  view-data
  |=  =parm:harvest:vyu
  ^-  data:harvest:vyu
  ?-    -.type.parm
      %main
    =/  tv  ~(. gol-cli-traverse all-goals:etch)
    =/  harvest=(list id:gol)  (ordered-goals-harvest:tv order.local.store)
    =/  goals=(list [id:gol pack:harvest:vyu])
      (turn harvest |=(=id:gol [id (id-to-pack id)]))
    ::
    =?  goals  !=(~ tags.parm)
      %+  murn  goals
      |=  [=id:gol =pack:harvest:vyu]
      ?.  (filter-tags id method.parm tags.parm)  ~
      (some [id pack]) 
    :: order according to order.local.store
    ::
    goals
    ::
      %pool
    =/  pool  (~(got by pools.store) pin.type.parm)
    =/  tv  ~(. gol-cli-traverse goals.pool)
    =/  harvest=(list id:gol)  (ordered-goals-harvest:tv order.local.store)
    =/  goals=(list [id:gol pack:harvest:vyu])
      (turn harvest |=(=id:gol [id (id-to-pack id)]))
    ::
    =?  goals  !=(~ tags.parm)
      %+  murn  goals
      |=  [=id:gol =pack:harvest:vyu]
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
    =/  harvest=(list id:gol)
      (ordered-harvest:tv id.type.parm order.local.store)
    =/  goals=(list [id:gol pack:harvest:vyu])
      (turn harvest |=(=id:gol [id (id-to-pack id)]))
    ::
    =?  goals  !=(~ tags.parm)
      %+  murn  goals
      |=  [=id:gol =pack:harvest:vyu]
      ?.  (filter-tags id method.parm tags.parm)  ~
      (some [id pack]) 
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
  ^-  pack:harvest:vyu
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
    ^-  $-(json parm:harvest:vyu)
    %-  ot
    :~  type+type
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
    ^-  $-(json type:harvest:vyu)
    %-  of
    :~  main+|=(jon=json ?>(?=(~ jon) ~))
        pool+dejs-pin
        goal+dejs-id
    ==
  --
::
++  enjs
  =,  gol-cli-json
  =,  enjs:format
  |%
  ++  view-data
    |=  =data:harvest:vyu
    ^-  json
    a+(turn goals.data id-pack)
  ::
  ++  id-pack
    |=  [=id =pack:harvest:vyu]
    ^-  json
    %-  pairs
    :~  [%id (enjs-id id)]
        [%pin (enjs-pin pin.pack)]
        [%pool-role ?~(pool-role.pack ~ s+u.pool-role.pack)]
        [%goal (enjs-goal +>.pack)]
    ==
  ::
  ++  view-diff
    |=  =diff:harvest:vyu
    %-  pairs
    :~  :-  %hed
        %-  pairs
        :~  [%pin (enjs-pin pin.diff)]
            [%mod (ship mod.diff)]
            [%pid s+`@t`pid.diff]
        ==
        :-  %tel
        %+  frond  %harvest
        ?>  ?=(%replace +<.diff)
        :-  %a
        %+  turn
          `(list [id pack:harvest:views])`+>.diff
        id-pack
    ==
  --
--
