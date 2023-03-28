|%
::
::  $clause: A key and value, as part of a config
::
::    Only used to parse $config
::
+$  clause
  $%  [%size size=[@ud @ud]]
      [%titlebar-border titlebar-border=?]
      [%show-titlebar show-titlebar=?]
  ==
::
+$  config
  $:  size=[@ud @ud]     ::  (width, height) normalized to 1 - 10 units
      titlebar-border=?  ::  should the bottom border show in the titlebar
      show-titlebar=?    ::  tells realm to not render the titlebar (except the buttons)
  ==
--

