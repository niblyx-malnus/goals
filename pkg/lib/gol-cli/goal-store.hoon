/-  gol=goal, goal-store
/+  *gol-cli-goal, gol-cli-goals, pl=gol-cli-pool
|_  =store:gol
+*  gols   ~(. gol-cli-goals +<)  
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
    =/  goal  (~(spawn-goal pl pool) id desc actionable goal-perms)
    =/  perm
      ?~  upid
        ?:  (~(check-pool-perm pl pool) mod)  [%& %&]  [%| %pool-perm-fail]
      (~(check-goal-perm pl pool) u.upid mod)
    ?-    -.perm
      %|  ~|(+.perm !!)
        %&
      =.  store  (put-in-pool:gols pin id goal)
      =.  pool  (~(got by pools.store) pin) :: pool has changed
      =/  out  (~(move-goal pl pool) id upid mod)
      ?-    -.out
        %|  ~|(+.out !!)
          %&
        =.  pool  pool.p.out :: pool has changed
        =.  pools.store  (~(put by pools.store) pin pool)
        =.  goal  (~(got by goals.pool) id)
        =/  nex  
          ?~  upid
            *nex:gol
          =/  nexus  nexus:`ngoal:gol`(~(got by goals.pool) u.upid)
          (~(put by *nex:gol) u.upid nexus)
        :+  pin
          [%spawn-goal nex id goal]
        store
      ==
    ==
::
++  update-store
  |=  [=pin:gol =pool:gol]
  ^-  store:gol
  :_  (~(put by pools.store) pin pool)
  (update-dir:gols pin ~(key by goals.pool))
::
:: create a new empty pool with title, initial viewers, chefs, and peons
:: chefs and peons immediately added as viewers
++  new-pool
  |=  $:  title=@t          chefs=(set ship)
          peons=(set ship)  viewers=(set ship)
          own=ship          mod=ship
          now=@da
      ==
  ^-  home-cud:goal-store
  =+  [pin pool]=(new-pool:gols title chefs peons viewers own now)
  :+  pin
    [[pin mod] %spawn-pool pool]
  store(pools (~(put by pools.store) pin pool))
::
++  delete-pool
  |=  [=pin:gol mod=ship]
  ^-  home-cud:goal-store
  :+  pin
    [[pin mod] %trash-pool ~]
  :-  (update-dir:gols pin ~)
  (~(del by pools.store) pin)
::
++  archive-pool  !!
::
++  copy-pool
  |=  $:  =old=pin:gol        title=@t
          chefs=(set ship)    peons=(set ship)
          viewers=(set ship)  own=ship
          mod=ship            now=@da
      ==
  ^-  home-cud:goal-store
  =+  [pin pool]=(copy-pool:gols old-pin title chefs peons viewers own now)
  :+  pin
    [[pin mod] %spawn-pool pool]
  (update-store pin pool)
::
++  delete-goal
  |=  [=id:gol mod=ship]
  ^-  away-cud:goal-store
  =/  check  (delete-goal:check +<)
  ?-    -.check
    %|  ~|(+.check !!)
      %&
    =/  pin  (~(got by directory.store) id)
    =/  pool  (~(got by pools.store) pin)
    :+  pin
      [%trash-goal id]
    :-  (~(del by directory.store) id)
    (~(put by pools.store) pin pool(goals (purge-goals:gols goals.pool id)))
  ==
::
++  edit-goal-desc
  |=  [=id:gol desc=@t mod=ship]
  ^-  away-cud:goal-store
  =/  check  (edit-goal-desc:check +<)
  ?-    -.check
    %|  ~|(+.check !!)
      %&
    =/  goal  (got-goal:gols id)
    =+  [pin pool]=(put-goal:gols id goal(desc desc))
    :+  pin
      [%goal-hitch id %desc desc]
    store(pools (~(put by pools.store) pin pool))
  ==
:: 
++  edit-pool-title
  |=  [=pin:gol title=@t mod=ship]
  ^-  away-cud:goal-store
  =/  check  (edit-pool-title:check +<)
  ?-    -.check
    %|  ~|(+.check !!)
      %&
    =/  pool  (~(got by pools.store) pin)
    =.  pool  pool(title title)
    :+  pin
      [%pool-hitch %title title]
    store(pools (~(put by pools.store) pin pool))
  ==
::
++  mark-actionable
  |=  [=id:gol mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  out  (~(mark-actionable pl pool) id mod)
  ?-    -.out
    %|  ~|(+.out !!)
      %&
    :+  pin
      [%goal-togls id %actionable %.y]
    store(pools (~(put by pools.store) pin p.out))
  ==
::
++  unmark-actionable
  |=  [=id:gol mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  out  (~(unmark-actionable pl pool) id mod)
  ?-    -.out
    %|  ~|(+.out !!)
      %&
    :+  pin
      [%goal-togls id %actionable %.n]
    store(pools (~(put by pools.store) pin p.out))
  ==
::
++  mark-complete
  |=  [=id:gol mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  out  (~(mark-complete pl pool) id mod)
  ?-    -.out
    %|  ~|(+.out !!)
      %&
    :+  pin
      [%goal-togls id %complete %.y]
   store(pools (~(put by pools.store) pin p.out))
  ==
::
++  unmark-complete
  |=  [=id:gol mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  out  (~(unmark-complete pl pool) id mod)
  ?-    -.out
    %|  ~|(+.out !!)
      %&
    :+  pin
      [%goal-togls id %complete %.n]
    store(pools (~(put by pools.store) pin p.out))
  ==
::
++  set-deadline
  |=  [=id:gol moment=(unit @da) mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  out  (~(set-deadline pl pool) id moment mod)
  ?-    -.out
    %|  ~|(+.out !!)
      %&
    :+  pin
      [%goal-nexus id %deadline moment]
    store(pools (~(put by pools.store) pin p.out))
  ==
::
++  put-viewer
  |=  [=pin:gol invitee=ship mod=ship]
  ^-  away-cud:goal-store
  =/  check  (put-viewer:check +<)
  ?-    -.check  
    %|  ~|(+.check !!)
      %&
    =/  pool  (~(got by pools.store) pin)
    =.  pool  pool(viewers (~(put in viewers.pool) invitee))
    :+  pin
      [%pool-perms %viewer invitee]
    store(pools (~(put by pools.store) pin pool))
  ==
::
++  make-chef
  |=  [=id:gol chef=ship mod=ship]
  ^-  away-cud:goal-store
  =/  check  (make-chef:check +<)
  ?-    -.check
    %|  ~|(+.check !!)
      %&
    =/  goal  (got-goal:gols id)
    =+  [pin pool]=(put-goal:gols id goal(chefs (~(put in chefs.goal) chef)))
    :+  pin
      [%goal-perms id %chef chef] 
    store(pools (~(put by pools.store) pin pool))
  ==
::
++  make-peon
  |=  [=id:gol peon=ship mod=ship]
  ^-  away-cud:goal-store
  =/  check  (make-peon:check +<)
  ?-    -.check  
    %|  ~|(+.check !!)
      %&
    =/  goal  (got-goal:gols id)
    =+  [pin pool]=(put-goal:gols id goal(peons (~(put in peons.goal) peon)))
    :+  pin
      [%goal-perms id %peon peon] 
    store(pools (~(put by pools.store) pin pool))
  ==
::
++  apply-sequence
  |=  [=pin:gol mod=ship yok=exposed-yoke:gol]
  ^-  away-cud:goal-store
  !!
  :: =/  pool  (~(got by pools.store) pin)
  :: =/  out  (~(apply-sequence pl pool) mod [yok]~)
  :: ?-    -.out
  ::   %|  ~|(+.out !!)
  ::     %&
  ::   =/  pool  pool.p.out
  ::   =/  nex  (~(get-nex pl pool) set.p.out)
  ::   :+  pin
  ::     [%pool-nexus %yoke-sequence yok nex]
  ::   store
  ::   :: store(pools (~(put by pools.store) pin pool.p.out))
  :: ==
::
++  check
  |%
  ::
  ++  delete-goal
    |=  [=id:gol mod=ship]
    ^-  (each ~ term)
    ?.  =(mod author:(got-goal:gols id))  [%| %author-fail]
    [%& ~]
  ::
  ++  edit-goal-desc
    |=  [=id:gol desc=@t mod=ship]
    ^-  (each ~ term)
    [%& ~]
  ::
  ++  edit-pool-title
    |=  [=pin:gol title=@t mod=ship]
    ^-  (each ~ term)
    [%& ~]
  ::
  ++  put-viewer
    |=  [=pin:gol invitee=ship mod=ship]
    ^-  (each ~ term)
    [%& ~]
  ::
  ++  make-chef
    |=  [=id:gol chef=ship mod=ship]
    ^-  (each ~ term)
    ?.  (~(has in viewers:(~(got by pools.store) (~(got by directory.store) id))) chef)
      [%| %not-viewer]
    [%& ~]
  ::
  ++  make-peon
    |=  [=id:gol peon=ship mod=ship]
    ^-  (each ~ term)
    ?.  (~(has in viewers:(~(got by pools.store) (~(got by directory.store) id))) peon)
      [%| %not-viewer]
    [%& ~]
  --
--
