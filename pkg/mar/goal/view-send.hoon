/-  *goal
/+  v=gol-cli-view
|_  =send:views
++  grow
  |%
  ++  noun  send
  ++  json
    =,  enjs:format
    %.  send
    |=  =send:views
    ^-  ^json
    ?:  ?=(%dot -.send)
      (frond %dot (path path.send))
    (view-diff:enjs:v ;;(diff:views send))
  --
++  grab
  |%
  ++  noun  send:views
  --
++  grad  %noun
--
