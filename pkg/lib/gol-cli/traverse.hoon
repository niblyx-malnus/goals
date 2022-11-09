/-  gol=goal
/+  *gol-cli-util, gol-cli-node
|_  =goals:gol
+*  nd  ~(. gol-cli-node goals)
::
++  iflo  iflo:nd
++  oflo  oflo:nd
::
:: "engine" used to perform different kinds
:: of graph traversals using the traverse function
++  gine
  |*  [nod=mold med=mold fin=mold]
  :*  flow=|~(nod *(list nod))
      init=|~(nod *med)
      stop=|~([nod med] `?`%.n)
      meld=|~([nod neb=nod old=med new=med] new)
      land=|~([nod =med ?] med)
      exit=|~([nod vis=(map nod med)] `fin`!!)
      prnt=|~(nod *tape) :: for debugging cycles
  ==
::
:: set defaults for gine where output mold is same
:: as transition mold
++  ginn
  |*  [nod=mold med=mold]
  =/  gine  (gine nod med med)
  gine(exit |~([=nod vis=(map nod med)] (~(got by vis) nod)))
::
:: print nodes for debugging cycles
++  print-id  |=(=id:gol (trip desc:(~(got by goals) id)))
++  print-nid  |=(=nid:gol `tape`(weld (trip `@t`-.nid) (print-id id.nid)))
::
:: traverse the underlying DAG (directed acyclic graph)
++  traverse
  |*  [nod=mold med=mold fin=mold]
  :: 
  :: takes an "engine" and a map of already visited nodes and values
  |=  [_(gine nod med fin) vis=(map nod med)]
  ::
  :: initialize path to catch cycles
  =|  pat=(list nod)
  ::
  :: accept single node id
  |=  =nod
  ::
  :: final transformation
  ^-  fin  %+  exit  nod
  |-
  ^-  (map ^nod med)
  ::
  :: catch cycles
  =/  i  (find [nod]~ pat) 
  =/  cyc=(list ^nod)  ?~(i ~ [nod (scag +(u.i) pat)])
  ?.  =(0 (lent cyc))  ~|(["cycle" (turn cyc prnt)] !!)
  ::
  :: iterate through neighbors (flo)
  =/  idx  0
  =/  flo  (flow nod)
  ::
  :: initialize output
  =/  med  (init nod)
  |-
  :: 
  :: stop when neighbors exhausted or stop condition met
  =/  cnd  (stop nod med)
  ?:  ?|  cnd
          =(idx (lent flo))
      ==
    ::
    :: output according to land function
    (~(put by vis) nod (land nod med cnd))
  ::
  =/  neb  (snag idx flo)
  ::
  :: make sure visited reflects output of next neighbor
  =.  vis
    ?:  (~(has by vis) neb)
      vis :: if already in visited, use stored output
    ::
    :: recursively compute output for next neighbor
    %=  ^$
      nod  neb
      pat  [nod pat]
      vis  vis :: this has been updated by inner trap
    ==
  ::
  :: update the output and go to the next neighbor
  %=  $
    idx  +(idx)
    ::
    :: meld the running output with the new output
    med  (meld nod neb med (~(got by vis) neb))
  ==
::
:: chain multiple traversals together, sharing visited map
++  chain
  |*  [nod=mold med=mold]
  |=  $:  trav=$-([nod (map nod med)] (map nod med))
          nodes=(list nod)
          vis=(map nod med)
      ==
  ^-  (map nod med)
  ?~  nodes
    vis
  %=  $
    nodes  t.nodes
    vis  (trav i.nodes vis)
  ==
::
:: check if there is a path from src to dst
++  check-path
  |=  [src=nid:gol dst=nid:gol dir=?(%l %r)]
  ^-  ?
  ?<  =(src dst)
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  ginn  (ginn nid:gol ?)
  =.  ginn
    %=  ginn
      flow  |=(=nid:gol ~(tap in (flo nid)))  :: inflow or outflow
      init  |=(=nid:gol (~(has in (flo nid)) dst))  :: check for dst
      stop  |=([nid:gol out=?] out)  :: stop on true
      meld  |=([nid:gol nid:gol a=? b=?] |(a b))
      prnt  print-nid
    ==
  (((traverse nid:gol ? ?) ginn ~) src)
::
:: if output is ~, cannot reach dst from source in this direction
:: if output is [~ ~], no legal cut exists between src and dst
:: if output is [~ non-empty-set-of-ids], this is the legal cut between
::   src and dst which is nearest to src
++  first-legal-cut
  |=  legal=$-(edge:gol ?)
  |=  [src=nid:gol dst=nid:gol dir=?(%l %r)]
  ^-  (unit edges:gol)
  ?<  =(src dst)
  =/  flo  ?-(dir %l iflo, %r oflo)
  :: 
  :: swap order according to traversal direction
  =/  pear  |*([a=* b=*] `(pair _a _a)`?-(dir %l [b a], %r [a b]))
  :: might not exist
  :: first get a full visited map of all the paths from src to dst
  :: get all 
  =/  ginn  (ginn nid:gol (unit edges:gol))
  =.  ginn
    %=  ginn
      flow  |=(=nid:gol ~(tap in (flo nid)))  :: inflow or outflow
      init
        |=  =nid:gol
        ?.  (~(has in (flo nid)) dst)
          ::
          :: if dst not in flo, initialize to ~
          :: signifying no path found (yet) from nod to dst
          ~
        ?.  (legal (pear nid dst))
          ::
          :: if has dst in flo but can't legal cut, returns [~ ~]
          :: which signifies a path to dst, but no legal cut
          (some ~)
        ::
        :: if has dst in flo and can legally cut, return legal cut
        :: as cut set
        (some (~(put in *edges:gol) (pear nid dst)))
      ::
      stop  |=([nid:gol out=(unit edges:gol)] =([~ ~] out))
      meld
        |=  $:  nod=nid:gol  neb=nid:gol
                a=(unit (set (pair nid:gol nid:gol)))
                b=(unit (set (pair nid:gol nid:gol)))
            ==
        :: if neb returns ~, ignore it
        ?~  b
          a
        :: if can make legal cut between nod and neb,
        :: put nod / neb cut with existing cuts instead of u.b.
        :: the nearest-to-nod legal cut between nod and dst
        :: passing through neb is given by nod / neb
        ?:  (legal (pear nod neb))
          ?~  a
            (some (~(put in *edges:gol) (pear nod neb)))
          (some (~(put in u.a) (pear nod neb)))
        :: if u.b is ~ and we cannot make a legal cut nod / neb,
        :: return [~ ~]; there are no legal cuts between nod and dst
        ?:  =(~ u.b)
          (some ~)
        :: if u.b is non-empty and we cannot make legal cut nod / neb,
        :: add u.b to existing edges
        :: the nearest-to-nod legal cut between nod and dst
        :: passing through neb is given in u.b
        ?~  a
          (some (~(uni in *edges:gol) u.b))
        (some (~(uni in u.a) u.b))
      ::
      prnt  print-nid
    ==
  (((traverse nid:gol (unit edges:gol) (unit edges:gol)) ginn ~) src)
::
:: set of neighbors on path from src to dst
++  step-stones
  |=  [src=nid:gol dst=nid:gol dir=?(%l %r)]
  ^-  (set nid:gol)
  ?<  =(src dst)
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  gine  (gine nid:gol ? (set nid:gol))
  =.  gine
    %=  gine
      flow  |=(=nid:gol ~(tap in (flo nid)))
      init  |=(=nid:gol (~(has in (flo nid)) dst)) :: check for dst
      ::
      :: never stop for immediate neighbors of src
      stop  |=([=nid:gol out=?] ?:(=(nid src) %.n out))
      meld  |=([nid:gol nid:gol a=? b=?] |(a b))
      ::
      :: get neighbors which return true (have path to dst)
      exit
        |=  [=nid:gol vis=(map nid:gol ?)]
        %-  ~(gas in *(set nid:gol))
        %+  murn
          ~(tap in (flo nid))
        |=  =nid:gol
        ?:  (~(got by vis) nid)
          ~
        (some nid)
    ==
  (((traverse nid:gol ? (set nid:gol)) gine ~) src)
::
++  done  |=(=id:gol complete:(~(got by goals) id))
++  nond  |=(=id:gol !complete:(~(got by goals) id))
::
:: for use with %[un]mark-complete
:: check if there are any uncompleted goals to the left OR
:: check if there are any completed goals to the right
++  get-plete
  |=  dir=?(%l %r)
  |=  =id:gol
  ^-  ?
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  pyt  ?-(dir %l nond, %r done)
  =/  ginn  (ginn nid:gol ?)
  =.  ginn
    %=  ginn
      flow  |=(=nid:gol ~(tap in (flo nid)))
      ::
      :: check deadline completion in the flo
      init  |=(=nid:gol &(=(-.nid %d) !=(id id.nid) (pyt id.nid)))
      stop  |=([nid:gol out=?] out)  :: stop on true
      meld  |=([nid:gol nid:gol a=? b=?] |(a b))
    ==
  (((traverse nid:gol ? ?) ginn ~) [%d id]) :: start at deadline
::
++  ryte-completed    (get-plete %r)
++  left-uncompleted  (get-plete %l)
::
:: check entire preceding graph for incorrect completion order
++  check-plete-mismatch
  |=  [=id:gol dir=?(%l %r)]
  ^-  ?
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  pyt  ?-(dir %l nond, %r done)
  =/  gine  (gine nid:gol (unit ?) ?)
  =.  gine
    %=  gine
      flow  |=(=nid:gol ~(tap in (flo nid)))
      init  |=(nid:gol (some %.n))
      stop  |=([nid:gol out=(unit ?)] =(~ out))
      meld  
        |=  [nid:gol nid:gol a=(unit ?) b=(unit ?)]
        ?~  a  ~
        ?~  b  ~
        (some |(u.a u.b))
      land
        |=  [=nid:gol out=(unit ?) ?]
        ?~  out  ~
        ?:  =(%k -.nid)
          out
        ?:  (pyt id.nid) :: %l: if I am incomplete
          (some %.y) :: %l: return that there is left-incomplete
        ?:  u.out :: %l: if I am complete and there is left-incomplete
          ~ :: fail
        (some %.n) :: %l: else return that there is no left-incomplete
      exit
        |=  [=nid:gol vis=(map nid:gol (unit ?))]
        =(~ (~(got by vis) nid)) :: if the output is null, yes, plete mismatch
    ==
  (((traverse nid:gol (unit ?) ?) gine ~) [%d id]) :: start at deadline
::
:: get uncompleted leaf goals left of id
++  harvest
  |=  =id:gol
  ^-  (set id:gol)
  =/  ginn  (ginn nid:gol (set id:gol))
  =.  ginn
    %=  ginn
      ::
      :: incomplete inflow
      flow
        |=  =nid:gol
        %+  murn
          ~(tap in (iflo nid))
        |=  =nid:gol
        ?:  complete:(~(got by goals) id.nid)
          ~
        (some nid)
      ::
      meld  |=([nid:gol nid:gol a=(set id:gol) b=(set id:gol)] (~(uni in a) b))
      ::
      :: harvest
      land
        |=  [=nid:gol out=(set id:gol) ?]
        ::
        :: a completed goal has no harvest
        ?:  complete:(~(got by goals) id.nid)
          ~
        ::
        :: in general, the harvest of a node is the union of the
        ::   harvests of its immediate inflow
        :: a deadline with an otherwise empty harvest
        ::   returns itself as its own harvest
        ?:  &(=(~ out) =(%d -.nid))
          (~(put in *(set id:gol)) id.nid)
        out
    ==
  ::
  :: work backwards from deadline
  (((traverse nid:gol (set id:gol) (set id:gol)) ginn ~) [%d id])
::
:: harvest with full goals
++  full-harvest
  |=  =id:gol
  ^-  goals:gol
  (gat-by goals (hi-to-lo ~(tap in (harvest id))))
::
:: get priority of a given goal - highest priority is 0
:: priority is the number of unique goals which must be started
:: before the given goal is started
++  priority
  |=  =id:gol
  ^-  @
  =/  gine  (gine nid:gol (set id:gol) @)
  =.  gine
    %=  gine
      flow  |=(=nid:gol ~(tap in (iflo nid)))  :: inflow
      ::
      :: all inflows
      init
        |=  =nid:gol
        %-  ~(gas in *(set id:gol))
        %+  turn
          ~(tap in (iflo nid))
        |=(=nid:gol id.nid)
      ::
      meld  |=([nid:gol nid:gol a=(set id:gol) b=(set id:gol)] (~(uni in a) b))
      exit
        |=  [=nid:gol vis=(map nid:gol (set id:gol))]
        ~(wyt in (~(got by vis) nid))  :: get count of priors
    ==
  ::
  :: work backwards from kickoff
  (((traverse nid:gol (set id:gol) @) gine ~) [%k id])
::
:: highest to lowest priority (highest being smallest number)
++  hi-to-lo
  |=  lst=(list id:gol)
  %+  sort  lst
  |=  [a=id:gol b=id:gol]
  (lth (priority a) (priority b))
::
++  get-bounds
  |=  dir=?(%l %r)
  |=  [=nid:gol vis=(map nid:gol moment:gol)]
  ^-  (map nid:gol moment:gol)
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  cmp  ?-(dir %l gth, %r lth)
  =/  gine  (gine nid:gol moment:gol (map nid:gol moment:gol))
  =.  gine
    %=  gine
      init  |=(=nid:gol ~)
      flow  |=(=nid:gol ~(tap in (flo nid)))
      meld 
        |=  [nid:gol neb=nid:gol a=moment:gol b=moment:gol]
        =/  nem  moment:(got-node:nd neb)
        =/  n
          ?~  b  nem
          ?~  nem  b
          ?.((cmp u.b u.nem) nem ~|("bound-mismatch" !!))
        ?~  a  n
        ?~  n  a
        ?:((cmp u.a u.n) a n)
      ::
      exit  |=([=nid:gol vis=(map nid:gol moment:gol)] vis)
    ==
  (((traverse nid:gol moment:gol (map nid:gol moment:gol)) gine vis) nid)
::
:: check entire preceding graph for incorrect moment order
++  check-bound-mismatch
  |=  [=nid:gol dir=?(%l %r)]
  ^-  ?
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  tem  ?-(dir %l max, %r min)  :: extremum
  =/  gine  (gine nid:gol (unit moment:gol) ?)
  =.  gine
    %=  gine
      flow  |=(=nid:gol ~(tap in (flo nid)))
      init  |=(=nid:gol (some ~))
      stop  |=([nid:gol out=(unit moment:gol)] =(~ out))  :: stop if null
      meld
        |=  [nid:gol nid:gol out=(unit moment:gol) new=(unit moment:gol)]
        :: 
        :: if out or new has failed, return failure
        ?~  out  ~
        ?~  new  ~
        ::
        :: if either moment of out or new is null, return the other
        ?~  u.out  new
        ?~  u.new  out
        ::
        :: else return the extremum
        (some (some (tem u.u.out u.u.new)))
      ::
      land
        |=  [nid:gol out=(unit moment:gol) ?]
        ::
        :: if out has failed, return failure
        ?~  out  ~
        ::
        =/  mot  moment:(got-node:nd nid)
        ?~  mot  out :: if moment is null, pass along bound
        ?~  u.out  (some mot)
        =/  tem  (tem u.mot u.u.out)
        ?.  =(u.mot tem)
          ~ :: if moment is not extremum, fail (return null)
        (some (some tem)) :: else return new bound
      ::
      exit
        |=  [=nid:gol vis=(map nid:gol (unit moment:gol))]
        =(~ (~(got by vis) nid)) :: if the output is null, yes, bound mismatch
    ==
  (((traverse nid:gol (unit moment:gol) ?) gine ~) nid) :: start at deadline
::
:: length of longest path to root or leaf
++  plomb
  |=  dir=?(%l %r)
  |=  [=nid:gol vis=(map nid:gol @)]
  ^-  (map nid:gol @)
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  gine  (gine nid:gol @ (map nid:gol @))
  =.  gine
    %=  gine
      flow  |=(=nid:gol ~(tap in (flo nid)))
      meld  |=([nid:gol nid:gol a=@ b=@] (max a b))
      land  |=([nid:gol out=@ ?] +(out))
      exit  |=([=nid:gol vis=(map nid:gol @)] vis)
    ==
  (((traverse nid:gol @ (map nid:gol @)) gine vis) nid)
::
:: get depth of a given goal (lowest level is depth of 1)
:: this is mostly for printing accurate level information in the CLI
++  plumb
  |=  =id:gol
  ^-  @
  =/  ginn  (ginn nid:gol @)
  =.  ginn
    %=  ginn
      flow  |=(=nid:gol ~(tap in (yong:nd nid)))
      meld  |=([nid:gol nid:gol a=@ b=@] (max a b))
      land  |=([nid:gol out=@ ?] +(out))
    ==
  (((traverse nid:gol @ @) ginn ~) [%d id])
::
++  get-stocks
  |=  [=id:gol vis=(map id:gol stock:gol)]
  ^-  (map id:gol stock:gol)
  =/  gaso  [id:gol stock:gol (map id:gol stock:gol)]
  =/  gine  (gine gaso)
  =.  gine
    %=  gine
      flow  |=(=id:gol =/(par par:(~(got by goals) id) ?~(par ~ [u.par]~)))
      land  |=([=id:gol =stock:gol ?] [[id chief:(~(got by goals) id)] stock])
      exit  |=([=id:gol vis=(map id:gol stock:gol)] vis)
      prnt  print-id
    ==
  (((traverse gaso) gine vis) id)
::
:: all nodes left or right of a given node including self
++  to-ends
  |=  [=nid:gol dir=?(%l %r)]
  ^-  (set nid:gol)
  =/  flo  ?-(dir %l iflo, %r oflo)
  =/  ginn  (ginn nid:gol (set nid:gol))
  =.  ginn
    %=  ginn
      flow  |=(=nid:gol ~(tap in (flo nid)))
      init  |=(=nid:gol (~(put in *(set nid:gol)) nid))
      meld  |=([nid:gol nid:gol a=(set nid:gol) b=(set nid:gol)] (~(uni in a) b))
    ==
  (((traverse nid:gol (set nid:gol) (set nid:gol)) ginn ~) nid)
::
:: all descendents including self
++  progeny
  |=  =id:gol
  ^-  (set id:gol)
  =/  ginn  (ginn id:gol (set id:gol))
  =.  ginn
    %=  ginn
      flow  |=(=id:gol ~(tap in kids:(~(got by goals) id)))
      init  |=(=id:gol (~(put in *(set id:gol)) id))
      meld  |=([id:gol id:gol a=(set id:gol) b=(set id:gol)] (~(uni in a) b))
    ==
  (((traverse id:gol (set id:gol) (set id:gol)) ginn ~) id)
::
++  replace-chief
  |=  [kick=(set ship) owner=ship]
  |=  [=id:gol vis=(map id:gol ship)]
  ^-  (map id:gol ship)
  =/  gaso  [id:gol ship (map id:gol ship)]
  =/  gine  (gine gaso)
  =.  gine
    %=  gine
      flow  |=(=id:gol =/(par par:(~(got by goals) id) ?~(par ~ [u.par]~)))
      init  |=(=id:gol chief:(~(got by goals) id))
      stop  |=([id:gol =ship] !(~(has in kick) ship)) :: stop if not in kick set
      meld  |=([id:gol id:gol a=ship b=ship] b)
      land  |=([=id:gol =ship cnd=?] ?:(cnd ship owner)) :: if not in kick set
    ==
  (((traverse gaso) gine vis) id)
::
:: smol helpers
++  anchor  |.(+((roll (turn (root-goals:nd) plumb) max)))
::
++  left-bound  |=(=nid:gol (~(got by ((get-bounds %l) nid ~)) nid))
++  ryte-bound  |=(=nid:gol (~(got by ((get-bounds %r) nid ~)) nid))
++  left-plumb  |=(=nid:gol (~(got by ((plomb %l) nid ~)) nid))
++  ryte-plumb  |=(=nid:gol (~(got by ((plomb %r) nid ~)) nid))
++  get-stock  |=(=id:gol (~(got by (get-stocks id ~)) id))
::
++  get-ranks
  |=  =stock:gol
  ^-  ranks:gol
  =|  =ranks:gol
  |-
  ?~  stock
    ranks
  %=  $
    stock  t.stock
    ranks  (~(put by ranks) [chief id]:i.stock)
  ==
::
:: get the left or right bound of a node (assumes correct moment order)
++  get-rank
  |=  [mod=ship =id:gol]
  ^-  (unit id:gol)
  (~(get by (get-ranks (get-stock id))) mod)
--
