/-  *chorus
|_  val=(map ship (set listing:desk))
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ::  the wick is for verification, not for clients: json gives
  ::  the desk and its description alone
  ++  json
    ^-  ^json
    :-  %o
    %-  ~(gas by *(map @t ^json))
    %+  turn  ~(tap by val)
    |=  [=ship listings=(set listing:desk)]
    :-  (scot %p ship)
    :-  %a
    %+  turn  ~(tap in listings)
    |=  lit=listing:desk
    %-  pairs:enjs:format
    :~  ['desk' s+desk.lit]
        ['desc' s+desc.lit]
    ==
  --
++  grab
  |%
  ++  noun  ,(map ship (set listing:desk))
  --
--
