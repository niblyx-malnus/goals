/-  gol=goal, vyu=view
/+  gol-cli-goals
|_  [=store:gol =views:vyu]
+*  gols  ~(. gol-cli-goals store)
::
++  add-new-goal
  |=  [=id:gol =directory:gol =projects:gol]
  ^-  views:vyu
  =/  grip  [%goal id]
  (~(put by views) grip *view:vyu)
::
++  update-views
  |=  [=directory:gol =projects:gol]
  ^-  views:vyu
  =/  ids=(list grip:vyu)  (turn ~(tap in ~(key by directory)) |=(=id:gol [%goal id]))
  =/  pins=(list grip:vyu)  (turn ~(tap in ~(key by projects)) |=(=pin:gol [%project pin]))
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
  ?<  =(-.clp %all)
  =/  view  (~(got by views) ctx)
  =/  fam  (get-fam:gols clp mode)
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
