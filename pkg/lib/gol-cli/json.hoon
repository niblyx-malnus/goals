/-  *goal, *goal-store
|%
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
   :~  [%moment ?~(moment.split ~ (time u.moment.split))]
       [%inflow a+(turn ~(tap in inflow.split) enjs-eid)]
       [%outflow a+(turn ~(tap in outflow.split) enjs-eid)]
   ==
::
++  enjs-eid
  =,  enjs:format
  |=  =eid
  ^-  json
  %+  frond
    %eid
  %-  pairs
  :~  [%edge s+-.eid]
      [%owner (ship owner.id.eid)]
      [%birth (time birth.id.eid)]
  ==
::
++  enjs-pin
  =,  enjs:format
  |=  =pin
  ^-  json
  %+  frond
    %pin
  %-  pairs
  :~  [%owner (ship owner.pin)]
      [%birth (time birth.pin)]
  ==
::
++  enjs-id
  =,  enjs:format
  |=  =id
  ^-  json
  %+  frond
    %id
  %-  pairs
  :~  [%owner (ship owner.id)]
      [%birth (time birth.id)]
  ==
--
