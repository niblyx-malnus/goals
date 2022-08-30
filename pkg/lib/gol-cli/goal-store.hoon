/-  gol=goal, goal-store
/+  *gol-cli-goal, gol-cli-goals, pr=gol-cli-project
|_  =store:gol
+*  gols   ~(. gol-cli-goals +<)  
::
++  update-store
  |=  [=pin:gol =project:gol]
  ^-  store:gol
  :_  (~(put by projects.store) pin project)
  (update-dir:gols pin ~(key by goals.project))
::
:: create a new empty project with title, initial viewers, chefs, and peons
:: chefs and peons immediately added as viewers
++  new-project
  |=  [title=@t chefs=(set ship) peons=(set ship) viewers=(set ship) own=ship now=@da]
  ^-  store-update:goal-store
  =/  check  (new-project:check +<)
  ?.  -.check  ~&(+.check !!)
  =+  [pin project]=(new-project:gols title chefs peons viewers own now)
  [pin [%project-update project] store(projects (~(put by projects.store) pin project))]
::
++  delete-project
  |=  [=pin:gol mod=ship]
  ^-  store:gol
  :-  (update-dir:gols pin ~)
  (~(del by projects.store) pin)
::
++  archive-project  10
::
++  copy-project
  |=  [=old=pin:gol title=@t chefs=(set ship) peons=(set ship) viewers=(set ship) own=ship now=@da]
  ^-  store-update:goal-store
  =/  check  (copy-project:check +<)
  ?.  -.check  ~&(+.check !!)
  =+  [pin project]=(copy-project:gols old-pin title chefs peons viewers own now)
  [pin [%project-update project] (update-store pin project)]
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
  ^-  store-update:goal-store
  =/  check  (new-goal:check +<)
  ?.  -.check  ~&(+.check !!)
  =/  id  (unique-id:gols [owner.pin now])
  =|  =goal:gol
  =.  desc.goal  desc
  =.  chefs.goal  chefs
  =.  peons.goal  peons
  =.  moment.deadline.goal  deadline
  =.  actionable.goal  actionable
  =.  author.goal  mod
  =.  outflow.kickoff.goal  (~(put in *(set eid:gol)) [%d id])
  =.  inflow.deadline.goal  (~(put in *(set eid:gol)) [%k id])
  =.  store  (put-in-project:gols pin id goal)
  [pin [%new-goal pin mod id goal] store]
::
++  delete-goal
  |=  [=id:gol mod=ship]
  ^-  store:gol
  =/  check  (delete-goal:check +<)
  ?.  -.check  ~&(+.check !!)
  =/  pin  (~(got by directory.store) id)
  =/  project  (~(got by projects.store) pin)
  :-  (~(del by directory.store) id)
  (~(put by projects.store) pin project(goals (purge-goals:gols goals.project id)))
::
:: create a new goal and add to goals, nesting under par
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
  ^-  store-update:goal-store
  =/  check  (add-under:check +<)
  ?.  -.check  ~&(+.check !!)
  =/  pin  (~(got by directory.store) pid)
  =/  cid  (unique-id:gols owner.pin now)
  =|  =goal:gol
  =.  desc.goal  desc
  =.  chefs.goal  chefs
  =.  peons.goal  peons
  =.  moment.deadline.goal  deadline
  =.  actionable.goal  actionable
  =.  author.goal  mod
  =.  outflow.kickoff.goal  (~(put in *(set eid:gol)) [%d cid])
  =.  inflow.deadline.goal  (~(put in *(set eid:gol)) [%k cid])
  =.  store  (put-in-project:gols pin cid goal)
  =/  project  (~(got by projects.store) pin)
  =/  as  (~(apply-sequence pr pin project) mod [%held-yoke cid pid]~)
  ?-    -.as
    %|  ~&(+.as !!)
      %&
    =.  projects.store  (~(put by projects.store) pin p.as)
    [pin [%add-under pin mod pid cid goal] store]
  ==
::
++  edit-goal-desc
  |=  [=id:gol desc=@t mod=ship]
  ^-  store-update:goal-store
  =/  check  (edit-goal-desc:check +<)
  ?.  -.check  ~&(+.check !!)
  =/  goal  (got-goal:gols id)
  =+  [pin project]=(put-goal:gols id goal(desc desc))
  [pin [%project-update project] store(projects (~(put by projects.store) pin project))]
:: 
++  edit-project-title
  |=  [=pin:gol title=@t mod=ship]
  ^-  store-update:goal-store
  =/  check  (edit-project-title:check +<)
  ?.  -.check  ~&(+.check !!)
  =/  project  (~(got by projects.store) pin)
  =.  project  project(title title)
  [pin [%project-update project] store(projects (~(put by projects.store) pin project))]
::
++  mark-actionable
  |=  [=id:gol mod=ship]
  ^-  store-update:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  project  (~(got by projects.store) pin)
  =/  ma  (~(mark-actionable pr pin project) id mod)
  ?-    -.ma
    %|  ~&(+.ma !!)
      %&
    =.  projects.store  (~(put by projects.store) pin p.ma)
    [pin [%project-update (~(got by projects.store) pin)] store]
  ==
::
++  unmark-actionable
  |=  [=id:gol mod=ship]
  ^-  store-update:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  project  (~(got by projects.store) pin)
  =/  ua  (~(unmark-actionable pr pin project) id mod)
  ?-    -.ua
    %|  ~&(+.ua !!)
      %&
    =.  projects.store  (~(put by projects.store) pin p.ua)
    [pin [%project-update (~(got by projects.store) pin)] store]
  ==
::
++  mark-complete
  |=  [=id:gol mod=ship]
  ^-  store-update:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  project  (~(got by projects.store) pin)
  =/  mc  (~(mark-complete pr pin project) id mod)
  ?-    -.mc
    %|  ~&(+.mc !!)
      %&
    =.  projects.store  (~(put by projects.store) pin p.mc)
    [pin [%project-update (~(got by projects.store) pin)] store]
  ==
::
++  unmark-complete
  |=  [=id:gol mod=ship]
  ^-  store-update:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  project  (~(got by projects.store) pin)
  =/  uc  (~(unmark-complete pr pin project) id mod)
  ?-    -.uc
    %|  ~&(+.uc !!)
      %&
    =.  projects.store  (~(put by projects.store) pin p.uc)
    [pin [%project-update (~(got by projects.store) pin)] store]
  ==
::
++  set-deadline
  |=  [=id:gol moment=(unit @da) mod=ship]
  ^-  store-update:goal-store
  =/  pin  (~(got by directory.store) id)
  =/  project  (~(got by projects.store) pin)
  =/  sd  (~(set-deadline pr pin project) id moment mod)
  ?-    -.sd
    %|  ~&(+.sd !!)
      %&
    =.  projects.store  (~(put by projects.store) pin p.sd)
    [pin [%project-update p.sd] store]
  ==
::
++  put-viewer
  |=  [=pin:gol invitee=ship mod=ship]
  ^-  store-update:goal-store
  =/  check  (put-viewer:check +<)
  ?.  -.check  ~&(+.check !!)
  =/  project  (~(got by projects.store) pin)
  =.  project  project(viewers (~(put in viewers.project) invitee))
  [pin [%project-update project] store(projects (~(put by projects.store) pin project))]
::
++  make-chef
  |=  [=id:gol chef=ship mod=ship]
  ^-  store-update:goal-store
  =/  check  (make-chef:check +<)
  ?.  -.check  ~&(+.check !!)
  =/  goal  (got-goal:gols id)
  =+  [pin project]=(put-goal:gols id goal(chefs (~(put in chefs.goal) chef)))
  [pin [%project-update project] store(projects (~(put by projects.store) pin project))]
::
++  make-peon
  |=  [=id:gol peon=ship mod=ship]
  ^-  store-update:goal-store
  =/  check  (make-peon:check +<)
  ?.  -.check  ~&(+.check !!)
  =/  goal  (got-goal:gols id)
  =+  [pin project]=(put-goal:gols id goal(peons (~(put in peons.goal) peon)))
  [pin [%project-update project] store(projects (~(put by projects.store) pin project))]
::
++  apply-sequence
  |=  [=pin:gol mod=ship seq=yoke-sequence:gol]
  ^-  store-update:goal-store
  =/  project  (~(got by projects.store) pin)
  =/  as  (~(apply-sequence pr pin project) mod seq)
  ?-    -.as
    %|  ~&(+.as !!)
      %&
    =.  projects.store  (~(put by projects.store) pin p.as)
    [pin [%yoke-sequence pin mod seq] store]
  ==
::
++  check-goal-perm
  |=  [mod=ship =goal-perm:gol =id:gol]
  ^-  ?
  =/  pin  (~(got by directory.store) id)
  =/  project-owner  +<:pin
  =/  project-chefs  chefs:(~(got by projects.store) pin)
  =/  typical
    ?:  ?|  =(mod project-owner)
            (~(has in project-chefs) mod)
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
++  check-project-perm
  |=  [mod=ship =project-perm:gol =pin:gol]
  ^-  ?
  =/  project-owner  +<:pin
  =/  project-chefs  chefs:(~(got by projects.store) pin)
  =/  typical
    ?:  |(=(mod project-owner) (~(has in project-chefs) mod))  %.y  %.n
  ?-  project-perm
    %mod-viewers  typical
    %edit-title   typical
    %new-goal     typical
  ==
::
++  check
  |%
  ++  new-project
    |=  [title=@t chefs=(set ship) peons=(set ship) viewers=(set ship) own=ship now=@da]
    ^-  (each ~ term)
    [%& ~]
  ::
  ++  copy-project
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
    ?.  (check-project-perm mod %new-goal pin)  [%| %perm-fail]
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
  ++  edit-project-title
    |=  [=pin:gol title=@t mod=ship]
    ^-  (each ~ term)
    ?.  (check-project-perm mod %edit-title pin)  [%| %perm-fail]
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
    ?.  (~(has by projects.store) pin)  [%| %not-project]
    ?.  (check-project-perm mod %mod-viewers pin)  [%| %perm-fail]
    [%& ~]
  ::
  ++  make-chef
    |=  [=id:gol chef=ship mod=ship]
    ^-  (each ~ term)
    ?.  (check-goal-perm mod %mod-chefs id)  [%| %perm-fail]
    ?.  (~(has in viewers:(~(got by projects.store) (~(got by directory.store) id))) chef)
      [%| %not-viewer]
    [%& ~]
  ::
  ++  make-peon
    |=  [=id:gol peon=ship mod=ship]
    ^-  (each ~ term)
    ?.  (check-goal-perm mod %mod-peons id)
      [%| %perm-fail]
    ?.  (~(has in viewers:(~(got by projects.store) (~(got by directory.store) id))) peon)
      [%| %not-viewer]
    [%& ~]
  --
::
++  update
  |%
  ++  yoke-sequence
    |=  [=pin:gol mod=ship seq=yoke-sequence:gol]
    =/  project  (~(got by projects.store) pin)
    =/  as  (~(apply-sequence pr pin project) mod seq)
    ?-    -.as
      %|  ~&(+.as !!)
        %&
      =.  projects.store  (~(put by projects.store) pin p.as)
      store
    ==
  ::
  ++  new-goal
    |=  [=pin:gol mod=ship =id:gol =goal:gol]
    ^-  store:gol
    (put-in-project:gols pin id goal)
  ::
  ++  add-under
    |=  [=pin:gol mod=ship pid=id:gol cid=id:gol =goal:gol]
    ^-  store:gol
    =.  store  (put-in-project:gols pin cid goal)
    =/  project  (~(got by projects.store) pin)
    =/  as  (~(apply-sequence pr pin project) mod [%held-yoke cid pid]~)
    ?-    -.as
      %|  ~&(+.as !!)
        %&
      =.  projects.store  (~(put by projects.store) pin p.as)
      store
    ==
  --
--
