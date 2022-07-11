/+  dates=gol-cli-dates
|%
:: ----------------------------------------------------------------------------
:: individual command parsers
::
:: empty the entire data structure and start from scratch
:: (mostly for playing around during development of the app)
++  parse-clearall
  (cold [%clearall ~] (jest 'clearall'))
::
:: add a goal to the data structure
++  parse-add-goal
  ;~  (glue ace)
    (cold %ag (jest 'ag'))    :: command 'ag'
    qut                       :: argument text as cord
  ==
::
:: nest a child goal under a parent goal
++  parse-nest-goal
  ;~  (glue ace)
    (cold %ng (jest 'ng'))    :: command 'ng'
    (cook crip parse-handle)  :: first handle argument (child)
    (cook crip parse-handle)  :: second handle argument (parent)
  ==
::
:: unnest a child goal from a parent goal
++  parse-flee-goal
  ;~  (glue ace)
    (cold %fg (jest 'fg'))    :: command 'fg'
    (cook crip parse-handle)  :: first handle argument (child)
    (cook crip parse-handle)  :: second handle argument (parent)
  ==
::
:: precede a left goal ahead of a right goal
++  parse-precede-goal
  ;~  (glue ace)
    (cold %ap (jest 'ap'))    :: command 'ap'
    (cook crip parse-handle)  :: first handle argument (left)   
    (cook crip parse-handle)  :: second handle argument (right)
  ==
::
:: unnest a child goal from a parent goal
++  parse-unprecede-goal
  ;~  (glue ace)
    (cold %rp (jest 'rp'))    :: command 'rp'
    (cook crip parse-handle)  :: first handle argument (left)   
    (cook crip parse-handle)  :: second handle argument (right)
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
    (cold %cc (jest 'cc'))    :: command 'cc'
    parse-handle-unit         :: handle of new context
  ==
::
:: change the current UTC-offset
++  parse-change-utc-offset
  ;~  (glue ace)
    (cold %tz (jest 'tz'))    :: command 'tz'
    parse-utc-offsets:dates   :: parse utc-offset cord to cell of [@dr ?]
  ==
::
:: will print context of a given goal
++  parse-print-goal
  ;~  (glue ace)
    (cold %pg (jest 'pg'))    :: command 'pg'
    parse-handle-unit         :: handle of goal whose context to print
  ==
::
:: will print parents (and ancestors) of a given goal
++  parse-print-parents
  ;~  (glue ace)
    (cold %pp (jest 'pp'))    :: command 'pp'
    (cook crip parse-handle)  :: handle of goal whose parents to print
  ==
::
:: collapse subgoals of a goal in a given context
++  parse-collapse
  ;~  plug
    (cold %cp ;~(plug (jest 'cp') ace))   :: command 'cp' (and following ace)
    (cook crip parse-handle)              :: handle of goal to collapse
    ;~  pose
      (cold %.y ;~(plug ace (jest '-r'))) :: recursive if -r flag present
      (cold %.n (jest ''))                :: not recursive if no flag present
    ==
  ==
::
:: uncollapse subgoals of a goal in a given context
++  parse-uncollapse
  ;~  plug
    (cold %uc ;~(plug (jest 'uc') ace))   :: command 'uc' (and following ace)
    (cook crip parse-handle)              :: handle of goal to uncollapse
    ;~  pose
      (cold %.y ;~(plug ace (jest '-r'))) :: recursive if -r flag present
      (cold %.n (jest ''))                :: not recursive if no flag present
    ==
  ==
::
:: print context when 'Enter' pressed
++  parse-print-context
  (cold [%pc ~] (jest ''))
::
:: print current utc-offset
++  parse-print-utc-offset
  (cold [%pz ~] (jest 'pz'))
::
:: print all as list
++  parse-print-all
  (cold [%pa ~] (jest 'pa'))
::
:: set deadline of a given goal
++  parse-set-deadline
  |=  [now=@da utc-offset=[@dr ?]]
  ;~  (glue ace)
    (cold %sd (jest 'sd'))                     :: command 'sd' (and following ace)
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
:: make this goal actionable
++  parse-actionate
  ;~  (glue ace)
    (cold %an (jest 'an'))
    (cook crip parse-handle)
  ==
::
:: mark this goal complete
++  parse-complete
  ;~  (glue ace)
    (cold %ct (jest 'ct'))
    (cook crip parse-handle)
  ==
::
:: mark this goal active
++  parse-activate
  ;~  (glue ace)
    (cold %av (jest 'av'))
    (cook crip parse-handle)
  ==
::
:: harvest progenitors
++  parse-harvest-progenitors
  ;~  (glue ace)
    (cold %hv (jest 'hv'))
    (cook crip parse-handle)
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
