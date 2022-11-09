/-  gol=goal
|_  p=pool:gol
++  inflate-pool
  |=  =pool:gol
  ^-  pool
::
:: get the left or right bound of a node (assumes correct moment order)
++  left-bound  |=(=nid:gol (~(got by left-bounds.trace.p) nid))
++  ryte-bound  |=(=nid:gol (~(got by ryte-bounds.trace.p) nid))
++  left-plumb  |=(=nid:gol (~(got by left-plumbs.trace.p) nid))
++  ryte-plumb  |=(=nid:gol (~(got by ryte-plumbs.trace.p) nid))
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
  =/  goal  (~(got by goals.p) id)
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
++  get-ranks
  |=  =stock:gol
  ^-  ranks:gol
  =|  =ranks:gol
  |-
  ?~  stock
    ranks
  %=  $
    stock  t.stock
    ranks  (~(put by ranks) [chief id]:i.stock)
  ==
::
++  inflate-goal
  |=  =id:gol
  ^-  goal:gol
  =/  goal  (~(got by goals.p) id)
  %=  goal
    stock  (~(got by stock-map.trace.p) id)
    ranks  (get-ranks (~(got by stock-map.trace.p) id))
    prio-left  (prio-left id)
    prio-ryte  (prio-ryte id)
    prec-left  (prec-left id)
    prec-ryte  (prec-ryte id)
    nest-left  (nest-left id)
    nest-ryte  (nest-ryte id)
    left-bound.kickoff  (left-bound [%k id]) 
    ryte-bound.kickoff  (ryte-bound [%k id]) 
    left-plumb.kickoff  (left-plumb [%k id]) 
    ryte-plumb.kickoff  (ryte-plumb [%k id]) 
    left-bound.deadline  (left-bound [%d id]) 
    ryte-bound.deadline  (ryte-bound [%d id]) 
    left-plumb.deadline  (left-plumb [%d id]) 
    ryte-plumb.deadline  (ryte-plumb [%d id]) 
  ==
::
++  inflate-goals
  |.
  ^-  _this
  =.  trace.p  (trace-update)
  =.  goals.p
        %-  ~(gas by goals.p)
        %+  turn
          ~(tap in ~(key by goals.p))
        |=(=id:gol [id (inflate-goal id)])
  this
--
