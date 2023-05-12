/-  *views
/+  v=gol-cli-view
|_  =send
++  grow
  |%
  ++  noun  send
  ++  json
    =,  enjs:format
    %.  send
    |=  =^send
    ^-  ^json
    ?-  -.send
      %dot   (frond %dot (path path.send))
      %diff  (view-diff:enjs:v +.send)
    ==
  --
++  grab
  |%
  ++  noun  ^send
  --
++  grad  %noun
--
