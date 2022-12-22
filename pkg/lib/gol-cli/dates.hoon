/-  *dates
/+  *gol-cli-util
|%
++  utc-offsets
  %-  ~(gas by *(map [@dr ?] @t))
  :~  [[~h12 %.n] '-12']
      [[~h11 %.n] '-11']
      [[~h10 %.n] '-10']
      [[~h9.m30 %.n] '-9:30']
      [[~h9 %.n] '-9']
      [[~h8 %.n] '-8']
      [[~h7 %.n] '-7']
      [[~h6 %.n] '-6']
      [[~h5 %.n] '-5']
      [[~h4 %.n] '-4']
      [[~h3.m30 %.n] '-3:30']
      [[~h3 %.n] '-3']
      [[~h2 %.n] '-2']
      [[~h1 %.n] '-1']
      [[~s0 %.y] '0']
      [[~h1 %.y] '+1']
      [[~h2 %.y] '+2']
      [[~h3 %.y] '+3']
      [[~h3.m30 %.y] '+3:30']
      [[~h4 %.y] '+4']
      [[~h4.m30 %.y] '+4:30']
      [[~h5 %.y] '+5']
      [[~h5.m30 %.y] '+5:30']
      [[~h5.m45 %.y] '+5:45']
      [[~h6 %.y] '+6']
      [[~h6.m30 %.y] '+6:30']
      [[~h7 %.y] '+7']
      [[~h8 %.y] '+8']
      [[~h8.m45 %.y] '+8:45']
      [[~h9 %.y] '+9']
      [[~h9.m30 %.y] '+9:30']
      [[~h10 %.y] '+10']
      [[~h10.m30 %.y] '+10:30']
      [[~h11 %.y] '+11']
      [[~h12 %.y] '+12']
      [[~h12.m45 %.y] '+12:45']
      [[~h13 %.y] '+13']
      [[~h14 %.y] '+14']
  ==
      
::
:: get the relative date based on 'today', 'tomorrow', 'yesterday', and
:: days of the week
++  rel-day
  |=  [date=@da day=?(@t [@t @t])]
  ^-  @da
  |^
  ?@  day
    ?:  =(day 'today')  date
    ?:  =(day 'tomorrow')  (add date ~d1)
    ?:  =(day 'yesterday')  (sub date ~d1)
    (soonday date day)
  ?:  =(-.day 'last')
    ?:  =((weekday date) +.day)
      (sub (soonday date +.day) ~d14)
    (sub (soonday date +.day) ~d7)
  ?:  =(-.day 'next')
    (add (soonday date +.day) ~d7)
  !!
  ::
  :: date of soonest ___day (weekday name, i.e. monday)
  ++  soonday  |=([date=@da day=@t] (add date (wkd-dist (weekday date) day)))
  --
::
:: given a date and a UTC-offset, convert from UTC time to local time
++  utc-to-local
  |=  [date=@da hours=@dr ahead=?]
  ^-  @da
  ?:  ahead
    (add date hours)
  (sub date hours)
::
:: given a date and a UTC-offset, convert from local time to utc time
++  local-to-utc
  |=  [date=@da hours=@dr ahead=?]
  ^-  @da
  ?:  ahead
    (sub date hours)
  (add date hours)
::
:: 
++  parse-deadline
  |=  [now=@da utc-offset=[@dr ?]]
  ;~  pose
    (cold ~ (jest '~'))
    ;~  plug
      (easy ~)
      ;~  pose
        (parse-mdy utc-offset)
        (parse-simple-day now utc-offset)
        (parse-from now utc-offset)
      ==
    ==
  ==
::
:: format a date as a readable text output
++  format-date
  |=  date=@da
  ^-  tape
  =/  d  (yore date)
  ;:  weld
    "{(trip (weekday date))} "
    "{(trip (scot %ud m.d))}"
    "-"
    "{(trip (scot %ud d.t.d))}"
    "-"
    "{(trip (scot %ud y.d))}"
    " at "
    "{(trip (scot %ud h.t.d))}:{(trip (scot %ud m.t.d))}"
  ==
::
:: format date unit
++  format-local-udate
  |=  [d=(unit @da) utc-offset=[@dr ?]]
  ?~(d "~" (format-local u.d utc-offset))
::
:: format real datetime as local datetime
++  format-local
  |=  [date=@da utc-offset=[@dr ?]]
  ^-  tape
  (format-date (utc-to-local date utc-offset))
::
:: format a date as a readable text output
++  simple-format-date
  |=  date=@da
  ^-  tape
  =/  d  (yore date)
  ;:  weld
    "{(zfill 2 (trip (scot %ud m.d)))}"
    "-"
    "{(zfill 2 (trip (scot %ud d.t.d)))}"
    "-"
    "{(slag 3 (trip (scot %ud y.d)))}"
  ==
::
:: format real datetime as local datetime
++  simple-format-local
  |=  [date=@da utc-offset=[@dr ?]]
  ^-  tape
  (simple-format-date (utc-to-local date utc-offset))
::
:: Go to end of the day
++  last-second
  |=  date=@da
  =/  date  (yore date)
  =/  date  (year [a.date y.date] m.date d.t.date 0 0 0 ~)
  `@da`(add date (sub ~d1 ~s1))
::
:: input: timezone and relative m, d, y, h, min
:: output: real datetime at this time in the timezone
++  convert-local-mdyhm
  |=  [utc-offset=[@dr ?] y=@ m=@ t=[d=@ h=@ m=@]]
  %+  local-to-utc
    (year [[%.y y] m d.t h.t m.t 0 ~])
  utc-offset
::
:: input: timezone and relative m, d, y
:: output: real datetime at the last second of the day in that timezone
++  convert-local-mdy
  |=  [utc-offset=[@dr ?] y=@ m=@ d=@]
  %+  local-to-utc
    (last-second (year [[%.y y] m d 0 0 0 ~]))
  utc-offset
::
:: convert real date to real date representing local time's last second
:: of "today"
++  convert-local-eod
  |=  [date=@da utc-offset=[@dr ?]]
  (local-to-utc (last-second (utc-to-local date utc-offset)) utc-offset)
::
:: Parse mm-dd-yyyy
++  parse-mdy
  |=  utc-offset=[@dr ?]
  %+  cook  |=([m=@ @ d=@ @ y=@] (convert-local-mdy utc-offset y m d))
  ;~(plug dem hep dem hep dem)
::
:: parse today, tomorrow, yesterday, weekdays, etc.
++  parse-simple-day
  |=  [now=@da utc-offset=[@dr ?]]
  %+  cook
    %+  corl
      (curr local-to-utc utc-offset)
    (cury rel-day (last-second (utc-to-local now utc-offset)))
  ;~  pose
    (jist (weld weekdays tty))
    %+  cook  |=([a=@ @ b=@t] ?~(a b [`@t`a b]))
    ;~  plug
      (opt (jist laxt))
      (cold ~ (opt ace))
      (jist weekdays)
    ==
  ==
::
:: parse "time from day" input
++  parse-from
  |=  [now=@da utc-offset=[@dr ?]]
  %+  cook  |=([num=@ kind=@ @ date=@da] `@da`(add date (mul kind num)))
  ;~  plug
    dem
    %+  cook  |=([@ a=@ @] a)
    ;~  plug
      ace
      (coji ~[[~d1 'day'] [~d7 'week']])
      (jost 's')
    ==
    (cold ~ ;~(plug ace (jest 'from') ace))
    ;~  pose
      (parse-simple-day now utc-offset)
      (parse-mdy utc-offset)
    ==
  ==
::
::
++  parse-utc-offsets
  ;~  pose
    (cold [~h12 %.n] (jest '-12'))
    (cold [~h11 %.n] (jest '-11'))
    (cold [~h10 %.n] (jest '-10'))
    (cold [~h9.m30 %.n] (jest '-9:30'))
    (cold [~h9 %.n] (jest '-9'))
    (cold [~h8 %.n] (jest '-8'))
    (cold [~h7 %.n] (jest '-7'))
    (cold [~h6 %.n] (jest '-6'))
    (cold [~h5 %.n] (jest '-5'))
    (cold [~h4 %.n] (jest '-4'))
    (cold [~h3.m30 %.n] (jest '-3:30'))
    (cold [~h3 %.n] (jest '-3'))
    (cold [~h2 %.n] (jest '-2'))
    (cold [~h1 %.n] (jest '-1'))
    (cold [~s0 %.y] (jest '0'))
    (cold [~h1 %.y] (jest '+1'))
    (cold [~h2 %.y] (jest '+2'))
    (cold [~h3 %.y] (jest '+3'))
    (cold [~h3.m30 %.y] (jest '+3:30'))
    (cold [~h4 %.y] (jest '+4'))
    (cold [~h4.m30 %.y] (jest '+4:30'))
    (cold [~h5 %.y] (jest '+5'))
    (cold [~h5.m30 %.y] (jest '+5:30'))
    (cold [~h5.m45 %.y] (jest '+5:45'))
    (cold [~h6 %.y] (jest '+6'))
    (cold [~h6.m30 %.y] (jest '+6:30'))
    (cold [~h7 %.y] (jest '+7'))
    (cold [~h8 %.y] (jest '+8'))
    (cold [~h8.m45 %.y] (jest '+8:45'))
    (cold [~h9 %.y] (jest '+9'))
    (cold [~h9.m30 %.y] (jest '+9:30'))
    (cold [~h10 %.y] (jest '+10'))
    (cold [~h10.m30 %.y] (jest '+10:30'))
    (cold [~h11 %.y] (jest '+11'))
    (cold [~h12 %.y] (jest '+12'))
    (cold [~h12.m45 %.y] (jest '+12:45'))
    (cold [~h13 %.y] (jest '+13'))
    (cold [~h14 %.y] (jest '+14'))
  ==
::
:: date to weekday
++  weekday
  |=  d=@da
  (snag (div (mod (sub d (add ~d2 *@da)) ~d7) ~d1) weekdays)
::
:: days between two weekdays
++  wkd-dist
  |=  [n=@t d=@t]
  =/  n  (~(got by wkd-map) n)
  =/  d  (~(got by wkd-map) d)
  =/  dist
    %+  mul  ~d1
    ?:  (lth n d)
      (sub d n)
    (sub 7 (sub n d))
  ?:  =(~d0 dist)  ~d7  dist
::
:: list of weekdays
++  weekdays
  ^-  (list @t)
  :~  'monday'
      'tuesday'
      'wednesday'
      'thursday'
      'friday'
      'saturday'
      'sunday'
  ==
::
:: map from weekday to num
++  wkd-map
  %-  ~(gas by *(map @t @))
  :~  ['monday' 0]
      ['tuesday' 1]
      ['wednesday' 2]
      ['thursday' 3]
      ['friday' 4]
      ['saturday' 5]
      ['sunday' 6]
  ==
::
:: today, tomorrow, yesterday
++  tty  ~['today' 'tomorrow' 'yesterday']
::
:: last, next
++  laxt  ~['last' 'next']
--
