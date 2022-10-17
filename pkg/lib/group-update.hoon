/-  *group, *resource, *group-store
|_  [=groups our=ship]
++  group-update
  |=  =update
  ^-  ^groups
  |^
  ?-  -.update
      %add-group       (add-group +.update)
      %add-members     (add-members +.update)
      %remove-members  (remove-members +.update)
      %add-tag         (add-tag +.update)
      %remove-tag      (remove-tag +.update)
      %change-policy   (change-policy +.update)
      %remove-group    (remove-group +.update)
      %expose          (expose +.update)
      %initial-group   (initial-group +.update)
      %initial         +.update
  ==
  ::  +expose: unset .hidden flag
  ::
  ++  expose
    |=  [rid=resource ~]
    ^-  ^groups
    =/  =group
      (~(got by groups) rid)
    =.  hidden.group  %.n
    (~(put by groups) rid group)
  ::  +add-group: add group to store
  ::
  ::    no-op if group already exists
  ::
  ++  add-group
    |=  [rid=resource =policy hidden=?]
    ^-  ^groups
    ?<  (~(has by groups) rid)
    =|  =group
    =.  policy.group   policy
    =.  hidden.group   hidden
    =.  tags.group
      (~(put ju tags.group) %admin our)
    (~(put by groups) rid group)
  ::  +add-members: add members to group
  ::
  ++  add-members
    |=  [rid=resource new-ships=(set ship)]
    ^-  ^groups
    %+  ~(jab by groups)  rid
    |=  group
    %=  +<
      members  (~(uni in members) new-ships)
    ::
        policy
      ?.  ?=(%invite -.policy)
        policy
      policy(pending (~(dif in pending.policy) new-ships))
    ==
  ::  +remove-members: remove members from group
  ::
  ::    no-op if group does not exist
  ::
  ::
  ++  remove-members
    |=  [rid=resource ships=(set ship)]
    ^-  ^groups
    ?.  (~(has by groups) rid)  groups
    %+  ~(jab by groups)  rid
    |=  group
    %=  +<
      members  (~(dif in members) ships)
      tags  (remove-tags +< ships)
    ==
  ::  +add-tag: add tag to ships
  ::
  ::    crash if ships are not in group
  ::
  ++  add-tag
    |=  [rid=resource =tag ships=(set ship)]
    ^-  ^groups
    %+  ~(jab by groups)  rid
    |=  group
    ?>  ?=(~ (~(dif in ships) members))
    +<(tags (merge-tags tags ships (sy tag ~)))
  ::  +remove-tag: remove tag from ships
  ::
  ::    crash if ships are not in group or tag does not exist
  ::
  ++  remove-tag
    |=  [rid=resource =tag ships=(set ship)]
    ^-  ^groups
    %+  ~(jab by groups)  rid
    |=  group
    ?>  ?&  ?=(~ (~(dif in ships) members))
            (~(has by tags) tag)
        ==
    %=  +<
      tags  (dif-ju tags tag ships)
    ==
  ::  initial-group: initialize foreign group
  ::
  ++  initial-group
    |=  [rid=resource =group]
    ^-  ^groups
    (~(put by groups) rid group)
  ::  +change-policy: modify group access control
  ::
  ::    If the change will kick members, then send a separate
  ::    %remove-members diff after the %change-policy diff
  ++  change-policy
    |=  [rid=resource =diff:policy]
    ^-  ^groups
    ?.  (~(has by groups) rid)
      groups
    =/  =group
      (~(got by groups) rid)
    |^
    =.  group
      ?-  -.diff
        %open     (open +.diff)
        %invite   (invite +.diff)
        %replace  (replace +.diff)
      ==
    (~(put by groups) rid group)
    ::
    ++  open
      |=  =diff:open:policy
      ?-  -.diff
        %allow-ranks     (allow-ranks +.diff)
        %ban-ranks       (ban-ranks +.diff)
        %allow-ships     (allow-ships +.diff)
        %ban-ships       (ban-ships +.diff)
      ==
    ::
    ++  invite
      |=  =diff:invite:policy
      ?-  -.diff
        %add-invites     (add-invites +.diff)
        %remove-invites  (remove-invites +.diff)
      ==
    ::
    ++  allow-ranks
      |=  ranks=(set rank:title)
      ^-  _group
      ?>  ?=(%open -.policy.group)
      group(ban-ranks.policy (~(dif in ban-ranks.policy.group) ranks))
    ::
    ++  ban-ranks
      |=  ranks=(set rank:title)
      ^-  _group
      ?>  ?=(%open -.policy.group)
      group(ban-ranks.policy (~(uni in ban-ranks.policy.group) ranks))
    ::
    ++  allow-ships
      |=  ships=(set ship)
      ^-  _group
      ?>  ?=(%open -.policy.group)
      group(banned.policy (~(dif in banned.policy.group) ships))
    ::
    ++  ban-ships
      |=  ships=(set ship)
      ^-  _group
      ?>  ?=(%open -.policy.group)
      =.  banned.policy.group
        (~(uni in banned.policy.group) ships)
      =/  to-remove=(set ship)
        (~(int in members.group) banned.policy.group)
      %=  group
        members  (~(dif in members.group) to-remove)
        tags  (remove-tags group to-remove)
      ==
    ::
    ++  add-invites
      |=  ships=(set ship)
      ^-  _group
      ?>  ?=(%invite -.policy.group)
      group(pending.policy (~(uni in pending.policy.group) ships))
    ::
    ++  remove-invites
      |=  ships=(set ship)
      ^-  _group
      ?>  ?=(%invite -.policy.group)
      group(pending.policy (~(dif in pending.policy.group) ships))
    ::
    ++  replace
      |=  =policy
      ^-  _group
      group(policy policy)
    --
  ::  +remove-group: remove group from store
  ::
  ::    no-op if group does not exist
  ++  remove-group
    |=  [rid=resource ~]
    ^-  ^groups
    ?.  (~(has by groups) rid)
      groups
    (~(del by groups) rid)
  --
++  dif-ju
  |=  [=tags =tag remove=(set ship)]
  =/  ships  ~(tap in remove)
  |-
  ?~  ships
    tags
  $(tags (~(del ju tags) tag i.ships), ships t.ships)
::
++  merge-tags
  |=  [=tags ships=(set ship) new-tags=(set tag)]
  ^+  tags
  =/  tags-list  ~(tap in new-tags)
  |-
  ?~  tags-list
    tags
  =*  tag  i.tags-list
  =/  old-ships=(set ship)
    (~(gut by tags) tag ~)
  %=    $
    tags-list  t.tags-list
  ::
      tags
    %+  ~(put by tags)
      tag
    (~(uni in old-ships) ships)
 ==
++  remove-tags
  |=  [=group ships=(set ship)]
  ^-  tags
  %-  malt
  %+  turn
    ~(tap by tags.group)
  |=  [=tag tagged=(set ship)]
  :-  tag
  (~(dif in tagged) ships)
--
