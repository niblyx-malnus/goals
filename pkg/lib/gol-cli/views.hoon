/-  gol=goal, vyu=view
/+  gol-cli-scries
|_  [=views:vyu =bowl:gall]
+*  scry  ~(. gol-cli-scries bowl)
::
++  new-goal
  |=  =id:gol
  ^-  views:vyu
  =/  grip  [%goal id]
  (~(put by views) grip *view:vyu)
::
++  new-pool
  |=  [=pin:gol =pool:gol]
  ^-  views:vyu
  =/  ids=(list grip:vyu)
    (turn ~(tap in ~(key by goals.pool)) |=(=id:gol [%goal id]))
  =.  views  (add-views (weld ids `(list grip:vyu)`[%pool pin]~))
  =.  views  (collapsify [%all ~] [%pool pin] %normal %.y %.n)
  (collapsify [%pool pin] [%pool pin] %normal %.y %.n)
::
++  initial
  ^-  views:vyu
  =.  views  *views:vyu
  =/  store  initial:scry
  =/  ids=(list grip:vyu)  (turn ~(tap in ~(key by index.store)) |=(=id:gol [%goal id]))
  =/  pins=(list grip:vyu)  
    %+  turn 
      ~(tap in ~(key by pools.store))
    |=(=pin:gol [%pool pin])
  =.  views  (add-views :(weld ids pins `(list grip:vyu)`[%all ~]~))
  =/  idx  0
  |-
  ?:  =(idx (lent pins))
    views
  =/  pin  (snag idx pins)
  %=  $
    idx  +(idx)
    views
      =.  views  (collapsify [%all ~] pin %normal %.y %.n)
      (collapsify pin pin %normal %.y %.n)
  ==
::
++  add-views
  |=  grips=(list grip:vyu)
  ^-  views:vyu
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
  |=  [ctx=grip:vyu clp=grip:vyu =mode:vyu rec=? inv=?]
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
