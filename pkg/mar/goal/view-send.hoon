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
    ?:  ?=(%dot -.send)
      (frond %dot (path path.send))
    (view-diff:enjs:v ;;(diff:views send))
  --
++  grab
  |%
  ++  noun  ^send
  --
++  grad  %noun
--
