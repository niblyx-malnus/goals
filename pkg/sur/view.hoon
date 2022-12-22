/-  *goal, *dates
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
::    .loc:        number determining which row to start printing from
::    .hidden:     set of hidden goals nested underneath this goal
::    .collapse:   set of collapsed goals nested underneath this goal
+$  view
  $:  loc=@
      hidden=(set grip)
      collapse=(set grip)
  ==
::
+$  views  (map grip view)
::
::  $handles:  handles are a shortened hash used to make accessing goals
::             in the CLI easier
+$  handles  [hg=(map @t grip) gh=(map grip @t)]
::
+$  normal-mode
  $?  %normal
      %normal-completed
  ==
+$  mode
  $?  normal-mode
      %nest-ryte
      %nest-left
      %prec-ryte
      %prec-left
      %prio-ryte
      %prio-left
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
