/-  gol=goal, goal-store
/+  *gol-cli-goal, gol-cli-goals, gol-cli-pools, gol-cli-etch, pl=gol-cli-pool
|_  =store:gol
+*  gols  ~(. gol-cli-goals +<)
    puls  ~(. gol-cli-pools +<)
    etch  ~(. gol-cli-etch store)
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
  (etch:etch pin efx:abet:pore)
::
++  spawn-goal
  |=  $:  [=pin:gol mod=ship]
          [our=ship now=@da]
          upid=(unit id:gol)
          desc=@t
          actionable=?(%.y %.n)
      ==
  =/  pool  (~(got by pools.store) pin)
  =/  =id:gol  (unique-id:gols [our now])
  =/  pore  (apex:pl pool)
  =.  pore  (spawn-goal-fixns:pore id upid desc actionable mod)
  (get-away-cud pin mod pore)
::
++  cache-goal
  |=  [=id:gol mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by index.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (cache-goal:pore id mod)
  (get-away-cud pin mod pore)
::
++  renew-goal
  |=  [=id:gol mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by index.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (renew-goal:pore id mod)
  (get-away-cud pin mod pore)
::
++  trash-goal
  |=  [=id:gol mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by index.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (trash-goal:pore id mod)
  (get-away-cud pin mod pore)
::
++  move
  |=  [cid=id:gol upid=(unit id:gol) mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by index.store) cid)
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (move-emot:pore cid upid mod)
  (get-away-cud pin mod pore)
::::
++  yoke
  |=  [=pin:gol yoks=(list exposed-yoke:gol) mod=ship]
  ^-  away-cud:goal-store
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (yoke-sequence:pore yoks mod)
  (get-away-cud pin mod pore)
::
++  spawn-pool
  |=  $:  title=@t
          own=ship
          mod=ship
          now=@da
      ==
  ^-  home-cud:goal-store
  =+  [pin pool]=(spawn-pool:puls title own now)
  :+  pin
    [[pin mod] %spawn-pool pool]~
  (etch:etch pin [%spawn-pool pool]~)
::
++  trash-pool
  |=  [=pin:gol mod=ship]
  ^-  home-cud:goal-store
  ?>  =(mod owner.pin)
  :+  pin
    [[pin mod] %trash-pool ~]~
  (etch:etch pin [%trash-pool ~]~)
::
++  cache-pool
  |=  [=pin:gol mod=ship]
  ^-  home-cud:goal-store
  ?>  =(mod owner.pin)
  :+  pin
    [[pin mod] %cache-pool pin]~
  (etch:etch pin [%cache-pool pin]~)
::
++  renew-pool
  |=  [=pin:gol mod=ship]
  ^-  home-cud:goal-store
  ?>  =(mod owner.pin)
  =/  pool  (~(got by cache.store) pin)
  :+  pin
    [[pin mod] %renew-pool pin pool]~
  (etch:etch pin [%renew-pool pin pool]~)
::
++  clone-pool
  |=  $:  =old=pin:gol
          title=@t
          own=ship
          mod=ship
          now=@da
      ==
  ^-  home-cud:goal-store
  =+  [pin pool]=(clone-pool:puls old-pin title own now)
  :+  pin
    [[pin mod] %spawn-pool pool]~
  (etch:etch pin [%spawn-pool pool]~)
::
++  edit-goal-desc
  |=  [=id:gol desc=@t mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by index.store) id)
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
  =/  pin  (~(got by index.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  out  (~(mark-actionable pl pool) id mod)
  =/  pore  (apex:pl pool)
  =.  pore  (mark-actionable:pore id mod)
  (get-away-cud pin mod pore)
::
++  unmark-actionable
  |=  [=id:gol mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by index.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (unmark-actionable:pore id mod)
  (get-away-cud pin mod pore)
::
++  mark-complete
  |=  [=id:gol mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by index.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (mark-complete:pore id mod)
  (get-away-cud pin mod pore)
::
++  unmark-complete
  |=  [=id:gol mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by index.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (unmark-complete:pore id mod)
  (get-away-cud pin mod pore)
::
++  set-kickoff
  |=  [=id:gol moment=(unit @da) mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by index.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (set-kickoff:pore id moment mod)
  (get-away-cud pin mod pore)
::
++  set-deadline
  |=  [=id:gol moment=(unit @da) mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by index.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (set-deadline:pore id moment mod)
  (get-away-cud pin mod pore)
::
++  update-goal-perms
  |=  [=id:gol chief=ship rec=?(%.y %.n) spawn=(set ship) mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by index.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (update-goal-perms:pore id chief rec spawn mod)
  (get-away-cud pin mod pore)
::
++  update-pool-perms
  |=  $:  =pin:gol
          new=pool-perms:gol
          mod=ship
      ==
  ^-  away-cud:goal-store
  =/  pool  (~(got by pools.store) pin)
  =/  pore  (apex:pl pool)
  =.  pore  (update-pool-perms:pore new mod)
  (get-away-cud pin mod pore)
--
