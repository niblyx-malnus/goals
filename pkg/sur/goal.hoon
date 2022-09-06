/+  *gol-cli-help
|%
::
+$  state-2  [%2 =store:s2]
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
++  s2
  |%
  +$  id  id:s1
  +$  eid  eid:s1
  +$  pin  pin:s1
  +$  edge  edge:s1
  +$  directory  directory:s1
  ::
  +$  togl
    $:  mod=ship
        timestamp=@da
    ==
  ::
  +$  goal
    $:  ::  fixed
        $:  owner=ship
            birth=@da :: unless it is a copy, same as genesis
            creator=ship
            genesis=@da
        ==
        ::  nexus
        $:  chefs=(set ship)
            peons=(set ship)
            par=(unit id)
            kids=(set id)
            kickoff=edge
            deadline=edge
            complete=(list togl) :: odd length means %.y
            actionable=(list togl) :: odd length means %.y
            archived=?(%.y %.n)
        ==
        ::  fluid
        $:  desc=@t :: should be revision controlled
            meta=(map @tas (unit @tas))
            tags=(set @tas)
        ==
    ==
  ::
  +$  goals  (map id goal)
  ::
  +$  pool
    $:  ::  fixed
        $:  owner=ship
            birth=@da   :: unless it is a copy, same as genesis
            creator=ship
            genesis=@da
        ==
        ::  nexus
        $:  =goals
            chefs=(set ship)
            peons=(set ship)
            viewers=(set ship)
            archived=?(%.y %.n)
        ==
        ::  fluid
        $:  title=@t
            fields=(map @tas (list @tas))
        ==
    ==
  ::
  +$  pools  (map pin pool)
  ::
  +$  store  [=directory =pools]
  --
::
++  s1
  |%
  +$  id  id:s0
  +$  eid  eid:s0
  +$  pin  pin:s0
  +$  directory  directory:s0
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
:: From state-1 to state-2:
::   - add owner, birth, and genesis
::
++  convert-1-to-2  !!
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
+$  nex  (map id nexus)
::
+$  nexus
  $:  par=(unit id)
      kids=(set id)
      kickoff=edge
      deadline=edge
  ==
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
      %held-rend-strict
      %held-yoke
  ==
::
+$  yoke-tag  (union-from-list yoke-tags)
::
+$  composite-yoke  $%([yoke-tag lid=id rid=id])
::
+$  yoke-sequence  (list ?(core-yoke [%held-rend lid=id rid=id] composite-yoke))
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
