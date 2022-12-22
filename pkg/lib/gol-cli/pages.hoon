/-  gol=goal
/+  rudder, nod=gol-cli-node, tav=gol-cli-traverse, gol-cli-lego
|=  [=bowl:gall store:gol]
^-  (map @ta (page:rudder store:gol unver-action:gol))
=*  lego  ~(. gol-cli-lego +6)
|^
=|  pages=(map @ta (page:rudder store:gol unver-action:gol))
%-  ~(gas by pages)
;:  welp
  [%index index-page]~
  [%all-pool-harvest index-harvest-page]~
  ::
  :: pool pages
  %+  turn
    ~(tap in ~(key by pools)) 
  |=  =pin:gol
  [(pin-to-url:lego pin) (pool-page pin)]
  ::
  :: pool note edit
  %+  turn
    ~(tap in ~(key by pools))
  |=  =pin:gol
  :_  (pool-note-page pin)
  (crip (weld (trip (pin-to-url:lego pin)) "-note"))
  ::
  :: pool harvest
  %+  turn
    ~(tap in ~(key by pools))
  |=  =pin:gol
  :_  (pool-harvest-page pin)
  (crip (weld (trip (pin-to-url:lego pin)) "-harvest"))
  ::
  :: pool participants
  %+  turn
    ~(tap in ~(key by pools)) 
  |=  =pin:gol
  :_  (pool-participants pin)
  (crip (weld (trip (pin-to-url:lego pin)) "-participants"))
  ::
  :: goal pages
  %+  turn
    (turn (tap:idx-orm:gol index) |=([=id:gol pin:gol] id))
  |=  =id:gol
  [(id-to-url:lego id) (goal-page id)]
  ::
  :: goal note edit
  %+  turn
    (turn (tap:idx-orm:gol index) |=([=id:gol pin:gol] id))
  |=  =id:gol
  :_  (goal-note-page id)
  (crip (weld (trip (id-to-url:lego id)) "-note"))
  ::
  :: goal harvest
  %+  turn
    (turn (tap:idx-orm:gol index) |=([=id:gol pin:gol] id))
  |=  =id:gol
  :_  (goal-harvest-page id)
  (crip (weld (trip (id-to-url:lego id)) "-harvest"))
  ::
  :: goal participants
  %+  turn
    (turn (tap:idx-orm:gol index) |=([=id:gol pin:gol] id))
  |=  =id:gol
  :_  (goal-participants id)
  (crip (weld (trip (id-to-url:lego id)) "-participants"))
==
::
:: accepts a local style
++  global-style
  |=  loc=cord
  ^-  cord
  %-  crip
  %+  weld
    (trip loc)
  %-  trip
  '''
  h, p, table { font-family:monospace; }
  h2 { 
    font-size:3em;
    line-height:1em;
  }
  h3 {
    font-size:1.5em;
    line-height:.5em;
  }
  p, table { font-size:1.5em; }
  td { line-height:2.2em; }
  .info { font-size:0.8em; }
  .widecol { min-width:20em; }
  .wide-input { width:50em; }
  .main-table {
    border-spacing: 1em .5em;
    }
  .green { color:#229922; }
  .bold { font-weight:bold; }
  .centered { text-align:center }
  .centered-button {
    text-align:center;
    position:relative;
    justify-content:center;
    margin-left:auto;
    margin-right:auto;
  }
  .bordered {
    border: 1px solid black;
    padding:5px
  } 
  div {
    max-width:1000px;
    margin-left:auto;
    margin-right:auto;
    line-height:0.75em;
  }
  .text-div {
    border: 1px solid gray;
    padding: 25px 25px 25px 25px;
    line-height:1.25em;
    max-width:800px;
  }
  textarea {
    width:65em;
    height:40em;
    display:block;
    margin-left:auto;
    margin-right:auto;
  }
  '''
++  goal-harvest-page
  |=  =id:gol
  ^-  (page:rudder store:gol unver-action:gol)
  =/  pin  (got:idx-orm:gol index id)
  =/  pool
    ?~  upool=(~(get by pools) pin)
      (~(got by cache) pin)
    u.upool
  =/  goal
    ?~  ugoal=(~(get by goals.pool) id)
      (~(got by cache.pool) id)
    u.ugoal
  |_  [=bowl:gall order:rudder store:gol]
  ++  argue
    |=  [headers=header-list:http body=(unit octs)]
    ^-  $@(brief:rudder unver-action:gol)
    =/  args=(map @t @t)  ?~(body ~ (frisk:rudder q.u.body))
    ?~  action=(~(get by args) 'action')  ~
    ?+    u.action  ~
        %edit-goal-note
      ?~  uowner=(~(get by args) 'owner')  ~
      ?~  owner=(slaw %p u.uowner)  ~
      ?~  ubirth=(~(get by args) 'birth')  ~
      ?~  birth=(slaw %da u.ubirth)  ~
      :*  %edit-goal-note
          [u.owner u.birth]
          (~(gut by args) 'note' '')
      ==
    ==
  ++  final  (alert:rudder url.request build)
  ++  build
    |=  $:  arg=(list [k=@t v=@t])
            msg=(unit [o=? =@t])
        ==
    ^-  reply:rudder
    |^  [%page page]
    ++  style  (global-style '')
    ++  page
      ^-  manx
      ;hmtl
        ;head
          ;title:"%goals-test"
          ;meta(charset "utf-8");
          ;meta(name "viewport", content "width=device-width, initial-scale=1");
          ;style:"{(trip style)}"
          ;script(type "module", src "https://md-block.verou.me/md-block.js");
        ==
        ;body
          ;div
            ;table.main-table
              ;tr
                ;td
                  :: eyre id overwrites goal id
                  ;a(href (trip (id-to-url:lego ^id))): source goal
                ==
              ==
            ==
            ;h2: Ⓖ   {(trip desc.goal)}
            ;*  %-  goal-list:lego
                %+  turn
                  %-  ~(actionable nod goals.pool)
                  ?.  hide-completed
                    ~(tap in (~(harvest tav goals.pool) ^id))
                  %-  ~(incomplete nod goals.pool)
                  ~(tap in (~(harvest tav goals.pool) ^id))
                |=(=id:gol [id (~(got by goals.pool) id)])
          ==
        ==
      ==
    --
  --
++  goal-note-page
  |=  =id:gol
  ^-  (page:rudder store:gol unver-action:gol)
  =/  pin  (got:idx-orm:gol index id)
  =/  pool
    ?~  upool=(~(get by pools) pin)
      (~(got by cache) pin)
    u.upool
  =/  goal
    ?~  ugoal=(~(get by goals.pool) id)
      (~(got by cache.pool) id)
    u.ugoal
  |_  [=bowl:gall order:rudder store:gol]
  ++  argue
    |=  [headers=header-list:http body=(unit octs)]
    ^-  $@(brief:rudder unver-action:gol)
    =/  args=(map @t @t)  ?~(body ~ (frisk:rudder q.u.body))
    ?~  action=(~(get by args) 'action')  ~
    ?+    u.action  ~
        %edit-goal-note
      ?~  uowner=(~(get by args) 'owner')  ~
      ?~  owner=(slaw %p u.uowner)  ~
      ?~  ubirth=(~(get by args) 'birth')  ~
      ?~  birth=(slaw %da u.ubirth)  ~
      :*  %edit-goal-note
          [u.owner u.birth]
          (~(gut by args) 'note' '')
      ==
    ==
  ++  final  (alert:rudder url.request build)
  ++  build
    |=  $:  arg=(list [k=@t v=@t])
            msg=(unit [o=? =@t])
        ==
    ^-  reply:rudder
    |^  [%page page]
    ++  style  (global-style '')
    ++  page
      ^-  manx
      ;hmtl
        ;head
          ;title:"%goals-test"
          ;meta(charset "utf-8");
          ;meta(name "viewport", content "width=device-width, initial-scale=1");
          ;style:"{(trip style)}"
          ;script(type "module", src "https://md-block.verou.me/md-block.js");
        ==
        ;body
          ;div
            ;table.main-table
              ;tr
                ;td
                  :: eyre id overwrites goal id
                  ;a(href (trip (id-to-url:lego ^id))): source goal
                ==
              ==
            ==
            ;h2: Ⓖ   {(trip desc.goal)}
            ;+  note
          ==
        ==
      ==
    ++  note
      ^-  manx
      ;div
        ;div.text-div
          ;md-block: {(trip note.goal)}
        ==
        ;br;
        ;form.centered.label(method "post")
          ;textarea(type "text", name "note"): {(trip note.goal)}
          ;input(type "hidden", name "owner", value "{(scow %p owner.^id)}");
          ;input(type "hidden", name "birth", value "{(scow %da birth.^id)}");
          ;button.centered-button(type "submit", name "action", value "edit-goal-note"):"submit"
        ==
      ==
    --
  --
::
++  goal-page
  |=  =id:gol
  ^-  (page:rudder store:gol unver-action:gol)
  =/  pin  (got:idx-orm:gol index id)
  =/  pool
    ?~  upool=(~(get by pools) pin)
      (~(got by cache) pin)
    u.upool
  =/  goal
    ?~  ugoal=(~(get by goals.pool) id)
      (~(got by cache.pool) id)
    u.ugoal
  |_  [=bowl:gall order:rudder store:gol]
  ++  argue
    |=  [headers=header-list:http body=(unit octs)]
    ^-  $@(brief:rudder unver-action:gol)
    =/  args=(map @t @t)  ?~(body ~ (frisk:rudder q.u.body))
    ?~  action=(~(get by args) 'action')  ~
    ?+    u.action  ~
        %spawn-goal
      ?~  upowner=(~(get by args) 'pool-owner')  ~
      ?~  pool-owner=(slaw %p u.upowner)  ~
      ?~  upbirth=(~(get by args) 'pool-birth')  ~
      ?~  pool-birth=(slaw %da u.upbirth)  ~
      ?~  ugowner=(~(get by args) 'goal-owner')  ~
      ?~  goal-owner=(slaw %p u.ugowner)  ~
      ?~  ugbirth=(~(get by args) 'goal-birth')  ~
      ?~  goal-birth=(slaw %da u.ugbirth)  ~
      :*  %spawn-goal
          [%pin u.pool-owner u.pool-birth]
          (some [u.goal-owner u.goal-birth])
          (~(gut by args) 'new-goal' '')
          %&
      ==
        ?(%complete %actionable)
      ?~  uowner=(~(get by args) 'owner')  ~
      ?~  owner=(slaw %p u.uowner)  ~
      ?~  ubirth=(~(get by args) 'birth')  ~
      ?~  birth=(slaw %da u.ubirth)  ~
      ?-    u.action
          %complete
        ?.  complete:(~(got by goals.pool) [u.owner u.birth])
          [%mark-complete [u.owner u.birth]]
        [%unmark-complete [u.owner u.birth]]
          %actionable
        ?.  actionable:(~(got by goals.pool) [u.owner u.birth])
          [%mark-actionable [u.owner u.birth]]
        [%unmark-actionable [u.owner u.birth]]
      ==
      ::
        %hide-completed
      ~&  hide-completed
      [%hide-completed ~]
    ==
  ++  final  (alert:rudder url.request build)
  ++  build
    |=  $:  arg=(list [k=@t v=@t])
            msg=(unit [o=? =@t])
        ==
    ^-  reply:rudder
    |^  [%page page]
    ++  style  (global-style '')
    ++  page
      ^-  manx
      ;hmtl
        ;head
          ;title:"%goals-test"
          ;meta(charset "utf-8");
          ;meta(name "viewport", content "width=device-width, initial-scale=1");
          ;style:"{(trip style)}"
          ;script(type "module", src "https://md-block.verou.me/md-block.js");
        ==
        ;body
          ;div
            ;+  header-table
            ;form.label(method "post")
              ;+  ?:  hide-completed
                    ;button(type "submit", name "action", value "hide-completed"): view completed
                  ;button(type "submit", name "action", value "hide-completed"): hide completed
            ==
            ;h2: {(weld "Ⓖ  " (trip desc.goal))}
            ;br;
            ;+  note
            ;+  adder-form
            ;br;
            ;*  ?:  actionable.goal
                  ~
                ;=  ;h3: child goals
                    ;*  =/  goals
                          ?.  hide-completed
                            ~(tap in kids.goal)
                          %-  ~(incomplete nod goals.pool)
                          ~(tap in kids.goal) 
                        %-  goal-list:lego
                        %+  turn
                          goals
                        |=(=id:gol [id (~(got by goals.pool) id)])
                ==
          ==
        ==
      ==
    ++  note
      ^-  manx
      ;div
        ;div.text-div
          ;md-block: {(trip note.goal)}
        ==
        ;br;
        ;p.centered
          ;a.centered(href (weld (trip (id-to-url:lego ^id)) "-note")): edit note
        ==
      ==
    ++  header-table
      ^-  manx
      ;table.main-table.info
        ;tr
          ;td
            ;+  hyperlinks-header
          ==
          ;td
            ;+  info-header
          ==
        ==
      ==
    ++  hyperlinks-header
      ^-  manx
      =/  url
        ?~  par.goal
          (trip (pin-to-url:lego pin))
        (trip (id-to-url:lego u.par.goal))
      ;table.main-table
        ;tr
          ;td
            ;a/"index": all pools
          ==
          ;td
            ;a(href (trip (pin-to-url:lego pin))): parent pool
          ==
          ;td
            ;a(href url): parent
          ==
        ==
      ==
    ++  info-header
      ^-  manx
      ;table.main-table
        ;tr
          ;th: type
          ;th: chief
          ;th: role
          ;th: perms
          ;th: harvest
        ==
        ;tr
          ;td: goal
          ;td: {(scow %p chief.goal)}
          ;td.centered: {(trip (our-goal-role:lego ^id))}
          ;td
            ;a(href (weld (trip (id-to-url:lego ^id)) "-participants")): link
          ==
          ;td
            ;a(href (weld (trip (id-to-url:lego ^id)) "-harvest")): link
          ==
        ==
      ==
    ++  adder-form
      ^-  manx
      ;table.main-table
        ;form(method "post")
          ;tr(style "font-weight: bold")
            ;td:""
            ;td:"new goal"
          ==
          ;tr
            ;td
              ;input(type "hidden", name "pool-owner", value "{(scow %p owner.pin)}");
              ;input(type "hidden", name "pool-birth", value "{(scow %da birth.pin)}");
              ;input(type "hidden", name "goal-owner", value "{(scow %p owner.^id)}");
              ;input(type "hidden", name "goal-birth", value "{(scow %da birth.^id)}");
              ;button(type "submit", name "action", value "spawn-goal"):"+"
            ==
            ;td
              ;input.wide-input(type "text", name "new-goal", placeholder "new goal description");
            ==
          ==
        ==
      ==
    --
  --
++  pool-harvest-page
  |=  =pin:gol
  ^-  (page:rudder store:gol unver-action:gol)
  =/  pool  (~(got by pools) pin)
  |_  [=bowl:gall order:rudder store:gol]
  ++  argue
    |=  [headers=header-list:http body=(unit octs)]
    ^-  $@(brief:rudder unver-action:gol)
    =/  args=(map @t @t)  ?~(body ~ (frisk:rudder q.u.body))
    ?~  action=(~(get by args) 'action')  ~
    ?+    u.action  ~
        %edit-goal-note
      ?~  uowner=(~(get by args) 'owner')  ~
      ?~  owner=(slaw %p u.uowner)  ~
      ?~  ubirth=(~(get by args) 'birth')  ~
      ?~  birth=(slaw %da u.ubirth)  ~
      :*  %edit-goal-note
          [u.owner u.birth]
          (~(gut by args) 'note' '')
      ==
    ==
  ++  final  (alert:rudder url.request build)
  ++  build
    |=  $:  arg=(list [k=@t v=@t])
            msg=(unit [o=? =@t])
        ==
    ^-  reply:rudder
    |^  [%page page]
    ++  style  (global-style '')
    ++  page
      ^-  manx
      ;hmtl
        ;head
          ;title:"%goals-test"
          ;meta(charset "utf-8");
          ;meta(name "viewport", content "width=device-width, initial-scale=1");
          ;style:"{(trip style)}"
          ;script(type "module", src "https://md-block.verou.me/md-block.js");
        ==
        ;body
          ;div
            ;table.main-table
              ;tr
                ;td
                  :: eyre id overwrites goal id
                  ;a(href (trip (pin-to-url:lego pin))): source pool
                ==
              ==
            ==
            ;h2: Ⓟ  {(trip title.pool)}
            ;*  =/  goals
                  %-  ~(actionable nod goals.pool)
                  ?.  hide-completed
                    ~(tap in (~(root-harvest tav goals.pool)))
                  %-  ~(incomplete nod goals.pool)
                  ~(tap in (~(root-harvest tav goals.pool)))
                %-  goal-list:lego
                %+  turn
                  goals
                |=(=id:gol [id (~(got by goals.pool) id)])
          ==
        ==
      ==
    --
  --
::
++  pool-note-page
  |=  =pin:gol
  ^-  (page:rudder store:gol unver-action:gol)
  =/  pool  (~(got by pools) pin)
  |_  [=bowl:gall order:rudder store:gol]
  ++  argue
    |=  [headers=header-list:http body=(unit octs)]
    ^-  $@(brief:rudder unver-action:gol)
    =/  args=(map @t @t)  ?~(body ~ (frisk:rudder q.u.body))
    ?~  action=(~(get by args) 'action')  ~
    ?+    u.action  ~
        %edit-pool-note
      ?~  uowner=(~(get by args) 'owner')  ~
      ?~  owner=(slaw %p u.uowner)  ~
      ?~  ubirth=(~(get by args) 'birth')  ~
      ?~  birth=(slaw %da u.ubirth)  ~
      :*  %edit-pool-note
          [%pin u.owner u.birth]
          (~(gut by args) 'note' '')
      ==
    ==
  ++  final  (alert:rudder url.request build)
  ++  build
    |=  $:  arg=(list [k=@t v=@t])
            msg=(unit [o=? =@t])
        ==
    ^-  reply:rudder
    |^  [%page page]
    ++  style  (global-style '')
    ++  page
      ^-  manx
      ;hmtl
        ;head
          ;title:"%goals-test"
          ;meta(charset "utf-8");
          ;meta(name "viewport", content "width=device-width, initial-scale=1");
          ;style:"{(trip style)}"
          ;script(type "module", src "https://md-block.verou.me/md-block.js");
        ==
        ;body
          ;div
            ;table.main-table
              ;tr
                ;td
                  ;a(href (trip (pin-to-url:lego pin))): source pool
                ==
              ==
            ==
            ;h2: Ⓟ   {(trip title.pool)}
            ;+  note
          ==
        ==
      ==
    ++  note
      ^-  manx
      ;div
        ;div.text-div
          ;md-block: {(trip note.pool)}
        ==
        ;br;
        ;form.centered.label(method "post")
          ;textarea(type "text", name "note"): {(trip note.pool)}
          ;input(type "hidden", name "owner", value "{(scow %p owner.pin)}");
          ;input(type "hidden", name "birth", value "{(scow %da birth.pin)}");
          ;button.centered-button(type "submit", name "action", value "edit-pool-note"):"submit"
        ==
      ==
    --
  --
::
++  pool-page
  |=  =pin:gol
  =/  pool  (~(got by pools) pin)
  ^-  (page:rudder store:gol unver-action:gol)
  |_  [=bowl:gall order:rudder store:gol]
  ++  argue
    |=  [headers=header-list:http body=(unit octs)]
    ^-  $@(brief:rudder unver-action:gol)
    =/  args=(map @t @t)  ?~(body ~ (frisk:rudder q.u.body))
    ?~  action=(~(get by args) 'action')  ~
    ?+    u.action  ~
        %spawn-goal
      ?~  uowner=(~(get by args) 'owner')  ~
      ?~  owner=(slaw %p u.uowner)  ~
      ?~  ubirth=(~(get by args) 'birth')  ~
      ?~  birth=(slaw %da u.ubirth)  ~
      [%spawn-goal [%pin u.owner u.birth] ~ (~(gut by args) 'new-goal' '') %&]
      ::
        %cache-goal
      ?~  uowner=(~(get by args) 'owner')  ~
      ?~  owner=(slaw %p u.uowner)  ~
      ?~  ubirth=(~(get by args) 'birth')  ~
      ?~  birth=(slaw %da u.ubirth)  ~
      [%cache-goal [u.owner u.birth]]
    ==
  ++  final  (alert:rudder url.request build)
  ++  build
    |=  $:  arg=(list [k=@t v=@t])
            msg=(unit [o=? =@t])
        ==
    ^-  reply:rudder
    |^  [%page page]
    ++  style  (global-style '')
    ++  page
      ^-  manx
      ;hmtl
        ;head
          ;title:"%goals-test"
          ;meta(charset "utf-8");
          ;meta(name "viewport", content "width=device-width, initial-scale=1");
          ;style:"{(trip style)}"
        ==
        ;body
          ;div
            ;table.main-table.info
              ;tr
                ;td
                  ;table.main-table
                    ;tr
                      ;td
                        ;a/"index": all pools
                      ==
                    ==
                  ==
                ==
                ;td
                  ;table.main-table
                    ;tr
                      ;th: type
                      ;th: owner
                      ;th: role
                      ;th: perms
                      ;th: harvest
                    ==
                    ;tr
                      ;td: pool
                      ;td: {(scow %p owner.pool)}
                      ;td.centered: {(trip (our-pool-role:lego pin))}
                      ;td
                        ;a(href (weld (trip (pin-to-url:lego pin)) "-participants")): link
                      ==
                      ;td
                        ;a(href (weld (trip (pin-to-url:lego pin)) "-harvest")): link
                      ==
                    ==
                  ==
                ==
              ==
            ==
            ;h2: {(weld "Ⓟ  " (trip title.pool))}
            ;+  note
            ;table.main-table
              ;form(method "post")
                ;tr(style "font-weight: bold")
                  ;td:""
                  ;td:"new goal"
                ==
                ;tr
                  ;td
                    ;input(type "hidden", name "owner", value "{(scow %p owner.pin)}");
                    ;input(type "hidden", name "birth", value "{(scow %da birth.pin)}");
                    ;button(type "submit", name "action", value "spawn-goal"):"+"
                  ==
                  ;td
                    ;input.wide-input(type "text", name "new-goal", placeholder "new goal description");
                  ==
                ==
              ==
            ==
            ;h3: root goals
            ;*  =/  goals
                  ?.  hide-completed
                    (~(root-goals nod goals.pool))
                  %-  ~(incomplete nod goals.pool)
                  (~(root-goals nod goals.pool))
                %-  goal-list:lego
                %+  turn
                  goals
                |=(=id:gol [id (~(got by goals.pool) id)])
          ==
        ==
      ==
    ++  note
      ^-  manx
      ;div
        ;div.text-div
          ;md-block: {(trip note.pool)}
        ==
        ;br;
        ;p.centered
          ;a.centered(href (weld (trip (pin-to-url:lego pin)) "-note")): edit note
        ==
      ==
    --
  --
::
++  goal-participants
  |=  =id:gol
  =/  pin  (got:idx-orm:gol index id)
  =/  pool
    ?~  upool=(~(get by pools) pin)
      (~(got by cache) pin)
    u.upool
  =/  goal
    ?~  ugoal=(~(get by goals.pool) id)
      (~(got by cache.pool) id)
    u.ugoal
  ^-  (page:rudder store:gol unver-action:gol)
  |_  [=bowl:gall order:rudder store:gol]
  ++  argue
    |=  [headers=header-list:http body=(unit octs)]
    ^-  $@(brief:rudder unver-action:gol)
    =/  args=(map @t @t)  ?~(body ~ (frisk:rudder q.u.body))
    ?~  what=(~(get by args) 'what')  ~
    ?~  who=(slaw %p (~(gut by args) 'who' ''))  ~
    *unver-action:gol
  ++  final  (alert:rudder url.request build)
  ++  build
    |=  $:  arg=(list [k=@t v=@t])
            msg=(unit [o=? =@t])
        ==
    ^-  reply:rudder
    |^  [%page page]
    ++  goal-perms
      ^-  marl
      =/  info=(list [ship=ship role=term])
        %+  murn
          ~(tap by perms.pool)
        |=  [=ship role=(unit pool-role:gol)]
        =/  role  ?~(role %viewer u.role)
        ?.(=(role %admin) ~ (some [ship=ship role=%admin]))
      =.  info  [[owner.pool %owner] info]
      =|  =marl
      |-
      ?~  info
        ;+  ;table.main-table
          ;tr
            ;th: ship
            ;th: role
          ==
          ;*  marl
        ==
      %=  $
        info  t.info
        marl  %+  welp
                marl
              ;+  ;tr
                    ;td: {(scow %p ship.i.info)}
                    ;td: {(trip role.i.info)}
                  ==
      ==
    ++  style  (global-style '')
    ++  page
      ^-  manx
      ;hmtl
        ;head
          ;title:"%goals-test"
          ;meta(charset "utf-8");
          ;meta(name "viewport", content "width=device-width, initial-scale=1");
          ;style:"{(trip style)}"
        ==
        ;body
          ;div
            ;table.main-table
              ;tr
                ;td
                  :: eyre id overwrites goal id
                  ;a(href (trip (id-to-url:lego ^id))): source goal
                ==
              ==
            ==
            ;h3: goal participants
            ;*  goal-perms
          ==
        ==
      ==
    --
  --
::
++  pool-participants
  |=  =pin:gol
  =/  pool  (~(got by pools) pin)
  ^-  (page:rudder store:gol unver-action:gol)
  |_  [=bowl:gall order:rudder store:gol]
  ++  argue
    |=  [headers=header-list:http body=(unit octs)]
    ^-  $@(brief:rudder unver-action:gol)
    =/  args=(map @t @t)  ?~(body ~ (frisk:rudder q.u.body))
    ?~  what=(~(get by args) 'what')  ~
    ?~  who=(slaw %p (~(gut by args) 'who' ''))  ~
    *unver-action:gol
  ++  final  (alert:rudder url.request build)
  ++  build
    |=  $:  arg=(list [k=@t v=@t])
            msg=(unit [o=? =@t])
        ==
    ^-  reply:rudder
    |^  [%page page]
    ++  pool-perms
      ^-  marl
      =/  info=(list [ship=ship role=term])
        %+  turn
          ~(tap by perms.pool)
        |=  [=ship role=(unit pool-role:gol)]
        [ship=ship role=?~(role %viewer u.role)]
      =.  info  [[owner.pool %owner] info]
      =|  =marl
      |-
      ?~  info
        ;+  ;table.main-table
          ;tr
            ;th: ship
            ;th: role
          ==
          ;*  marl
        ==
      %=  $
        info  t.info
        marl  %+  welp
                marl
              ;+  ;tr
                    ;td: {(scow %p ship.i.info)}
                    ;td: {(trip role.i.info)}
                  ==
      ==
    ++  style  (global-style '')
    ++  page
      ^-  manx
      ;hmtl
        ;head
          ;title:"%goals-test"
          ;meta(charset "utf-8");
          ;meta(name "viewport", content "width=device-width, initial-scale=1");
          ;style:"{(trip style)}"
        ==
        ;body
          ;div
            ;table.main-table
              ;tr
                ;td
                  ;a/"index": all pools
                ==
                ;td
                  ;a(href (trip (pin-to-url:lego pin))): source pool
                ==
              ==
            ==
            ;h2: pool participants
            ;h3: {(trip title.pool)}
            ;*  pool-perms
          ==
        ==
      ==
    --
  --
::
++  index-page
  ^-  (page:rudder store:gol unver-action:gol)
  |_  [=bowl:gall order:rudder store:gol]
  ++  argue
    |=  [headers=header-list:http body=(unit octs)]
    ^-  $@(brief:rudder unver-action:gol)
    =/  args=(map @t @t)  ?~(body ~ (frisk:rudder q.u.body))
    ?~  action=(~(get by args) 'action')  ~
    ?+    u.action  ~
        %spawn-pool
      [%spawn-pool (~(gut by args) 'new-pool' '')]
        %clone-pool  ~
        %cache-pool
      ?~  uowner=(~(get by args) 'owner')  ~
      ?~  owner=(slaw %p u.uowner)  ~
      ?~  ubirth=(~(get by args) 'birth')  ~
      ?~  birth=(slaw %da u.ubirth)  ~
      [%cache-pool [%pin u.owner u.birth]]
    ==
  ++  final  (alert:rudder url.request build)
  ++  build
    |=  $:  arg=(list [k=@t v=@t])
            msg=(unit [o=? =@t])
        ==
    ^-  reply:rudder
    |^  [%page page]
    ++  style  (global-style '')
    ++  page
      ^-  manx
      ;hmtl
        ;head
          ;title:"%goals-test"
          ;meta(charset "utf-8");
          ;meta(name "viewport", content "width=device-width, initial-scale=1");
          ;style:"{(trip style)}"
        ==
        ;body
          ;div
            ;h2: all pools
            ;p
              ;a/"{(trip dap.bowl)}/all-pool-harvest": harvest
            ==
            ;table.main-table
              ;form(method "post")
                ;tr(style "font-weight: bold")
                  ;td:""
                  ;td:"new pool"
                ==
                ;tr
                  ;td
                    ;button(type "submit", name "action", value "spawn-pool"):"+"
                  ==
                  ;td
                    ;input.wide-input(type "text", name "new-pool", placeholder "new pool title");
                  ==
                ==
              ==
            ==
            ;*  pool-list
          ==
        ==
      ==
    ++  pool-list
      ^-  marl
      =/  pools  ~(tap by pools)
      =|  data-rows=marl
      |-
      |^
      ?~  pools
        ;+  ;table.main-table
              ;+  header-row
              ;*  (flop data-rows)
            ==
      %=  $
        pools  t.pools
        data-rows  [(data-row i.pools) data-rows]
      ==
      ++  header-row
        ^-  manx
        ;tr
          ;th: 
          ;th.widecol: title
          ;th: owner
          ;th: role
          ;th: perms
          ;th: 
        ==
      ++  data-row
        |=  [=pin:gol =pool:gol]
        |^
        ^-  manx
        =/  url  :(weld (trip dap.bowl) "/" (trip (pin-to-url:lego pin)))
        ;tr
          ;td
            ;+  shifters
          ==
          ;td.widecol
            ;a(href url): {(trip title.pool)}
          ==
          ;td: {(scow %p owner.pool)}
          ;td: {(trip (our-pool-role:lego pin))}
          ;td
            ;a(href (weld url "-participants")): link
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
            ==
          ==
        ++  action-buttons
          ^-  manx
          ;table
            ;tr
              ;td
                ;form.label(method "post")
                  ;input(type "hidden", name "owner", value "{(scow %p owner.pin)}");
                  ;input(type "hidden", name "birth", value "{(scow %da birth.pin)}");
                  ;button(type "submit", name "action", value "cache-pool"):"a"
                ==
              ==
              ;td
                ;form.label(method "post")
                  ;input(type "hidden", name "owner", value "{(scow %p owner.pin)}");
                  ;input(type "hidden", name "birth", value "{(scow %da birth.pin)}");
                  ;button(type "submit", name "action", value "clone-pool"):"c"
                ==
              ==
            ==
          ==
        --
      --
    --
  --
++  index-harvest-page
  ^-  (page:rudder store:gol unver-action:gol)
  |_  [=bowl:gall order:rudder store:gol]
  ++  argue
    |=  [headers=header-list:http body=(unit octs)]
    ^-  $@(brief:rudder unver-action:gol)
    =/  args=(map @t @t)  ?~(body ~ (frisk:rudder q.u.body))
    ?~  action=(~(get by args) 'action')  ~
    ?+    u.action  ~
        %edit-goal-note
      ?~  uowner=(~(get by args) 'owner')  ~
      ?~  owner=(slaw %p u.uowner)  ~
      ?~  ubirth=(~(get by args) 'birth')  ~
      ?~  birth=(slaw %da u.ubirth)  ~
      :*  %edit-goal-note
          [u.owner u.birth]
          (~(gut by args) 'note' '')
      ==
    ==
  ++  final  (alert:rudder url.request build)
  ++  build
    |=  $:  arg=(list [k=@t v=@t])
            msg=(unit [o=? =@t])
        ==
    ^-  reply:rudder
    |^  [%page page]
    ++  style  (global-style '')
    ++  page
      ^-  manx
      ;hmtl
        ;head
          ;title:"%goals-test"
          ;meta(charset "utf-8");
          ;meta(name "viewport", content "width=device-width, initial-scale=1");
          ;style:"{(trip style)}"
          ;script(type "module", src "https://md-block.verou.me/md-block.js");
        ==
        ;body
          ;div
            ;table.main-table
              ;tr
                ;td
                  ;a/"index": all pools
                ==
                ;*  %-  goal-list:lego
                    =/  pools
                      (turn ~(tap in pools) |=([pin:gol =pool:gol] pool))
                    =|  harv=(list [id:gol goal:gol])
                    |-
                    ?~  pools
                      harv
                    %=  $
                      pools  t.pools
                      harv
                        %+  weld
                          harv
                        %+  turn
                          %-  ~(actionable nod goals.i.pools)
                          ?.  hide-completed
                            ~(tap in (~(root-harvest tav goals.i.pools)))
                          %-  ~(incomplete nod goals.i.pools)
                          ~(tap in (~(root-harvest tav goals.i.pools)))
                        |=(=id:gol [id (~(got by goals.i.pools) id)])
                    ==
              ==
            ==
          ==
        ==
      ==
    --
  --
--
