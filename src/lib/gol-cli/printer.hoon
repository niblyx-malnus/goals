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
::
++  print-cards
  |=  tapes=(list tape)
  ^-  (list card)
  (turn tapes |=(=tape [%shoe ~ %sole %klr [[~ ~ ~] [(crip tape)]~]~]))
::
::
++  print-family
  |=  [id=(unit id:nest) last=? clps=? dir=?(%p %c) indent=tape lvl=@]
  ^-  (list tape)
  =/  line  (liner id last clps dir indent lvl)
  =/  indent  (indenter id last dir indent lvl)
  =/  fam  (get-fam:gols id dir)
  =/  lvl  (get-lvl:gols id dir)
  =/  output=(list tape)  ~[line]
  ?~  fam
    ?.  last
      output
    ?:  (levy indent |=(a=@t =(a ' ')))
      output
    (weld output ~[(weld "                     " indent)])
  ?:  clps  output
  =/  idx=@  0
  |-
  =/  id  [~ (snag idx `(list id:nest)`fam)]
  =/  clps=?  (~(has in collapse:(~(got by views) context)) +.id)
  ?:  =(+(idx) (lent fam))
    (weld output (print-family id %.y clps dir indent lvl))
  $(idx +(idx), output (weld output (print-family id %.n clps dir indent lvl)))
::
::
++  spacer  3
::
::
++  liner
  |=  [id=(unit id:nest) last=? clps=? dir=?(%p %c) indent=tape lvl=@]
  ^-  tape
  (weld (prefix id dir) (brancher id last clps dir indent lvl))
::
::
++  prefix
  |=  [id=(unit id:nest) dir=?(%p %c)]
  ^-  tape
  ?~  id
    ?-  dir
      %p  !!
      %c  (weld "    [ ~     ~~   ]" (reap spacer ' '))
    ==
  =/  hndl  (~(got by ih.handles) u.id)
  =/  goal  (~(got by goals) u.id)
  =/  actionable  ?:(actionable.goal "@" " ")
  =/  completed  ?:(=(status.goal %completed) "x" " ")

  :(weld " " actionable completed " " "[{(trip hndl)} {(deadline-text -:(inherit-deadline:gols u.id))}]" (reap spacer ' '))
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
  |=  [id=(unit id:nest) last=? clps=? dir=?(%p %c) indent=tape lvl=@]
  ^-  tape
  =/  branch-char
    ?:  clps
      '>'
    '-'
  ?~  id
    ?-  dir
      %p  !!
      %c  "\\--All"
    ==
  =/  goal  (~(got by goals) u.id)
  =/  output
    ?:  last
      :(weld indent "\\" (reap (dec (shift u.id dir lvl)) branch-char))
    :(weld indent "|" (reap (dec (shift u.id dir lvl)) branch-char))
  (weld output (trip desc.goal))
::
:: indent structure based on ancestors
++  indenter
  |=  [id=(unit id:nest) last=? dir=?(%p %c) indent=tape lvl=@]
  ^-  tape
  ?~  id
    ?-  dir
      %p  !!
      %c  (reap spacer ' ')
    ==
  ?:  last
    (weld indent (reap (shift u.id dir lvl) ' '))
  :(weld indent "|" (reap (dec (shift u.id dir lvl)) ' '))
::
:: shift based on level difference from parent
++  shift
  |=  [=id:nest dir=?(%p %c) lvl=@]
  ^-  @
  ?-  dir
      %p
    (mul spacer (sub (plumb:gols id) lvl))
      %c
    (mul spacer (sub lvl (plumb:gols id)))
  ==
::
::
++  print-utc
  |.  (print-cards ~[(weld "UTC " (trip (~(got by utc-offsets:dates) utc-offset)))])
::
:: get cards to print goal substructure, catch if goal does not exist
++  print-catch
  |=  [id=(unit id:nest) dir=?(%p %c)]
  ?~  id  (print id dir)
    ?:  (~(has in ~(key by goals)) u.id)
      (print id dir)
    (print-cards ~["" "Specified goal does not exist."])
::
:: get cards to print goal substructure, crash if goal does not exist
++  print
  |=  [id=(unit id:nest) dir=?(%p %c)]
  ^-  (list card)
  %-  print-cards 
  =/  lvl
    ?-  dir
      %p  (dec (get-lvl:gols id dir))
      %c  +((get-lvl:gols id dir))
    ==
  ;:  weld
    :~  `tape`(reap 80 '-')
        "    [hdl deadline]"
    ==
    (print-family id %.y %.n dir "" lvl)
    ~[`tape`(reap 80 '-')]
  ==
::
::
++  print-goal-list
  |=  ids=(list id:nest)
  %-  print-cards
  ;:  weld
    ~[`tape`(reap 80 '-') "[hdl deadline]"]
    (turn ids print-single-goal)
    ~[`tape`(reap 80 '-')]
  ==
::
::
++  print-single-goal
  |=  =id:nest
  =/  goal  (~(got by goals) id)
  =/  hndl  (~(got by ih.handles) id)
  "[{(trip hndl)} {(deadline-text -:(inherit-deadline:gols id))}]   {(trip desc.goal)}"
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
