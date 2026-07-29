/-  *chorus
|_  val=(map ship (set listing:announcement))
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ::  the wick is for verification, not for clients: json gives
  ::  the time and text alone
  ++  json
    ^-  ^json
    :-  %o
    %-  ~(gas by *(map @t ^json))
    %+  turn  ~(tap by val)
    |=  [=ship listings=(set listing:announcement)]
    :-  (scot %p ship)
    :-  %a
    %+  turn  ~(tap in listings)
    |=  lit=listing:announcement
    %-  pairs:enjs:format
    :~  ['time' s+(scot %da time.lit)]
        ['text' s+txt.lit]
    ==
  --
++  grab
  |%
  ++  noun  ,(map ship (set listing:announcement))
  --
--
