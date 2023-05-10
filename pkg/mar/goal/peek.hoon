/-  *peek
/+  *gol-cli-json, v=gol-cli-view
|_  pyk=peek
++  grow
  |%
  ++  noun  pyk
  ++  json
    =,  enjs:format
    %.  pyk
    |=  pyk=peek
    ^-  ^json
    ?-  -.pyk
      %store  (frond %store (enjs-store store.pyk))
      %views  (frond %views (views:enjs:v views.pyk))
    ==
  --
++  grab
  |%
  ++  noun  peek
  --
++  grad  %noun
--
