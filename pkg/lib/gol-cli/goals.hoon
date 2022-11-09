/-  gol=goal
|_  store:gol
::
:: create unique goal id based on source ship and creation time
++  unique-id
  |=  [own=ship now=@da]
  ^-  id:gol
  ?.  (has:idx-orm:gol index [own now])
    [own now]
  $(now (add now ~s0..0001))
::
:: creating a mapping from old ids to new ids
:: to be used in the process of copying goals
++  new-ids
  |=  [=(list id:gol) own=ship now=@da]
  ^-  (map id:gol id:gol)
  =/  idx  0
  =|  =(map id:gol id:gol)
  |-
  ?:  =(idx (lent list))
    map
  =/  new-id  (unique-id own now)
  %=  $
    idx  +(idx)
    ::
    :: temporary use of index for use by new-id
    :: which is not given back by this function
    index  (put:idx-orm:gol index new-id *pin:gol)
    map  (~(put by map) (snag idx list) new-id)
  ==
::
++  clone-goals
  |=  [=goals:gol own=ship now=@da]
  ^-  [id-map=(map id:gol id:gol) =goals:gol]
  =/  id-map  (new-ids ~(tap in ~(key by goals)) own now)
  :-  id-map
  |^
  %-  ~(gas by *goals:gol)
  %+  turn  ~(tap by goals)
  |=  [=id:gol =goal:gol]
  :-  (~(got by id-map) id)
  %=  goal
    par  ?~(par.goal ~ (some (new-id u.par.goal)))
    kids  (new-set-id kids.goal)
    ::
    inflow.kickoff  (new-set-nid inflow.kickoff.goal)
    outflow.kickoff  (new-set-nid outflow.kickoff.goal)
    inflow.deadline  (new-set-nid inflow.deadline.goal)
    outflow.deadline  (new-set-nid outflow.deadline.goal)
  ==
  ++  new-id  |=(=id:gol (~(got by id-map) id))
  ++  new-nid  |=(=nid:gol [-.nid (new-id id.nid)])
  ++  new-set-id  |=(=(set id:gol) (~(run in set) new-id))
  ++  new-set-nid  |=(=(set nid:gol) (~(run in set) new-nid))
  --
--
