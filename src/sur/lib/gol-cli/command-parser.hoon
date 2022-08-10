/+  dates=gol-cli-dates
|%
++  command-parser
  |=  [now=@da =utc-offset:dates]
  ;~  pose
    parse-invite                              :: %invite
    parse-held-yoke                           :: %hy
    parse-new-project                         :: %np
    parse-make-chef                           :: %mc
    parse-make-peon                           :: %mp
    parse-add-goal                            :: %ag
    parse-add-task                            :: %at
    parse-edit-goal-desc                      :: %eg
    parse-edit-project-title                  :: %ep
    parse-nest-goal                           :: %ng
    parse-move-goal                           :: %mv
    parse-flee-goal                           :: %fg
    parse-precede-goal                        :: %ap
    parse-unprecede-goal                      :: %rp
    parse-remove-goal                         :: %rg
    parse-change-context                      :: %cc
    parse-change-utc-offset                   :: %tz
    parse-print-goal                          :: %pg
    parse-print-parents                       :: %pp
    parse-print-precedents                    :: %ppc
    parse-collapse                            :: %cp
    parse-uncollapse                          :: %uc
    (parse-set-deadline now utc-offset)       :: %sd
    parse-print-utc-offset                    :: %pz
    parse-print-all                           :: %pa
    parse-print-sorted                        :: %ps
    parse-deadline-sort                       :: %ds
    parse-print-befs                          :: %bf
    parse-print-afts                          :: %af
    parse-actionate                           :: %an
    parse-complete                            :: %ct
    parse-activate                            :: %av
    parse-harvest-progenitors                 :: %hv
    parse-prioritize-goal                     :: %pt
    parse-unprioritize-goal                   :: %up
    parse-print-context                       :: %pc
  ==
:: ----------------------------------------------------------------------------
:: individual command parsers
::
++  parse-held-yoke
  ;~  (glue ace)
    (cold %hy (jest 'hy'))    :: command 'hy'
    (cook crip parse-handle)  :: first handle argument (left l)
    (cook crip parse-handle)  :: second handle argument (right r)
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
    (cold %mc (jest 'mc'))
    fed:ag
    (cook crip parse-handle)  :: handle argument
  ==
::
++  parse-make-peon
  ;~  (glue ace)
    (cold %mp (jest 'mp'))
    fed:ag
    (cook crip parse-handle)  :: handle argument
  ==
::
:: add a goal to the data structure
++  parse-add-goal
  ;~  (glue ace)
    (cold %ag (jest 'ag'))    :: command 'ag'
    (cook crip (star prn))    :: argument text as cord
  ==
::
:: add a new project to the data structure
++  parse-new-project
  ;~  (glue ace)
    (cold %np (jest 'np'))    :: command 'np'
    (cook crip (star prn))    :: title of new project
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
    (cold %eg (jest 'eg'))    :: command 'eg'
    (cook crip parse-handle)  :: handle argument
    (cook crip (star prn))    :: argument text as cord
  ==
::
:: edit a project's title in the data structure
++  parse-edit-project-title
  ;~  (glue ace)
    (cold %ep (jest 'ep'))    :: command 'eg'
    (cook crip parse-handle)  :: handle argument
    (cook crip (star prn))    :: argument text as cord
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
:: move a child goal under a parent goal
++  parse-move-goal
  ;~  (glue ace)
    (cold %mv (jest 'mv'))    :: command 'mv'
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
::
++  parse-prioritize-goal
  ;~  (glue ace)
    (cold %pt (jest 'pt'))    ::
    (cook crip parse-handle)  ::
    (cook crip parse-handle)  ::
  ==
::
::
++  parse-unprioritize-goal
  ;~  (glue ace)
    (cold %up (jest 'up'))    ::
    (cook crip parse-handle)  ::
    (cook crip parse-handle)  ::
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
    (cold %cp ;~(plug (jest 'cp') ace))   :: command 'cp' (and following ace)
    (cook crip parse-handle)              :: handle of goal to collapse
    (may %.n (cold %.y ;~(plug ace (jest '-r')))) :: recursive if -r flag present
  ==
::
:: uncollapse subgoals of a goal in a given context
++  parse-uncollapse
  ;~  plug
    (cold %uc ;~(plug (jest 'uc') ace))
    (cook crip parse-handle)              :: handle of goal to uncollapse
    (may %.n (cold %.y ;~(plug ace (jest '-r')))) :: recursive if -r flag present
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
::
:: stolen from Fang's suite/lib/pal.hoon
++  may  |*([else=* =rule] ;~(pose rule (easy else)))
++  opt  |*(=rule (may rule ~))
--
