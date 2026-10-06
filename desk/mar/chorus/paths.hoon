::
::  the listing of a cabinet: every slip a ship lists, at its
::  path, and whether we hold its page
/-  chorus
/+  slp=slip
|_  val=(axal listed:chorus)
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ::
  ::  a nested object mirroring the tree: the stub at each
  ::  node, if any, and its children by segment. .text and
  ::  .links are blank, as this listing gave them when a shelf
  ::  carried each slip's text
  ++  json
    |-  ^-  ^json
    %-  pairs:enjs:format
    :~  :-  'slip'
        ?~  fil.val
          ~
        %-  pairs:enjs:format
        %+  weld  (stub-pairs:slp stub.u.fil.val)
        ^-  (list [@t ^json])
        :~  ['held' b+held.u.fil.val]
            ['links' a+~]
            ['text' s+'']
        ==
      ::
        :-  'dir'
        :-  %o
        %-  ~(run by dir.val)
        |=(kid=(axal listed:chorus) ^$(val kid))
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
  ++  noun  ,(axal listed:chorus)
  --
--
