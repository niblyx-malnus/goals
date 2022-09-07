/-  gol=goal, goal-store
/+  *gol-cli-goal, gol-cli-goals, pr=gol-cli-pool
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
  |=  [title=@t chefs=(set ship) peons=(set ship) viewers=(set ship) own=ship now=@da]
  ^-  store-update:goal-store
  =/  check  (new-pool:check +<)
  ?-    -.check
    %|  !! ::  [*pin:gol [%error +.check] store]
      %&
    =+  [pin pool]=(new-pool:gols title chefs peons viewers own now)
    [pin [%new-pool pin pool] store(pools (~(put by pools.store) pin pool))]
  ==
::
++  delete-pool
  |=  [=pin:gol mod=ship]
  ^-  store-update:goal-store
  :-  pin  :-  [%delete-pool pin]
  :-  (update-dir:gols pin ~)
  (~(del by pools.store) pin)
::
++  archive-pool  !!
::
++  copy-pool
  |=  [=old=pin:gol title=@t chefs=(set ship) peons=(set ship) viewers=(set ship) own=ship now=@da]
  ^-  store-update:goal-store
  =/  check  (copy-pool:check +<)
  ?-    -.check  
    %|  !! ::  [old-pin [%error +.check] store]
      %&
    =+  [pin pool]=(copy-pool:gols old-pin title chefs peons viewers own now)
    [pin [%new-pool pin pool] (update-store pin pool)]
  == 
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
  ^-  store-update:goal-store
  =/  check  (new-goal:check +<)
  ?-    -.check  
    %|  !! ::   [pin [%error +.check] store]
      %&
    =+  ^=  [id goal]
      %:  new-goal-temp
        owner.pin   now
        desc  deadline  chefs  peons  actionable
      ==
    =.  store  (put-in-pool:gols pin id goal)
    [pin [%new-goal pin mod id goal] store]
  ==
::
++  delete-goal
  |=  [=id:gol mod=ship]
  ^-  store-update:goal-store
  =/  check  (delete-goal:check +<)
  ?-    -.check
    %|  !! ::   [(~(got by directory.store) id) [%error +.check] store]
      %&
    =/  pin  (~(got by directory.store) id)
    =/  pool  (~(got by pools.store) pin)
    :-  pin  :-  [%delete-goal pin mod id]
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
  ^-  store-update:goal-store
  =/  check  (add-under:check +<)
  ?-    -.check  
    %|  !! ::   [(~(got by directory.store) pid) [%error +.check] store]
      %&
    =/  pin  (~(got by directory.store) pid)
    =+  ^=  [cid goal]
      %:  new-goal-temp
        owner.pin   now
        desc  deadline  chefs  peons  actionable
      ==
    =.  store  (put-in-pool:gols pin cid goal)
    =/  pool  (~(got by pools.store) pin)
    =/  out  (~(apply-sequence pr pin pool) mod [%held-yoke cid pid]~)
    ?-    -.out
      %|  [pin [%error p.out] store]
        %&
      =/  pool  pool.p.out
      =.  pools.store  (~(put by pools.store) pin pool)
      =.  goal  (~(got by goals.pool) cid)
      [pin [%add-under pin mod pid cid goal] store]
    ==
  ==
::
++  edit-goal-desc
  |=  [=id:gol desc=@t mod=ship]
  ^-  store-update:goal-store
  =/  check  (edit-goal-desc:check +<)
  ?-    -.check
    %|  !! ::   [(~(got by directory.store) id) [%error +.check] store]
      %&
    =/  goal  (got-goal:gols id)
    =+  [pin pool]=(put-goal:gols id goal(desc desc))
    [pin [%pool-update pool] store(pools (~(put by pools.store) pin pool))]
  ==
:: 
++  edit-pool-title
  |=  [=pin:gol title=@t mod=ship]
  ^-  store-update:goal-store
  =/  check  (edit-pool-title:check +<)
  ?-    -.check
    %|  !! ::   [pin [%error +.check] store]
      %&
    =/  pool  (~(got by pools.store) pin)
    =.  pool  pool(title title)
    [pin [%pool-update pool] store(pools (~(put by pools.store) pin pool))]
  ==
::
++  mark-actionable
  |=  [=id:gol mod=ship]
  ^-  store-update:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  ma  (~(mark-actionable pr pin pool) id mod)
  ?-    -.ma
    %|  !! ::   [pin [%error +.ma] store]
      %&
    =.  pools.store  (~(put by pools.store) pin p.ma)
    [pin [%pool-update (~(got by pools.store) pin)] store]
  ==
::
++  unmark-actionable
  |=  [=id:gol mod=ship]
  ^-  store-update:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  ua  (~(unmark-actionable pr pin pool) id mod)
  ?-    -.ua
    %|  !! ::   [pin [%error +.ua] store]
      %&
    =.  pools.store  (~(put by pools.store) pin p.ua)
    [pin [%pool-update (~(got by pools.store) pin)] store]
  ==
::
++  mark-complete
  |=  [=id:gol mod=ship]
  ^-  store-update:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  mc  (~(mark-complete pr pin pool) id mod)
  ?-    -.mc
    %|  !! ::   [pin [%error +.mc] store]
      %&
    =.  pools.store  (~(put by pools.store) pin p.mc)
    [pin [%pool-update (~(got by pools.store) pin)] store]
  ==
::
++  unmark-complete
  |=  [=id:gol mod=ship]
  ^-  store-update:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  uc  (~(unmark-complete pr pin pool) id mod)
  ?-    -.uc
    %|   !! ::    [pin [%error +.uc] store]

      %&
    =.  pools.store  (~(put by pools.store) pin p.uc)
    [pin [%pool-update (~(got by pools.store) pin)] store]
  ==
::
++  set-deadline
  |=  [=id:gol moment=(unit @da) mod=ship]
  ^-  store-update:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  pool  (~(got by pools.store) pin)
  =/  sd  (~(set-deadline pr pin pool) id moment mod)
  ?-    -.sd
    %|  !! ::   [pin [%error +.sd] store]
      %&
    =.  pools.store  (~(put by pools.store) pin p.sd)
    [pin [%pool-update p.sd] store]
  ==
::
++  put-viewer
  |=  [=pin:gol invitee=ship mod=ship]
  ^-  store-update:goal-store
  =/  check  (put-viewer:check +<)
  ?-    -.check  
    %|  !! ::   [pin [%error +.check] store]
      %&
    =/  pool  (~(got by pools.store) pin)
    =.  pool  pool(viewers (~(put in viewers.pool) invitee))
    [pin [%pool-update pool] store(pools (~(put by pools.store) pin pool))]
  ==
::
++  make-chef
  |=  [=id:gol chef=ship mod=ship]
  ^-  store-update:goal-store
  =/  check  (make-chef:check +<)
  ?-    -.check
    %|  !! ::   [(~(got by directory.store) id) [%error +.check] store]
      %&
    =/  goal  (got-goal:gols id)
    =+  [pin pool]=(put-goal:gols id goal(chefs (~(put in chefs.goal) chef)))
    [pin [%pool-update pool] store(pools (~(put by pools.store) pin pool))]
  ==
::
++  make-peon
  |=  [=id:gol peon=ship mod=ship]
  ^-  store-update:goal-store
  =/  check  (make-peon:check +<)
  ?-    -.check  
    %|  !! ::   [(~(got by directory.store) id) [%error +.check] store]
      %&
    =/  goal  (got-goal:gols id)
    =+  [pin pool]=(put-goal:gols id goal(peons (~(put in peons.goal) peon)))
    [pin [%pool-update pool] store(pools (~(put by pools.store) pin pool))]
  ==
::
++  apply-sequence
  |=  [=pin:gol mod=ship seq=yoke-sequence:gol]
  ^-  store-update:goal-store
  =/  pool  (~(got by pools.store) pin)
  =/  as  (~(apply-sequence pr pin pool) mod seq)
  ?-    -.as
    %|  !! ::   [pin [%error +.as] store]
      %&
    =.  pools.store  (~(put by pools.store) pin pool.p.as)
    =/  nex  (~(get-nex pr pin pool) set.p.as)
    [pin [%yoke-sequence pin mod nex] store(pools (~(put by pools.store) pin pool))]
  ==
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
  ++  new-pool
    |=  [title=@t chefs=(set ship) peons=(set ship) viewers=(set ship) own=ship now=@da]
    ^-  (each ~ term)
    [%& ~]
  ::
  ++  copy-pool
    |=  [=old=pin:gol title=@t chefs=(set ship) peons=(set ship) viewers=(set ship) own=ship now=@da]
    ^-  (each ~ term)
    [%& ~]
  ::
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
:: actually apply received updates
::
++  update
  |%
  ++  yoke-sequence
    |=  [=pin:gol =nex:gol]
    ^-  store:gol
    =/  pool  (~(got by pools.store) pin)
    =.  pool  (~(apply-nex pr pin pool) nex)
    store(pools (~(put by pools.store) pin pool))
  ::
  ++  new-goal
    |=  [=id:gol =goal:gol]
    ^-  store:gol
    =/  pin  (~(got by directory.store) id)
    (put-in-pool:gols pin id goal)
  ::
  ++  add-under
    |=  [=pin:gol mod=ship pid=id:gol cid=id:gol =goal:gol]
    ^-  store:gol
    =.  store  (put-in-pool:gols pin cid goal)
    =/  pool  (~(got by pools.store) pin)
    =/  out  (~(apply-sequence pr pin pool) mod [%held-yoke cid pid]~)
    ?-  -.out
      %|  ~&(p.out !!)
      %&  store(pools (~(put by pools.store) pin pool.p.out))
    ==
  ::
  ++  new-pool
    |=  [=pin:gol =pool:gol]
    ^-  store:gol
    store(pools (~(put by pools.store) pin pool))
  ::
  ++  delete-pool
    |=  =pin:gol
    ^-  store:gol
    :-  %-  ~(gas by *(map id:gol pin:gol))
        %+  murn  ~(tap by directory.store)
        |=  [=id:gol =pin:gol]
        ?:  =(pin ^pin)
          ~
        (some [id pin])
    (~(del by pools.store) pin)
  ::
  ++  delete-goal
    |=  =id:gol
    ^-  store:gol
    =/  pin  (~(got by directory.store) id)
    =/  pool  (~(got by pools.store) pin)
    :-  (~(del by directory.store) id)
    (~(put by pools.store) pin pool(goals (purge-goals:gols goals.pool id)))
  ::
  ++  edit-goal-desc
    |=  [=id:gol desc=@t]
    ^-  store:gol
    =/  pin  (~(got by directory.store) id)
    =/  pool  (~(got by pools.store) pin)
    =/  goal  (~(got by goals.pool) id)
    =+  [pin pool]=(put-goal:gols id goal(desc desc))
    store(pools (~(put by pools.store) pin pool))
  ::
  ++  edit-pool-title
    |=  [=pin:gol title=@t]
    ^-  store:gol
    =/  pool  (~(got by pools.store) pin)
    =.  pool  pool(title title)
    store(pools (~(put by pools.store) pin pool))
  ::
  ++  set-deadline
    |=  [=id:gol moment=(unit @da) mod=ship]
    ^-  store:gol
    =/  pin  (~(got by directory.store) id)
    =/  pool  (~(got by pools.store) pin)
    =/  out  (~(set-deadline pr pin pool) id moment mod)
    ?-  -.out
      %|  ~&(p.out !!)
      %&  store(pools (~(put by pools.store) pin p.out))
    ==
  ::
  ++  mark-actionable
    |=  [=id:gol mod=ship]
    ^-  store:gol
    =/  pin  (~(got by directory.store) id)
    =/  pool  (~(got by pools.store) pin)
    =/  out  (~(mark-actionable pr pin pool) id mod)
    ?-  -.out
      %|  ~&(p.out !!)
      %&  store(pools (~(put by pools.store) pin p.out))
    ==
  ::
  ++  unmark-actionable
    |=  [=id:gol mod=ship]
    ^-  store:gol
    =/  pin  (~(got by directory.store) id)
    =/  pool  (~(got by pools.store) pin)
    =/  out  (~(unmark-actionable pr pin pool) id mod)
    ?-  -.out
      %|  ~&(p.out !!)
      %&  store(pools (~(put by pools.store) pin p.out))
    ==
  ::
  ++  mark-complete
    |=  [=id:gol mod=ship]
    ^-  store:gol
    =/  pin  (~(got by directory.store) id)
    =/  pool  (~(got by pools.store) pin)
    =/  out  (~(mark-complete pr pin pool) id mod)
    ?-  -.out
      %|  ~&(p.out !!)
      %&  store(pools (~(put by pools.store) pin p.out))
    ==
  ::
  ++  unmark-complete
    |=  [=id:gol mod=ship]
    ^-  store:gol
    =/  pin  (~(got by directory.store) id)
    =/  pool  (~(got by pools.store) pin)
    =/  out  (~(unmark-complete pr pin pool) id mod)
    ?-  -.out
      %|  ~&(p.out !!)
      %&  store(pools (~(put by pools.store) pin p.out))
    ==
  ::
  ++  make-chef
    |=  [=id:gol chef=ship mod=ship]
    ^-  store:gol
    =/  goal  (got-goal:gols id)
    =+  [pin pool]=(put-goal:gols id goal(chefs (~(put in chefs.goal) chef)))
    store(pools (~(put by pools.store) pin pool))
  ::
  ++  make-peon
    |=  [=id:gol peon=ship mod=ship]
    ^-  store:gol
    =/  goal  (got-goal:gols id)
    =+  [pin pool]=(put-goal:gols id goal(peons (~(put in peons.goal) peon)))
    store(pools (~(put by pools.store) pin pool))
  --
--
