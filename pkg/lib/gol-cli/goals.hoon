/-  gol=goal, vyu=view
/+  *gol-cli-goal
|_  store:gol
+*  store  +<
:: create unique goal id based on source ship and creation time
++  unique-id
  |=  [our=ship now=@da]
  ^-  id:gol
  ?.  ?|  (~(has by directory) [our now])
          (~(has by projects) [%pin our now])
      ==
    [our now]
  $(now (add now ~s0..0001))
::
++  new-project
  |=  [title=@t chefs=(set ship) peons=(set ship) viewers=(set ship) own=ship now=@da]
  ^-  [pin:gol project:gol]
  =/  pin  [%pin (unique-id own now)]
  =|  =project:gol
  =.  title.project  title
  =.  creator.project  own
  =.  chefs.project  chefs
  =.  peons.project  peons
  =.  viewers.project  (~(uni in viewers) (~(uni in chefs) peons))
  [pin project]
::
++  new-ids
  |=  [=(list id:gol) our=ship now=@da]
  ^-  (map id:gol id:gol)
  =/  idx  0
  =|  =(map id:gol id:gol)
  |-
  ?:  =(idx (lent list))
    map
  =/  new-id  (unique-id our now)
  %=  $
    idx  +(idx)
    directory  (~(put by directory) new-id *pin:gol)
    map  (~(put by map) (snag idx list) new-id)
  ==
::
++  copy-project
  |=  $:  =old=pin:gol
          title=@t
          chefs=(set ship)
          peons=(set ship)
          viewers=(set ship)
          own=ship
          now=@da
      ==
  ^-  [pin:gol project:gol]
  =/  old-project  (~(got by projects) old-pin)
  =+  [pin project]=(new-project title chefs peons viewers own now)
  =.  projects  (~(put by projects) pin project(creator owner.old-pin))
  =/  id-map  (new-ids ~(tap in ~(key by goals.old-project)) own now)
  :-  pin
  %=  project
    goals
      %-  ~(gas by goals.project)
      %+  turn  ~(tap by goals.old-project)
      |=  [=id:gol =goal:gol]
      :-  (~(got by id-map) id)
      %=  goal
        author  own
        par  ?~(par.goal ~ (some (~(got by id-map) u.par.goal)))
        kids  (~(run in kids.goal) |=(=id:gol (~(got by id-map) id)))
        inflow.kickoff
          (~(run in inflow.kickoff.goal) |=(=eid:gol [-.eid (~(got by id-map) id.eid)]))
        outflow.kickoff
          (~(run in outflow.kickoff.goal) |=(=eid:gol [-.eid (~(got by id-map) id.eid)]))
        inflow.deadline
          (~(run in inflow.deadline.goal) |=(=eid:gol [-.eid (~(got by id-map) id.eid)]))
        outflow.deadline
          (~(run in outflow.deadline.goal) |=(=eid:gol [-.eid (~(got by id-map) id.eid)]))
      ==
  ==
::
:: purge goal from goals
++  purge-goals
  |=  [=goals:gol =id:gol]
  ^-  goals:gol
  %-  %~  del
        by
      %-  ~(run by goals)
      |=  =goal:gol
      %=  goal
        par   ?~(par.goal ~ ?:(=(u.par.goal id) ~ par.goal))
        kids  (~(del in kids.goal) id)
        inflow.kickoff
          (~(del in (~(del in inflow.kickoff.goal) [%k id])) [%d id])
        outflow.kickoff
          (~(del in (~(del in outflow.kickoff.goal) [%k id])) [%d id])
        inflow.deadline
          (~(del in (~(del in inflow.deadline.goal) [%k id])) [%d id])
        outflow.deadline
          (~(del in (~(del in outflow.deadline.goal) [%k id])) [%d id])
      ==
  id
::
:: find the oldest ancestor of this goal for which you are a chef
++  seniority
  |=  [mod=ship =id:gol senior=(unit id:gol) path=(list id:gol) cp=?(%c %p)]
  ^-  senior=(unit id:gol)
  =/  new-path=(list id:gol)  [id path]
  =/  i  (find [id]~ path) 
  ?.  =(~ i)  ?~(i !! ~&([%cycle (flop (scag u.i new-path))] !!))
  =.  senior
    ?-    cp
        %c
      ?:  (~(has in chefs:(got-goal id)) mod)
        (some id)
      senior
        %p
      ?:  (~(has in peons:(got-goal id)) mod)
        (some id)
      senior
    ==
  =/  par  par:(got-goal id)
  ?~  par  senior
  (seniority mod u.par senior path cp)
::
++  check-pair-perm
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each ? term)
  =/  pin  (~(got by directory) lid)
  ?.  =(pin (~(got by directory) rid))  [%& %.n]
  =/  project-owner  +<:pin
  =/  project-chefs  chefs:(~(got by projects) pin)
  ?:  |(=(project-owner mod) (~(has in project-chefs) mod))  [%& %.y]
  =/  l  (seniority mod lid ~ ~ %c)
  =/  r  (seniority mod rid ~ ~ %c)
  ?.  =(senior.l senior.r)  [%| %diff-sen-perm-fail]
  ?~  senior.l  [%| %null-sen-perm-fail]
  ?:  =(lid u.senior.l)  [%| %no-left-perm-perm-fail]  [%& %.y]
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
++  got-split
  |=  =eid:gol
  ^-  split:gol
  =/  pin  (~(got by directory) id.eid)
  =/  project  (~(got by projects.store) pin)
  =/  goal  (~(got by goals.project) id.eid)
  ?-  -.eid
    %k  kickoff.goal
    %d  deadline.goal
  ==
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
  (~(put by directory) id pin)
::
:: update directory to reflect new goals in a project
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
:: is e1 before e2
++  before
  |=  [e1=eid:gol e2=eid:gol]
  ^-  ?
  |^
  -:(before e1 e2 ~ ~)
  ++  before
    |=  $:  e1=eid:gol
            e2=eid:gol
            path=(list eid:gol)
            visited=(set eid:gol)
        ==
    ^-  [? visited=(set eid:gol)]
    =/  new-path=(list eid:gol)  [e2 path]
    =/  i  (find [e2]~ path) 
    ?.  =(~ i)  ?~(i !! ~&([%cycle (flop (scag u.i new-path))] !!))
    =/  inflow  inflow:(got-split e2)
    ?:  (~(has in inflow) e1)  [%& visited]
    =.  visited  (~(put in visited) e2)
    =/  idx  0
    =/  inflow  ~(tap in inflow)
    |-
    ?:  =(idx (lent inflow))
      [%| visited]
    ?:  (~(has in visited) (snag idx inflow))
      $(idx +(idx))
    =/  cmp  (before e1 (snag idx inflow) new-path visited)
    ?:  -.cmp
      [%& visited.cmp]
    $(idx +(idx), visited visited.cmp)
  --
::
++  own-yoke
  |=  [lid=id:gol rid=id:gol]
  ^-  (each projects:gol term)
  =/  l  (got-goal lid)
  =/  r  (got-goal rid)
  =/  output
    ?~  par.l
      [%& projects]
    (own-rend lid u.par.l)
  ?-    -.output
    %|  output
      %&
    =.  projects  +.output
    =/  pin  (~(got by directory) lid)
    =/  project  (~(got by projects) pin)
    =.  goals.project  (~(put in goals.project) lid l(par (some rid)))
    =.  goals.project  (~(put in goals.project) rid r(kids (~(put in kids.r) lid)))
    [%& (~(put in projects) pin project)]
  ==
::
++  own-rend
  |=  [lid=id:gol rid=id:gol]
  ^-  (each projects:gol term)
  =/  l  (got-goal lid)
  =/  r  (got-goal rid)
  =/  pin  (~(got by directory) lid)
  =/  project  (~(got by projects) pin)
  =.  goals.project  (~(put in goals.project) lid l(par ~))
  =.  goals.project  (~(put in goals.project) rid r(kids (~(del in kids.r) lid)))
  [%& (~(put in projects) pin project)]
::
++  dag-yoke
  |=  [e1=eid:gol e2=eid:gol]
  ^-  (each projects:gol term)
  =/  pin  (~(got by directory) id.e1)
  =/  project  (~(got by projects) pin)
  =/  split1  (got-split e1)
  =/  split2  (got-split e2)
  ?:  (before e2 e1)  [%| %before-e2-e1]
  =.  outflow.split1  (~(put in outflow.split1) e2)
  =.  inflow.split2  (~(put in inflow.split2) e1)
  =.  goals.project  (~(put in goals.project) id.e1 (update-split e1 split1))
  =.  goals.project  (~(put in goals.project) id.e2 (update-split e2 split2))
  [%& (~(put by projects) pin project)]
::
++  dag-rend
  |=  [e1=eid:gol e2=eid:gol]
  ^-  (each projects:gol term)
  =/  pin  (~(got by directory) id.e1)
  =/  project  (~(got by projects) pin)
  =/  l  (got-goal id.e1)
  =/  r  (got-goal id.e2)
  =/  split1  (got-split e1)
  =/  split2  (got-split e2)
  ?:  =(id.e1 id.e2)  [%| %same-goal]
  ?:  ?|  &(=(-.e1 %d) =(-.e2 %d) (~(has in kids.r) id.e1))
          &(=(-.e1 %k) =(-.e2 %k) (~(has in kids.l) id.e2))
      ==
    [%| %owned-goal]
  =.  outflow.split1  (~(del in outflow.split1) e2)
  =.  inflow.split2  (~(del in inflow.split2) e1)
  =.  goals.project  (~(put in goals.project) id.e1 (update-split e1 split1))
  =.  goals.project  (~(put in goals.project) id.e2 (update-split e2 split2))
  [%& (~(put by projects) pin project)]
::
++  prio-yoke
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each projects:gol term)
  =/  perm  (check-pair-perm lid rid mod)
  ?-    -.perm
    %|  perm
      %&
    ?:  =(lid rid)  [%| %yoke-self]
    ?:  |(complete:(got-goal lid) complete:(got-goal rid))
      [%| %complete]
    (dag-yoke [%k lid] [%k rid])
  ==
::
++  prio-rend
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each projects:gol term)
  =/  perm  (check-pair-perm lid rid mod)
  ?-    -.perm
    %|  perm
      %&
    ?:  =(lid rid)  [%| %rend-self]
    (dag-rend [%k lid] [%k rid])
  ==
::
++  prec-yoke
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each projects:gol term)
  =/  perm  (check-pair-perm lid rid mod)
  ?-    -.perm
    %|  perm
      %&
    ?:  =(lid rid)  [%| %yoke-self]
    ?:  |(complete:(got-goal lid) complete:(got-goal rid))
      [%| %complete]
    (dag-yoke [%d lid] [%k rid])
  ==
::
++  prec-rend
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each projects:gol term)
  =/  perm  (check-pair-perm lid rid mod)
  ?-    -.perm
    %|  perm
      %&
    ?:  =(lid rid)  [%| %rend-self]
    (dag-rend [%d lid] [%k rid])
  ==
::
++  nest-yoke
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each projects:gol term)
  =/  perm  (check-pair-perm lid rid mod)
  ?-    -.perm
    %|  perm
      %&
    ?:  =(lid rid)  [%| %yoke-self]
    =/  l  (got-goal lid)
    =/  r  (got-goal rid)
    ?:  |(complete:(got-goal lid) complete:(got-goal rid))
      [%| %complete]
    ?:  actionable.r
      [%| %actionable]
    (dag-yoke [%d lid] [%d rid])
  ==
::
++  nest-rend
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each projects:gol term)
  =/  perm  (check-pair-perm lid rid mod)
  ?-    -.perm
    %|  perm
      %&
    ?:  =(lid rid)  [%| %rend-self]
    (dag-rend [%d lid] [%d rid])
  ==
::
++  held-yoke
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each projects:gol term)
  =/  perm  (check-pair-perm lid rid mod)
  ?-    -.perm
    %|  perm
      %&
    ?:  =(lid rid)  [%| %yoke-self]
    =/  l  (got-goal lid)
    =/  r  (got-goal rid)
    ?:  |(complete:(got-goal lid) complete:(got-goal rid))
      [%| %complete]
    ?:  actionable.r
      [%| %actionable]
    =|  output=(each projects:gol term)
    =.  output
      ?~  par.l
        [%& projects]
      (held-rend lid u.par.l mod)
    ?-    -.output
      %|  output
        %&
      %+  apply-sequence  mod
      :~  [%dag-yoke [%d lid] %d rid]
          [%dag-yoke [%k rid] %k lid]
          [%own-yoke lid rid]
      ==
    ==
  ==
::
++  held-rend
  |=  [lid=id:gol rid=id:gol mod=ship]
  ^-  (each projects:gol term)
  =/  perm  (check-pair-perm lid rid mod)
  ?-    -.perm
    %|  perm
      %&
    ?:  =(lid rid)  [%| %rend-self]
    %+  apply-sequence  mod
    :~  [%dag-rend [%d lid] %d rid]
        [%dag-rend [%k rid] %k lid]
        [%own-rend lid rid]
    ==
  ==
::
++  update-split
  |=  [=eid:gol =split:gol]
  ^-  goal:gol
  =/  goal  (got-goal id.eid)
  ?-  -.eid
    %k  goal(kickoff split)
    %d  goal(deadline split)
  ==
::
++  apply-sequence
  |=  [mod=ship seq=yoke-sequence:gol]
  ^-  (each projects:gol term)
  ?~  seq
    [%& projects]
  =/  yoke-output=(each projects:gol term)
    ?-  -.i.seq
      %dag-yoke   (dag-yoke e1.i.seq e2.i.seq)
      %dag-rend   (dag-rend e1.i.seq e2.i.seq)
      %own-yoke   (own-yoke lid.i.seq rid.i.seq)
      %own-rend   (own-rend lid.i.seq rid.i.seq)
      %prio-rend  (prio-rend lid.i.seq rid.i.seq mod)
      %prio-yoke  (prio-yoke lid.i.seq rid.i.seq mod)
      %prec-rend  (prec-rend lid.i.seq rid.i.seq mod)
      %prec-yoke  (prec-yoke lid.i.seq rid.i.seq mod) 
      %nest-rend  (nest-rend lid.i.seq rid.i.seq mod) 
      %nest-yoke  (nest-yoke lid.i.seq rid.i.seq mod) 
      %held-rend  (held-rend lid.i.seq rid.i.seq mod) 
      %held-yoke  (held-yoke lid.i.seq rid.i.seq mod) 
    ==
  ?-  -.yoke-output
    %|  yoke-output
    %&  $(seq t.seq, projects p.yoke-output)  
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
  $(idx +(idx), lvl (max lvl (plumb (snag idx gots))))
::
:: get roots
++  roots
  |=  =goals:gol
  ^-  (list id:gol)
  %+  turn
    %+  skim  ~(tap by goals)
    |=  [id:gol =goal:gol]
    ?&  =(~ par.goal)
        .=  0
        %-  lent
        %+  murn
          ~(tap in outflow.deadline.goal)
        |=  =eid:gol
        ?-  -.eid
          %k  ~
          %d  (some id.eid)
        ==
    ==
  |=([=id:gol goal:gol] id)
::
++  uncompleted-roots
  |=  =goals:gol
  %+  murn  (roots goals)
  |=  =id:gol
  ?:  complete:(~(got by goals) id)
    ~
  (some id)
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
  ~(wyt in (prios id ~))
  ++  prios
    |=  [=id:gol path=(list id:gol)]
    ^-  (set id:gol)
    =/  new-path=(list id:gol)  [id path]
    =/  i  (find [id]~ path) 
    ?.  =(~ i)  ?~(i !! ~&([%cycle (flop (scag u.i new-path))] !!))
    =/  goal  (got-goal id)
    =/  prio  (prio goal)
    =/  idx  0
    =/  output  prio
    =/  prio  ~(tap in prio)
    |-
    ?:  =(idx (lent prio))
      output
    $(idx +(idx), output (~(uni in output) (prios (snag idx prio) new-path)))
  --
::
:: get lowest priority; priority of "virtual" root node
++  lowpri  ~(wyt by directory)
::
:: get the number representing the deepest path to a leaf node
++  get-lvl
  |=  [=grip:vyu =mode:gol]
  ^-  @
  ?+    mode  !!
      normal-mode:gol
    ?-    -.grip
      %all  ~
      %project  (anchor goals:(~(got by projects) +.grip))
      %goal  (plumb +.grip)
    ==
  ==
::
:: get either the children or the parents depending on dir
++  get-fam
  |=  [=grip:vyu =mode:gol]
  ^-  (list grip:vyu)
  ?+    mode  !!
      %normal
    ?-    -.grip
      %all  (turn ~(tap in ~(key by projects)) |=(=pin:gol [%project pin]))
      %project  (turn (hi-to-lo (uncompleted-roots goals:(~(got by projects) +.grip))) |=(=id:gol [%goal id]))
        %goal
      =/  goal  (got-goal +.grip)
      (turn (hi-to-lo ~(tap in ((uncompleted yung) goal))) |=(=id:gol [%goal id]))
    ==
      %normal-completed
    ?-    -.grip
      %all  (turn ~(tap in ~(key by projects)) |=(=pin:gol [%project pin]))
      %project  (turn (hi-to-lo (roots goals:(~(got by projects) +.grip))) |=(=id:gol [%goal id]))
        %goal
      =/  goal  (got-goal +.grip)
      (turn (hi-to-lo ~(tap in (yung goal))) |=(=id:gol [%goal id]))
    ==
  ==
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
++  uncompleted
  |=  getter=$-(goal:gol (set id:gol))
  |=  =goal:gol
  %-  ~(gas in *(set id:gol))
  (skim ~(tap in (getter goal)) |=(=id:gol !complete:(got-goal id)))
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
  (rightbound [%d id])

++  rightbound
  |=  =eid:gol
  ^-  [deadline=(unit @da) hereditor=eid:gol]
  =/  split  (got-split eid)
  ?:  =(0 ~(wyt in outflow.split))
    [moment.split eid]
  %-  list-min-head
  %+  weld
    ~[[moment.split eid]]
  %+  turn
    ~(tap in outflow.split)
  rightbound
::
++  unit-lth
  |=  [a=(unit @) b=(unit @)]
  ?~  a  %.n
  ?~  b  %.y
  (lth u.a u.b)
::
++  list-min-head
  |*  lst=(list [(unit @) *])
  %+  roll
    ^+  lst  +.lst
  |:  [a=i.-.lst b=i.-.lst]
  ?:  (unit-lth -.a -.b)  a  b
--
