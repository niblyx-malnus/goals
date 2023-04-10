/-  gol=goal
|_  =goals:gol
::
:: get a node from a node id
++  got-node
  |=  =nid:gol
  ^-  node:gol
  =/  goal  (~(got by goals) id.nid)
  ?-  -.nid
    %k  kickoff.goal
    %d  deadline.goal
  ==
::
:: Update the node at nid with the given node
++  update-node
  |=  [=nid:gol =node:gol]
  ^-  goals:gol
  =/  goal  (~(got by goals) id.nid)
  %+  ~(put by goals)
    id.nid
  ?-  -.nid
    %k  goal(kickoff node)
    %d  goal(deadline node)
  ==
::
++  iflo  |=(=nid:gol inflow:(got-node nid))
++  oflo  |=(=nid:gol outflow:(got-node nid))
::
:: nodes which have no outflows (must be deadlines)
++  root-nodes
  |.  ^-  (list nid:gol)
  %+  turn
    %+  skim
      ~(tap by goals)
    |=([id:gol =goal:gol] =(~ outflow.deadline.goal))
  |=([=id:gol =goal:gol] [%d id])
::
:: nodes which have no inflows (must be kickoffs)
++  leaf-nodes
  |.  ^-  (list nid:gol)
  %+  turn
    %+  skim
      ~(tap by goals)
    |=([id:gol =goal:gol] =(~ inflow.kickoff.goal))
  |=([=id:gol =goal:gol] [%k id])
::
:: goals whose deadlines have no outflows
++  root-goals
  |.  ^-  (list id:gol)
  %+  turn
    %+  skim
      ~(tap by goals)
    |=([id:gol =goal:gol] =(~ outflow.deadline.goal))
  |=([=id:gol =goal:gol] id)
::
:: parentless goals
++  waif-goals
  |.  ^-  (list id:gol)
  %+  turn
    %+  skim
      ~(tap by goals)
    |=([id:gol =goal:gol] =(~ par.goal))
  |=([=id:gol =goal:gol] id)
::
:: childless goals
++  bare-goals
  |.  ^-  (list id:gol)
  %+  turn
    %+  skim
      ~(tap by goals)
    |=([id:gol =goal:gol] =(~ kids.goal))
  |=([=id:gol =goal:gol] id)
::
:: accepts a deadline; returns inflowing deadlines
++  yong
  |=  =nid:gol
  ^-  (set nid:gol)
  ?>  =(%d -.nid)
  %-  ~(gas in *(set nid:gol))
  %+  murn
    ~(tap in (iflo nid))
  |=  =nid:gol
  ?-  -.nid
    %k  ~
    %d  (some nid)
  ==
::
:: gets the kids and "virtual children" of a goal
++  yung
  |=  =id:gol
  ^-  (list id:gol)
  (turn ~(tap in (yong [%d id])) |=(=nid:gol id.nid))
::
:: gets the "virtual children" of a goal
:: (non-kids inflowing deadlines to the deadline)
++  virt
  |=  =id:gol
  ^-  (list id:gol)
  %~  tap  in
  %-  %~  dif  in
      (~(gas in *(set id:gol)) (yung id))
  kids:(~(got by goals) id)
::
:: extracts ids of incomplete goals from a list of ids
++  incomplete
  |=  ids=(list id:gol)
  ^-  (list id:gol)
  (skip ids |=(=id:gol complete:(~(got by goals) id)))
::
:: get all nodes from a set of ids
++  nodify
  |=  ids=(set id:gol)
  ^-  (set nid:gol)
  =/  kix=(set nid:gol)  (~(run in ids) |=(=id:gol [%k id]))
  =/  ded=(set nid:gol)  (~(run in ids) |=(=id:gol [%d id]))
  (~(uni in kix) ded)
::
:: get the nodes from a set of nodes which are
:: contained in the inflow/outflow of a goal's kickoff/deadline
++  bond-overlap
  |=  [=id:gol nids=(set nid:gol) dir=?(%l %r) src=?(%k %d)]
  ^-  (set (pair nid:gol nid:gol))
  =/  flo  ?-(dir %l iflo, %r oflo)
  %-  ~(run in (~(int in nids) (flo [src id])))
  |=(=nid:gol ?-(dir %l [nid src id], %r [[src id] nid]))
::
:: get the bonds which exist between a goal and a set of other goals
++  get-bonds
  |=  [=id:gol ids=(set id:gol)]
  ^-  (list (pair nid:gol nid:gol))
  ::
  :: get set of nodes of ids
  =/  nids  (nodify ids)
  :: 
  %~  tap  in
  ::
  :: get the nodes flowing into id's kickoff
  %-  ~(uni in (bond-overlap id nids %l %k))
  ::
  :: get the nodes flowing out of id's kickoff
  %-  ~(uni in (bond-overlap id nids %r %k))
  ::
  :: get the nodes flowing into id's deadline
  %-  ~(uni in (bond-overlap id nids %l %d))
  ::
  :: get the nodes flowing out of id's deadline
  (bond-overlap id nids %r %d)
:: 
:: kid - include if kid, yes or no?
:: par - include if par, yes or no?
:: dir - leftward or rightward
:: src - starting in kickoff or deadline
:: dst - ending in kickoff or deadline
++  neighbors
  |=  [=id:gol kid=? par=? dir=?(%l %r) src=?(%k %d) dst=?(%k %d)]
  ^-  (set id:gol)
  =/  flow  ?-(dir %l (iflo [src id]), %r (oflo [src id]))
  =/  goal  (~(got by goals) id)
  %-  ~(gas in *(set id:gol))
  %+  murn
    ~(tap in flow)
  |=  =nid:gol
  ?.  ?&  =(dst -.nid) :: we keep when destination is as specified
          |(kid !(~(has in kids.goal) id.nid)) :: if k false, must not be in kids
          |(par !?~(par.goal %| =(id.nid u.par.goal))) :: if p is false, must not be par
      ==
    ~
  (some id.nid)
::  
++  prio-left  |=(=id:gol (neighbors id %& %| %l %k %k))
++  prio-ryte  |=(=id:gol (neighbors id %| %& %r %k %k))
++  prec-left  |=(=id:gol (neighbors id %& %& %l %k %d))
++  prec-ryte  |=(=id:gol (neighbors id %& %& %r %d %k))
++  nest-left  |=(=id:gol (neighbors id %| %& %l %d %d))
++  nest-ryte  |=(=id:gol (neighbors id %& %| %r %d %d))
::
++  young  |=(=id:gol (~(uni in kids:(~(got by goals) id)) (nest-left id)))
--
