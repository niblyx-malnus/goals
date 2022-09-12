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
    =.  captains.goal-perms  (~(put in captains.goal-perms) mod)
    =/  pool  (~(got by pools.store) pin)
    =/  =id:gol  (unique-id:gols [our now])
    =/  goal  (~(init-goal pl pool) id desc actionable goal-perms)
    =/  perm
      ?~  upid
        ?:  (~(check-root-spawn-perm pl pool) mod)  [%& %&]
        [%| %root-spawn-perm-fail]
      (~(check-goal-perm pl pool) u.upid mod)
    ?-    -.perm
      %|  ~|(+.perm !!)
        %&
      =.  store  (put-in-pool:gols pin id goal)
      =.  pool  (~(got by pools.store) pin) :: pool has changed
      =/  out  (~(move-goal pl pool) id upid owner.pool) :: divine intervention
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
          [%spawn-goal nex id goal]~
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
  :-  (update-dir:gols pin ~)
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
  (update-store pin pool)
::
++  delete-goal
  |=  [=id:gol mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  prog  ~(tap in (~(progeny pl pool) id))
  =/  ovlp  *(set id:gol)
  =/  idx  0
  |-
  ?:  =(idx (lent prog))
    =/  nex
      %-  ~(gas by *(map id:gol goal-nexus:gol))
      %+  turn  ~(tap in (~(dif in ovlp) (sy prog)))
      |=(=id:gol [id nexus:`ngoal:gol`(~(got by goals.pool) id)])
    :+  pin
      [%trash-goal nex (sy prog)]~
    :-  (~(del by directory.store) id)
    (~(put by pools.store) pin pool)
  %=  $
    idx  +(idx)
    ovlp  (~(uni in ovlp) (get-overlaps:gols goals.pool (snag idx prog)))
    pool  pool(goals (purge-goals:gols goals.pool (snag idx prog)))
  ==
::
++  edit-goal-desc
  |=  [=id:gol desc=@t mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  out  (~(edit-goal-desc pl pool) id desc mod)
  ?-    -.out
    %|  ~|(+.out !!)
      %&
    :+  pin
      [%goal-hitch id %desc desc]~
    store(pools (~(put by pools.store) pin p.out))
  ==
:: 
++  edit-pool-title
  |=  [=pin:gol title=@t mod=ship]
  ^-  away-cud:goal-store
  =/  pool  (~(got by pools.store) pin)
  =/  out  (~(edit-pool-title pl pool) title mod)
  ?-    -.out
    %|  ~|(+.out !!)
      %&
    :+  pin
      [%pool-hitch %title title]~
    store(pools (~(put by pools.store) pin p.out))
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
      [%goal-togls id %actionable %.y]~
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
      [%goal-togls id %actionable %.n]~
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
      [%goal-togls id %complete %.y]~
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
      [%goal-togls id %complete %.n]~
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
      [%goal-nexus id %deadline moment]~
    store(pools (~(put by pools.store) pin p.out))
  ==
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
  =/  v  (~(add-pool-viewers pl pool) viewers mod)
  ?-    -.v
    %|  ~|(+.v !!)
      %&
    =/  a  (~(add-pool-admins pl p.v) admins mod)
    ?-    -.a
      %|  ~|(+.a !!)
        %&
      =/  c  (~(add-pool-captains pl p.a) captains mod)
      ?-    -.c
        %|  ~|(+.c !!)
          %&
        :+  pin
          :~  [%pool-perms %add-pool-viewers viewers]
              [%pool-perms %add-pool-admins admins]
              [%pool-perms %add-pool-captains captains]
          ==
        store(pools (~(put by pools.store) pin p.c))
      ==
    ==
  ==
::
++  add-goal-captains
  |=  [=id:gol captains=(set ship) mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  out  (~(add-goal-captains pl pool) id captains mod)
  ?-    -.out
    %|  ~|(+.out !!)
      %&
    :+  pin
      [%goal-perms id %add-goal-captains captains]~
    store(pools (~(put by pools.store) pin p.out))
  ==
::
++  add-goal-peons
  |=  [=id:gol peons=(set ship) mod=ship]
  ^-  away-cud:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  out  (~(add-goal-peons pl pool) id peons mod)
  ?-    -.out
    %|  ~|(+.out !!)
      %&
    :+  pin
      [%goal-perms id %add-goal-peons peons]~
    store(pools (~(put by pools.store) pin p.out))
  ==
--
