|%
::
++  id  *
++  nid  [?(%k %d) =id]
++  node-nexus
  $:  moment=(unit @da)
      inflow=(set nid)
      outflow=(set nid)
  ==
++  node  [node-nexus *]
++  goal-nexus
  $:  par=(unit id)
      kids=(set id)
      kickoff=node
      deadline=node
      complete=_|
      actionable=_|
      chief=ship
      spawn=(set ship)
  ==
++  goal  [goal-nexus *]
++  goals  (map id goal)
++  pool-role  ?(%admin %spawn)
++  pool-nexus
  $:  =goals
      cache=goals
      owner=ship
      perms=(map ship (unit pool-role))
  ==
++  pool  [pool-nexus *]
--
