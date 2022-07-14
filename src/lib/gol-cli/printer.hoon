/-  nest
/+  shoe, dates=gol-cli-dates
/+  gol-cli-goals, gol-cli-handles
|_  $:  =goals:nest
        =handles:nest
        =views:nest
        context=(unit id:nest)
        utc-offset=[hours=@dr ahead=?]
    ==
+*  gols  ~(. gol-cli-goals goals)
    hdls  ~(. gol-cli-handles goals handles)
+$  card  card:shoe
::
:: get cards to print goal substructure
++  nest-print
  |=  [id=(unit id:nest) col-names=(list col-name) =dir:nest]
  ^-  (list card)
  %-  print-cards 
  =/  lvl :: initial level; printing from context
    ?-  dir
      %nest-ryte  (dec (get-lvl:gols id dir))
      %nest-left  +((get-lvl:gols id dir))
      %prec-ryte  (dec (get-lvl:gols id dir))
      %prec-left  +((get-lvl:gols id dir))
      %prio-ryte  !!
      %prio-left  !!
    ==
  ;:  weld
    ~[hrz]
    ~[(weld (reap toggle-len ' ') (headers col-names))]
    tapes:(print-family id col-names %.y %.n *(set (unit id:nest)) dir "" lvl)
    ~[hrz]
  ==
::
::
++  print-family
  |=  $:  id=(unit id:nest)
          col-names=(list col-name)
          last=?
          clps=?
          prtd-set=(set (unit id:nest))
          =dir:nest
          indent=tape
          lvl=@
      ==
  ^-  [tapes=(list tape) prtd-set=(set (unit id:nest))]
  =/  line  (liner id col-names last clps prtd-set dir indent lvl)
  =.  indent  (indenter id last dir indent lvl)
  =/  fam  (hi-to-lo:gols (get-fam:gols id dir))
  =.  lvl  (get-lvl:gols id dir)
  =/  output=[tapes=(list tape) prtd-set=(set (unit id:nest))]
    [~[line] (~(put in prtd-set) id)]
  ?~  fam
    ?.  last  output
    :: if the indent is all spaces, this is the last printed line
    :: in the whole printed family
    ?:  (levy indent |=(a=@t =(a ' ')))  output
    :: otherwise it is last printed line in a sub-family
    :: add empty line after last line of a sub-family
    :-  (weld tapes:output ~[(weld (empty-prefix col-names) indent)])
    prtd-set:output
  ?:  clps  output
  ?:  (~(has in prtd-set) id)  output
  =/  idx=@  0
  |-
  =/  id  [~ u=(snag idx `(list id:nest)`fam)]
  =.  clps  (~(has in collapse:(~(got by views) context)) u.id)
  ?:  =(+(idx) (lent fam))
    =/  newest  (print-family id col-names %.y clps prtd-set:output dir indent lvl)
    :-  (weld tapes:output tapes:newest)
    prtd-set:newest
  =/  newest  (print-family id col-names %.n clps prtd-set:output dir indent lvl)
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
  |=  $:  id=(unit id:nest)
          col-names=(list col-name)
          last=?
          clps=?
          prtd-set=(set (unit id:nest))
          =dir:nest
          indent=tape
          lvl=@
      ==
  ^-  tape
  ;:  weld
    (toggles id)
    (columns id col-names)
    buffer
    (brancher id last clps prtd-set dir indent lvl)
  ==
::
::
++  toggle-len  4
::
::
++  toggles
  |=  id=(unit id:nest)
  ^-  tape
  =/  toggles  (reap toggle-len ' ')
  ?~  id  toggles
  =/  goal  (~(got by goals) u.id)
  =/  actionable  ?:(actionable.goal '@' ' ')
  =/  completed  ?:(=(status.goal %completed) 'x' ' ')
  (snap `tape`(snap toggles 1 actionable) 2 completed)
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
  |=  $:  id=(unit id:nest)
          last=?
          clps=?
          prtd-set=(set (unit id:nest))
          =dir:nest
          indent=tape
          lvl=@
      ==
  ^-  tape
  ?~  id
    ?-  dir
      %nest-ryte  !! :: Can't print parents of virtual root node
      %nest-left  "\\--All"
      %prec-ryte  !!
      %prec-left  !!
      %prio-ryte  !!
      %prio-left  !!
    ==
  =/  goal  (~(got by goals) u.id)
  =/  elbow  ?:(last "\\" "|")
  =/  branch-char
    ?:  &(clps !=(0 ~(wyt in kids.goal)))
      '>'
    ?:  &((~(has in prtd-set) id) !=(0 ~(wyt in kids.goal)))
      '<'
    ?-  dir
      %nest-ryte  '_'
      %nest-left  '-'
      %prec-ryte  '-'
      %prec-left  '-'
      %prio-ryte  !!
      %prio-left  !!
    ==
  =/  forearm
    ?-  dir
      %nest-ryte  (reap (dec (shift u.id dir lvl)) branch-char)
      %nest-left  (reap (dec (shift u.id dir lvl)) branch-char)
      %prec-ryte  (weld (reap (sub (shift u.id dir lvl) 2) branch-char) ">")
      %prec-left  (weld "<" (reap (sub (shift u.id dir lvl) 2) branch-char))
      %prio-ryte  !!
      %prio-left  !!
    ==
  =/  branch  :(weld indent elbow forearm)
  (weld branch (trip desc.goal))
::
:: indent structure based on ancestors
++  indenter
  |=  [id=(unit id:nest) last=? =dir:nest indent=tape lvl=@]
  ^-  tape
  ?~  id
    ?-  dir
      %nest-ryte  !! :: Can't print parents of virtual root node
      %nest-left  buffer
      %prec-ryte  !!
      %prec-left  !!
      %prio-ryte  !!
      %prio-left  !!
    ==
  ?:  last
    (weld indent (reap (shift u.id dir lvl) ' '))
  :(weld indent "|" (reap (dec (shift u.id dir lvl)) ' '))
::
:: shift based on level difference from parent
++  shift
  |=  [=id:nest =dir:nest lvl=@]
  ^-  @
  ?-  dir
      %nest-ryte
    (mul spacer (sub (nest-plumb:gols id) lvl))
      %nest-left
    (mul spacer (sub lvl (nest-plumb:gols id)))
      %prec-ryte
    (mul spacer (sub (prec-plumb:gols id) lvl))
      %prec-left
    (mul spacer (sub lvl (prec-plumb:gols id)))
    %prio-ryte  !!
    %prio-left  !!
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
  |=  ids=(list id:nest)
  %-  print-cards
  ;:  weld
    ~[hrz "[hdl]"]
    (turn ids print-single-goal)
    ~[hrz]
  ==
::
::
++  print-single-goal
  |=  =id:nest
  =/  goal  (~(got by goals) id)
  =/  hndl  (~(got by ih.handles) id)
  "[{(trip hndl)}]   {(trip desc.goal)}"
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
  |=  [id=(unit id:nest) name=col-name]
  ^-  tape
  ?-  name
      %handle
    ?~  id  " ~ "
    =/  hdl  (trip (~(got by ih.handles) u.id))
    ?:  (gth (lent hdl) 3)  ~&('Unusually long handle.' !!)  hdl
      %deadline
    ?~  id  "   ~~   "
    (deadline-text -:(inherit-deadline:gols u.id))
      %level
    ?~  id  (zfill:dates 3 (trip (scot %ud anchor:gols)))
    (zfill:dates 3 (trip (scot %ud (nest-plumb:gols u.id))))
      %priority
    ?~  id  (zfill:dates 3 (trip (scot %ud lowpri:gols)))
    (zfill:dates 3 (trip (scot %ud (priority:gols u.id))))
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
  |=  [id=(unit id:nest) names=(list col-name)]
  ^-  tape
  =/  idx  0
  =/  output  "["
  |-
  ?:  =(+(idx) (lent names))
    :(weld output (col-data id (snag idx names)) "]")
  $(idx +(idx), output :(weld output (col-data id (snag idx names)) " "))
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
:: catch invalid handle error
++  catch-handle
  |=  hdl=@t
  ^-  [(list card) [=id:nest =goal:nest]]
  =/  g  (get-handle:hdls hdl)
  ?~  g  [(print-cards ~["ERROR: Invalid handle [{(trip hdl)}]."]) *id:nest *goal:nest]
  [~ u.g]
--
