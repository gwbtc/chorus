/-  *chorus
|_  val=(map ship (set [=time =announcement]))
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %o
    %-  ~(gas by *(map @t ^json))
    %+  turn  ~(tap by val)
    |=  [=ship announcements=(set [=time =announcement])]
    :-  (scot %p ship)
    :-  %a
    %+  turn  ~(tap in announcements)
    |=  [=time =announcement]
    %-  pairs:enjs:format
    :~  ['time' s+(scot %da time)]
        ['text' s+announcement]
    ==
  --
++  grab
  |%
  ++  noun  ,(map ship (set [=time =announcement]))
  --
--
