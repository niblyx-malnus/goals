/-  *realm-goals
/+  *gol-cli-json
|%
++  enjs
  =,  enjs:format
  |%
  ++  enjs-pins
    |=  pins=(map space pin)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by pins)
    |=  [=space =pin]
    ^-  [@t json]
    :-  `@t`(rap 3 (scot %p -.space) '/' +.space ~)
    (enjs-pin pin)
  --
--
