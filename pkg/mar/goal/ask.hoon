/-  *views
/+  v=gol-cli-view
|_  =ask
++  grow
  |%
  ++  noun  ask
  --
++  grab
  |%
  ++  noun  ^ask
  ++  json
    =,  dejs:format
    |=  jon=json
    ~|  json-ask+(en-json:html jon)
    `^ask`[%.(jon (ot ~[pid+so pok+view-parm:dejs:v]))]
  --
++  grad  %noun
--
