/-  *chorus
|_  val=(set listing:announcement)
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %a
    %+  turn  ~(tap in val)
    |=  lit=listing:announcement
    %-  pairs:enjs:format
    :~  ['ship' s+(scot %p ship.lit)]
        ['time' s+(scot %da time.lit)]
        ['text' s+txt.lit]
    ==
  --
++  grab
  |%
  ++  noun  ,(set listing:announcement)
  --
--
