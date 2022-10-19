|%
::
+$  hv-flag
  $?  %actionable
      %completed
      %unpreceded
  ==
:: held-yoke nest-yoke prec-yoke
::
+$  command
  $?  [%change-context c=(unit @t)]
      [%hide-completed ~]
      [%unhide-completed ~]
      [%print-context ~]
      [%held-yoke l=@t r=@t]
      [%held-rend l=@t r=@t]
      [%nest-yoke l=@t r=@t]
      [%nest-rend l=@t r=@t]
      [%prec-yoke l=@t r=@t]
      [%prec-rend l=@t r=@t]
      [%prio-yoke l=@t r=@t]
      [%prio-rend l=@t r=@t]
      [%spawn-pool title=@t]
      [%clone-pool h=@t title=@t]
      [%cache-pool h=@t]
      [%renew-pool h=@t]
      [%trash-pool h=@t]
      [%spawn-goal desc=@t]
      [%cache-goal h=@t]
      [%renew-goal h=@t]
      [%trash-goal h=@t]
      [%edit-goal-desc h=@t desc=@t]
      [%edit-pool-title h=@t title=@t]
      [%collapse h=@t rec=?]
      [%uncollapse h=@t rec=?]
      [%set-kickoff h=@t k=(unit @d)]
      [%set-deadline h=@t d=(unit @d)]
      [%set-utc-offset hours=@dr ahead=?]
      [%mark-actionable h=@t]
      [%unmark-actionable h=@t]
      [%mark-complete h=@t]
      [%unmark-complete h=@t]
      [%harvest h=@t]
      [%invite invitee=ship h=@t]
  ==
::
++  tab-list
  ^-  (list [@t tank])
  :~  ['ag' leaf+"add goal"]
  ==
--
