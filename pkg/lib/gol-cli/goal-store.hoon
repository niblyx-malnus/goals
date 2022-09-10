/-  gol=goal, goal-store
/+  *gol-cli-goal, gol-cli-goals, pl=gol-cli-pool
|_  =store:gol
+*  gols   ~(. gol-cli-goals +<)  
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
++  new-goal-temp
  |=  $:  our=ship
          now=@da
          desc=@t           deadline=(unit @da)
          chefs=(set ship)  peons=(set ship)
          actionable=?
      ==
    ^-  [id:gol goal:gol]
    =/  id  (unique-id:gols [our now])
    =|  =goal:gol
    =.  owner.goal       owner.id      =.  birth.goal            birth.id
    =.  desc.goal        desc          =.  chefs.goal            chefs
    =.  peons.goal       peons         =.  moment.deadline.goal  deadline
    =.  actionable.goal  actionable    =.  author.goal           our
    =.  outflow.kickoff.goal  (~(put in *(set eid:gol)) [%d id])
    =.  inflow.deadline.goal  (~(put in *(set eid:gol)) [%k id])
    [id goal]
::
++  new-goal
  |=  $:  =pin:gol             desc=@t
          chefs=(set ship)     peons=(set ship)
          deadline=(unit @da)  actionable=?
          mod=ship             now=@da
      ==
  ^-  away-cud:goal-store
  =/  check  (new-goal:check +<)
  ?-    -.check  
    %|  ~|(+.check !!)
      %&
    =+  ^=  [id goal]
      %:  new-goal-temp
        owner.pin   now
        desc  deadline  chefs  peons  actionable
      ==
    =.  store  (put-in-pool:gols pin id goal)
    :+  pin
      [%spawn-goal ~ id goal]
    store
  ==
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
:: create a new goal and add to goals, nesting under par
++  add-under
  |=  $:  pid=id:gol
          desc=@t           chefs=(set ship)
          peons=(set ship)  deadline=(unit @da)
          actionable=?
          mod=ship          now=@da
      ==
  ^-  away-cud:goal-store
  =/  check  (add-under:check +<)
  ?-    -.check  
    %|  ~|(+.check !!)
      %&
    =/  pin  (~(got by directory.store) pid)
    =+  ^=  [cid goal]
      %:  new-goal-temp
        owner.pin   now
        desc  deadline  chefs  peons  actionable
      ==
    =.  store  (put-in-pool:gols pin cid goal)
    =/  pool  (~(got by pools.store) pin)
    =/  out  (~(apply-sequence pl pool) mod [%held-yoke cid pid]~)
    ?-    -.out
      %|  ~|(+.out !!)
        %&
      =/  pool  pool.p.out
      =.  pools.store  (~(put by pools.store) pin pool)
      =.  goal  (~(got by goals.pool) cid)
      =/  nexus  nexus:`ngoal:gol`(~(got by goals.pool) pid)
      =/  nex  (~(put by *nex:gol) pid nexus)
      :+  pin
        [%spawn-goal nex cid goal]
      store
    ==
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
++  check-goal-perm
  |=  [mod=ship =goal-perm:gol =id:gol]
  ^-  ?
  =/  pin  (~(got by directory.store) id)
  =/  pool-owner  +<:pin
  =/  pool-chefs  chefs:(~(got by pools.store) pin)
  =/  typical
    ?:  ?|  =(mod pool-owner)
            (~(has in pool-chefs) mod)
            !=(~ (seniority:gols mod id ~ ~ %c))
        ==
      %.y
    %.n
  ?-    goal-perm
    %mod-chefs        typical
    %mod-peons        typical
    %add-under        typical
    %remove           typical
    %edit-desc        typical
    %set-deadline     typical
    %mark-actionable  typical
    %mark-complete    typical
    %mark-active      typical
  ==
::
++  check-pool-perm
  |=  [mod=ship =pool-perm:gol =pin:gol]
  ^-  ?
  =/  pool-owner  +<:pin
  =/  pool-chefs  chefs:(~(got by pools.store) pin)
  =/  typical
    ?:  |(=(mod pool-owner) (~(has in pool-chefs) mod))  %.y  %.n
  ?-  pool-perm
    %mod-viewers  typical
    %edit-title   typical
    %new-goal     typical
  ==
::
++  check
  |%
  ++  new-goal
    |=  $:  =pin:gol
            desc=@t
            chefs=(set ship)
            peons=(set ship)
            deadline=(unit @da)
            actionable=?
            mod=ship
            now=@da
        ==
    ^-  (each ~ term)
    ?.  (check-pool-perm mod %new-goal pin)  [%| %perm-fail]
    [%& ~]
  ::
  ++  add-under
    |=  $:  pid=id:gol
            desc=@t
            chefs=(set ship)
            peons=(set ship)
            deadline=(unit @da)
            actionable=?
            mod=ship
            now=@da
        ==
    ^-  (each ~ term)
    ?.  (check-goal-perm mod %add-under pid)  [%| %perm-fail]
    [%& ~]
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
    ?.  (check-goal-perm mod %edit-desc id)  [%| %perm-fail]
    [%& ~]
  ::
  ++  edit-pool-title
    |=  [=pin:gol title=@t mod=ship]
    ^-  (each ~ term)
    ?.  (check-pool-perm mod %edit-title pin)  [%| %perm-fail]
    [%& ~]
  ::
  ++  mark-actionable
    |=  [=id:gol mod=ship]
    ^-  (each ~ term)
    ?.  (check-goal-perm mod %mark-actionable id)  [%| %perm-fail]
    =/  goal  (got-goal:gols id)
    :: make sure has no kids
    :: [%| %kids-fail]
    [%& ~]
  ::
  ++  mark-complete
    |=  [=id:gol mod=ship]
    ^-  (each ~ term)
    ?.  (check-goal-perm mod %mark-complete id)  [%| %perm-fail]
    =/  goal  (got-goal:gols id)
    :: make sure all preceding goals are completed
    :: [%| %incomplete-prec]
    [%& ~]
  ::
  ++  mark-active
    |=  [=id:gol mod=ship]
    ^-  (each ~ term)
    ?.  (check-goal-perm mod %mark-active id)  [%| %perm-fail]
    =/  goal  (got-goal:gols id)
    :: make sure no succeeding goals are completed
    :: [%| %complete-succ]
    [%& ~]
  ++  set-deadline
    |=  [=id:gol deadline=(unit @da) mod=ship]
    ^-  (each ~ term)
    ?.  (check-goal-perm mod %set-deadline id)
      [%| %perm-fail]
    [%& ~]
  ::
  ++  put-viewer
    |=  [=pin:gol invitee=ship mod=ship]
    ^-  (each ~ term)
    ?.  (~(has by pools.store) pin)  [%| %not-pool]
    ?.  (check-pool-perm mod %mod-viewers pin)  [%| %perm-fail]
    [%& ~]
  ::
  ++  make-chef
    |=  [=id:gol chef=ship mod=ship]
    ^-  (each ~ term)
    ?.  (check-goal-perm mod %mod-chefs id)  [%| %perm-fail]
    ?.  (~(has in viewers:(~(got by pools.store) (~(got by directory.store) id))) chef)
      [%| %not-viewer]
    [%& ~]
  ::
  ++  make-peon
    |=  [=id:gol peon=ship mod=ship]
    ^-  (each ~ term)
    ?.  (check-goal-perm mod %mod-peons id)
      [%| %perm-fail]
    ?.  (~(has in viewers:(~(got by pools.store) (~(got by directory.store) id))) peon)
      [%| %not-viewer]
    [%& ~]
  --
--
