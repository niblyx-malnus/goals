/-  gol=goal, vyu=view
/+  shoe, dates=gol-cli-dates
/+  gol-cli-goals, gol-cli-handles
|_  $:  =store:gol
        =handles:vyu
        =views:vyu
        context=grip:vyu
        utc-offset=[hours=@dr ahead=?]
    ==
+*  gols  ~(. gol-cli-goals store)
    hdls  ~(. gol-cli-handles store handles)
+$  card  card:shoe
:: TODO:
:: do not print goals marked completed unless otherwise specified
:: print completed goals...
:: different harvesting...
::
:: get cards to print goal substructure
++  nest-print
  |=  [=grip:vyu col-names=(list col-name) =dir:gol]
  ^-  (list card)
  %-  print-cards 
  =/  lvl :: initial level; printing from context
    ?-  dir
      %nest-ryte  (dec (get-lvl:gols grip dir))
      %nest-left  +((get-lvl:gols grip dir))
      %nest-left-completed  +((get-lvl:gols grip dir))
      %prec-ryte  (dec (get-lvl:gols grip dir))
      %prec-left  +((get-lvl:gols grip dir))
      %prio-ryte  !!
      %prio-left  !!
    ==
  ;:  weld
    ~[hrz]
    ~[(weld (reap toggle-len ' ') (headers col-names))]
    tapes:(print-family grip col-names %.y %.n *(set grip:vyu) dir "" lvl %1)
    ~[hrz]
  ==
::
::
++  print-family
  |=  $:  =grip:vyu
          col-names=(list col-name)
          last=?
          clps=?
          prtd-set=(set grip:vyu)
          =dir:gol
          indent=tape
          lvl=@
          timidity=?(%1 %0)
      ==
  ^-  [tapes=(list tape) prtd-set=(set grip:vyu)]
  =/  line  (liner grip col-names last clps prtd-set dir indent lvl)
  =.  indent  (indenter grip last dir indent lvl)
  ::  =/  fam  (hi-to-lo:gols (get-fam:gols grip dir))
  =/  fam  (get-fam:gols grip dir)
  =.  lvl  (get-lvl:gols grip dir)
  =/  output=[tapes=(list tape) prtd-set=(set grip:vyu)]
    [~[line] (~(put in prtd-set) grip)]
  ?:  |(=(~ fam) (~(has in prtd-set) grip) clps)
    ?.  last  output
    :: if the indent is all spaces, this is the last printed line
    :: in the whole printed family
    ?:  (levy indent |=(a=@t =(a ' ')))  output
    :: otherwise it is last printed line in a sub-family
    :: add empty line after last line of a sub-family
    :-  (weld tapes:output ~[(weld (empty-prefix col-names) indent)])
    prtd-set:output
  ?:  clps  output
  ?:  (~(has in prtd-set) grip)  output
  =/  caught-cycle
    ?-    -.grip  
      ?(%all %project)  %.n
        %goal
      ?-  timidity
        %0  %.n
        %1  %.n
      ==
    ==
  ?:  caught-cycle  output
  =/  idx=@  0
  |-
  =/  grip  (snag idx fam)
  =.  clps  (~(has in collapse:(~(got by views) context)) grip)
  ?:  =(+(idx) (lent fam))
    =/  newest  (print-family grip col-names %.y clps prtd-set:output dir indent lvl %1)
    :-  (weld tapes:output tapes:newest)
    prtd-set:newest
  =/  newest  (print-family grip col-names %.n clps prtd-set:output dir indent lvl %1)
  %=  $
    idx  +(idx)
    output  :-  (weld tapes:output tapes:newest)
            prtd-set:newest
  ==
::
::
++  empty-prefix
  |=  col-names=(list col-name)
  (reap :(add toggle-len (cols-lent col-names) spacer) ' ')
::
::
++  spacer  3
::
:: space between prefix and branches
++  buffer  (reap spacer ' ')
::
:: get an entire line
++  liner
  |=  $:  =grip:vyu
          col-names=(list col-name)
          last=?
          clps=?
          prtd-set=(set grip:vyu)
          =dir:gol
          indent=tape
          lvl=@
      ==
  ^-  tape
  ;:  weld
    (toggles grip)
    (columns grip col-names)
    buffer
    (brancher grip last clps prtd-set dir indent lvl)
  ==
::
::
++  toggle-len  4
::
::
++  toggles
  |=  =grip:vyu
  ^-  tape
  =/  toggles  (reap toggle-len ' ')
  ?-    -.grip
    ?(%all %project)  toggles
      %goal
    =/  goal  (got-goal:gols +.grip)
    =/  actionable  ?:(actionable.goal '@' ' ')
    =/  completed  ?:(=(status.goal %completed) 'x' ' ')
    (snap `tape`(snap toggles 1 actionable) 2 completed)
  ==
::
::
++  deadline-text
  |=  deadline=(unit @da)
  ?~  deadline 
    "   ~~   "
  (simple-format-local:dates u.deadline utc-offset)
::
:: branch structure based on status as last subgoal and level shift
++  brancher
  |=  $:  =grip:vyu
          last=?
          clps=?
          prtd-set=(set grip:vyu)
          =dir:gol
          indent=tape
          lvl=@
      ==
  ^-  tape
  |^
  :(weld indent elbow forearm text)
  ++  text  
    ?-  -.grip
      %all  "Projects"
      %project  (trip title:(~(got by projects.store) +.grip))
      %goal  (trip desc:(got-goal:gols +.grip))
    ==
  ++  elbow  ?:(last "\\" "|")
  ++  branch-char
    ?:  &(clps !=(0 (lent (get-fam:gols grip dir))))
      '>'
    ?:  &((~(has in prtd-set) grip) !=(0 (lent (get-fam:gols grip dir))))
      '<'
    ?-  dir
      %nest-ryte  '_'
      %nest-left  '-'
      %nest-left-completed  '-'
      %prec-ryte  '-'
      %prec-left  '-'
      %prio-ryte  !!
      %prio-left  !!
    ==
  ++  forearm
    ?-    -.grip
      %all  "--"
      %project  "--"
        %goal
      ?-  dir
        %nest-ryte  (reap (dec (shift grip dir lvl)) branch-char)
        %nest-left  (reap (dec (shift grip dir lvl)) branch-char)
        %nest-left-completed  (reap (dec (shift grip dir lvl)) branch-char)
        %prec-ryte  (weld (reap (sub (shift grip dir lvl) 2) branch-char) ">")
        %prec-left  (weld "<" (reap (sub (shift grip dir lvl) 2) branch-char))
        %prio-ryte  !!
        %prio-left  !!
      ==
    ==
  --
::
:: indent structure based on ancestors
++  indenter
  |=  [=grip:vyu last=? =dir:gol indent=tape lvl=@]
  ^-  tape
  =/  space  (shift grip dir lvl)
  ?:  last
    (weld indent (reap space ' '))
  :(weld indent "|" (reap (dec space) ' '))
::
:: shift based on level difference from parent
++  shift
  |=  [=grip:vyu =dir:gol lvl=@]
  ^-  @
  ?-    -.grip
    ?(%all %project)  spacer
      %goal
    ?-    dir
      %nest-ryte  !!
        %nest-left
      (mul spacer (sub lvl (plumb:gols +.grip)))
      %nest-left-completed  !!
      %prec-ryte  !!
      %prec-left  !!
      %prio-ryte  !!
      %prio-left  !!
    ==
  ==
::
::
++  print-utc
  |.  (print-cards ~[(weld "UTC " (trip (~(got by utc-offsets:dates) utc-offset)))])
::
::
++  hrz  `tape`(reap 80 '-')
::
::
++  print-goal-list
  |=  [ids=(list id:gol) col-names=(list col-name)]
  %-  print-cards
  ;:  weld
    ~[hrz]
    ~[(weld (reap toggle-len ' ') (headers col-names))]
    (turn ids (curr print-single-goal col-names))
    ~[hrz]
  ==
::
::
++  print-single-goal
  |=  [=id:gol col-names=(list col-name)]
  =/  goal  (got-goal:gols id)
  =/  hndl  (~(got by gh.handles) [%goal id])
  :(weld (toggles [%goal id]) (columns [%goal id] col-names) buffer (trip desc.goal))
::
::
++  print-cards
  |=  tapes=(list tape)
  ^-  (list card)
  (turn tapes |=(=tape [%shoe ~ %sole %klr [[~ ~ ~] [(crip tape)]~]~]))
:: 
:: ----------------------------------------------------------------------------
:: column functionality
::
:: column type definitions
+$  col-name
  $?  %handle
      %deadline
      %level
      %priority
  ==
::
:: header for each column type
++  col-head
  |=  name=col-name
  ^-  tape
  ?-  name
    %handle    "hdl"
    %deadline  "deadline"
    %level     "lvl"
    %priority  "pty"
  ==
::
:: data for each column type
++  col-data
  |=  [=grip:vyu name=col-name]
  ^-  tape
  ?-  name
      %handle
    ?-    -.grip
      %all  " ~ "
      %project  (trip (~(got by gh.handles) grip))
      %goal  (trip (~(got by gh.handles) grip))
    ==
      %deadline
    ?-    -.grip
      %all  "   ~~   "
      %project  "   ~~   "
        %goal
      (deadline-text -:(inherit-deadline:gols +.grip))
    ==
      %level
    ?-  -.grip
      %all  (zfill:dates 3 (trip (scot %ud (get-lvl:gols grip %nest-left))))
      %project  (zfill:dates 3 (trip (scot %ud (get-lvl:gols grip %nest-left))))
      %goal  (zfill:dates 3 (trip (scot %ud (get-lvl:gols grip %nest-left))))
    ==
      %priority
    ?-  -.grip
      %all  " ~ "
      %project  " ~ "
      %goal  (zfill:dates 3 (trip (scot %ud (priority:gols +.grip))))
    ==
  ==
::
:: lengths of each column type
++  col-lent
  |=  name=col-name
  ^-  @
  ?-  name
    %handle    3
    %deadline  8
    %level     3
    %priority  3
  ==
::
:: length of all columns together with spacing
++  cols-lent
  |=  names=(list col-name)
  =/  len  +((lent names))
  =/  idx  0
  |-
  ?:  =(idx (lent names))
    len
  $(idx +(idx), len (add len (col-lent (snag idx names))))
::
:: columns output for specific id on specific columns
++  columns
  |=  [=grip:vyu names=(list col-name)]
  ^-  tape
  =/  idx  0
  =/  output  "["
  |-
  ?:  =(+(idx) (lent names))
    :(weld output (col-data grip (snag idx names)) "]")
  $(idx +(idx), output :(weld output (col-data grip (snag idx names)) " "))
::
:: columns output for specific id on specific columns
++  headers
  |=  names=(list col-name)
  ^-  tape
  =/  idx  0
  =/  output  "["
  |-
  ?:  =(+(idx) (lent names))
    :(weld output (col-head (snag idx names)) "]")
  $(idx +(idx), output :(weld output (col-head (snag idx names)) " "))
:: 
:: ----------------------------------------------------------------------------
:: error handling
::
:: output for "catch" gates should be [msg res]
:: msg is a list of error message cards
:: if msg is empty, res can be used for its original purpose
:: if msg contains messages, they will be returned (and res should bunt
:: its types)
:: =+  [msg res]=(catch-gate data)  ?.  =(~ msg)  msg  ...
:: 
:: catch invalid goal handle error
++  invalid-goal-error
  |=  hdl=@t
  ^-  [(list card) [=id:gol =goal:gol]]
  =/  g  (handle-to-goal:hdls hdl)
  ?~  g  [(print-cards ~["ERROR: Invalid goal handle [{(trip hdl)}]."]) *id:gol *goal:gol]
  [~ u.g]
::
:: catch invalid project handle error
++  invalid-project-error
  |=  hdl=@t
  ^-  [(list card) [=pin:gol =project:gol]]
  =/  p  (handle-to-project:hdls hdl)
  ?~  p  [(print-cards ~["ERROR: Invalid project handle [{(trip hdl)}]."]) *pin:gol *project:gol]
  [~ u.p]
--
