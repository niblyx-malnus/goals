/-  *goal, *view, *resource, ms=metadata-store
|_  =bowl:gall
++  initial
  ^-  store
  =/  pyk=peek
    .^  peek
      %gx
      :~  (scot %p our.bowl)
          %goal-store-beta
          (scot %da now.bowl)
          %initial
          %goal-peek
      ==
    ==
  ?+  -.pyk  !!
    %initial  store.pyk
  ==
::
++  pool-keys
  ^-  (set pin)
  =/  pyk=peek
    .^  peek
      %gx
      :~  (scot %p our.bowl)
          %goal-store-beta
          (scot %da now.bowl)
          %pool-keys
          %goal-peek
      ==
    ==
  ?+  -.pyk  !!
    %pool-keys  keys.pyk
  ==
::
++  all-goal-keys
  ^-  (set id)
  =/  pyk=peek
    .^  peek
      %gx
      :~  (scot %p our.bowl)
          %goal-store-beta
          (scot %da now.bowl)
          %all-goal-keys
          %goal-peek
      ==
    ==
  ?+  -.pyk  !!
    %all-goal-keys  keys.pyk
  ==
::
++  get-goal
  |=  =id
  ^-  (unit goal)
  =/  pyk=peek
    .^  peek
      %gx
      :~  (scot %p our.bowl)
          %goal-store-beta
          (scot %da now.bowl)
          %goal
          (scot %p owner.id)
          (scot %da birth.id)
          %get-goal
          %goal-peek
      ==
    ==
  ?+  -.pyk  !!
    %get-goal  ugoal.pyk
  ==
::
++  got-goal  |=(=id `goal`(need (get-goal id)))
::
++  got-pin
  |=  =id
  ^-  pin
  =/  pyk=peek
    .^  peek
      %gx
      :~  (scot %p our.bowl)
          %goal-store-beta
          (scot %da now.bowl)
          %goal
          (scot %p owner.id)
          (scot %da birth.id)
          %get-pin
          %goal-peek
      ==
    ==
  ?+  -.pyk  !!
    %get-pin  ?~(upin.pyk !! u.upin.pyk)
  ==
::
++  get-pool
  |=  =pin
  ^-  (unit pool)
  =/  pyk=peek
    .^  peek
      %gx
      :~  (scot %p our.bowl)
          %goal-store-beta
          (scot %da now.bowl)
          %pool
          (scot %p owner.pin)
          (scot %da birth.pin)
          %get-pool
          %goal-peek
      ==
    ==
  ?+  -.pyk  !!
    %get-pool  upool.pyk
  ==
::
++  got-pool  |=(=pin `pool`(need (get-pool pin)))
::
::
++  ryte-bound
  |=  =id
  ^-  (unit @da)
  =/  pyk=peek
    .^  peek
      %gx
      :~  (scot %p our.bowl)
          %goal-store-beta
          (scot %da now.bowl)
          %goal
          (scot %p owner.id)
          (scot %da birth.id)
          %ryte-bound
          %goal-peek
      ==
    ==
  ?+  -.pyk  !!
    %ryte-bound  moment.pyk
  ==
::
++  plumb
  |=  =id
  ^-  @ud
  =/  pyk=peek
    .^  peek
      %gx
      :~  (scot %p our.bowl)
          %goal-store-beta
          (scot %da now.bowl)
          %goal
          (scot %p owner.id)
          (scot %da birth.id)
          %plumb
          %goal-peek
      ==
    ==
  ?+  -.pyk  !!
    %plumb  depth.pyk
  ==
::
++  anchor
  |=  =pin
  ^-  @ud
  =/  pyk=peek
    .^  peek
      %gx
      :~  (scot %p our.bowl)
          %goal-store-beta
          (scot %da now.bowl)
          %pool
          (scot %p owner.pin)
          (scot %da birth.pin)
          %anchor
          %goal-peek
      ==
    ==
  ?+  -.pyk  !!
    %anchor  depth.pyk
  ==
::
++  priority
  |=  =id
  ^-  @ud
  =/  pyk=peek
    .^  peek
      %gx
      :~  (scot %p our.bowl)
          %goal-store-beta
          (scot %da now.bowl)
          %goal
          (scot %p owner.id)
          (scot %da birth.id)
          %priority
          %goal-peek
      ==
    ==
  ?+  -.pyk  !!
    %priority  priority.pyk
  ==

 ++  yung
   |=  =id
   ^-  (list ^id)
   =/  pyk=peek
     .^  peek
       %gx
       :~  (scot %p our.bowl)
           %goal-store-beta
           (scot %da now.bowl)
           %goal
           (scot %p owner.id)
           (scot %da birth.id)
           %yung
           %goal-peek
       ==
     ==
   ?+  -.pyk  !!
     %yung  yung.pyk
   ==
::
++  yung-uncompleted
  |=  =id
  ^-  (list ^id)
  =/  pyk=peek
    .^  peek
      %gx
      :~  (scot %p our.bowl)
          %goal-store-beta
          (scot %da now.bowl)
          %goal
          (scot %p owner.id)
          (scot %da birth.id)
          %yung
          %uncompleted
          %goal-peek
      ==
    ==
  ?+  -.pyk  !!
    %yung-uncompleted  yung-uc.pyk
  ==
::
++  yung-virtual
  |=  =id
  ^-  (list ^id)
  =/  pyk=peek
    .^  peek
      %gx
      :~  (scot %p our.bowl)
          %goal-store-beta
          (scot %da now.bowl)
          %goal
          (scot %p owner.id)
          (scot %da birth.id)
          %yung
          %virtual
          %goal-peek
      ==
    ==
  ?+  -.pyk  !!
    %yung-virtual  yung-vr.pyk
  ==
::
++  roots
  |=  =pin
  ^-  (list id)
  =/  pyk=peek
    .^  peek
      %gx
      :~  (scot %p our.bowl)
          %goal-store-beta
          (scot %da now.bowl)
          %pool
          (scot %p owner.pin)
          (scot %da birth.pin)
          %roots
          %goal-peek
      ==
    ==
  ?+  -.pyk  !!
    %roots  roots.pyk
  ==
::
++  roots-uncompleted
  |=  =pin
  ^-  (list id)
  =/  pyk=peek
    .^  peek
      %gx
      :~  (scot %p our.bowl)
          %goal-store-beta
          (scot %da now.bowl)
          %pool
          (scot %p owner.pin)
          (scot %da birth.pin)
          %roots
          %uncompleted
          %goal-peek
      ==
    ==
  ?+  -.pyk  !!
    %roots-uncompleted  roots-uc.pyk
  ==
::
:: ++  seniority
::   |=  [mod=ship =id cp=?(%c %p)]
::   ^-  (unit ^id)
::   =/  pyk=peek
::     .^  peek
::       %gx
::       :~  (scot %p our.bowl)
::           %goal-store-beta
::           (scot %da now.bowl)
::           %goal
::           (scot %p owner.id)
::           (scot %da birth.id)
::           %seniority
::           (scot %p mod)
::           [cp]
::           %goal-peek
::       ==
::     ==
::   ?+  -.pyk  !!
::     %seniority  u-senior.pyk
::   ==
::
++  harvest
  |=  =id
  ^-  (list ^id)
  =/  pyk=peek
    .^  peek
      %gx
      :~  (scot %p our.bowl)
          %goal-store-beta
          (scot %da now.bowl)
          %goal
          (scot %p owner.id)
          (scot %da birth.id)
          %harvest
          %goal-peek
      ==
    ==
  ?+  -.pyk  !!
    %harvest  harvest.pyk
  ==
:: 
:: ----------------------------------------------------------------------------
:: composite helpers
::
:: get the number representing the deepest path to a leaf node
++  get-lvl
  |=  [=grip =mode]
  ^-  @ud
  ?+    mode  !!
      normal-mode
    ?-    -.grip
      %all  0
      %pool  (anchor +.grip)
      %goal  (plumb +.grip)
    ==
  ==
::
:: get the goals to print beneath a given goal
++  get-fam
  |=  [=grip =mode]
  ^-  (list ^grip)
  ?+    mode  !!
      %normal
    ?-    -.grip
      %all  (turn ~(tap in pool-keys) |=(=pin [%pool pin]))
        %pool  
      (turn (roots-uncompleted +.grip) |=(=id [%goal id]))
        %goal
      =/  goal  (got-goal +.grip)
      (turn (yung-uncompleted +.grip) |=(=id [%goal id]))
    ==
      %normal-completed
    ?-    -.grip
      %all  (turn ~(tap in pool-keys) |=(=pin [%pool pin]))
      %pool  (turn (roots +.grip) |=(=id [%goal id]))
        %goal
      =/  goal  (got-goal +.grip)
      (turn (yung +.grip) |=(=id [%goal id]))
    ==
  ==
--
