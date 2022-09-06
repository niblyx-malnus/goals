/+  dates=gol-cli-dates, *gol-cli-help
|%
++  command-parser
  |=  [now=@da =utc-offset:dates]
  ;~  pose
    parse-invite                              :: %invite
    parse-held-yoke                           
    parse-held-rend-strict
    parse-nest-yoke                           
    parse-nest-rend
    parse-prec-yoke
    parse-prec-rend                           
    parse-prio-yoke                           
    parse-prio-rend                           
    parse-held-left
    parse-nest-left                           
    parse-prec-left                           
    parse-prio-left                           
    parse-new-pool                         :: %np
    parse-delete-pool-goal
    parse-copy-pool                         
    parse-make-chef                           :: %mc
    parse-make-peon                           :: %mp
    parse-add-goal                            :: %ag
    parse-add-task                            :: %at
    parse-edit-goal-desc                      :: %eg
    parse-edit-pool-title                  :: %ep
    parse-change-context                      :: %cc
    parse-hide-completed
    parse-unhide-completed
    parse-set-utc-offset                      :: %tz
    parse-print-goal                          :: %pg
    parse-print-parents                       :: %pp
    parse-print-precedents                    :: %ppc
    parse-collapse                            :: %cp
    parse-uncollapse                          :: %uc
    (parse-set-deadline now utc-offset)       :: %sd
    parse-print-all                           :: %pa
    parse-print-sorted                        :: %ps
    parse-deadline-sort                       :: %ds
    parse-print-befs                          :: %bf
    parse-print-afts                          :: %af
    parse-mark-actionable
    parse-unmark-actionable
    parse-mark-complete
    parse-unmark-complete
    parse-harvest-progenitors                 :: %hv
    parse-print-context                       :: %pc
  ==
:: ----------------------------------------------------------------------------
:: individual command parsers
::
++  parse-held-yoke
  ;~  (glue ace)
    (cold %held-yoke (jest 'mv'))
    (cook crip parse-handle)
    (cook crip parse-handle)
  ==
::
++  parse-held-rend-strict
  ;~  (glue ace)
    (cold %held-rend-strict (jest '^mv'))
    (cook crip parse-handle)
    (cook crip parse-handle)
  ==
::
++  parse-nest-yoke
  ;~  (glue ace)
    (cold %nest-yoke (jest 'ns'))
    (cook crip parse-handle)
    (cook crip parse-handle)
  ==
::
++  parse-nest-rend
  ;~  (glue ace)
    (cold %nest-rend (jest '^ns'))
    (cook crip parse-handle)
    (cook crip parse-handle)
  ==
::
++  parse-prec-yoke
  ;~  (glue ace)
    (cold %prec-yoke (jest 'pr'))
    (cook crip parse-handle)
    (cook crip parse-handle)
  ==
::
++  parse-prec-rend
  ;~  (glue ace)
    (cold %prec-rend (jest '^pr'))
    (cook crip parse-handle)
    (cook crip parse-handle)
  ==
::
++  parse-prio-yoke
  ;~  (glue ace)
    (cold %prio-yoke (jest 'pt'))
    (cook crip parse-handle)
    (cook crip parse-handle)
  ==
::
++  parse-prio-rend
  ;~  (glue ace)
    (cold %prio-rend (jest '^pt'))
    (cook crip parse-handle)
    (cook crip parse-handle)
  ==
::
++  parse-held-left
  ;~  (glue ace)
    (cold %held-left (jest '?mv'))
    (cook crip parse-handle)
    (cook crip parse-handle)
  ==
::
++  parse-nest-left
  ;~  (glue ace)
    (cold %nest-left (jest '?ns'))
    (cook crip parse-handle)
    (cook crip parse-handle)
  ==
::
++  parse-prec-left
  ;~  (glue ace)
    (cold %prec-left (jest '?pr'))
    (cook crip parse-handle)
    (cook crip parse-handle)
  ==
::
++  parse-prio-left
  ;~  (glue ace)
    (cold %prio-left (jest '?pt'))
    (cook crip parse-handle)
    (cook crip parse-handle)
  ==
::
++  parse-invite
  ;~  (glue ace)
    (cold %invite (jest 'invite'))
    fed:ag
    (cook crip parse-handle)  :: handle argument
  ==
::
++  parse-make-chef
  ;~  (glue ace)
    (cold %make-chef (jest 'mc'))
    fed:ag
    (cook crip parse-handle)  :: handle argument
  ==
::
++  parse-make-peon
  ;~  (glue ace)
    (cold %make-peon (jest 'mp'))
    fed:ag
    (cook crip parse-handle)  :: handle argument
  ==
::
:: add a goal to the data structure
++  parse-add-goal
  ;~  (glue ace)
    (cold %add-goal (jest 'ag'))    :: command 'ag'
    (cook crip (star prn))    :: argument text as cord
  ==
::
:: add a new pool to the data structure
++  parse-new-pool
  ;~  (glue ace)
    (cold %new-pool (jest 'np'))    :: command 'np'
    (cook crip (star prn))    :: title of new pool
  ==
::
++  parse-delete-pool-goal
  ;~  (glue ace)
    (cold %delete-pool-goal (jest 'del'))
    (cook crip parse-handle)  :: handle argument
  ==
::
++  parse-copy-pool
  ;~  (glue ace)
    (cold %copy-pool (jest 'copy'))
    (cook crip parse-handle)  :: handle argument
    (cook crip (star prn))    :: title of copied pool
  ==
::
:: add a goal to the data structure
++  parse-add-task
  ;~  (glue ace)
    (cold %at (jest 'at'))    :: command 'at'
    (cook crip (star prn))    :: argument text as cord
  ==
::
:: edit a goal's desc in the data structure
++  parse-edit-goal-desc
  ;~  (glue ace)
    (cold %edit-goal-desc (jest 'eg'))    :: command 'eg'
    (cook crip parse-handle)  :: handle argument
    (cook crip (star prn))    :: argument text as cord
  ==
::
:: edit a pool's title in the data structure
++  parse-edit-pool-title
  ;~  (glue ace)
    (cold %edit-pool-title (jest 'ep'))    :: command 'eg'
    (cook crip parse-handle)  :: handle argument
    (cook crip (star prn))    :: argument text as cord
  ==
::
:: permanently remove a goal from the data structure
++  parse-remove-goal
  ;~  (glue ace)
    (cold %rg (jest 'rg'))    :: command 'rg'
    (cook crip parse-handle)  :: handle of goal to remove
  ==
::
:: change the current context from which data structure is printed in
:: CLI
++  parse-change-context
  ;~  (glue ace)
    (cold %change-context (jest 'cc'))    :: command 'cc'
    parse-handle-unit         :: handle of new context
  ==
::
++  parse-hide-completed
  (cold [%hide-completed ~] (jest '-x'))
::
++  parse-unhide-completed
  (cold [%unhide-completed ~] (jest '+x'))
::
:: change the current UTC-offset
++  parse-set-utc-offset
  ;~  (glue ace)
    (cold %set-utc-offset (jest 'tz'))    :: command 'tz'
    parse-utc-offsets:dates   :: parse utc-offset cord to cell of [@dr ?]
  ==
::
:: will print context of a given goal
++  parse-print-goal
  ;~  plug
    (cold %pg ;~(plug (jest 'pg') ace))  :: command 'pg'
    parse-handle-unit                    :: handle of goal whose context to print
    (may %.n (cold %.y ;~(plug ace (jest '-c')))) :: completed if -c flag present
  ==
::
:: will print parents (and ancestors) of a given goal
++  parse-print-parents
  ;~  (glue ace)
    (cold %pp (jest 'pp'))    :: command 'pp'
    (cook crip parse-handle)  :: handle of goal whose parents to print
  ==
::
:: will print precedents of given goal
++  parse-print-precedents
  ;~  (glue ace)
    (cold %ppc (jest 'ppc'))    :: command 'ppc'
    (cook crip parse-handle)  :: handle of goal whose parents to print
  ==
::
:: collapse subgoals of a goal in a given context
++  parse-collapse
  ;~  plug
    (cold %collapse ;~(plug (jest 'cp') ace))   :: command 'cp' (and following ace)
    (cook crip parse-handle)              :: handle of goal to collapse
    (may %.n (cold %.y ;~(plug ace (jest '-r')))) :: recursive if -r flag present
  ==
::
:: uncollapse subgoals of a goal in a given context
++  parse-uncollapse
  ;~  plug
    (cold %uncollapse ;~(plug (jest 'uc') ace))
    (cook crip parse-handle)              :: handle of goal to uncollapse
    (may %.n (cold %.y ;~(plug ace (jest '-r')))) :: recursive if -r flag present
  ==
::
:: print context when 'Enter' pressed
++  parse-print-context
  (cold [%print-context ~] (jest ''))
::
:: print all as list
++  parse-print-all
  (cold [%pa ~] (jest 'pa'))
::
:: set deadline of a given goal
++  parse-set-deadline
  |=  [now=@da utc-offset=[@dr ?]]
  ;~  (glue ace)
    (cold %set-deadline (jest 'sd'))           :: command 'sd' (and following ace)
    (cook crip parse-handle)                   :: handle of goal to update deadline of
    (parse-deadline:dates now utc-offset)      :: get (unit @da) of deadline to update
  ==
::
:: print "befores"; goals which precede this goal
++  parse-print-befs
  ;~  (glue ace)
    (cold %bf (jest 'bf'))
    (cook crip parse-handle)
  ==
::
++  parse-mark-actionable
  ;~  (glue ace)
    (cold %mark-actionable (jest '@'))
    (cook crip parse-handle)
  ==
::
++  parse-unmark-actionable
  ;~  (glue ace)
    (cold %unmark-actionable (jest '^@'))
    (cook crip parse-handle)
  ==
::
:: mark this goal complete
++  parse-mark-complete
  ;~  (glue ace)
    (cold %mark-complete (jest 'x'))
    (cook crip parse-handle)
  ==
::
:: mark this goal active
++  parse-unmark-complete
  ;~  (glue ace)
    (cold %unmark-complete (jest '^x'))
    (cook crip parse-handle)
  ==
::
:: harvest progenitors
++  parse-harvest-progenitors
  ;~  plug
    (cold %hv ;~(plug (jest 'hv') ace))
    (cook crip parse-handle)
    %+  may  %actionable
    ;~  pose
      (cold %completed ;~(plug ace (jest '-c')))
      (cold %unpreceded ;~(plug ace (jest '-u')))
    ==
  ==
::
:: print "afters"; goals which are preceded by this goal
++  parse-print-afts
  ;~  (glue ace)
    (cold %af (jest 'af'))
    (cook crip parse-handle)
  ==
::
:: print all goals sorted by creation date
++  parse-print-sorted
  (cold [%ps ~] (jest 'ps'))
::
:: print all goals sorted by inherited deadline
++  parse-deadline-sort
  (cold [%ds ~] (jest 'ds'))
:: 
:: end of individual command parsers
:: ----------------------------------------------------------------------------
:: parser helpers
::
:: parse non-ace printable ASCII characters
:: [a-z] [A-Z] [0-9] !@#$%^&*()-_=+[]{}\|:;'"/?.>,<`~
:: a handle is a sequence of at least three of these
++  parse-handle  (stun [3 100] (shim 33 126))
::
:: parse either a handle or ~ (representing All goals)
++  parse-handle-unit
  ;~  pose
    (cook |=(a=tape (some (crip a))) parse-handle) :: cook handle to unit
    (cold %~ (just '~'))                           :: if input ~, output ~
  ==
--
