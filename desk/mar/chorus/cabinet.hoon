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
    =|  pax=path
    |-  ^-  ^json
    %-  pairs:enjs:format
    :~  ['slip' ?~(fil.val ~ (enjs:slp pax u.fil.val))]
        :-  'dir'
        :-  %o
        %-  ~(gas by *(map @t ^json))
        %+  turn  ~(tap by dir.val)
        |=  [seg=@ta kid=cabinet:chorus]
        [seg ^$(val kid, pax (snoc pax seg))]
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
