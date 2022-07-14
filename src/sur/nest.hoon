|%
::
++  goals-state-0
  |%
  +$  id  [@p @da]
  ::
  +$  goal
    $:  desc=@t
        deadline=(unit @da)
        pars=(set id)
        kids=(set id)
        befs=(set id)
        afts=(set id)
        actionable=?
        status=?(%active %completed %ghost)
    ==
  ::
  +$  goal-view
    $:  collapse=(set id)
        hidden=(set id)
    ==
  ::
  +$  goals  (map id goal)
  ::
  +$  views  (map (unit id) goal-view)
  ::
  +$  handles  [hi=(map @t id) ih=(map id @t)]
  --
::
:: $id: identity of a goal; determined by creator and time of creation
+$  id  [@p @da]
::
:: 
+$  dir
  $?  %nest-left
      %nest-ryte
      %prec-left
      %prec-ryte
      %prio-left
      %prio-ryte
  ==
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
::
+$  goal
  $:  desc=@t
      deadline=(unit @da)
      pars=(set id)
      kids=(set id)
      befs=(set id)
      afts=(set id)
      moar=(set id)
      less=(set id)
      actionable=?
      status=?(%active %completed %ghost)
  ==
::
::  $goal-view:  an object which contains local information about how to
::               view a goal in the CLI.
::
::    .collapse:   set of collapsed goals nested underneath this goal
::    .hidden:     set of hidden goals nested underneath this goal
::
+$  goal-view
  $:  collapse=(set id)
      hidden=(set id)
  ==
::
::
+$  goals  (map id goal)
::
::  map from unit so that base context ~ can have a view as well
+$  views  (map (unit id) goal-view)
::
::  $handles:  handles are a shortened hash used to make accessing goals
::             in the CLI easier
+$  handles  [hi=(map @t id) ih=(map id @t)]
::
::  $action:  request to change goal state
::
::    %add:
::    %del:
::    %nest:
::    %flee:
::    %clearall:
::    %cc: change context
::    %clps: 
::    %uncl:
::
+$  action
  $%  [%add desc=@t par=(unit id)]
      [%del =id]
      [%nest par=id kid=id]
      [%flee par=id kid=id]
      [%prec ryt=id lef=id]
      [%unpr ryt=id lef=id]
      [%prio ryt=id lef=id]
      [%uprt ryt=id lef=id]
      [%clearall ~]
      [%cc c=(unit id)]
      [%clps ctx=(unit id) clp=id rec=?]
      [%uncl ctx=(unit id) clp=id rec=?]
      [%tz utc-offset=[hour=@dr ahead=?]]
      [%sd =id deadline=(unit @da)]
      [%actionate =id]
      [%complete =id]
      [%activate =id]
  ==
--
