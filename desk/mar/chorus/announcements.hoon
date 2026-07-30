/-  *chorus
/+  *wick
|_  val=(set listing:announcement)
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ::  json gives the wick as a wire, which a client can hand
  ::  back to chorus/verify-wire, and the time and text
  ++  json
    ^-  ^json
    :-  %a
    %+  turn  ~(tap in val)
    |=  lit=listing:announcement
    %-  pairs:enjs:format
    :~  ['time' s+(scot %da time.lit)]
        ['text' s+txt.lit]
        ['wire' s+(wick-to-wire wick.lit)]
    ==
  --
++  grab
  |%
  ++  noun  ,(set listing:announcement)
  --
--
