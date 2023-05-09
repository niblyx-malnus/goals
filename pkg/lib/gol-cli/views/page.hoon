/-  gol=goal
|_  =store:gol
+*  vyu   views:gol
++  view-data
  |=  =parm:page:vyu
  ^-  data:page:vyu
  ?-    -.type.parm
    %main  [%main ~]
    %pool  [%pool title note]:(~(got by pools.store) pin.type.parm)
    ::
      %goal
    =/  =pin:gol  (got:idx-orm:gol index.store id.type.parm)
    =/  pool  (~(got by pools.store) pin)
    =.  goals.pool  (unify-tags goals.pool)
    =/  =goal:gol  (~(got by goals.pool) id.type.parm)
    [%goal pin [par desc note tags]:goal]
  ==
::
++  view-diff
  |=  $:  =parm:page:vyu
          =data:page:vyu
          upd=home-update:gol
      ==
  ^-  (unit diff:page:vyu)
  =;  diff=(unit diff:page:vyu)
    ~|  "non-equivalent-page-view-diff"
    =/  check=?
      ?~  diff  =(data (view-data parm))
      =((view-data parm) (etch-diff data u.diff))
    ?>(check diff)
  =/  atad=data:page:vyu  (view-data parm)
  ?:  =(data atad)  ~
  (some [[pin mod pid]:upd %replace atad])
::
++  etch-diff
  |=  [=data:page:vyu =diff:page:vyu]
  ^-  data:page:vyu
  ?>(?=(%replace +<.diff) +>.diff)
::
++  unify-tags
  |=  =goals:gol
  ^-  goals:gol
  %-  ~(gas by *goals:gol)
  %+  turn  ~(tap by goals)
  |=  [=id:gol =goal:gol]
  ^-  [id:gol goal:gol]
  :-  id
  %=    goal
      tags
   %-  ~(uni in tags.goal)
   ?~  get=(~(get by goals.local.store) id)
     ~
   tags.u.get
  ==
--
