/-  nest
/+  gol-cli-goals
|_  [=goals:nest =views:nest]
+*  gols  ~(. gol-cli-goals goals)
::
:: 
++  collapsify
  |=  [ctx=(unit id:nest) clp=id:nest rec=? inv=?]
  =/  view  (~(got by views) ctx)
  =/  fam  (get-fam:gols `clp %c)
  =.  views
    ?:  inv
      (~(put by views) ctx [(~(del in collapse.view) clp) hidden.view])
    (~(put by views) ctx [(~(put in collapse.view) clp) hidden.view])
  ?.  rec  views
  ?~  fam  views
  =/  idx=@  0
  |-
  ?:  =(idx (lent fam))  views
  =/  clp  (snag idx `(list id:nest)`fam)
  $(idx +(idx), views (collapsify ctx clp rec inv))
--
