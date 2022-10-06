/-  gol=goal
/+  *gol-cli-goal, gol-cli-goals, pl=gol-cli-pool
|_  store:gol
+*  gols  ~(. gol-cli-goals +<)
::
++  new-pool
  |=  [title=@t upds=(list [ship (unit (unit pool-role:gol))]) own=ship now=@da]
  ^-  [pin:gol pool:gol]
  =/  pin  [%pin (unique-id:gols own now)]
  =|  =pool:gol
  =.  owner.pool  owner.pin
  =.  birth.pool  birth.pin
  =.  title.pool  title
  =.  creator.pool  own
  =.  pool  pool:abet:(update-pool-perms:(apex:pl pool) upds own)
  [pin pool]
::
++  copy-pool
  |=  $:  =old=pin:gol
          title=@t
          upds=(list [ship (unit (unit pool-role:gol))])
          own=ship
          now=@da
      ==
  ^-  [pin:gol pool:gol]
  =/  old-pool  (~(got by pools) old-pin)
  =+  [pin pool]=(new-pool title upds own now)
  =.  pools  (~(put by pools) pin pool(creator owner.old-pin))
  =/  id-map  (new-ids:gols ~(tap in ~(key by goals.old-pool)) own now)
  :-  pin
  %=  pool
    goals
      %-  ~(gas by goals.pool)
      %+  turn  ~(tap by goals.old-pool)
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
--
