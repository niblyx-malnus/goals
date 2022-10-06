/-  gol=goal, vyu=view
/+  gol-cli-scries
|_  [=handles:vyu =bowl:gall]
+*  scry  ~(. gol-cli-scries bowl)
::
++  new-goal
  |=  =id:gol
  ^-  handles:vyu
  (add-handles [%goal id]~)
::
++  new-pool
  |=  [=pin:gol =pool:gol]
  ^-  handles:vyu
  =/  ids=(list grip:vyu)
    (turn ~(tap in ~(key by goals.pool)) |=(=id:gol [%goal id]))
  (add-handles (weld ids `(list grip:vyu)`[%pool pin]~))
::
++  delete-goal
  |=  =id:gol
  ^-  handles:vyu
  (delete-handles [%goal id]~)
::
++  delete-pool
  |=  =pin:gol
  ^-  handles:vyu
  =/  pool  (got-pool:scry pin)
  =/  ids=(list grip:vyu)
    (turn ~(tap in ~(key by goals.pool)) |=(=id:gol [%goal id]))
  (delete-handles (weld ids `(list grip:vyu)`[%pool pin]~))
::
++  initial
  ^-  handles:vyu
  =.  handles  *handles:vyu
  =/  =store:gol  initial:scry
  =/  ids=(list grip:vyu)
    (turn ~(tap in ~(key by directory.store)) |=(=id:gol [%goal id]))
  =/  pins=(list grip:vyu)
    (turn ~(tap in ~(key by pools.store)) |=(=pin:gol [%pool pin]))
  (add-handles (weld ids pins))
::
++  add-handles
  |=  grips=(list grip:vyu)
  ^-  handles:vyu
  =/  idx  0
  |-
  ?:  =(idx (lent grips))
    handles
  =/  grip  (snag idx grips)
  ?:  (~(has by gh.handles) grip)
    $(idx +(idx))
  =/  hdl  (make-handle grip)
  $(idx +(idx), handles [(~(put by hg.handles) hdl grip) (~(put by gh.handles) grip hdl)])
::
++  delete-handles
  |=  grips=(list grip:vyu)
  ^-  handles:vyu
  =/  idx  0
  |-
  ?:  =(idx (lent grips))
    handles
  =/  grip  (snag idx grips)
  ?.  (~(has by gh.handles) grip)
    $(idx +(idx))
  =/  hdl  (~(got by gh.handles) grip)
  $(idx +(idx), handles [(~(del by hg.handles) hdl) (~(del by gh.handles) grip)])
::
++  grip-to-tape
  |=  =grip:vyu
  ^-  tape
  ?-  -.grip
    %all  !!
    %pool  (handle (scow %ud (shad (cat 0 %pin (cat 0 +>-.grip +>+.grip)))))
    %goal  (handle (scow %ud (shad (cat 0 +<.grip +>.grip))))
  ==
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
  |=  =grip:vyu 
  ^-  @t
  =/  =tape  (grip-to-tape grip)
  =/  idx=@  3
  |-
  ?:  =(idx (lent tape))  ~&('Handle uniqueness error!' !!)
  ?:  (~(has by hg.handles) (crip (swag [0 idx] tape)))
    $(idx +(idx))
  (crip (swag [0 idx] tape))
  ::
:: get goal from handle (?(~ [~ [gid gol]])) returning null if does not
:: exist
++  handle-to-goal
  |=  hdl=@t
  ^-  (unit [id:gol goal:gol])
  =/  grip  (~(get by hg.handles) hdl)
  ?~  grip  ~
  ?-  -.u.grip
    ?(%all %pool)  ~
    %goal  (some [+.u.grip (got-goal:scry +.u.grip)])
  ==
::
++  handle-to-pool
  |=  hdl=@t
  ^-  (unit [pin:gol pool:gol])
  =/  grip  (~(get by hg.handles) hdl)
  ?~  grip  ~
  ?-  -.u.grip
    ?(%all %goal)  ~
    %pool  (some [+.u.grip (got-pool:scry +.u.grip)])
  ==
::
:: purge goal from handles
++  purge-handles
  |=  =grip:vyu
  ^-  handles:vyu
  :_  (~(del by gh.handles) grip)
      (~(del by hg.handles) (~(got by gh.handles) grip))
--
