/-  *goal
|%
::
:: consider projects and goals and the null context as viewable things
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
