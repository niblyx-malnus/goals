/+  dates=gol-cli-dates, *gol-cli-help
|%
++  command-parser
  |=  [now=@da =utc-offset:dates]
  ;~  pose
    parse-invite                              :: %invite
    parse-held-yoke                           
    parse-held-rend
    parse-nest-yoke                           
    parse-nest-rend
    parse-prec-yoke
    parse-prec-rend                           
    parse-prio-yoke                           
    parse-prio-rend                           
    parse-new-pool                            :: %np
    parse-delete-pool-goal
    parse-copy-pool                         
    parse-make-chef                           :: %mc
    parse-make-peon                           :: %mp
    parse-add-goal                            :: %ag
    parse-edit-goal-desc                      :: %eg
    parse-edit-pool-title                     :: %ep
    parse-change-context                      :: %cc
    parse-hide-completed
    parse-unhide-completed
    parse-set-utc-offset                      :: %tz
    parse-collapse                            :: %cp
    parse-uncollapse                          :: %uc
    (parse-set-deadline now utc-offset)       :: %sd
    parse-mark-actionable
    parse-unmark-actionable
    parse-mark-complete
    parse-unmark-complete
    parse-harvest
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
++  parse-held-rend
  ;~  (glue ace)
    (cold %held-rend (jest '^mv'))
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
    (cold %edit-pool-title (jest 'ep'))    :: command 'ep'
    (cook crip parse-handle)  :: handle argument
    (cook crip (star prn))    :: argument text as cord
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
:: set deadline of a given goal
++  parse-set-deadline
  |=  [now=@da utc-offset=[@dr ?]]
  ;~  (glue ace)
    (cold %set-deadline (jest 'sd'))           :: command 'sd' (and following ace)
    (cook crip parse-handle)                   :: handle of goal to update deadline of
    (parse-deadline:dates now utc-offset)      :: get (unit @da) of deadline to update
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
++  parse-harvest
  ;~  plug
    (cold %harvest ;~(plug (jest 'hv') ace))
    (cook crip parse-handle)
    :: %+  may  %actionable
    :: ;~  pose
    ::   (cold %completed ;~(plug ace (jest '-c')))
    ::   (cold %unpreceded ;~(plug ace (jest '-u')))
    :: ==
  ==
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
