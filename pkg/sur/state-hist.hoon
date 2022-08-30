/-  nest
|%
:: 
:: states
::
+$  state-0
  $:  %0
      =goals:goals-state-0:nest
      =handles:nest
      =views:nest
      context=(unit id:nest)
      utc-offset=[hours=@dr ahead=?]
  ==
+$  state-1
  $:  %1
      =goals:goals-state-1:nest
      =handles:nest
      =views:nest
      context=(unit id:nest)
      utc-offset=[hours=@dr ahead=?]
  ==
+$  state-2
  $:  %2
      =goals:nest
      =viewers:nest
      =directory:nest
      =handles:nest
      =views:nest
      context=(unit id:nest)
      utc-offset=[hours=@dr ahead=?]
  ==
::
:: conversion methods
:: 
++  goals-0-to-1
  |=  =goals:goals-state-0:nest
  ^-  goals:goals-state-1:nest
  %-  ~(run by goals)
  |=  old-goal=goal:goals-state-0:nest
  =|  =goal:goals-state-1:nest
  =.  desc.goal  desc.old-goal
  =.  deadline.goal  deadline.old-goal
  =.  pars.goal  pars.old-goal
  =.  kids.goal  kids.old-goal
  =.  befs.goal  befs.old-goal
  =.  afts.goal  afts.old-goal
  =.  actionable.goal  actionable.old-goal
  =.  status.goal  status.old-goal
  goal
++  convert-1-to-2
    |=  [=state-1 =bowl:gall]
    ^-  state-2
    :*  %2
        :: goals
        %-  ~(run by goals.state-1)
        |=  old-goal=goal:goals-state-1:nest
        =|  =goal:nest
        =.  desc.goal  desc.old-goal
        =.  deadline.goal  deadline.old-goal
        =.  pars.goal  pars.old-goal
        =.  kids.goal  kids.old-goal
        =.  befs.goal  befs.old-goal
        =.  afts.goal  afts.old-goal
        =.  moar.goal  moar.old-goal
        =.  less.goal  less.old-goal
        =.  actionable.goal  actionable.old-goal
        =.  status.goal  status.old-goal
        goal
        :: viewers
        %-  ~(gas by *(map id:nest (set ship)))
        %+  turn  ~(tap in ~(key by goals.state-1))
        |=  =id:nest
        [id (~(put in *(set ship)) our.bowl)]
        :: directory
        %-  ~(gas by *(map id:nest [ship (list id:nest)]))
        %+  turn  ~(tap in ~(key by goals.state-1))
        |=  =id:nest
        [id our.bowl [id ~]]
        ::
        handles.state-1
        views.state-1
        context.state-1
        utc-offset.state-1
    ==
--
