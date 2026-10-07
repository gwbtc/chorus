::
::  the slips under a path whose pages we hold, each credited
::  to its author's nym
/-  chorus
/+  slp=slip
|_  val=drawer:chorus
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ::
  ::  a nested object mirroring the tree: the slip at
  ::  each node, if any, and its children by segment
  ++  json
    |-  ^-  ^json
    %-  pairs:enjs:format
    :~  :-  'slip'
        ?~  fil.val
          ~
        %-  pairs:enjs:format
        [['nym' s+nym.u.fil.val] (slip-pairs:slp slip.u.fil.val)]
      ::
        ['dir' o+(~(run by dir.val) |=(kid=drawer:chorus ^$(val kid)))]
    ==
  ::
  ::  one path per line
  ++  txt
    ^-  wain
    %+  turn
      (sort (turn ~(tap of val) |=([pax=path *] pax)) aor)
    spat
  --
++  grab
  |%
  ++  noun  ,drawer:chorus
  --
--
