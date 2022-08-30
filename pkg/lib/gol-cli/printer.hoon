/-  gol=goal, vyu=view
/+  shoe, dates=gol-cli-dates,
    *gol-cli-goal, gol-cli-goals, gol-cli-handles, gol-cli-goal-store
|_  $:  =store:gol
        =handles:vyu
        =views:vyu
        context=grip:vyu
        utc-offset=[hours=@dr ahead=?]
        =bowl:gall
    ==
+*  gols  ~(. gol-cli-goals store)
    hdls  ~(. gol-cli-handles store handles)
    gs    ~(. gol-cli-goal-store store)
+$  card  card:shoe
:: TODO:
:: do not print goals marked completed unless otherwise specified
:: print completed goals...
:: different harvesting...
::
++  hrz  `tape`(reap 80 '-')
::
++  info
  |=  =grip:vyu
  =/  tz  (trip (~(got by utc-offsets:dates) utc-offset))
  =/  owner  (owner grip)
  =/  permissions  (perms grip)
  =/  delegates  (delegates grip)
  =/  par-hdl  
    ?-    -.grip
      %all  "   "
      %project  " ~ "
        %goal
      =/  goal  (got-goal:gols +.grip)
      ?~  par.goal
        "{(col-data [%project (~(got by directory.store) +.grip)] %handle)}"
      "{(col-data [%goal u.par.goal] %handle)}"
    ==
  :~  ;:  weld
        owner
        `tape`(reap (sub 80 :(add (lent owner) 4 (lent tz))) ' ')
        "UTC "
        tz
      ==
      ;:  weld
        delegates
        `tape`(reap (sub 80 :(add (lent delegates) 5)) ' ')
        par-hdl
      ==
  ==
++  owner
  |=  =grip:vyu
  ?-    -.grip
    %all  "o~"
    %project  (weld "o" (trip (scot %p owner.pin.grip)))
    %goal  (weld "o" (trip (scot %p owner.id.grip)))
  ==
++  perms
  |=  =grip:vyu
  ?-    -.grip
    %all  "~"
      %project
    =/  chefs  (~(put in chefs:(~(got by projects.store) pin.grip)) owner.pin.grip)
    ?:  (~(has in chefs) our.bowl)
      "c"
    "~"
      %goal
    =/  chefs  (~(put in chefs:(~(got by projects.store) (~(got by directory.store) id.grip))) owner.id.grip)
    ?:  (~(has in chefs) our.bowl)
      "c"
    =/  c-sen  (seniority:gols our.bowl id.grip ~ ~ %c)
    =/  p-sen  (seniority:gols our.bowl id.grip ~ ~ %p)
    ?~  c-sen
      ?~  p-sen
        "~"
      "p"
    "c"
  ==
++  delegates
  |=  =grip:vyu
  ?-    -.grip
    %all  "c~ p~"
      %project
    =/  chefs  (~(put in chefs:(~(got by projects.store) pin.grip)) owner.pin.grip)
    ?:  =(1 ~(wyt in chefs))  :(weld "c" (trip (scot %p owner.pin.grip)) " p~")
    "c+ p~"
      %goal
    =/  chefs  chefs:(got-goal:gols id.grip)
    =/  chef
      ?:  =(0 ~(wyt in chefs))
        "c~"
      ?.  =(1 ~(wyt in chefs))
        "c+"
      (weld "c" (trip (scot %p (snag 0 ~(tap in chefs)))))
    =/  peons  peons:(got-goal:gols id.grip)
    =/  peon
      ?:  =(0 ~(wyt in peons))
        "p~"
      ?.  =(1 ~(wyt in peons))
        "p+"
      (weld "p" (trip (scot %p (snag 0 ~(tap in peons)))))
    :(weld chef " " peon)
  ==
::
:: get cards to print goal substructure
++  nest-print
  |=  [=grip:vyu col-names=(list col-name) =mode:gol]
  ^-  (list card)
  %-  print-cards 
  =/  lvl :: initial level; printing from context
    ?+  mode  !!
      %nest-ryte  (dec (get-lvl:gols grip mode))
      normal-mode:gol  +((get-lvl:gols grip mode))
      %prec-ryte  (dec (get-lvl:gols grip mode))
      %prec-left  +((get-lvl:gols grip mode))
    ==
  =/  first-block  [grip "" mode lvl %.y %.n %.n *(set grip:vyu) col-names]
  =/  tapes  tapes:(print-family first-block ~)
  ;:  weld
    ~[hrz]
    ~[(weld (reap toggle-len ' ') (headers col-names))]
    `(list tape)`tapes
    ~[hrz]
    (info grip)
  ==
::
++  next-gen
  |=  =block:vyu
  ^-  (list block:vyu)
  =/  fam  (get-fam:gols grip.block mode.block)
  =/  lvl  (get-lvl:gols grip.block mode.block)
  =/  prtd-set  (~(put in prtd-set.block) grip.block)
  =/  indent  (indenter block)
  =/  idx=@  0
  =|  =(list block:vyu)
  |-
  ?:  =(idx (lent fam))
    (flop list)
  =/  grip  (snag idx fam)
  =/  virtual
    ?.  ?=(normal-mode:gol mode.block)  %|
    ?-    -.grip.block
      ?(%all %project)  %|
        %goal
      ?-    -.grip
        ?(%all %project)  %|
          %goal
        =/  goal  (got-goal:gols id.grip.block)
        ?&  (~(has in (yung goal)) id.grip)
            !(~(has in kids.goal) id.grip)
        ==
      ==
    ==
  =/  last  =(+(idx) (lent fam))
  =/  clps  (~(has in collapse:(~(got by views) context)) grip)
  %=  $
    idx  +(idx)
    list  [[grip indent mode.block lvl last clps virtual prtd-set col-names.block] list]
  ==
:: this needs to output prtd-set
:: to avoid printing duplicates
++  print-family
  |=  [=block:vyu =prtd=(set grip:vyu)]
  ^-  [tapes=(list tape) =prtd=(set grip:vyu)]
  =/  prtd  (~(has in prtd-set) grip.block)
  =/  line  (liner block prtd)
  =/  tapes=(list tape)  ~[line]
  =.  prtd-set  (~(put in prtd-set) grip.block)
  ?:  clps.block  [tapes prtd-set]
  ?:  prtd  [tapes prtd-set]
  =/  blocks  (next-gen block)
  =/  idx=@  0
  |-
  ?:  =(idx (lent blocks))
    ?:  |(last.block =(1 (lent tapes)))
      [tapes prtd-set]
    :-  (weld tapes ~[(weld (empty-prefix col-names.block) (indenter block))])
    prtd-set
  =/  newest  (print-family (snag idx blocks) prtd-set)
  $(idx +(idx), tapes (weld tapes tapes:newest), prtd-set prtd-set:newest)
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
  |=  [=block:vyu prtd=?]
  ^-  tape
  ;:  weld
    (toggles grip.block)
    (columns grip.block col-names.block =(-.grip.block %project))
    buffer
    (brancher block prtd)
  ==
::
::
++  toggle-len  5
::
::
++  toggles
  |=  =grip.vyu
  ^-  tape
  =/  toggles  (reap toggle-len ' ')
  ?-    -.grip
    %all  toggles
    %project  (snap toggles 3 (crip (perms grip)))
      %goal
    =/  goal  (got-goal:gols +.grip)
    =/  actionable  ?:(actionable.goal '@' ' ')
    =/  completed  ?:(complete.goal 'x' ' ')
    =/  perms  (crip (perms grip))
    (snap `tape`(snap `tape`(snap toggles 1 actionable) 2 completed) 3 perms)
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
  |=  [=block:vyu prtd=?]
  ^-  tape
  |^
  =/  branch  :(weld elbow forearm text)
  :(weld indent.block branch)
  ++  text  
    ?-  -.grip.block
      %all  "Projects"
      %project  (trip title:(~(got by projects.store) +.grip.block))
      %goal  (trip desc:(got-goal:gols +.grip.block))
    ==
  ++  elbow
    ?-    -.grip.block
      ?(%all %project)  ?:(last.block "\\" "|")
        %goal  ?:(virtual.block "*" ?:(last.block "\\" "|"))
    ==
  ++  branch-char
    ?:  &(clps.block !=(0 (lent (get-fam:gols grip.block mode.block))))
      '>'
    ?:  &(prtd !=(0 (lent (get-fam:gols grip.block mode.block))))
      '<'
    ?+  mode.block  !!
      %nest-ryte  '_'
      normal-mode:gol  '-'
      %prec-ryte  '-'
      %prec-left  '-'
    ==
  ++  forearm
    ?-    -.grip.block
      %all  "--"
      %project  `tape`(reap 2 branch-char)
        %goal
      ?+  mode.block  !!
        %nest-ryte  (reap (dec (shift block)) branch-char)
        normal-mode:gol  (reap (dec (shift block)) branch-char)
        %prec-ryte  (weld (reap (sub (shift block) 2) branch-char) ">")
        %prec-left  (weld "<" (reap (sub (shift block) 2) branch-char))
      ==
    ==
  --
::
:: indent structure based on ancestors
++  indenter
  |=  =block:vyu
  ^-  tape
  =/  space  (shift block)
  ?:  last.block
    (weld indent.block (reap space ' '))
  :(weld indent.block "|" (reap (dec space) ' '))
::
:: shift based on level difference from parent
++  shift
  |=  =block:vyu
  ^-  @
  ?-    -.grip.block
    ?(%all %project)  spacer
      %goal
    ?+    mode.block  !!
        normal-mode:gol
      (mul spacer (sub lvl.block (plumb:gols +.grip.block)))
    ==
  ==
:: 
:: ----------------------------------------------------------------------------
:: other printers
::
++  print-utc
  |.  (print-cards ~[(weld "UTC " (trip (~(got by utc-offsets:dates) utc-offset)))])
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
++  print-single-goal
  |=  [=id:gol col-names=(list col-name)]
  =/  goal  (got-goal:gols id)
  =/  hndl  (~(got by gh.handles) [%goal id])
  :(weld (toggles [%goal id]) (columns [%goal id] col-names %.n) buffer (trip desc.goal))
::
++  print-cards
  |=  tapes=(list tape)
  ^-  (list card)
  (turn tapes |=(=tape [%shoe ~ %sole %klr [[~ ~ ~] [(crip tape)]~]~]))
:: 
:: ----------------------------------------------------------------------------
:: column functionality
+$  col-name  col-name:vyu
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
      %all  (zfill:dates 3 (trip (scot %ud (get-lvl:gols grip %normal))))
      %project  (zfill:dates 3 (trip (scot %ud (get-lvl:gols grip %normal))))
      %goal  (zfill:dates 3 (trip (scot %ud (get-lvl:gols grip %normal))))
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
  |=  [=grip:vyu names=(list col-name) proj=?]
  ^-  tape
  =/  idx  0
  =/  output  ?:(proj "\{" "[")
  |-
  ?:  =(+(idx) (lent names))
    :(weld output (col-data grip (snag idx names)) ?:(proj "}" "]"))
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
::
:: catch invalid project or goal handle error
++  invalid-goal-project-error
  |=  hdl=@t
  ^-  [(list card) grip:vyu]
  =/  grip  (~(get by hg.handles) hdl)
  ?~  grip
    [(print-cards ~["ERROR: Invalid goal or project handle [{(trip hdl)}]."]) *grip:vyu]
  ?:  =(-.u.grip %all)
    [(print-cards ~["ERROR: Invalid goal or project handle [{(trip hdl)}]."]) *grip:vyu]
  [~ u.grip]
--
