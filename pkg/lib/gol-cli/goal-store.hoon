/-  gol=goal, goal-store
/+  *gol-cli-goal, gol-cli-goals, pl=gol-cli-pool
|_  =store:gol
+*  gols   ~(. gol-cli-goals +<)  
::
:: update directory to reflect new goals in a pool
++  update-dir
  |=  [=pin:gol efx=(list update:goal-store)]
  ^-  directory:gol
  |^
  =/  idx  0
  |-
  ?:  =(idx (lent efx))
    directory.store
  =/  upd  (snag idx efx)
  %=  $
    idx  +(idx)
    directory.store
      ?+    upd  directory.store
          [%spawn-pool *]
        %-  ~(gas by directory.store) 
        %+  turn
          ~(tap in ~(key by goals.pool.upd))
        |=  =id:gol
        [id pin]
        ::
          [%trash-pool *]
        (gus-by-directory ~(tap in ~(key by goals:(~(got by pools.store) pin))))
        ::
          [%spawn-goal *]
        (~(put by directory.store) id.upd pin)
        ::
          [%trash-goal *]
        (gus-by-directory ~(tap in del.upd))
      ==
  ==
  ++  gus-by-directory
    |=  ids=(list id:gol)
    =/  idx  0
    |-
    ?:  =(idx (lent ids))
      directory.store
    $(idx +(idx), directory.store (~(del in directory.store) (snag idx ids)))
  --
::
++  update-store
  |=  [=pin:gol efx=(list update:goal-store) =pool:gol]
  ^-  store:gol
  :_  (~(put by pools.store) pin pool)
  (update-dir pin efx)
::
++  get-away-cud
  |=  [=pin:gol mod=ship pore=_pl]
  ^-  away-cud:goal-store
  :+  pin
    %+  turn
    efx:abet:pore
    |=  upd=update:goal-store
    ^-  away-update:goal-store
    [mod upd]
  (update-store pin abet:pore)
::
++  spawn-goal
  |=  $:  [=pin:gol mod=ship]
          [our=ship now=@da]
          upid=(unit id:gol)
          desc=@t
          actionable=?(%.y %.n)
          =goal-perms:gol
      ==
  =/  pool  (~(got by pools.store) pin)
  =/  =id:gol  (unique-id:gols [our now])
  =/  pore  (apex:pl pool)
  =.  pore
    %:  spawn-goal-fixns:pore
      id          upid
      desc        actionable
      goal-perms  mod
    ==
  (get-away-cud pin mod pore)
::
++  move-goal
  |=  [=pin:gol cid=id:gol upid=(unit id:gol) mod=ship]
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (move-goal:pore cid upid mod)
  (get-away-cud pin mod pore)
::
++  yoke
  |=  [=pin:gol yok=exposed-yoke:gol mod=ship]
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (yoke:pore yok mod)
  (get-away-cud pin mod pore)
::
:: create a new empty pool with title, initial viewers, admins, captains
:: admins and captains immediately added as viewers
++  new-pool
  |=  $:  title=@t           captains=(set ship)
          admins=(set ship)  viewers=(set ship)
          own=ship           mod=ship
          now=@da
      ==
  ^-  home-cud:goal-store
  =+  [pin pool]=(new-pool:gols title captains admins viewers own now)
  :+  pin
    [[pin mod] %spawn-pool pool]~
  store(pools (~(put by pools.store) pin pool))
::
++  delete-pool
  |=  [=pin:gol mod=ship]
  ^-  home-cud:goal-store
  :+  pin
    [[pin mod] %trash-pool ~]~
  :-  (update-dir pin [%trash-pool ~]~)
  (~(del by pools.store) pin)
::
++  archive-pool  !!
::
++  copy-pool
  |=  $:  =old=pin:gol         title=@t
          captains=(set ship)  admins=(set ship)
          viewers=(set ship)   own=ship
          mod=ship             now=@da
      ==
  ^-  home-cud:goal-store
  =+  [pin pool]=(copy-pool:gols old-pin title captains admins viewers own now)
  :+  pin
    [[pin mod] %spawn-pool pool]~
  (update-store pin [%spawn-pool pool]~ pool)
::
++  delete-goal
  |=  [=id:gol mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (delete-goal:pore id mod)
  (get-away-cud pin mod pore)
::
++  edit-goal-desc
  |=  [=id:gol desc=@t mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (edit-goal-desc:pore id desc mod)
  (get-away-cud pin mod pore)
:: 
++  edit-pool-title
  |=  [=pin:gol title=@t mod=ship]
  ^-  away-cud:goal-store
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (edit-pool-title:pore title mod)
  (get-away-cud pin mod pore)
::
++  mark-actionable
  |=  [=id:gol mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  out  (~(mark-actionable pl pool) id mod)
  =/  pore  (apex:pl pool)
  =.  pore  (mark-actionable:pore id mod)
  (get-away-cud pin mod pore)
::
++  unmark-actionable
  |=  [=id:gol mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (unmark-actionable:pore id mod)
  (get-away-cud pin mod pore)
::
++  mark-complete
  |=  [=id:gol mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (mark-complete:pore id mod)
  (get-away-cud pin mod pore)
::
++  unmark-complete
  |=  [=id:gol mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (unmark-complete:pore id mod)
  (get-away-cud pin mod pore)
::
++  set-deadline
  |=  [=id:gol moment=(unit @da) mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (set-deadline:pore id moment mod)
  (get-away-cud pin mod pore)
::
++  add-pool-invitees
  |=  $:  =pin:gol
          viewers=(set ship)
          admins=(set ship)
          captains=(set ship)
          mod=ship
      ==
  ^-  away-cud:goal-store
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (add-pool-perms:pore viewers admins captains mod)
  (get-away-cud pin mod pore)
::
++  add-goal-captains
  |=  [=id:gol captains=(set ship) mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (add-goal-captains:pore id captains mod)
  (get-away-cud pin mod pore)
::
++  add-goal-peons
  |=  [=id:gol peons=(set ship) mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (add-goal-peons:pore id peons mod)
  (get-away-cud pin mod pore)
--
