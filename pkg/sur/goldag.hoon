|%
+$  id  @
+$  nid  [?(%k %d) id]
+$  node
  $:  moment=(unit @da)
      incoming=(set nid)
      outgoing=(set nid)
  ==
+$  goal
  $:  chief=ship
      par=(unit id)
      kids=(set id)
      kickoff=node
      deadline=node
      complete=?(%.y %.n)
      actionable=?(%.y %.n)
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
  :: assert no completed deadline is right of any incomplete deadline
  :: assert doubly-linked par/kids
  :: assert all par/kids relationships reflects containment (held-yoke)
  :: assert actionable goals have no kids or nested goals
  !!
--
