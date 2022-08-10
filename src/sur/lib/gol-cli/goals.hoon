/-  gol=goal, vyu=view
/+  *gol-cli-goal
=|  =goals:gol
|_  store:gol
+*  store  +<
::
++  update-store
  |=  [=pin:gol =project:gol]
  ^-  store:gol
  :_  (~(put by projects) pin project)
  (update-dir pin ~(key by goals.project))
::
++  update-dir
  |=  [target=pin:gol sources=(set id:gol)]
  ^-  directory:gol
  =/  dir
    %-  ~(gas by *directory:gol)
    %+  murn  ~(tap by directory)
    |=  [a=id:gol b=pin:gol]
    ?:(=(b target) ~ (some [a b]))
  =/  pairs  (turn ~(tap in sources) |=(=id:gol [id target]))
  (~(gas by dir) pairs)
::
:: create unique goal id based on source ship and creation time
++  unique-id
  |=  [our=ship now=@da]
  ?.  ?|  (~(has by directory) [our now])
          (~(has by projects) [%pin our now])
      ==
    [our now]
  $(now (add now ~s0..0001))
::
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
  ^-  store-update:gol
  =/  perm  (check-project-perm mod %new-goal pin)
  ?-    -.perm
    %|  perm
      %&
    =/  id  (unique-id [owner.pin now])
    =|  =goal:gol
    =.  desc.goal  desc
    =.  chefs.goal  chefs
    =.  peons.goal  peons
    =.  deadline.goal  deadline
    =.  actionable.goal  actionable
    =.  store  (put-in-project pin id goal)
    =/  project  (~(got by projects) pin)
    [%& [pin project] store]
  ==
::
:: gets the stored goal associated with the goal id and crashes if does
:: not exist
++  got-goal
  |=  =id:gol
  ^-  goal:gol
  =/  pin  (~(got by directory) id)
  =/  project  (~(got by projects.store) pin)
  (~(got by goals.project) id)
::
:: replace the goal at given id with given goal
++  put-goal
  |=  [=id:gol =goal:gol]
  ^-  [pin:gol project:gol]
  =/  pin  (~(got by directory) id)
  =/  project  (~(got by projects) pin)
  [pin project(goals (~(put by goals.project) id goal))]
::
:: put a new goal in a specific project
++  put-in-project
  |=  [=pin:gol =id:gol =goal:gol]
  ^-  store:gol
  =/  project  (~(got by projects) pin)
  =.  goals.project  (~(put by goals.project) id goal)
  :_  (~(put by projects) pin project)
  (update-dir pin ~(key by goals.project))
::
:: gets parent of goal if it exists, otherwise returns null
++  get-par
  |=  =goal:gol
  ^-  (unit id:gol)
  *(unit id:gol)
::
:: create a new empty project with title, initial viewers, chefs, and peons
:: chefs and peons immediately added as viewers
++  new-project
  |=  [title=@t chefs=(set ship) peons=(set ship) viewers=(set ship) own=ship now=@da]
  ^-  store-update:gol
  =/  pin  [%pin (unique-id own now)]
  =|  =project:gol
  =.  title.project  title
  =.  creator.project  own
  =.  chefs.project  chefs
  =.  peons.project  peons
  =.  viewers.project  (~(uni in viewers) (~(uni in chefs) peons))
  [%& [pin project] store(projects (~(put by projects) pin project))]
::
++  edit-goal-desc
  |=  [=id:gol desc=@t mod=ship]
  ^-  store-update:gol
  =/  perm  (check-goal-perm mod %edit-desc id)
  ?-    -.perm
    %|  perm
      %&
    =/  goal  (got-goal id)
    =+  [pin project]=(put-goal id goal(desc desc))
    [%& [pin project] store(projects (~(put by projects) pin project))]
  ==
::
++  edit-project-title
  |=  [=pin:gol title=@t mod=ship]
  ^-  store-update:gol
  =/  perm  (check-project-perm mod %edit-title pin)
  ?-    -.perm
    %|  perm
      %&
    =/  project  (~(got by projects) pin)
    =.  project  project(title title)
    [%& [pin project] store(projects (~(put by projects) pin project))]
  ==
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
  ^-  store-update:gol
  =/  perm  (check-goal-perm mod %add-under pid)
  ?-    -.perm
    %|  perm
      %&
    =/  pin  (~(got by directory) pid)
    =/  cid  (unique-id owner.pin now)
    =|  =goal:gol
    =.  desc.goal  desc
    =.  chefs.goal  chefs
    =.  peons.goal  peons
    =.  deadline.goal  deadline
    =.  actionable.goal  actionable
    =.  store  (put-in-project pin cid goal)
    =/  yoke  (held-yoke-safe cid pid %0)
    ?-    -.yoke
        %&  
      =/  project  (~(got by projects.yoke) pin)
      [%& [pin project] directory projects.yoke]
        %|
      [%| error.yoke]
    ==
  ==
::
++  held-yoke-update
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  store-update:gol
  =/  pin  (~(got by directory) lid)
  ?.  =(pin (~(got by directory) rid))  [%| %m %diff-proj]
  =/  perm  (check-pair-perm mod %& lid rid)
  ?-    -.perm
    %|  perm
      %&
    =/  yoke  (held-yoke-safe lid rid %0)
    ?-    -.yoke
        %&  
      =/  project  (~(got by projects.yoke) pin)
      [%& [pin project] directory projects.yoke]
        %|
      [%| error.yoke]
    ==
  ==
::
++  check-pair-perm
  |=  [mod=ship =pair-perm:gol lid=id:gol rid=id:gol]
  ^-  $%([%& ~] [%| =error:gol])
  =/  pin  (~(got by directory) lid)
  ?.  =(pin (~(got by directory) rid))  [%| %m %diff-proj-perm-fail]
  =/  project-owner  +<:pin
  =/  project-chefs  chefs:(~(got by projects) pin)
  ?:  |(=(project-owner mod) (~(has in project-chefs) mod))  [%& ~]
  =/  l  (seniority mod lid ~ ~)
  ?-  -.l
    %|  l
  %&  =/  r  (seniority mod rid ~ ~)
  ?-  -.r
    %|  r
  %&  ?.  =(senior.l senior.r)  [%| %m %diff-sen-perm-fail]
  ?~  senior.l  [%| %m %null-sen-perm-fail]
  ?:  =(lid u.senior.l)  [%| %m %no-left-perm-perm-fail]  [%& ~]
  ==  ==
::
++  check-goal-perm
  |=  [mod=ship =goal-perm:gol =id:gol]
  ^-  $%([%& ~] [%| =error:gol])
  =/  pin  (~(got by directory) id)
  =/  project-owner  +<:pin
  =/  project-chefs  chefs:(~(got by projects) pin)
  =/  goal-chefs  +:(get-chefs id)
  =/  chefs  (~(uni in goal-chefs) project-chefs)
  =/  typical
    ?:  |(=(mod project-owner) (~(has in chefs) mod))
      [%& ~]
    [%| %m %perm-fail]
  ?-    goal-perm
    %mod-chefs    typical
    %mod-peons    typical
    %add-under    typical
    %remove       typical
    %edit-desc    typical
  ==
::
++  check-project-perm
  |=  [mod=ship =project-perm:gol =pin:gol]
  ^-  $%([%& ~] [%| =error:gol])
  =/  project-owner  +<:pin
  =/  project-chefs  chefs:(~(got by projects) pin)
  =/  typical
    ?:  |(=(mod project-owner) (~(has in project-chefs) mod))
      [%& ~]
    [%| %m %perm-fail]
  ?-  project-perm
    %mod-viewers  typical
    %edit-title   typical
    %new-goal     typical
  ==
::
:: find the oldest ancestor of this goal for which you are a chef
++  seniority
  |=  [mod=ship =id:gol senior=(unit id:gol) path=(list id:gol)]
  ^-  $%([%& senior=(unit id:gol)] [%| =error:gol])
  =/  new-path  (flop `(list id:gol)`[id (flop path)])
  =/  i  (find [id]~ path) 
  ?.  =(~ i)  ?~(i !! [%| %c (slag u.i `(list id:gol)`new-path)])
  =.  senior
    ?:  (~(has in chefs:(got-goal id)) mod)
      (some id)
    senior
  =/  par  par:(got-goal id)
  ?~  par  [%& senior]
  (seniority mod u.par senior path)
::
++  put-viewer
  |=  [=pin:gol invitee=ship mod=ship]
  ^-  store-update:gol
  ?.  (~(has by projects) pin)
    [%| %m %not-project]
  =/  perm  (check-project-perm mod %mod-viewers pin)
  ?-    -.perm
    %|  perm
      %&
    =/  project  (~(got by projects) pin)
    =.  project  project(viewers (~(put in viewers.project) invitee))
    [%& [pin project] (update-store pin project)]
  ==
::
:: deleting goals
::
:: moving goals
::
::
++  make-chef
  |=  [=id:gol chef=ship mod=ship]
  ^-  store-update:gol
  ?.  (~(has by directory) id)
    [%| %m %miss-goal]
  =/  perm  (check-goal-perm mod %mod-chefs id)
  ?-    -.perm
    %|  perm
      %&
    ?.  (~(has in viewers:(~(got by projects) (~(got by directory) id))) chef)
      [%| %m %not-viewer]
    =/  goal  (got-goal id)
    =+  [pin project]=(put-goal id goal(chefs (~(put in chefs.goal) chef)))
    [%& [pin project] (update-store pin project)]
  ==
::
++  make-peon
  |=  [=id:gol peon=ship mod=ship]
  ^-  store-update:gol
  ?.  (~(has by directory) id)
    [%| %m %miss-goal]
  =/  perm  (check-goal-perm mod %mod-peons id)
  ?-    -.perm
    %|  perm
      %&
    ?.  (~(has in viewers:(~(got by projects) (~(got by directory) id))) peon)
      [%| %m %not-viewer]
    =/  goal  (got-goal id)
    =+  [pin project]=(put-goal id goal(peons (~(put in peons.goal) peon)))
    [%& [pin project] (update-store pin project)]
  ==
::
++  get-chefs
  |=  =id:gol
  ^-  [? (set ship)]
  |^
  (gc id *(set id:gol))
  ++  gc
    |=  [=id:gol checked=(set id:gol)]
    ^-  [? (set ship)]
    =/  goal  (got-goal id)
    ?~  par.goal
      [%& chefs.goal]
    ?:  (~(has in checked) u.par.goal)
      [%| *(set ship)]
    =.  checked  (~(put in checked) id)
    [%& (~(uni in chefs.goal) +:(gc u.par.goal checked))]
  --
::
++  get-peons
  |=  =id:gol
  ^-  [? (set ship)]
  |^
  (gp id *(set id:gol))
  ++  gp
    |=  [=id:gol checked=(set id:gol)]
    ^-  [? (set ship)]
    =/  goal  (got-goal id)
    ?~  par.goal
      [%& peons.goal]
    ?:  (~(has in checked) u.par.goal)
      [%| *(set ship)]
    =.  checked  (~(put in checked) id)
    [%& (~(uni in peons.goal) +:(gp u.par.goal checked))]
  --
::
:: comparison generator
:: always tries to go from b to a
++  cmp-gen
  |=  =getter
  |=  [lid=id:gol rid=id:gol]
  ^-  ?
  =/  gots  (getter (got-goal rid))
  ?:  =(0 ~(wyt in gots))   %|
  ?:  (~(has in gots) lid)  %&
  (~(any in gots) (cury (cmp-gen getter) lid))  
::
:: secure comparison generator
++  sec-cmp-gen
  |=  =getter
  |=  [lid=id:gol rid=id:gol path=(list id:gol)]
  ^-  comp-output:gol
  =/  new-path  (flop `(list id:gol)`[rid (flop path)])
  =/  i  (find [rid]~ path) 
  ?.  =(~ i)  ?~(i !! [%| %c (slag u.i `(list id:gol)`new-path)])
  =/  gots  (getter (got-goal rid))
  ?:  (~(has in gots) lid)  [%& %&]
  =/  idx  0
  =/  gots  ~(tap in gots)
  |-
  ?:  =(idx (lent gots))
    [%& %|]
  =/  out  ((sec-cmp-gen getter) lid (snag idx gots) new-path)
  ?-    -.out
    %|  out
      %&
    ?-  +.out
      %&  out
      %|  $(idx +(idx))
    ==
  ==
::
++  held-left  |=([a=id:gol b=id:gol] ((cmp-gen kids) a b))
++  held-ryte  |=([a=id:gol b=id:gol] ((cmp-gen parr) a b))
++  nest-left  |=([a=id:gol b=id:gol] ((cmp-gen yung) a b))
++  nest-ryte  |=([a=id:gol b=id:gol] ((cmp-gen olds) a b))
++  prec-left  |=([a=id:gol b=id:gol] ((cmp-gen prec) a b))
++  prec-ryte  |=([a=id:gol b=id:gol] ((cmp-gen succ) a b))
++  prio-left  |=([a=id:gol b=id:gol] ((cmp-gen prio) a b))
++  prio-ryte  |=([a=id:gol b=id:gol] ((cmp-gen demo) a b))
::
++  sec-held-left  |=([a=id:gol b=id:gol] ((sec-cmp-gen kids) a b ~))
++  sec-held-ryte  |=([a=id:gol b=id:gol] ((sec-cmp-gen parr) a b ~))
++  sec-nest-left  |=([a=id:gol b=id:gol] ((sec-cmp-gen nefs) a b ~))
++  sec-nest-ryte  |=([a=id:gol b=id:gol] ((sec-cmp-gen uncs) a b ~))
++  sec-prec-left  |=([a=id:gol b=id:gol] ((sec-cmp-gen prec) a b ~))
++  sec-prec-ryte  |=([a=id:gol b=id:gol] ((sec-cmp-gen succ) a b ~))
++  sec-prio-left  |=([a=id:gol b=id:gol] ((sec-cmp-gen prio) a b ~))
++  sec-prio-ryte  |=([a=id:gol b=id:gol] ((sec-cmp-gen demo) a b ~))
::
++  jab
  |=  =setter
  |=  =id:gol
  ^-  projects:gol
  (~(put by projects) (put-goal id (setter (got-goal id))))
::
++  prio-rend
  |=  [lid=id:gol rid=id:gol]
  ^-  projects:gol
  =.  projects  ((jab (del-moar lid)) rid)  ((jab (del-less rid)) lid)
::
++  prio-yoke
  |=  [lid=id:gol rid=id:gol]
  ^-  projects:gol
  =.  projects  ((jab (put-moar lid)) rid)  ((jab (put-less rid)) lid)
::
++  prec-rend
  |=  [lid=id:gol rid=id:gol]
  ^-  projects:gol
  =.  projects  ((jab (del-befs lid)) rid)  ((jab (del-afts rid)) lid)
::
++  prec-yoke
  |=  [lid=id:gol rid=id:gol]
  ^-  projects:gol
  =.  projects  ((jab (put-befs lid)) rid)  ((jab (put-afts rid)) lid)
::
++  nest-rend
  |=  [lid=id:gol rid=id:gol]
  ^-  projects:gol
  =.  projects  ((jab (del-nefs lid)) rid)  ((jab (del-uncs rid)) lid)
::
++  nest-yoke
  |=  [lid=id:gol rid=id:gol]
  ^-  projects:gol
  =.  projects  ((jab (put-nefs lid)) rid)  ((jab (put-uncs rid)) lid)
::
++  held-rend
  |=  [lid=id:gol rid=id:gol]
  ^-  projects:gol
  =.  projects  ((jab (del-kids lid)) rid)  ((jab (del-par (some rid))) lid)
:: 
++  held-yoke
  |=  [lid=id:gol rid=id:gol]
  ^-  projects:gol
  =/  par  par:(got-goal lid)
  =.  projects  ?~(par projects (held-rend lid u.par))
  =.  projects  ((jab (put-kids lid)) rid)  ((jab (put-par (some rid))) lid)
::
++  one-to-many
  |=  =linker:gol
  |=  [lid=id:gol =(set id:gol)]
  ^-  projects:gol
  =/  idx  0
  =/  list  ~(tap in set)
  |-
  ?:  =(idx (lent list))
    projects
  $(projects (linker lid (snag idx list)))
::
++  many-to-one
  |=  =linker:gol
  |=  [=(set id:gol) rid=id:gol]
  ^-  projects:gol
  =/  idx  0
  =/  list  ~(tap in set)
  |-
  ?:  =(idx (lent list))
    projects
  $(projects (linker (snag idx list) rid))
::
++  many-to-many
  |=  =linker:gol
  |=  [=l=(set id:gol) =r=(set id:gol)]
  ^-  projects:gol
  =/  idx  0
  =/  list  ~(tap in l-set)
  |-
  ?:  =(idx (lent list))
    projects
  $(projects ((one-to-many linker) (snag 0 list) r-set))
::
++  any-in
  |=  =comparator:gol
  |=  [=(set id:gol) rid=id:gol]
  ^-  comp-output:gol
  =/  idx  0
  =/  list  ~(tap in set)
  |-
  ?:  =(idx (lent list))
    [%& %|]
  =/  out  (comparator (snag idx list) rid)
  ?-    -.out
    %|  out
      %&
    ?-  +.out
      %&  out
      %|  $(idx +(idx))
    ==
  ==
::
++  prio-yoke-force
  |=  [lid=id:gol rid=id:gol]
  ^-  yoke-output:gol
  |^
  =/  comp  (sec-prio-left rid lid)
  ?-  -.comp
    %|  comp
  %&  ?>  +.comp
  :: Cannot prio-yoke: R prec-left L
  =/  comp  (sec-prec-left rid lid)
  ?-  -.comp
    %|  comp
  %&  ?:  +.comp  [%| %m %prec-left]
  :: if r prio-left goals which are prec-left of l
  =/  l  (got-goal lid)
  :: Cannot prio-yoke if R prio-left of goals prec-left of L.
  =/  comp  ((any-in sec-prio-left) (prec l) rid)
  ?-  -.comp
    %|  comp
  %&  ?:  +.comp  [%| %m %prio-prec]
  =/  r  (got-goal rid)
  :: ids in moar.l which are prio-ryte of r
  =/  morr  (sy (skim ~(tap in moar.l) r-check))
  =.  projects  (prio-rend rid lid)
  =.  projects  ((many-to-one prio-rend) morr lid)
  =.  projects  ((many-to-many prio-yoke) morr (demo l))
  =.  projects  ((many-to-one prio-yoke) (prio r) lid)
  =.  projects  (prio-yoke lid rid)
  :: assert successful flip
  =/  comp  (sec-prio-left lid rid)
  ?-  -.comp
    %|  comp
  %&  ?.  +.comp  [%| %m %prio-yoke-force-fail]
  [%& projects]
  ==  ==  ==  ==
  ::
  :: check if an id is rid or if rid is prio-left of a given id
  ++  r-check
    |=  =id:gol
    ?:  =(id rid)  %.y
    (prio-left rid id)
  --
::
:: Force precedent, only swapping precedence relationship
++  prec-yoke-force
  |=  [lid=id:gol rid=id:gol]
  ^-  yoke-output:gol
  |^
  ?>  (prec-left rid lid)
  :: Cannot prec-yoke: R nest-left L
  ?:  (nest-left rid lid)  [%| %m %nest-left]
  :: if r prec-left goals which are nest-left of l
  =/  l  (got-goal lid)
  :: Cannot prec-yoke: R prec-left of goals nest-left of L.
  ?:  (~(any in nefs.l) (cury prec-left rid))  [%| %m %prec-nest]
  =/  r  (got-goal rid)
  :: ids in befs.l which are prec-ryte of r
  =/  befr  (sy (skim ~(tap in befs.l) r-check))
  =.  projects  (prec-rend rid lid)
  =.  projects  ((many-to-one prec-rend) befr lid)
  =.  projects  ((many-to-many prec-yoke) befr (succ l))
  =.  projects  ((many-to-one prec-yoke) (prec r) lid)
  =.  projects  (prec-yoke lid rid)
  :: assert successful flip
  ?.  (prec-left lid rid)  [%| %m %prio-yoke-force-fail]
  :: if necessary, prio-yoke-force
  ?:  (prio-left rid lid)  (prio-yoke-force lid rid)
  [%& projects]
  ::
  :: check if an id is rid or if rid is prec-left of a given id
  ++  r-check
    |=  =id:gol
    ?:  =(id rid)  %.y
    (prec-left rid id)
  --
::
:: Force nest, only swapping nesting relationship
++  nest-yoke-force
  |=  [lid=id:gol rid=id:gol]
  ^-  yoke-output:gol
  |^
  ?>  (nest-left rid lid)
  :: Cannot nest-yoke: R held-left L
  ?:  (held-left rid lid)  [%| %m %held-left]
  :: if r nest-left goals which are held-left of l
  =/  l  (got-goal lid)
  :: Cannot nest-yoke: R nest-left of goals held-left of L.
  ?:  (~(any in kids.l) (cury nest-left rid))  [%| %m %nest-held]
  =/  r  (got-goal rid)
  :: ids in nefs.l which are nest-ryte of r
  =/  nefr  (sy (skim ~(tap in nefs.l) r-check))
  =.  projects  (nest-rend rid lid)
  =.  projects  ((many-to-one nest-rend) nefr lid)
  =.  projects  ((many-to-many nest-yoke) nefr (olds l))
  =.  projects  (nest-yoke lid rid)
  :: assert successful flip
  ?.  (nest-left lid rid)  [%| %m %nest-yoke-force-fail]
  :: if necessary, prec-yoke-force
  ?:  (prec-left rid lid)  (prec-yoke-force lid rid)
  [%& projects]
  ::
  :: check if an id is rid or if rid is nest-left of a given id
  ++  r-check
    |=  =id:gol
    ?:  =(id rid)  %.y
    (nest-left rid id)
  --
::
:: Force held, only swapping holding relationship
++  held-yoke-force
  |=  [lid=id:gol rid=id:gol]
  ^-  yoke-output:gol
  |^
  ?>  (held-left rid lid)
  =/  l  (got-goal lid)
  =/  r  (got-goal rid)
  =/  kidr  (skim ~(tap in kids.l) r-check)
  =.  projects  (nest-rend rid lid)
  ?.  =(1 (lent kidr))  [%| %m %uniq-kidr-fail]
  =/  kid  (snag 0 kidr)
  =.  projects  (held-rend rid lid)
  =.  projects  (held-rend kid lid)
  =.  projects  ?~(par.l projects (held-yoke kid u.par.l))
  =.  projects  (held-yoke lid rid)
  :: assert successful flip
  ?.  (held-left lid rid)  [%| %m %held-yoke-force-fail]
  :: if necessary, nest-yoke-force
  ?:  (nest-left rid lid)  (nest-yoke-force lid rid)
  [%& projects]
  ::
  :: check if an id is rid or if rid is held-left of a given id
  ++  r-check
    |=  =id:gol
    ?:  =(id rid)  %.y
    (held-left rid id)
  --
::
:: prio-yoke left goal to right goal
:: so that left goal is prio-left of right goal
++  prio-yoke-safe
  |=  [lid=id:gol rid=id:gol timidity=?(%1 %0)]
  :: Cannot prio-yoke goal to itself
  ?:  =(lid rid)  [%| %m %self]
  ?-  timidity
      %1
    :: Cannot prio-yoke: R prio-left of L
    ?:  (prio-left rid lid)  [%| %m %prio-left]
    [%& (prio-yoke lid rid)]
      %0
    ?:  (prio-left rid lid)  (prio-yoke-force lid rid)
    [%& (prio-yoke lid rid)]
  ==
::
:: prec-yoke left goal to right goal
++  prec-yoke-safe
  |=  [lid=id:gol rid=id:gol timidity=?(%2 %1 %0)]
  ^-  yoke-output:gol
  :: Cannot prec-yoke goal to itself
  ?:  =(lid rid)  [%| %m %self]
  ?-  timidity
      %2
    :: Cannot prec-yoke: R prio-left of L
    ?:  (prio-left rid lid)  [%| %m %prio-left]
    [%& (prec-yoke lid rid)]
      %1
    :: Cannot prec-yoke: R prec-left of L
    ?:  (prec-left rid lid)  [%| %m %prec-left]
    =.  projects  (prec-yoke lid rid)
    ?:  (prio-left rid lid)  (prio-yoke-force lid rid) 
    [%& projects]
      %0
    ?:  (prec-left rid lid)  (prec-yoke-force lid rid)
    =.  projects  (prec-yoke lid rid)
    ?:  (prio-left rid lid)  (prio-yoke-force lid rid)
    [%& projects]
  ==
::
:: nest-yoke left goal to right goal
++  nest-yoke-safe
  |=  [lid=id:gol rid=id:gol timidity=?(%3 %2 %1 %0)]
  ^-  yoke-output:gol
  ?:  =(lid rid)  [%| %m %self]
  ?:  actionable:(got-goal rid)  [%| %m %act-unc]
  ?-  timidity
      %3
    ?:  (prio-left rid lid)  [%| %m %prio-left]
    [%& (nest-yoke lid rid)]
      %2
    ?:  (prec-left rid lid)  [%| %m %prec-left]
    =.  projects  (nest-yoke lid rid)
    ?:  (prio-left rid lid)  (prio-yoke-force lid rid)
    [%& projects]
      %1
    ?:  (nest-left rid lid)  [%| %m %nest-left]
    =.  projects  (nest-yoke lid rid)
    ?:  (prec-left rid lid)  (prec-yoke-force lid rid)
    ?:  (prio-left rid lid)  (prio-yoke-force lid rid)
    [%& projects]
      %0
    ?:  (nest-left rid lid)  (nest-yoke-force lid rid)
    =.  projects  (nest-yoke lid rid)
    ?:  (prec-left rid lid)  (prec-yoke-force lid rid)
    ?:  (prio-left rid lid)  (prio-yoke-force lid rid)
    [%& projects]
  ==
::
:: held-yoke left goal to right goal
++  held-yoke-safe
  |=  [lid=id:gol rid=id:gol timidity=?(%4 %3 %2 %1 %0)]
  ^-  yoke-output:gol
  ?:  =(lid rid)  [%| %m %self]
  ?:  actionable:(got-goal rid)  [%| %m %act-par]
  ?-  timidity
      %4
    ?:  (prio-left rid lid)  [%| %m %prio-left]
    [%& (held-yoke lid rid)]
      %3
    ?:  (prec-left rid lid)  [%| %m %prec-left]
    =.  projects  (held-yoke lid rid)
    ?:  (prio-left rid lid)  (prio-yoke-force lid rid)
    [%& projects]
      %2
    ?:  (nest-left rid lid)  [%| %m %nest-left]
    =.  projects  (held-yoke lid rid)
    ?:  (prec-left rid lid)  (prec-yoke-force lid rid)
    ?:  (prio-left rid lid)  (prio-yoke-force lid rid)
    [%& projects]
      %1
    ?:  (held-left rid lid)  [%| %m %held-left]
    =.  projects  (held-yoke lid rid)
    ?:  (nest-left rid lid)  (nest-yoke-force lid rid)
    ?:  (prec-left rid lid)  (prec-yoke-force lid rid)
    ?:  (prio-left rid lid)  (prio-yoke-force lid rid)
    [%& projects]
      %0
    ?:  (held-left rid lid)  (held-yoke-force lid rid)
    =.  projects  (held-yoke lid rid)
    ?:  (nest-left rid lid)  (nest-yoke-force lid rid)
    ?:  (prec-left rid lid)  (prec-yoke-force lid rid)
    ?:  (prio-left rid lid)  (prio-yoke-force lid rid)
    [%& projects]
  ==
::
::  get depth of a given goal (lowest level is depth of 1)
++  plumb
  |=  =id:gol
  ^-  @ud
  =/  goal  (got-goal id)
  =/  lvl  1
  =/  gots  (yung goal)
  ?:  =(0 ~(wyt in gots))  lvl :: if childless, depth of 1
  =/  idx  0
  =/  gots  ~(tap in gots)
  |-
  ?:  =(idx (lent gots))  +(lvl) :: add 1 to maximum child depth
  $(idx +(idx), lvl (max lvl ^$(id (snag idx gots))))
::
:: get roots
++  roots
  |=  =goals:gol
  ^-  (list id:gol)
  %:  turn
  (skim ~(tap by goals) |=([id:gol =goal:gol] &(=(~ par.goal) =(0 ~(wyt in uncs.goal)))))
  |=([=id:gol goal:gol] id)
  ==
::
:: get max depth + 1; depth of "virtual" root node
++  anchor  
  |=  =goals:gol
  ^-  @ud
  +((roll (turn (roots goals) plumb) max))
::
++  project-anchor
  ^-  @ud
  %+  roll
  (turn ~(val by (~(run by projects) |=(=project:gol goals.project))) anchor)
  max
::
:: get priority of a given goal (highest priority is 0)
:: priority is the number of goals prioritized ahead of a given goal
++  priority
  |=  =id:gol
  |^
  ~(wyt in (prios id))
  ++  prios
    |=  =id:gol
    ^-  (set id:gol)
    =/  goal  (got-goal id)
    =/  prio  (prio goal)
    =/  idx  0
    =/  output  prio
    =/  prio  ~(tap in prio)
    |-
    ?:  =(idx (lent prio))  output
    $(idx +(idx), output (~(uni in output) (prios (snag idx prio))))
  --
::
:: get lowest priority; priority of "virtual" root node
++  lowpri  ~(wyt by directory)
::
:: purge goal from goals and from nefs/uncs/befs/afts/moar/less
++  purge-goals
  |=  =id:gol
  ^-  goals:gol
  %-  %~  del
        by
      %-  ~(run by goals)
      |=  =goal:gol
      %=  goal
        nefs  (~(del in nefs.goal) id)
        uncs  (~(del in uncs.goal) id)
        befs  (~(del in befs.goal) id)
        afts  (~(del in afts.goal) id)
        moar  (~(del in moar.goal) id)
        less  (~(del in less.goal) id)
      ==
  id
::
:: get the number representing the deepest path to a leaf node
++  get-lvl
  |=  [=grip:vyu =dir:gol]
  ^-  @
  ?-    dir
    %nest-ryte  !!
      %nest-left
    ?-    -.grip
      %all  ~
      %project  (anchor goals:(~(got by projects) +.grip))
      %goal  (plumb +.grip)
    ==
    %nest-left-completed  !!
    %prec-ryte  !!
    %prec-left  !!
    %prio-ryte  !!
    %prio-left  !!
  ==
::
:: get either the children or the parents depending on dir
++  get-fam
  |=  [=grip:vyu =dir:gol]
  ^-  (list grip:vyu)
  ?-    dir
    %nest-ryte  !!
      %nest-left
    ?-    -.grip
      %all  (turn ~(tap in ~(key by projects)) |=(=pin:gol [%project pin]))
      %project  (turn (roots goals:(~(got by projects) +.grip)) |=(=id:gol [%goal id]))
        %goal
      =/  goal  (got-goal +.grip)
      (turn ~(tap in ((active yung) goal)) |=(=id:gol [%goal id]))
    ==
    %nest-left-completed  !!
    %prec-ryte  !!
    %prec-left  !!
    %prio-ryte  !!
    %prio-left  !!
  ==
::
::
++  harvest-gen
  |=  [getter=$-(goal:gol (set id:gol)) check=$-(id:gol ?)]
  |=  =id:gol
  ^-  (set id:gol)
  =/  gots  ~(tap in (getter (got-goal id)))
  =/  out  (~(gas in *(set id:gol)) (skim gots check))
  =/  idx  0
  |-
  ?:  =(idx (lent gots))
    out
  $(idx +(idx), out (~(uni in out) ((harvest-gen getter check) (snag idx gots))))
::
::
++  empt
  |=  getter=$-(goal:gol (set id:gol))
  |=  =id:gol
  =(0 ~(wyt in (getter (got-goal id))))
::
::
++  active
  |=  getter=$-(goal:gol (set id:gol))
  |=  =goal:gol
  %-  ~(gas in *(set id:gol))
  (skim ~(tap in (getter goal)) |=(=id:gol =(%active status:(got-goal id))))
::
::
++  completed
  |=  getter=$-(goal:gol (set id:gol))
  |=  =goal:gol
  %-  ~(gas in *(set id:gol))
  (skim ~(tap in (getter goal)) |=(=id:gol =(%completed status:(got-goal id))))
::
::
++  harvest-childless  |=(=id:gol ((harvest-gen (active nefs) (empt (active nefs))) id))
++  harvest-unpreceded  |=(=id:gol ((harvest-gen (active prec) (empt (active prec))) id))
++  harvest-actionable
  |^
  |=  =id:gol
  ((harvest-gen prec acbl) id)
  ++  acbl  
    |=(=id:gol actionable:(got-goal id))
  --
++  harvest-actionable-active
  |^
  |=  =id:gol
  ((harvest-gen (active prec) acav) id)
  ++  acav  
    |=  =id:gol
    =/  goal  (got-goal id)
    &(=(%active status:goal) actionable:goal)
  --
++  harvest-completed
  |^
  |=  =id:gol
  ((harvest-gen nefs cplt) id)
  ++  cplt  |=(=id:gol =(%completed status:(got-goal id)))
  --
:: be able to see history of goals completed....
:: goals completed in last day...
:: goals completed in last x period...
:: means need time associate with status changes...
:: harvest goals completed in last day, week, month, year, etc...
:: print goal structure of these goals...
:: A B
:: if i want to add a left arrow from B to A (A <- B) I have to check
:: that there is no path from A to B through left arrows
:: if B <- A, then this would give us A <- B <- A ; A <- A, which is a
:: degenerate case
:: suppose we have A, B, and C. Suppose B <- C  and C <- A
:: Thus we have B <- C <- A so B <- A. Okay so this case is handled
:: But what if there is a path from B to A through right arrows
:: Suppose we have B -> A. Can we say A <- B?
::
:: get goals with no actionable subgoals
::
::
++  later-to-sooner
  |=  lst=(list id:gol)
  |^  (sort lst cmp)
  ++  cmp
    |=  [a=id:gol b=id:gol]
    (unit-lth deadline:(inherit-deadline b) deadline:(inherit-deadline a))
  --
::
::
++  sooner-to-later
  |=  lst=(list id:gol)
  |^  (sort lst cmp)
  ++  cmp
    |=  [a=id:gol b=id:gol]
    (unit-lth deadline:(inherit-deadline a) deadline:(inherit-deadline b))
  --
::
::
++  newest-to-oldest
  |=  lst=(list =id:gol)
  (sort lst |=([a=[@p d=@da] b=[@p d=@da]] (gth d.a d.b)))
::
::
++  oldest-to-newest
  |=  lst=(list =id:gol)
  (sort lst |=([a=[@p d=@da] b=[@p d=@da]] (lth d.a d.b)))
::
:: highest to lowest priority (highest being smallest number)
++  hi-to-lo
  |=  lst=(list id:gol)
  |^  (sort lst cmp)
  ++  cmp
    |=  [a=id:gol b=id:gol]
    (lth (priority a) (priority b))
  --
::
:: inherit deadline
++  inherit-deadline
  |=  =id:gol
  ^-  [deadline=(unit @da) hereditor=id:gol]
  =/  goal  (got-goal id)
  ?:  &(=(0 ~(wyt in uncs.goal)) =(0 ~(wyt in afts.goal)))
    [deadline.goal id]
  %-  list-min-head
  %+  weld
    ~[[deadline.goal id]]
  %+  turn
    (weld ~(tap in afts.goal) ~(tap in uncs.goal))
  inherit-deadline
::
::
++  unit-lth
  |=  [a=(unit @) b=(unit @)]
  ?~  a  %.n
  ?~  b  %.y
  (lth u.a u.b)
::
::
++  list-min-head
  |*  lst=(list [(unit @) *])
  %+  roll
    ^+  lst  +.lst
  |:  [a=i.-.lst b=i.-.lst]
  ?:  (unit-lth -.a -.b)  a  b
::
:: make a goal actionable
++  actionate
  |=  =goal:gol
  ?:  =(0 ~(wyt in nefs.goal)) :: cannot have children
    goal(actionable %.y)
  ~&('Cannot make actionable; has children.' goal)
::
:: mark a goal complete
++  complete
  |=  =goal:gol
  |^
  ?:  &(befs-complete nefs-complete)
    goal(status %completed)
  ~&('Cannot mark complete; children or precedents uncompleted.' goal)
  ++  befs-complete  (~(all in befs.goal) completed)
  ++  nefs-complete  (~(all in nefs.goal) completed)
  ++  completed  |=(=id:gol =(%completed status:(got-goal id)))
  --
::
:: mark a goal active
++  activate
  |=  =goal:gol
  |^
  ?:  &(afts-active uncs-active)
    goal(status %active)
  ~&('Cannot mark active; parents or successors uncompleted.' goal)
  ++  afts-active  (~(all in afts.goal) activated)
  ++  uncs-active  (~(all in uncs.goal) activated)
  ++  activated  |=(=id:gol =(%active status:(got-goal id)))
  --
--
