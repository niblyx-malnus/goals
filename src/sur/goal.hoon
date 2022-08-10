|%
::
:: $id: identity of a goal; determined by creator and time of creation
+$  id  [owner=@p birth=@da]
::
:: $goal:        represents a single indivisible goal, task, or aim
::
::   .desc:        simple description of goal as text
::   .deadline:    deadline for goal (null if non-existent)
::   .pars:        set of parent goals which this goal nests under
::   .kids:        set of child goals which nest under this goal
::   .befs:        set of goals which come immediately before this goal
::                 this goal cannot be completed until all befs are
::                 completed
::                 befs should contain all kids
::   .afts:        set of goals which come immediately after this goal
::                 this goal inherits its deadline from its afts
::                 afts should contain all pars
::   .moar:        set of goals immediately more important (priority)
::   .less:        set of goals immediately less important (priority)
::   .actionable:  actionable - can this goal be acted upon immediately?
::                 a goal cannot be marked actionable if .kids is not
::                 empty
::   .status:      is this goal %active, %completed, or %ghost?
::     %active:      goal has not yet been completed
::                   when a goal is marked active, all its completed
::                   afts are marked active as well
::     %completed:   goal has been completed
::                   a goal cannot be marked complete until all befs are
::                   complete
::     %ghost:       goal is ignored; draft goal or archived goal...
+$  goal
  $:  desc=@t
      author=ship
      chefs=(set ship)
      peons=(set ship)
      deadline=(unit @da)
      par=(unit id)
      kids=(set id)
      uncs=(set id)
      nefs=(set id)
      befs=(set id)
      afts=(set id)
      moar=(set id)
      less=(set id)
      actionable=?
      =status
  ==
::
+$  goals  (map id goal)
::
+$  project
  $:  title=@t
      creator=ship
      =goals
      chefs=(set ship)
      peons=(set ship)
      viewers=(set ship)
  ==
::
+$  pin  [%pin id]
::
+$  projects  (map pin project)
::
+$  directory  (map id pin)
::
+$  store  [=directory =projects]
:: 
+$  dir
  $?  %nest-ryte
      %nest-left
      %nest-left-completed
      %prec-ryte
      %prec-left
      %prio-ryte
      %prio-left
  ==
::
+$  status
  $~  %active
  $?  %active
      %completed
      %ghost
  ==
::
+$  error
  $%  [%m =term]
      [%c path=(list id)]
  ==
::
+$  store-update
  $%  [%& update=[=pin =project] =store]
      [%| =error]
  ==
::
+$  yoke-output
  $%  [%& =projects]
      [%| =error]
  ==
::
+$  comp-output
  $%  [%& ?]
      [%| =error]
  ==
::
+$  comparator  $-([id id] comp-output)
::
+$  linker  $-([id id] projects)
::
+$  goal-perm
  $%  %mod-chefs
      %mod-peons
      %add-under
      %remove
      %edit-desc
  ==
::
+$  project-perm
  $%  %mod-viewers
      %edit-title
      %new-goal
  ==
::
+$  pair-perm
  $%  %&
  ==
--
