/-  gol=goal
/+  *gol-cli-goal
|_  store:gol
:: create unique goal id based on source ship and creation time
++  unique-id
  |=  [our=ship now=@da]
  ^-  id:gol
  ?.  ?|  (~(has by index) [our now])
          (~(has by pools) [%pin our now])
      ==
    [our now]
  $(now (add now ~s0..0001))
::
++  new-ids
  |=  [=(list id:gol) our=ship now=@da]
  ^-  (map id:gol id:gol)
  =/  idx  0
  =|  =(map id:gol id:gol)
  |-
  ?:  =(idx (lent list))
    map
  =/  new-id  (unique-id our now)
  %=  $
    idx  +(idx)
    index  (~(put by index) new-id *pin:gol)
    map  (~(put by map) (snag idx list) new-id)
  ==
--
