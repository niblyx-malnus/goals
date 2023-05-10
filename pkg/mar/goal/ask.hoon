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
    ^-  ^ask
    %.  jon
    %-  ot
    =-  ~[pid+so pok+-]
    %-  of
    :~  [%init (ot ~[parm+view-parm:dejs:v])]
        [%step (ot ~[path+pa parm+view-parm:dejs:v])]
    ==
  --
++  grad  %noun
--
