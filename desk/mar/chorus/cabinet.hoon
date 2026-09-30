/-  chorus
/+  slp=slip
|_  val=cabinet:chorus
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
    :~  ['slip' ?~(fil.val ~ (enjs:slp u.fil.val))]
        ['dir' o+(~(run by dir.val) |=(kid=cabinet:chorus ^$(val kid)))]
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
  ++  noun  ,cabinet:chorus
  --
--
