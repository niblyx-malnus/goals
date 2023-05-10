/-  *goal
:: a view is a distorted view of the store, a perspective, a transformation
::
:: TODO:
:: - include sorting as a parameter
:: - Include pin in goal initial (for tree view?)
:: - Include pool role in harvest and list view
:: - Add young to roots in trace for a goal page initial
|%
+$  vid  @uv
+$  views  (map vid [ack=_| =view])
+$  ask  [pid=@ pok=parm:views]
+$  say  [=path =data:views]
+$  view
  $%  [%tree =parm:tree =data:tree]
      [%harvest =parm:harvest =data:harvest]
      [%list-view =parm:list-view =data:list-view]
      [%page =parm:page =data:page]
  ==
+$  parm
  $%  [%tree parm:tree]
      [%harvest parm:harvest]
      [%list-view parm:list-view]
      [%page parm:page]
  ==
+$  data
  $%  [%tree data:tree]
      [%harvest data:harvest]
      [%list-view data:list-view]
      [%page data:page]
  ==
:: dots must be acked
::
+$  send  $%([%dot =path] diff)
+$  diff
  $%  [%tree diff:tree]
      [%harvest diff:harvest]
      [%list-view diff:list-view]
      [%page diff:page]
  ==
++  tree
  |%
  +$  parm  $:(=type)
  +$  type  $%([%main ~] [%pool =pin] [%goal =id])
  +$  data  $:(pools=tree-pools cache=tree-pools)
  +$  diff  [[=pin mod=ship pid=@] update]
  :: trying to slowly sever this from underlying DS
  ::
  +$  tree-pool   pool
  +$  tree-pools  (map pin tree-pool)
  --
++  harvest
  |%
  +$  parm
    $:  =type
        method=?(%any %all)
        tags=(set tag)
    ==
  +$  type  $%([%main ~] [%pool =pin] [%goal =id])
  +$  data  $:(goals=(list [id pack]))
  +$  pack
    $:  =pin
        pool-role=(unit ?(%owner pool-role))
        goal
    ==
  ::  $:  pool-role=(unit pool-role)
  ::      nexus=goal-nexus
  ::      trace=goal-trace
  ::      hitch=goal-hitch
  ::  ==
  +$  diff  [[=pin mod=ship pid=@] $%([%replace data])]
  --
++  list-view
  |%
  +$  parm
    $:  =type
        first-gen-only=_|
        actionable-only=_|
        method=?(%any %all)
        tags=(set tag)
    ==
  +$  type
    $%  [%main ~]
        [%pool =pin]
        [%goal =id ignore-virtual=_|]
    ==
  +$  data  $:(goals=(list [id pack]))
  +$  pack
    $:  =pin
        pool-role=(unit ?(%owner pool-role))
        goal
    ==
  ::  $:  pool-role=(unit pool-role)
  ::      nexus=goal-nexus
  ::      trace=goal-trace
  ::      hitch=goal-hitch
  ::  ==
  +$  diff  [[=pin mod=ship pid=@] $%([%replace data])]
  --
++  page
  |%
  +$  parm  $:(=type)
  +$  type  $%([%main ~] [%pool =pin] [%goal =id])
  +$  data  pack
  +$  pack
    $%  [%main ~]
        $:  %pool
            title=@t
            note=@t
        ==
        $:  %goal
            par-pool=pin
            par-goal=(unit id)
            desc=@t
            note=@t
            tags=(set tag)
        ==
    ==
  +$  diff  [[=pin mod=ship pid=@] $%([%replace data])]
  --
--
