/-  gol=goal, vyu=view
/+  gol-cli-scries
|_  [=views:vyu =bowl:gall]
+*  scry  ~(. gol-cli-scries bowl)
::
++  add-new-goal
  |=  =id:gol
  ^-  views:vyu
  =/  grip  [%goal id]
  (~(put by views) grip *view:vyu)
::
++  add-new-pool
  |=  =pin:gol
  ^-  views:vyu
  =/  grip  [%pool pin]
  (~(put by views) grip *view:vyu)
::
++  update-views-new-pool
  |=  =pin:gol
  =.  views  updated-views
  =.  views  (collapsify [%all ~] [%pool pin] %normal %.y %.n)
  (collapsify [%pool pin] [%pool pin] %normal %.y %.n)
::
++  updated-views
  |-
  ^-  views:vyu
  =/  store  initial:scry
  =/  ids=(list grip:vyu)  (turn ~(tap in ~(key by directory.store)) |=(=id:gol [%goal id]))
  =/  pins=(list grip:vyu)  (turn ~(tap in ~(key by pools.store)) |=(=pin:gol [%pool pin]))
  =/  grips  (weld ids pins)
  =/  idx  0
  |-
  ?:  =(idx (lent grips))
    views
  =/  grip  (snag idx grips)
  ?:  (~(has by views) grip)
    $(idx +(idx))
  $(idx +(idx), views (~(put by views) grip *view:vyu))

:: 
++  collapsify
  |=  [ctx=grip:vyu clp=grip:vyu =mode:gol rec=? inv=?]
  ^-  views:vyu
  ?<  =(-.clp %all)
  =/  view  (~(got by views) ctx)
  =/  fam  (get-fam:scry clp mode)
  =.  views
    ?:  inv
      (~(put by views) ctx [(~(del in collapse.view) clp) hidden.view])
    (~(put by views) ctx [(~(put in collapse.view) clp) hidden.view])
  ?.  rec  views
  ?:  =(0 (lent fam))  views
  =/  idx=@  0
  |-
  ?:  =(idx (lent fam))  views
  =/  clp  (snag idx fam)
  $(idx +(idx), views (collapsify ctx clp mode rec inv))
--
