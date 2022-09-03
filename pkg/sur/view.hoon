/-  *goal, *dates
|%
+$  state-1
  $:  %1
      =store
      =handles:s1
      =views:s1
      context=grip:s1
      hide-completed=?
      =utc-offset
  ==
+$  state-0
  $:  %0
      =store
      =handles:s0
      =views:s0
      context=grip:s0
      hide-completed=?
      =utc-offset
  ==
::
+$  grip     grip:s1
+$  view     view:s1
+$  views    views:s1
+$  handles  handles:s1
::
++  s1
  |%
  ::
  :: consider pools and goals and the null context as viewable things
  +$  grip
    $~  [%all ~]
    $%  [%all ~]
        [%pool =pin]
        [%goal =id]
    ==
  ::
  ::  $view:  an object which contains local information about how to
  ::               view a goal in the CLI.
  ::
  ::    .collapse:   set of collapsed goals nested underneath this goal
  ::    .hidden:     set of hidden goals nested underneath this goal
  +$  view
    $:  collapse=(set grip)
        hidden=(set grip)
    ==
  ::
  +$  views  (map grip view)
  ::
  ::  $handles:  handles are a shortened hash used to make accessing goals
  ::             in the CLI easier
  +$  handles  [hg=(map @t grip) gh=(map grip @t)]
  --
++  s0
  |%
  ::
  :: consider pools and goals and the null context as viewable things
  +$  grip
    $~  [%all ~]
    $%  [%all ~]
        [%project =pin]
        [%goal =id]
    ==
  ::
  ::  $view:  an object which contains local information about how to
  ::               view a goal in the CLI.
  ::
  ::    .collapse:   set of collapsed goals nested underneath this goal
  ::    .hidden:     set of hidden goals nested underneath this goal
  +$  view
    $:  collapse=(set grip)
        hidden=(set grip)
    ==
  ::
  +$  views  (map grip view)
  ::
  ::  $handles:  handles are a shortened hash used to make accessing goals
  ::             in the CLI easier
  +$  handles  [hg=(map @t grip) gh=(map grip @t)]
  --
::
++  grip-0-to-1
  |=  =grip:s0
  ^-  grip:s1
  ?+  -.grip  grip
    %project  [%pool pin.grip]
  ==
::
++  view-0-to-1
  |=  =view:s0
  ^-  view:s1
  :_  hidden=*(set grip:s1)
  (~(gas in *(set grip:s1)) (turn ~(tap in collapse.view) grip-0-to-1))
::
++  views-0-to-1
  |=  =views:s0
  ^-  views:s1
  %-  ~(gas by *(map grip view:s1))
  %+  turn  ~(tap by views)
  |=  [=grip:s0 =view:s0]
  :-  (grip-0-to-1 grip)
  (view-0-to-1 view)
::
++  handles-0-to-1
  |=  =handles:s0
  ^-  handles:s1
  :-  %-  ~(gas by *(map @t grip:s1))
      %+  turn  ~(tap by hg.handles)
      |=  [hdl=@t =grip:s0]
      [hdl (grip-0-to-1 grip)]
  %-  ~(gas by *(map grip:s1 @t))
  %+  turn  ~(tap by gh.handles)
  |=  [=grip:s0 hdl=@t]
  [(grip-0-to-1 grip) hdl]
::
:: From state-0 to state-1:
::   - grip was changed so that %project headtag was converted to %pool headtag
::
++  convert-0-to-1
  |=  [=state-0]
  ^-  state-1
  :*  %1
      store.state-0
      (handles-0-to-1 handles.state-0)
      (views-0-to-1 views.state-0)
      (grip-0-to-1 context.state-0)
      hide-completed.state-0
      utc-offset.state-0
  ==
::
+$  col-name
  $?  %handle
      %deadline
      %level
      %priority
  ==
::
+$  block
  $:  =grip
      indent=tape
      =mode
      lvl=@
      last=?
      clps=?
      virtual=?
      =prtd=(set grip)
      col-names=(list col-name)
  ==
--
