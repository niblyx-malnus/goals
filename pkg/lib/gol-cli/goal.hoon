/-  gol=goal
|%
++  yung
  |=  =goal:gol
  ^-  (set id:gol)
  %-  sy
  %+  murn
    ~(tap in inflow.deadline.goal)
  |=  =eid:gol
  ^-  (unit id:gol)
  ?-  -.eid
    %k  ~
    %d  (some id.eid)
  ==
::
++  prio
  |=  =goal:gol
  ^-  (set id:gol)
  %-  sy
  %+  turn
    ~(tap in inflow.kickoff.goal)
  |=  =eid:gol
  ^-  id:gol
  id.eid
--
