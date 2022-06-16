/-  nest
|%
++  grip
  |=  =id:nest
  ^-  tape
  (handle (scow %ud (shad (cat 0 -:id +:id))))
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
--
