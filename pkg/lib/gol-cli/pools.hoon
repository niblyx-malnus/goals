/-  gol=goal
/+  gol-cli-goals, pl=gol-cli-pool, em=gol-cli-emot, *gol-cli-util
|_  store:gol
+*  gols  ~(. gol-cli-goals +<)
::
:: create unique pool id based on source ship and creation time
++  unique-pin
  |=  [own=ship now=@da]
  ^-  pin:gol
  ?.  (~(has by pools) [%pin own now])
    [%pin own now]
  $(now (add now ~s0..0001))
::
++  spawn-pool
  |=  [title=@t own=ship now=@da]
  ^-  [pin:gol pool:gol]
  =/  pin  (unique-pin own now)
  =|  =pool:gol
  =.  owner.pool  owner.pin
  =.  birth.pool  birth.pin
  =.  title.pool  title
  =.  creator.pool  own
  [pin pool]
::
++  clone-pool
  |=  [=old=pin:gol title=@t own=ship now=@da]
  ^-  [pin:gol pool:gol]
  =/  old-pool  (~(got by pools) old-pin)
  =+  [pin pool]=(spawn-pool title own now)
  =.  pool  pool(creator owner.old-pin)
  =.  pool  pool(goals goals:(clone-goals:gols goals.old-pool own now))
  [pin pool:abet:(inflater:(apex:em pool))]
::
++  sort-by-order
  |=  input=(list id:gol)
  ^-  (list id:gol)
  =/  ord  ?~  order  *(map id:gol @)
           %-  ~(gas by *(map id:gol @))
           (fuse order (gulf 1 (lent order)))
  %+  sort
    input
  |=  [a=id:gol b=id:gol]
  (lth (~(got by ord) a) (~(got by ord) b))
::
++  clone-goal
  |=  $:  =old=id:gol
          upin=(unit pin:gol) :: destination pin; new pool if ~
          upid=(unit id:gol) :: must be ~ if upin is ~
          udesc=(unit @t)
          sfx=@t
          own=ship
          now=@da
      ==
  ^-  [ids=(list id:gol) =pin:gol =pool:gol]
  ::
  :: Old pool info
  =/  old-pin  (got:idx-orm:gol index old-id)
  =/  old-pool  (~(got by pools) old-pin)
  ::
  :: Get goal and goal descendents
  =/  waz  trac:(wrest-goal:~(. pl old-pool) old-id owner.old-pool)
  =/  old-goal  (~(got by waz) old-id)
  =/  new-desc  ?~(udesc desc.old-goal u.udesc)
  ::
  :: Update goal descriptions
  =.  waz  (~(put by waz) old-id old-goal(desc new-desc))
  =.  waz
    %-  ~(run by waz)
    |=  =goal:gol 
    goal(desc (crip (weld (trip desc.goal) (trip sfx))))
  ::
  :: Identify dest pool (spawn one if necessary)
  =+  ^-  [=dest=pin:gol =dest=pool:gol]
    ?~  upin
      =/  title  (crip (weld (trip new-desc) (trip sfx)))
      (spawn-pool title own now)
    ?.  =((got:idx-orm:gol index old-id) u.upin)
      ~|("pin and id do not correspond" !!)
    [u.upin (~(got by pools) u.upin)]
  ::
  :: Clone the goals
  =+  (clone-goals:gols waz own now)  :: exposes id-map and goals
  =.  dest-pool  dest-pool(goals goals)
  ::
  :: In order for this to work more smoothly need to settle pin vs id
  :: will pin be changed to human readable names like group channels?
  :: will id then be pin/birth, only identified by birth datetime?
  :: also need validators for a pool or goals structure...
  !!
--
