/-  nest
|_  [=goals:nest =handles:nest]
::
::
++  grip
  |=  =id:nest
  ^-  tape
  (handle (scow %ud (shad (cat 0 -:id +:id))))
::
::
++  handle
  |=  nums=tape
  ^-  tape
  =|  out=(list @t)
  |-
  =/  pair  (firstpass nums)
  =/  chr  -:pair
  =/  rem  +:pair
  ?:  =(0 (lent nums))
    out
  ?:  =(0 (lent rem))
    out
  ?~  chr
    $(nums rem)
  $(out (snoc out `@t`+:chr), nums rem)
::
::
++  firstpass
  |=  nums=tape
  ^-  [(unit @) tape]
  =/  cnt=@  33
  |-
  ?:  =(cnt 127)
    [~ `tape`(slag 1 nums)]
  =/  stp=@  (sub q.p:((jest (scot %ud cnt)) [[1 1] nums]) 1)
  ?:  =(stp (lent (scow %ud cnt)))
    :-  `cnt 
    `tape`(slag stp nums)
  $(cnt +(cnt))
::
:: make a unique handle based on the goal id
++  make-handle
  |=  =id:nest 
  ^-  @t
  =/  grp=tape  (grip:handle id)
  =/  idx=@  3
  |-
  ?:  =(idx (lent grp))  ~&('Handle uniqueness error!' !!)
  ?:  (~(has by hi.handles) (crip (swag [0 idx] grp)))
    $(idx +(idx))
  (crip (swag [0 idx] grp))
  ::
:: get goal from handle (?(~ [~ [gid gol]])) returning null if does not
:: exist
++  get-handle
  |=  hdl=@t
  ^-  (unit [id:nest goal:nest])
  =/  id  (~(get by hi.handles) hdl)
  ?~  id  ~
  (some [u.id (~(got by goals) u.id)])
::
:: purge goal from handles
++  purge-handles
  |=  =id:nest
  ^-  handles:nest
  :_  (~(del by ih.handles) id)
      (~(del by hi.handles) (~(got by ih.handles) id))
--
