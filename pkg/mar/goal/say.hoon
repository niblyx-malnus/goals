/-  *views
/+  v=gol-cli-view
|_  =say
++  grow
  |%
  ++  noun  say
  ++  json
    =,  enjs:format
    %.  say
    |=  =^say
    ^-  ^json
    %+  frond  -.data.say
    %-  pairs
    :~  [%path (path path.say)]
        [%data (view-data:enjs:v data.say)]
    ==
  --
++  grab
  |%
  ++  noun  ^say
  --
++  grad  %noun
--
