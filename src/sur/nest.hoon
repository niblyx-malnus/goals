|%
+$  id  [@p @da]  :: identified by creator and time of creation
+$  hndl  @t
+$  desc  @t
+$  dead  (unit @da)
+$  pars  (set id)
+$  kids  (set id)
+$  clps  (set id)
+$  hidn  (set id)
+$  goal
  $:  =desc
      =dead
      =pars
      =kids
      =clps
      =hidn
  ==
+$  goals  (map id goal)
+$  handles  [hi=(map hndl id) ih=(map id hndl)]
+$  context  (unit id)
+$  action
  $%  [%add =desc par=(unit id)]
      [%del =id]
      [%nest par=id kid=id]
      [%flee par=id kid=id]
      :: [%dead =id]
      [%clearall ~]
      [%cc c=(unit id)]
  ==
--
