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
  $?  [%change-context c=(unit @t)]             :: change context
      [%hide-completed ~]
      [%unhide-completed ~]
      [%print-context ~]                       :: print context
      [%pg h=(unit @t) cpt=?]       :: print goal
      [%held-yoke l=@t r=@t]
      [%held-rend l=@t r=@t]
      [%nest-yoke l=@t r=@t]
      [%nest-rend l=@t r=@t]
      [%prec-yoke l=@t r=@t]
      [%prec-rend l=@t r=@t]
      [%prio-yoke l=@t r=@t]
      [%prio-rend l=@t r=@t]
      [%held-left l=@t r=@t]
      [%nest-left l=@t r=@t]
      [%prec-left l=@t r=@t]
      [%prio-left l=@t r=@t]
      [%ng c=@t p=@t]               :: nest goal (perhaps better ns?)
      [%mv c=@t p=@t]               :: move goal (nest under specified, unnest from current context)
      [%fg c=@t p=@t]               :: flee/unnest goal (perhaps better un?)
      [%ap l=@t r=@t]               :: precede goal (add precedence)
      [%rp l=@t r=@t]               :: unprecede goal (remove precedence)
      [%up l=@t r=@t]               :: unprioritize
      [%new-project title=@t]                :: new project
      [%delete-project-goal h=@t]
      [%copy-project h=@t title=@t]                :: new project
      [%add-goal desc=@t]                 :: add goal
      [%at desc=@t]                 :: add task (actionable goal)
      [%edit-goal-desc h=@t desc=@t]            :: edit goal (replace description)
      [%edit-project-title h=@t title=@t]           :: edit project (replace title)
      [%rg h=@t]                    :: remove goal
      [%pp h=@t]                    :: print parents
      [%ppc h=@t]                   :: print precedents
      [%collapse h=@t rec=?]              :: collapse goal with respect to current context
      [%uncollapse h=@t rec=?]              :: uncollapse goal
      [%set-deadline h=@t d=(unit @d)]        :: set deadline
      [%set-utc-offset hours=@dr ahead=?]       :: change utc-offset
      [%bf h=@t]                    :: print befores
      [%af h=@t]                    :: print afters
      [%hv h=@t =hv-flag]           :: print harvest
      [%mark-actionable h=@t]
      [%unmark-actionable h=@t]
      [%mark-complete h=@t]
      [%unmark-complete h=@t]
      :: %hd                        :: hide goal
      :: %uh                        :: unhide goal
      :: %ph                        :: print hidden
      :: %pd                        :: print deadline (or other
      ::                            ::   goal-specific information)
      ::                            :: "inspect goal" in a way
      [%pa ~]                       :: print all as list
      [%ps ~]                       :: print all sorted
      [%ds ~]                       :: sort by deadline
      [%invite invitee=ship h=@t]   :: invite ship to view goal
      [%make-chef chef=ship h=@t]          :: make chef
      [%make-peon peon=ship h=@t]          :: make peon
  ==
::
++  tab-list
  ^-  (list [@t tank])
  :~  ['clearall' leaf+"clear data structure"]
      ['ag' leaf+"add goal"]
      ['eg' leaf+"edit goal"]
      ['ng' leaf+"nest goal"]
      ['fg' leaf+"flee goal"]
      ['rg' leaf+"del goal"]
      ['cc' leaf+"change context goal"]
      ['pg' leaf+"print goal substructure"]
      ['pp' leaf+"print parents"]
      ['sd' leaf+"set deadline"]
      ['tz' leaf+"change utc-offset"]
      ['pz' leaf+"print utc-offset"]
      ['ap' leaf+"add precedence"]
      ['rp' leaf+"remove precedence"]
      ['pa' leaf+"print all"]
      ['bf' leaf+"print befs"]
      ['af' leaf+"print afts"]
      ['an' leaf+"actionate"]
      ['av' leaf+"activate"]
      ['ct' leaf+"complete"]
      ['hv' leaf+"harvest progenitors"]
  ==
--
