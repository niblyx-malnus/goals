/-  gol=goal
/+  gol-cli-etch, gol-cli-node, gol-cli-traverse,
    gol-cli-views-tree, gol-cli-views-harvest, gol-cli-views-list-view,
    gol-cli-views-page
|_  [=store:gol =bowl:gall]
+*  vyu   views:gol
    etch  ~(. gol-cli-etch store)
    tree  ~(. gol-cli-views-tree store)
    harv  ~(. gol-cli-views-harvest store bowl)
    livy  ~(. gol-cli-views-list-view store bowl)
    page  ~(. gol-cli-views-page store)
:: Convert an update into a diff for a given view
::
++  view-diff
  |=  [=view:vyu upd=home-update:gol]
  ^-  (unit diff:vyu)
  ?-  -.view
    %tree       (bind (view-diff:tree parm.view data.view upd) (lead %tree))
    %harvest    (bind (view-diff:harv parm.view data.view upd) (lead %harvest))
    %list-view  (bind (view-diff:livy parm.view data.view upd) (lead %list-view))
    %page       (bind (view-diff:page parm.view data.view upd) (lead %page))
  ==
::
++  grab-view
  |=  =parm:vyu
  ^-  view:vyu
  ?-  -.parm
    %tree       [%tree +.parm (view-data:tree +.parm)]
    %harvest    [%harvest +.parm (view-data:harv +.parm)]
    %list-view  [%list-view +.parm (view-data:livy +.parm)]
    %page       [%page +.parm (view-data:page +.parm)]
  ==
::
++  view-data
  |=  =parm:vyu
  ^-  data:vyu
  ?-  -.parm
    %tree       [%tree (view-data:tree +.parm)]
    %harvest    [%harvest (view-data:harv +.parm)]
    %list-view  [%list-view (view-data:livy +.parm)]
    %page       [%page (view-data:page +.parm)]
  ==
--
