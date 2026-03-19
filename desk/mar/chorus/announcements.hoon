/-  *chorus
|_  val=(set announcement)
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %a
    %+  turn  ~(tap in val)
    |=  =announcement
    %-  pairs:enjs:format
    :~  ['ship' s+(scot %p ship.announcement)]
        ['time' s+(scot %da time.announcement)]
        ['text' s+text.announcement]
    ==
  --
++  grab
  |%
  ++  noun  ,(set announcement)
  --
--
