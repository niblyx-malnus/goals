/+  realm=realm
|_  =config:realm
++  grow
  |%
  ++  mime  
    ^-  ^mime
    [/text/x-config (as-octt:mimes:html (spit-config:mime:realm config))]
  ++  noun  config
  ++  json  (config:enjs:realm config)
  --
++  grab
  |%
  ::
  ++  mime
    |=  [=mite len=@ud tex=@]
    ^-  config:realm
    %-  need
    %-  from-clauses:mime:realm
::    =/  tex  '""'
    !<((list clause:realm) (slap !>(~) (ream tex)))

  ::
  ++  noun  config:realm
  --
++  grad  %noun
--

