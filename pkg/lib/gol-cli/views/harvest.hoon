/-  gol=goal, vyu=views
/+  gol-cli-etch, gol-cli-traverse, j=gol-cli-json
|_  [=store:gol =bowl:gall]
+*  etch  ~(. gol-cli-etch store)
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
          [[=pin:gol mod=ship pid=@] upd=update:gol]
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
  (some [[pin mod pid] %replace atad])
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
  =/  =goal:gol  (unify-tags id)
  :*  pin
      pool-role
      par.goal
      kids.goal
      kickoff.goal
      deadline.goal
      complete.goal
      actionable.goal
      chief.goal
      spawn.goal
      owner.goal
      birth.goal
      author.goal
      desc.goal
      note.goal
      tags.goal
      fields.goal
      stock.goal
      ranks.goal
      young.goal
      young-by-precedence.goal
      young-by-kickoff.goal
      young-by-deadline.goal
      progress.goal
      prio-left.goal
      prio-ryte.goal
      prec-left.goal
      prec-ryte.goal
      nest-left.goal
      nest-ryte.goal
  ==
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
    ^-  $-(json parm:harvest:vyu)
    %-  ot
    :~  type+type
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
    ^-  $-(json type:harvest:vyu)
    %-  of
    :~  main+|=(jon=json ?>(?=(~ jon) ~))
        pool+pin:dejs:j
        goal+id:dejs:j
    ==
  --
::
++  enjs
  =,  enjs:format
  |%
  ++  view-data
    |=  =data:harvest:vyu
    ^-  json
    a+(turn goals.data id-pack)
  ::
  ++  id-pack
    |=  [=id:gol =pack:harvest:vyu]
    ^-  json
    %-  pairs
    :~  [%id (enjs-id:j id)]
        [%pin (enjs-pin:j pin.pack)]
        [%pool-role ?~(pool-role.pack ~ s+u.pool-role.pack)]
        [%goal (enjs-goal:j (convert-to-goal pack))]
    ==
  ::
  ++  convert-to-goal
    |=  pack:harvest:vyu
    ^-  goal:gol
    =|  =goal:gol
    %=  goal
      par                  par
      kids                 kids
      kickoff              kickoff
      deadline             deadline
      complete             complete
      actionable           actionable
      chief                chief
      spawn                spawn
      owner                owner
      birth                birth
      author               author
      desc                 desc
      note                 note
      tags                 tags
      fields               fields
      stock                stock
      ranks                ranks
      young                young
      young-by-precedence  young-by-precedence
      young-by-kickoff     young-by-kickoff
      young-by-deadline    young-by-deadline
      progress             progress
      prio-left            prio-left
      prio-ryte            prio-ryte
      prec-left            prec-left
      prec-ryte            prec-ryte
      nest-left            nest-ryte
    ==
  ::
  ++  view-diff
    |=  =diff:harvest:vyu
    ^-  json
    %-  pairs
    :~  :-  %hed
        %-  pairs
        :~  [%pin (enjs-pin:j pin.diff)]
            [%mod (ship mod.diff)]
            [%pid s+`@t`pid.diff]
        ==
        :-  %tel
        %+  frond  %harvest
        ?>  ?=(%replace +<.diff)
        :-  %a
        %+  turn
          `(list [id:gol pack:harvest:vyu])`+>.diff
        id-pack
    ==
  ::
  ++  view-parm
    |=  =parm:harvest:vyu
    ^-  json
    %-  pairs
    :~  [%type (type type.parm)]
        [%method s+method.parm]
        [%tags a+(turn ~(tap in tags.parm) enjs-tag:j)]
    ==
  ::
  ++  type
    |=  =type:harvest:vyu
    ^-  json
    ?-  -.type
      %main  (frond %main ~)
      %pool  (frond %pool (enjs-pin:j pin.type))
      %goal  (frond %goal (enjs-id:j id.type))
    ==
  --
--
