/-  *realm-goals
/+  *gol-cli-json
|%
++  enjs
  =,  enjs:format
  |%
  ++  enjs-space-pools
    |=  sp=(map space pool)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by sp)
    |=  [=space =pool]
    ^-  [@t json]
    :-  `@t`(rap 3 (scot %p -.space) '/' +.space ~)
    (enjs-pool:enjs pool)
  --
--
