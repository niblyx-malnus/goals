/-  gol=goal
/+  *gol-cli-goal, gol-cli-goals, pl=gol-cli-pool
:: apply (etch) updates received from foreign pools
::
|_  =store:gol
+*  gols   ~(. gol-cli-goals +<)  
::
++  spawn-trash
  |%
  ++  spawn-pool
    |=  [=pin:gol =pool:gol]
    ^-  store:gol
    ?:  (~(has by pools.store) pin)  store :: necessary?
    %=  store
      directory
        %-  ~(gas by directory.store)
        (turn ~(tap in ~(key by goals.pool)) |=(=id:gol [id pin]))
      pools  (~(put by pools.store) pin pool)
    ==
  ::
  ++  trash-pool
    |=  =pin:gol
    ^-  store:gol
    :-  %-  ~(gas by *directory:gol)
        %+  murn  ~(tap by directory.store)
        |=  [=id:gol =pin:gol]
        ?:  =(pin ^pin)
          ~
        (some [id pin])
    (~(del by pools.store) pin)
  --
--
