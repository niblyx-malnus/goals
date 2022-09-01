/-  *goal, *goal-store
/+  *gol-cli-help
|%
++  dejs-action
  =,  dejs:format
  |=  jon=json
  ^-  action
  %.  jon
  %-  of
  :~  :-  %new-project
      %-  ot
      :~  title+so
          chefs+dejs-set-ships
          peons+dejs-set-ships
          viewers+dejs-set-ships
      ==
      ::
      :-  %copy-project
      %-  ot
      :~  old-pin+dejs-pin
          title+so
          chefs+dejs-set-ships
          peons+dejs-set-ships
          viewers+dejs-set-ships
      ==
      ::
      :-  %new-goal
      %-  ot
      :~  pin+dejs-pin
          desc+so
          chefs+dejs-set-ships
          peons+dejs-set-ships
          deadline+dejs-unit-date
          actionable+bo
      ==
      ::
      :-  %add-under
      %-  ot
      :~  id+dejs-id
          desc+so
          chefs+dejs-set-ships
          peons+dejs-set-ships
          deadline+dejs-unit-date
          actionable+bo
      ==
      [%edit-goal-desc (ot ~[id+dejs-id desc+so])]
      [%edit-project-title (ot ~[pin+dejs-pin title+so])]
      [%delete-project (ot ~[pin+dejs-pin])]
      [%delete-goal (ot ~[id+dejs-id])]
      [%yoke-sequence (ot ~[pin+dejs-pin yoke-sequence+dejs-yoke-seq])]
      [%set-deadline (ot ~[id+dejs-id deadline+dejs-unit-date])]
      [%mark-actionable (ot ~[id+dejs-id])]
      [%unmark-actionable (ot ~[id+dejs-id])]
      [%mark-complete (ot ~[id+dejs-id])]
      [%unmark-complete (ot ~[id+dejs-id])]
      [%make-chef (ot ~[chef+dejs-ship id+dejs-id])]
      [%make-peon (ot ~[peon+dejs-ship id+dejs-id])]
  ==
::
++  dejs-unit-date  |=(jon=json ?~(jon ~ (some (ni:dejs:format jon))))
++  dejs-pin  (pe:dejs:format %pin dejs-id)
++  dejs-id  (ot ~[owner+(su fed:ag) birth+ni]):dejs:format
++  dejs-set-ships  (as:dejs:format dejs-ship)
++  dejs-ship  (su fed:ag):dejs:format
++  dejs-yoke-seq  (ar:dejs:format dejs-yoke)
++  dejs-yoke  (ot:dejs:format ~[yoke+dejs-yoke-tag lid+dejs-id rid+dejs-id])
++  parse-yoke-tag
  ;~  pose
    (cold %prio-rend (jest 'prio-rend'))
    (cold %prio-yoke (jest 'prio-yoke'))
    (cold %prec-rend (jest 'prec-rend'))
    (cold %prec-yoke (jest 'prec-yoke'))
    (cold %nest-rend (jest 'nest-rend'))
    (cold %nest-yoke (jest 'nest-yoke'))
    (cold %held-rend (jest 'held-rend'))
    (cold %held-yoke (jest 'held-yoke'))
  ==
++  dejs-yoke-tag  (su:dejs:format parse-yoke-tag)
::
++  dejs-tests
  |%
  ++  new-project
    =,  enjs:format
    ^-  json
    %+  frond
      %new-project
    %-  pairs
    :~  [%title s+'test']
        [%chefs a+~[s+'zod' s+'nec' s+'bud']]
        [%peons a+~[s+'zod' s+'nec' s+'bud']]
        [%viewers a+~[s+'zod' s+'nec' s+'bud']]
    ==
  ++  copy-project
    =,  enjs:format
    ^-  json
    %+  frond
      %copy-project
    %-  pairs
    :~  [%old-pin (pairs ~[[%owner s+'zod'] [%birth (numb (add ~2000.1.1 ~s1..0001))]])]
        [%title s+'test']
        [%chefs a+~[s+'zod' s+'nec' s+'bud']]
        [%peons a+~[s+'zod' s+'nec' s+'bud']]
        [%viewers a+~[s+'zod' s+'nec' s+'bud']]
    ==
  ++  new-goal
    =,  enjs:format
    ^-  json
    %+  frond
      %new-goal
    %-  pairs
    :~  [%pin (pairs ~[[%owner s+'zod'] [%birth (numb (add ~2000.1.1 ~s1..0001))]])]
        [%desc s+'test desc']
        [%chefs a+~[s+'zod' s+'nec' s+'bud']]
        [%peons a+~[s+'zod' s+'nec' s+'bud']]
        [%deadline (numb (add ~2000.1.1 ~s1..0001))]
        [%actionable b+%.n]
    ==
  ++  yoke-sequence
    =,  enjs:format
    ^-  json
    %+  frond
      %yoke-sequence
    %-  pairs
    :~  [%pin (pairs ~[[%owner s+'zod'] [%birth (numb (add ~2000.1.1 ~s1..0001))]])]
        :-  %yoke-sequence
        :-  %a
        :~  %-  pairs
            :~  [%yoke s+'nest-yoke']
                [%lid (pairs ~[[%owner s+'zod'] [%birth (numb (add ~2000.1.1 ~s1..0001))]])]
                [%rid (pairs ~[[%owner s+'zod'] [%birth (numb (add ~2000.1.1 ~s1..0001))]])]
            ==
            %-  pairs
            :~  [%yoke s+'prec-rend']
                [%lid (pairs ~[[%owner s+'zod'] [%birth (numb (add ~2000.1.1 ~s1..0001))]])]
                [%rid (pairs ~[[%owner s+'zod'] [%birth (numb (add ~2000.1.1 ~s1..0001))]])]
            ==
        ==
    ==
  --
::
++  enjs-update
  =,  enjs:format
  |=  =update
  ^-  json
  ?+    -.update  !!
      %initial
    %+  frond
      %initial
    %-  pairs
    :~  [%store (enjs-store store.update)]
    ==
  ==
::
++  enjs-store
  =,  enjs:format
  |=  =store
  ^-  json
  %-  pairs
  :~  [%directory (enjs-directory directory.store)]
      [%projects (enjs-projects projects.store)]
  ==
::
++  enjs-directory
  =,  enjs:format
  |=  =directory
  :-  %a  %+  turn  ~(tap by directory)
  |=  [=id =pin] 
  %-  pairs
  :~  [%id (enjs-id id)]
      [%pin (enjs-pin pin)]
  ==
  
++  enjs-projects
  =,  enjs:format
  |=  =projects
  :-  %a  %+  turn  ~(tap by projects) 
  |=  [=pin =project] 
  %-  pairs
  :~  [%pin (enjs-pin pin)]
      [%project (enjs-project project)]
  ==
::
++  enjs-project
  =,  enjs:format
  |=  =project
  %-  pairs
  :~  [%title s+title.project]
      [%creator (ship creator.project)]
      [%goals (enjs-goals goals.project)]
      [%chefs a+(turn ~(tap in chefs.project) ship)]
      [%peons a+(turn ~(tap in peons.project) ship)]
      [%viewers a+(turn ~(tap in viewers.project) ship)]
      [%archived b+archived.project]
  ==
::
++  enjs-goals
  =,  enjs:format
  |=  =goals
  :-  %a  %+  turn  ~(tap by goals) 
  |=  [=id =goal] 
  %-  pairs
  :~  [%id (enjs-id id)]
      [%goal (enjs-goal goal)]
  ==
::
++  enjs-goal
  =,  enjs:format
  |=  =goal
  ^-  json
  %-  pairs
  :~  [%desc s+desc.goal]
      [%author (ship author.goal)]
      [%chefs a+(turn ~(tap in chefs.goal) ship)]
      [%peons a+(turn ~(tap in peons.goal) ship)]
      [%par ?~(par.goal ~ (enjs-id u.par.goal))]
      [%kids a+(turn ~(tap in kids.goal) enjs-id)]
      [%kickoff (enjs-split kickoff.goal)]
      [%deadline (enjs-split deadline.goal)]
      [%complete b+complete.goal]
      [%actionable b+actionable.goal]
      [%archived b+archived.goal]
  ==
::
++  enjs-split
   =,  enjs:format
   |=  =split
   ^-  json
   %-  pairs
   :~  [%moment ?~(moment.split ~ (numb `@`u.moment.split))]
       [%inflow a+(turn ~(tap in inflow.split) enjs-eid)]
       [%outflow a+(turn ~(tap in outflow.split) enjs-eid)]
   ==
::
++  enjs-eid
  =,  enjs:format
  |=  =eid
  ^-  json
  %-  pairs
  :~  [%edge s+-.eid]
      [%id (enjs-id +.eid)]
  ==
::
++  enjs-pin
  =,  enjs:format
  |=  =pin
  ^-  json
  (enjs-id +.pin)
::
++  enjs-id
  =,  enjs:format
  |=  =id
  ^-  json
  %-  pairs
  :~  [%owner (ship owner.id)]
      [%birth (numb `@`birth.id)]
  ==
--
