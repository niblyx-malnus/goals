/-  gol=goal
|%
::
+$  getter  $-(goal:gol (set id:gol))
+$  setter  $-(goal:gol goal:gol)
::
:: getters for different sets
::
++  kids  `getter`|=(=goal:gol kids.goal)
++  parr  `getter`|=(=goal:gol ?~(par.goal ~ (~(put in *(set id:gol)) u.par.goal)))
++  nefs  `getter`|=(=goal:gol nefs.goal)
++  uncs  `getter`|=(=goal:gol uncs.goal)
++  befs  `getter`|=(=goal:gol befs.goal)
++  afts  `getter`|=(=goal:gol afts.goal)
++  moar  `getter`|=(=goal:gol moar.goal)
++  less  `getter`|=(=goal:gol less.goal)
::
:: getters for composite sets
::
:: goals immediately nest-left of this goal
++  yung  |=(=goal:gol `(set id:gol)`(~(uni in kids.goal) nefs.goal))
::
:: goals immediately nest-ryte of this goal
++  olds  |=(=goal:gol `(set id:gol)`(~(uni in (parr goal)) nefs.goal))
::
:: goals immediately prec-left of this goal (think "precedents")
++  prec  |=(=goal:gol `(set id:gol)`(~(uni in (yung goal)) befs.goal))
::
:: goals immediately prec-ryte of this goal (think "successsors")
++  succ  |=(=goal:gol `(set id:gol)`(~(uni in (olds goal)) afts.goal))
::
:: goals immediately prio-left of this goal (think "prioritized")
++  prio  |=(=goal:gol `(set id:gol)`(~(uni in (prec goal)) moar.goal))
::
:: goals immediately prio-ryte of this goal (think "demoted")
++  demo  |=(=goal:gol `(set id:gol)`(~(uni in (succ goal)) less.goal))
::
:: setters for different sets
::
++  put-kids
  |=  =id:gol
  |=(=goal:gol goal(kids (~(put in kids.goal) id)))
::
++  del-kids
  |=  =id:gol
  |=(=goal:gol goal(kids (~(del in kids.goal) id)))
::
++  put-par
  |=  id=(unit id:gol)
  |=(=goal:gol goal(par id))
::
++  del-par
  |=  id=(unit id:gol)
  |=  =goal:gol
  ?:  =(par.goal id)  goal(par ~)  goal
::
++  put-nefs
  |=  =id:gol
  |=(=goal:gol goal(nefs (~(put in nefs.goal) id)))
::
++  del-nefs
  |=  =id:gol
  |=(=goal:gol goal(nefs (~(del in nefs.goal) id)))
::
++  put-uncs
  |=  =id:gol
  |=(=goal:gol goal(uncs (~(put in uncs.goal) id)))
::
++  del-uncs
  |=  =id:gol
  |=(=goal:gol goal(uncs (~(del in uncs.goal) id)))
::
++  put-befs
  |=  =id:gol
  |=(=goal:gol goal(befs (~(put in befs.goal) id)))
::
++  del-befs
  |=  =id:gol
  |=(=goal:gol goal(befs (~(del in befs.goal) id)))
::
++  put-afts
  |=  =id:gol
  |=(=goal:gol goal(afts (~(put in afts.goal) id)))
::
++  del-afts
  |=  =id:gol
  |=(=goal:gol goal(afts (~(del in afts.goal) id)))
::
++  put-moar
  |=  =id:gol
  |=(=goal:gol goal(moar (~(put in moar.goal) id)))
::
++  del-moar
  |=  =id:gol
  |=(=goal:gol goal(moar (~(del in moar.goal) id)))
::
++  put-less
  |=  =id:gol
  |=(=goal:gol goal(less (~(put in less.goal) id)))
::
++  del-less
  |=  =id:gol
  |=(=goal:gol goal(less (~(del in less.goal) id)))
--
