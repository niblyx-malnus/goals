/-  gol=goal
/+  *gol-cli-util, gol-cli-node, gol-cli-traverse
|%
::
++  all-own-edges
  |=  =goals:gol
  ^-  [kids=(set (pair id:gol id:gol)) pars=(set (pair id:gol id:gol))]
  =/  g  ~(tap in goals)
  =|  kids=(set (pair id:gol id:gol))
  =|  pars=(set (pair id:gol id:gol))
  |-
  ?~  g
    [kids pars]
  =/  [=id:gol =goal:gol]  i.g
  %=  $
    g  t.g
    kids  
      %-  ~(uni in kids)
      ^-  (set (pair id:gol id:gol))
      %-  ~(run in kids.goal)
      |=(kid=id:gol [kid id])
    pars  
      ?~  par.goal
        pars
      %-  ~(put in pars)
      [id u.par.goal]
  ==
::
:: assert kids/par doubly-linked
++  doubly-own-linked  |=(=goals:gol `?`=(kids pars):(all-own-edges goals))
::
++  all-dag-edges
  |=  =goals:gol
  ^-  [inflows=(set edge:gol) outflows=(set edge:gol)]
  =/  g  ~(tap in goals)
  =|  inflows=(set edge:gol)
  =|  outflows=(set edge:gol)
  |-
  ?~  g
    [inflows outflows]
  =/  [=id:gol =goal:gol]  i.g
  =.  inflows
    %-  ~(uni in inflows)
    ^-  (set edge:gol)
    %-  ~(run in inflow.kickoff.goal)
    |=(=nid:gol [nid [%k id]])
  =.  outflows
    %-  ~(uni in outflows)
    ^-  (set edge:gol)
    %-  ~(run in outflow.kickoff.goal)
    |=(=nid:gol [[%k id] nid])
  %=  $
    g  t.g
    inflows  
      %-  ~(uni in inflows)
      ^-  (set edge:gol)
      %-  ~(run in inflow.deadline.goal)
      |=(=nid:gol [nid [%d id]])
    outflows  
      %-  ~(uni in outflows)
      ^-  (set edge:gol)
      %-  ~(run in outflow.deadline.goal)
      |=(=nid:gol [[%d id] nid])
  ==
::
:: assert nodes doubly-linked
++  doubly-dag-linked
  |=(=goals:gol `?`=(inflows outflows):(all-dag-edges goals))
::
::
++  kd-pairs
  |=  =goals:gol
  ^-  ?
  %-  ~(rep by goals)
  |=  [[=id:gol =goal:gol] all=?]
  ?&  (~(has in outflow.kickoff.goal) [%d id])
      (~(has in inflow.deadline.goal) [%k id])
  ==
::
:: assumes doubly-own-linked and doubly-dag-linked
++  ownership-containment
  |=  =goals:gol
  ^-  ?
  =/  branches  kids:(all-own-edges goals)
  %-  ~(all in branches)
  |=  [kid=id:gol pid=id:gol]
  ^-  ?
  =/  goal  (~(got by goals) kid)
  ?&  (~(has in inflow.kickoff.goal) [%k pid])
      (~(has in outflow.deadline.goal) [%d pid])
  ==
::
:: no actionable goal has goals nested below it
++  bare-actionable
  |=  =goals:gol
  ^-  ?
  %-  ~(all by goals)
  |=  =goal:gol
  ^-  ?
  ?.  actionable.goal
    %.y
  =;  kd=(set ?(%k %d))  
    !(~(has in kd) %d)
  %-  ~(run in inflow.deadline.goal)
  |=(=nid:gol -.nid)
::
++  check-bound-mismatch
  |=  =goals:gol
  ^-  ?
  =/  rn  (~(root-nodes gol-cli-node goals))
  =/  vis
    %:  (~(chain gol-cli-traverse goals) nid:gol (unit moment:gol))
      (~(bound-visit gol-cli-traverse goals) %l)
      rn
      ~
    ==
  =/  ids=(set id:gol)  (~(run in ~(key by vis)) |=(=nid:gol id.nid))
  ?.  =(0 ~(wyt in (~(dif in ids) ~(key by goals))))
    ~|("all ids not visited" !!)
  =/  vos=(map nid:gol (unit moment:gol))  (gat-by vis rn)
  (~(all by vos) |=(out=(unit moment:gol) !=(~ out)))
::
++  check-plete-mismatch
  |=  =goals:gol
  ^-  ?
  =/  rn  (~(root-nodes gol-cli-node goals))
  =/  vis
    %:  (~(chain gol-cli-traverse goals) nid:gol (unit ?))
      (~(plete-visit gol-cli-traverse goals) %l)
      rn
      ~
    ==
  =/  ids=(set id:gol)  (~(run in ~(key by vis)) |=(=nid:gol id.nid))
  ?.  =(0 ~(wyt in (~(dif in ids) ~(key by goals))))
    ~|("all ids not visited" !!)
  =/  vos=(map nid:gol (unit ?))  (gat-by vis rn)
  (~(all by vos) |=(out=(unit ?) !=(~ out)))
::
++  validate-goals
  |=  =goals:gol
  ^-  goals:gol
  :: assert par/kids doubly-linked
  ?.  (doubly-own-linked goals)  ~|("ownership not doubly linked" !!)
  :: assert nodes doubly-linked
  ?.  (doubly-dag-linked goals)  ~|("DAG not doubly linked" !!)
  :: assert corresponding kickoffs and deadlines are linked
  ?.  (kd-pairs goals)  ~|("kickoffs not linked to deadlines" !!)
  :: assert all par/kids relationships reflects containment (held-yoke)
  ?.  (ownership-containment goals)
    ~|("some goals owned but not contained" !!)
  :: assert actionable goals have no kids or nested goals
  ?.  (bare-actionable goals)  ~|("actionable has nested" !!)
  :: assert traversal from roots produces correctly ordered moments
  ?.  (check-bound-mismatch goals)  ~|("bound-mismatch-fail" !!)
  :: assert no completed deadline is right of any incomplete deadline
  ?.  (check-plete-mismatch goals)  ~|("plete-mismatch-fail" !!)
  goals
--
