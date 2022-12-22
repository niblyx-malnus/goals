/-  gol=goal
|_  [=bowl:gall store:gol]
++  got-pool
  |=  =pin:gol
  ^-  pool:gol
  ?~  upool=(~(get by pools) pin)
    (~(got by cache) pin)
  u.upool
::
++  got-goal
  |=  =id:gol
  ^-  [=pin:gol =pool:gol =goal:gol]
  =/  pin  (got:idx-orm:gol index id)
  =/  pool  (got-pool pin)
  :-  pin  :-  pool
  ?~  ugoal=(~(get by goals.pool) id)
    (~(got by cache.pool) id)
  u.ugoal
::
++  id-to-url
  |=  =id:gol
  ^-  @ta
  %-  crip 
  %+  weld
    ~(r at owner.id)
  ~(r at (unm:chrono:userlib birth.id))
::
++  pin-to-url
  |=  =pin:gol
  ^-  @ta
  %-  crip 
  (weld "p" (trip (id-to-url +.pin)))
::
++  our-pool-role
  |=  =pin:gol
  ^-  @tas
  =/  pool  (got-pool pin)
  ?:  =(our.bowl owner.pool)  %owner
  ?~(role=(~(got by perms.pool) our.bowl) %viewer u.role)
::
++  our-goal-role
  |=  =id:gol
  ^-  @tas
  =+  (got-goal id) :: exposes pin, pool, and goal
  =/  pool-role  (our-pool-role pin)
  ?:  |(=(pool-role %owner) =(pool-role %admin))  pool-role
  ?:  =(our.bowl chief.goal)  %chief
  ?:  (~(has by ranks.goal) our.bowl)  %ranking-chief
  ?:((~(has in spawn.goal) our.bowl) %spawn %viewer)
::
++  goal-list
  |=  goals=(list [=id:gol =goal:gol])
  ^-  marl
  =|  data-rows=marl
  |-
  ?~  goals
    ;+  ;table.main-table
      ;+  header-row
      ;*  (flop data-rows)
    ==
  %=  $
    goals  t.goals
    data-rows  [(data-row i.goals) data-rows]
  ==
  ++  header-row
    ^-  manx
    ;tr
      ;th: 
      ;th.widecol: description
      ;th: chief
      ;th: role
      ;th: perms
      ;th: harvest
      ;th: 
    ==
  ++  data-row
    |=  [=id:gol =goal:gol]
    ^-  manx
    |^
    =/  url  (trip (id-to-url id))
    ;tr
      ;td
        ;+  shifters
      ==
      ;td.widecol
        ;+  ?.  actionable.goal
              ?.  complete.goal
                ;a(href url): {(trip desc.goal)}
              ;a(href url)
                ;s(style "background-color:#d3d3d3"): {(trip desc.goal)}
              ==
            ?.  complete.goal
              ;a.bordered(href url): {(trip desc.goal)}
            ;a.bordered(href url)
              ;s(style "background-color:#d3d3d3"): {(trip desc.goal)}
            ==
      ==
      ;td: {(scow %p chief.goal)}
      ;td.centered: {(trip (our-goal-role id))}
      ;td
        ;a(href (weld url "-participants")): link
      ==
      ;td
        ;a(href (weld url "-harvest")): link
      ==
      ;td
        ;+  action-buttons
      ==
    ==
    ++  shifters
      ^-  manx
      ;table
        ;tr
          ;td
            ;form.label(method "post")
              ;button(type "submit", name "action", value ""):"^"
            ==
          ==
          ;td
            ;form.label(method "post")
              ;button(type "submit", name "action", value ""):"v"
            ==
          ==
          ;td
            ;form.label(method "post")
              ;input(type "hidden", name "owner", value "{(scow %p owner.id)}");
              ;input(type "hidden", name "birth", value "{(scow %da birth.id)}");
              ;button(type "submit", name "action", value "actionable"):"@"
            ==
          ==
          ;td
            ;form.label(method "post")
              ;input(type "hidden", name "owner", value "{(scow %p owner.id)}");
              ;input(type "hidden", name "birth", value "{(scow %da birth.id)}");
              ;button(type "submit", name "action", value "complete"):"x"
            ==
          ==
        ==
      ==
    ++  action-buttons
      ^-  manx
      ;table
        ;tr
          ;td
            ;form.label(method "post")
              ;input(type "hidden", name "owner", value "{(scow %p owner.id)}");
              ;input(type "hidden", name "birth", value "{(scow %da birth.id)}");
              ;button(type "submit", name "action", value "cache-goal"):"a"
            ==
          ==
        ==
      ==
    --
  --
