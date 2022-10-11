/-  gol=goal
/+  *gol-cli-goal, gol-cli-goals, pl=gol-cli-pool
|_  store:gol
+*  gols  ~(. gol-cli-goals +<)
::
++  spawn-pool
  |=  [title=@t own=ship now=@da]
  ^-  [pin:gol pool:gol]
  =/  pin  [%pin (unique-id:gols own now)]
  =|  =pool:gol
  =.  owner.pool  owner.pin
  =.  birth.pool  birth.pin
  =.  title.pool  title
  =.  creator.pool  own
  =.  perms.pool  (~(put by perms.pool) own (some %owner))
  [pin pool]
::
++  clone-pool
  |=  $:  =old=pin:gol
          title=@t
          own=ship
          now=@da
      ==
  ^-  [pin:gol pool:gol]
  =/  old-pool  (~(got by pools) old-pin)
  =+  [pin pool]=(spawn-pool title own now)
  =.  pools  (~(put by pools) pin pool(creator owner.old-pin))
  =/  id-map  (new-ids:gols ~(tap in ~(key by goals.old-pool)) own now)
  |^
  :-  pin
  %=  pool
    goals
      %-  ~(gas by goals.pool)
      %+  turn  ~(tap by goals.old-pool)
      |=  [=id:gol =goal:gol]
      :-  (~(got by id-map) id)
      %=  goal
        par  ?~(par.goal ~ (some (new-id u.par.goal)))
        kids  (new-set-id kids.goal)
        ::
        inflow.kickoff  (new-set-eid inflow.kickoff.goal)
        outflow.kickoff  (new-set-eid outflow.kickoff.goal)
        inflow.deadline  (new-set-eid inflow.deadline.goal)
        outflow.deadline  (new-set-eid outflow.deadline.goal)
        ::
        hereditor.left-bound.kickoff
          (new-eid hereditor.left-bound.kickoff.goal)
        hereditor.ryte-bound.kickoff
          (new-eid hereditor.ryte-bound.kickoff.goal)
        hereditor.left-bound.deadline
          (new-eid hereditor.left-bound.deadline.goal)
        hereditor.ryte-bound.deadline
          (new-eid hereditor.ryte-bound.deadline.goal)
        ::
        stock  (turn stock.goal |=([=id:gol =ship] [(new-id id) ship]))
        ranks
          %-  ~(gas by ranks.goal)
          (turn ~(tap by ranks.goal) |=([=ship =id:gol] [ship (new-id id)]))
        ::
        prio-left  (new-set-id prio-left.goal)
        prio-ryte  (new-set-id prio-ryte.goal)
        prec-left  (new-set-id prec-left.goal)
        prec-ryte  (new-set-id prec-ryte.goal)
        nest-left  (new-set-id nest-left.goal)
        nest-ryte  (new-set-id nest-ryte.goal)
      ==
  ==
  ++  new-id  |=(=id:gol (~(got by id-map) id))
  ++  new-eid  |=(=eid:gol [-.eid (new-id id.eid)])
  ++  new-set-id  |=(=(set id:gol) (~(run in set) new-id))
  ++  new-set-eid  |=(=(set eid:gol) (~(run in set) new-eid))
  --
--
