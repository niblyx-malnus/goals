|%
::
:: stolen from Fang's suite/lib/pal.hoon
++  may  |*([else=* =rule] ;~(pose rule (easy else)))
++  opt  |*(=rule (may ~ rule))
::
++  fuse                                                ::  cons contents
  |*  [a=(list) b=(list)]
  ^-  (list [_?>(?=(^ a) i.a) _?>(?=(^ b) i.b)])
  ?~  a  ~
  ?~  b  ~
  :-  [i.a i.b]
  $(a t.a, b t.b)
::
++  union-from-list
  |*  =(list *)
  _(snag 0 ~(tap in (sy list)))
::
:: optional jest
++  jost  |=(a=@t (opt (jest a)))
::
:: pose a list of jests
++  jist
  |=  a=(list @t)
  ?~  a  fail
  ;~  pose
    (jest i.a)
    %+  knee  *@t
    |.  ~+
    ^$(a t.a)
  ==
::
:: pose a list of jests and output atoms with cold
++  coji
  |*  a=(list [* @t])
  ?~  a  fail
  ;~  pose
    (cold -.i.a (jest +.i.a))
    %+  knee  -.i.a
    |.
    ^$(a t.a)
  ==
::
:: convert a list to a non-null-terminated right branching cell
++  cellify
  |*  a=(list)
  ?~  a  !!
  ?~  t.a  i.a
  [i.a $(a t.a)]
::
:: Get address from tuple index
++  tupdex
  |=  idx=@
  =/  count  0
  =/  addr  1
  |-
  ?:  =(count idx)
    (mul 2 addr)
  $(count +(count), addr +((mul 2 addr)))
--
