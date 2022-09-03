/+  *gol-cli-help
|%
::
+$  state-1  [%1 =store:s1]
+$  state-0  [%0 =store:s0]
::
+$  id         id:s1
+$  eid        eid:s1
+$  pin        pin:s1
+$  edge       edge:s1
+$  goal       goal:s1
+$  goals      goals:s1
+$  pool       pool:s1
+$  pools      pools:s1
+$  directory  directory:s1
+$  store      store:s1
::
++  s1
  |%
  +$  id  id:s0
  +$  eid  eid:s0
  +$  pin  pin:s0
  ::
  +$  edge
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
        kickoff=edge
        deadline=edge
        complete=?(%.y %.n)
        actionable=?(%.y %.n)
        archived=?(%.y %.n)
    ==
  ::
  +$  goals  (map id goal)
  ::
  +$  pool
    $:  title=@t
        creator=ship
        =goals
        chefs=(set ship)
        peons=(set ship)
        viewers=(set ship)
        archived=?(%.y %.n)
    ==
  ::
  +$  pools  (map pin pool)
  ::
  +$  directory  directory:s0
  ::
  +$  store  [=directory =pools]
  --
::
++  s0
  |%
  ::
  :: $id: identity of a goal; determined by creator and time of creation
  +$  id  [owner=@p birth=@da]
  ::
  +$  eid  [?(%k %d) =id]
  ::
  +$  pin  [%pin id]
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
  +$  projects  (map pin project)
  ::
  +$  directory  (map id pin)
  ::
  +$  store  [=directory =projects]
  --
:: From state-0 to state-1:
::   - split was changed to edge
::   - project was changed to pool
::   - projects was changed to pools
::
++  convert-0-to-1
  |=  [=state-0]
  ^-  state-1
  [%1 `store`store.state-0]
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
+$  yoke  $-([id id] pools)
::
+$  core-yoke
  $%  [%own-yoke lid=id rid=id]
      [%own-rend lid=id rid=id]
      [%dag-yoke e1=eid e2=eid]
      [%dag-rend e1=eid e2=eid]
  ==
::
++  yoke-tags
  :~  %prio-rend
      %prio-yoke
      %prec-rend
      %prec-yoke
      %nest-rend
      %nest-yoke
      %held-rend
      %held-yoke
  ==
::
+$  yoke-tag  (union-from-list yoke-tags)
::
+$  composite-yoke  $%([yoke-tag lid=id rid=id])
::
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
+$  pool-perm
  $%  %mod-viewers
      %edit-title
      %new-goal
  ==
::
+$  pair-perm
  $%  %&
  ==
--
