/-  gol=goal, vyu=views
/+  gol-cli-traverse, j=gol-cli-json
|_  =store:gol
:: TODO: Sever this data structure from the core backend data
:: structure
++  view-data
  |=  =parm:tree:vyu
  ^-  data:tree:vyu
  :: =-  ~&(- -)
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
::
++  view-diff
  |=  $:  =parm:tree:vyu
          =data:tree:vyu
          [[=pin:gol mod=ship pid=@] upd=update:gol]
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
    :: ~&  diff
    diff
  (some [[pin mod pid] upd])
::
++  etch-diff
  |=  [=data:tree:vyu =diff:tree:vyu]
  ^-  data:tree:vyu
  *data:tree:vyu
::
++  dejs
  =,  dejs:format
  |%
  ++  view-parm
    ^-  $-(json parm:tree:vyu)
    (ot ~[type+type])
  ::
  ++  type
    ^-  $-(json type:tree:vyu)
    %-  of
    :~  main+|=(jon=json ?>(?=(~ jon) ~))
        pool+pin:dejs:j
        goal+id:dejs:j
    ==
  --
::
++  enjs
  =,  j
  =,  enjs:format
  |%
  ++  view-data
    |=  =data:tree:vyu
    ^-  json
    %-  pairs
    :~  [%pools (enjs-pools pools.data)]
        [%cache (enjs-pools cache.data)]
    ==
  ::
  ++  view-diff
    |=  =diff:tree:vyu
    ^-  json
    =/  upd=update  +.diff
    =/  upd  +.upd  :: ignore version
    %-  pairs
    :~  :-  %hed
        %-  pairs
        :~  [%pin (enjs-pin pin.diff)]
            [%mod (ship mod.diff)]
            [%pid s+`@t`pid.diff]
        ==
        :-  %tel
        %+  frond  -.upd
        ?-    -.upd
          %poke-error  (frond %tang (enjs-tang tang.upd))
            %spawn-goal
          %-  pairs
          :~  [%pin (enjs-pin pin.diff)]
              [%pex (enjs-pex pex.upd)]
              [%nex (enjs-nex nex.upd)]
              [%id (enjs-id id.upd)]
              [%goal (enjs-goal goal.upd)]
          ==
          ::
            %waste-goal
          %-  pairs
          :~  [%pin (enjs-pin pin.diff)]
              [%pex (enjs-pex pex.upd)]
              [%nex (enjs-nex nex.upd)]
              [%id (enjs-id id.upd)]
              [%waz a+(turn ~(tap in waz.upd) enjs-id)]
          ==
          ::
            %cache-goal
          %-  pairs
          :~  [%pin (enjs-pin pin.diff)]
              [%pex (enjs-pex pex.upd)]
              [%nex (enjs-nex nex.upd)]
              [%id (enjs-id id.upd)]
              [%cas a+(turn ~(tap in cas.upd) enjs-id)]
          ==
          ::
          %renew-goal  
          %-  pairs
          :~  [%pin (enjs-pin pin.diff)]
              [%pex (enjs-pex pex.upd)]
              [%id (enjs-id id.upd)]
              [%ren (enjs-goals ren.upd)]
          ==
          ::
          %trash-goal
          %-  pairs
          :~  [%pin (enjs-pin pin.diff)]
              [%pex (enjs-pex pex.upd)]
              [%id (enjs-id id.upd)]
              [%tas a+(turn ~(tap in tas.upd) enjs-id)]
          ==
          ::
          %spawn-pool  (frond %pool (enjs-pool pool.upd))
          ::
          %cache-pool  (frond %pin (enjs-pin pin.upd))
          ::
            %renew-pool 
          (pairs ~[[%pin (enjs-pin pin.upd)] [%pool (enjs-pool pool.upd)]])
          ::
          %waste-pool  ~
          %trash-pool  ~
          ::
            %pool-perms
          :-  %a  %+  turn  ~(tap by new.upd) 
          |=  [chip=@p role=(unit pool-role)] 
          %-  pairs
          :~  [%ship (ship chip)]
              [%role ?~(role ~ s+u.role)]
          ==
          ::
            %pool-hitch
          ?-  +<.upd
            %title  (frond +<.upd s+title.upd)
            %note  (frond +<.upd s+note.upd)
            %del-field-type  (frond +<.upd s+field.upd)
              %add-field-type
            %+  frond  +<.upd
            %-  pairs
            :~  [%field s+field.upd]
                [%field-type (enjs-field-type field-type.upd)]
            ==
          ==
          ::
            %pool-nexus
          ?-    +<.upd
              %yoke
            %+  frond  +<.upd
            %-  pairs
            :~  pex+(enjs-pex pex.upd)
                nex+(enjs-nex nex.upd)
            ==
          ==
          ::
            %goal-dates
          %-  pairs
          :~  pex+(enjs-pex pex.upd)
              nex+(enjs-nex nex.upd)
          ==
          ::
            %goal-perms
          %-  pairs
          :~  pex+(enjs-pex pex.upd)
              nex+(enjs-nex nex.upd)
          ==
          ::
            %goal-young
          %-  pairs
          :~  [%id (enjs-id id.upd)]
              [%young a+(turn young.upd enjs-id-v)]
              [%young-by-precedence a+(turn young-by-precedence.upd enjs-id-v)]
              [%young-by-kickoff a+(turn young-by-kickoff.upd enjs-id-v)]
              [%young-by-deadline a+(turn young-by-deadline.upd enjs-id-v)]
          ==
          ::
            %goal-roots
          %+  frond  %pex
          (enjs-pex pex.upd)
          ::
            %goal-togls
          %-  pairs
          :~  [%id (enjs-id id.upd)]
              :-  %togls-updated
              %+  frond
                +>-.upd
              ?-  +>-.upd
                %complete  b+complete.upd
                %actionable  b+actionable.upd
              ==
          ==
          ::
            %goal-hitch
          %-  pairs
          :~  [%id (enjs-id id.upd)]
              ?-  +>-.upd
                %desc  [%desc s+desc.upd]
                %note  [%note s+note.upd]
                %add-tag  [%tag (enjs-tag tag.upd)]
                %del-tag  [%tag (enjs-tag tag.upd)]
                %put-tags  [%tags a+(turn ~(tap in tags.upd) enjs-tag)]
                %del-field-data  [%del-field-data s+field.upd]
                  %add-field-data
                :-  %add-field-data
                %-  pairs
                :~  [%field s+field.upd]
                    [%field-data (enjs-field-data field-data.upd)]
                ==
              ==
          ==
        ==
    ==
  ::
  ++  view-parm
    |=  =parm:tree:vyu
    ^-  json
    (frond %type (type type.parm))
  ::
  ++  type
    |=  =type:page:vyu
    ^-  json
    ?-  -.type
      %main  (frond %main ~)
      %pool  (frond %pool (enjs-pin pin.type))
      %goal  (frond %goal (enjs-id id.type))
    ==
  --
--
