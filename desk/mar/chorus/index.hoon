::
::  what ships list of the slips in a cabinet: every slip
::  at its path, less its text
/-  chorus
/+  slp=slip
|_  val=index:chorus
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ::
  ::  a nested object mirroring the tree: the stub at
  ::  each node, if any, and its children by segment
  ++  json
    |-  ^-  ^json
    %-  pairs:enjs:format
    :~  ['slip' ?~(fil.val ~ (pairs:enjs:format (stub-pairs:slp u.fil.val)))]
        ['dir' o+(~(run by dir.val) |=(kid=index:chorus ^$(val kid)))]
    ==
  --
++  grab
  |%
  ++  noun  ,index:chorus
  --
--
