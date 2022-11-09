|%
+$  id  *
+$  nid  [?(%k %d) id]
+$  node
  $:  $:  moment=(unit @da)
          inflow=(set nid)
          outflow=(set nid)
      ==
      * :: exists for historical reasons; goal "inflation"
  ==
+$  goal
  $:  $:  par=(unit id)
          kids=(set id)
          kickoff=node
          deadline=node
          complete=?(%.y %.n)
          actionable=?(%.y %.n)
          chief=ship
          spawn=(set ship)
      ==
      * :: exists for historical reasons; goal "inflation"
  ==
+$  goals  (map id goal)
--
|%
++  validate
  |=  =goals
  ^-  ?
  :: assert nodes doubly-linked
  :: assert traversal from roots produces no cycles
  :: assert traversal from roots produces all nodes
  :: assert traversal from roots produces correctly ordered moments
  ::   (use check-bound-mismatch on all roots)
  :: assert no completed deadline is right of any incomplete deadline
  ::   (use check-plete-mismatch on all roots)
  :: assert doubly-linked par/kids
  :: assert all par/kids relationships reflects containment (held-yoke)
  :: assert actionable goals have no kids or nested goals
  !!
--
