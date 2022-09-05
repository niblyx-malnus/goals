/-  gol=goal, vyu=view
/+  gol-cli-scries
|_  [=handles:vyu =bowl:gall]
+*  scry  ~(. gol-cli-scries bowl)
::
++  add-new-goal
  |=  [=id:gol =directory:gol =pools:gol]
  ^-  handles:vyu
  =/  grip  [%goal id]
  =/  hdl  (make-handle grip)
  [(~(put by hg.handles) hdl grip) (~(put by gh.handles) grip hdl)]
::
++  generate
  |=  [=directory:gol =pools:gol]
  ^-  handles:vyu
  =.  handles  *handles:vyu :: from scratch
  =/  ids=(list grip:vyu)
    (turn ~(tap in ~(key by directory)) |=(=id:gol [%goal id]))
  =/  pins=(list grip:vyu)
    (turn ~(tap in ~(key by pools)) |=(=pin:gol [%pool pin]))
  =/  grips  (weld ids pins)
  =/  idx  0
  |-
  ?:  =(idx (lent grips))
    handles
  =/  grip  (snag idx grips)
  =/  hdl  (make-handle grip)
  $(idx +(idx), handles [(~(put by hg.handles) hdl grip) (~(put by gh.handles) grip hdl)])
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
