|%
::
:: $id: identity of a goal; determined by creator and time of creation
+$  id  [owner=@p birth=@da]
::
+$  eid  [?(%k %d) =id]
::
+$  split
  $:  moment=(unit @da)
      inflow=(set eid)
      outflow=(set eid)
  ==
::
+$  goal
  $:  desc=@t
      author=ship
      chefs=(set ship)
      peons=(set ship)
      par=(unit id)
      kids=(set id)
      kickoff=split
      deadline=split
      complete=?(%.y %.n)
      actionable=?(%.y %.n)
      archived=?(%.y %.n)
  ==
::
+$  goals  (map id goal)
::
+$  project
  $:  title=@t
      creator=ship
      =goals
      chefs=(set ship)
      peons=(set ship)
      viewers=(set ship)
      archived=?(%.y %.n)
  ==
::
+$  pin  [%pin id]
::
+$  projects  (map pin project)
::
+$  directory  (map id pin)
::
+$  store  [=directory =projects]
:: 
+$  normal-mode
  $?  %normal
      %normal-completed
  ==
+$  mode
  $?  normal-mode
      %nest-ryte
      %nest-left
      %prec-ryte
      %prec-left
      %prio-ryte
      %prio-left
  ==
::
+$  comparator  $-([id id] ?)
::
+$  yoke  $-([id id] projects)
::
+$  core-yoke
  $%  [%own-yoke lid=id rid=id]
      [%own-rend lid=id rid=id]
      [%dag-yoke e1=eid e2=eid]
      [%dag-rend e1=eid e2=eid]
  ==
::
+$  yoke-tag
  $?  %prio-rend
      %prio-yoke
      %prec-rend
      %prec-yoke
      %nest-rend
      %nest-yoke
      %held-rend
      %held-yoke
  ==
+$  composite-yoke  $%([yoke-tag lid=id rid=id])
+$  yoke-sequence  (list ?(core-yoke composite-yoke))
::
+$  goal-perm
  $%  %mod-chefs
      %mod-peons
      %add-under
      %remove
      %edit-desc
      %set-deadline
      %mark-actionable
      %mark-complete
      %mark-active
  ==
::
+$  project-perm
  $%  %mod-viewers
      %edit-title
      %new-goal
  ==
::
+$  pair-perm
  $%  %&
  ==
--
