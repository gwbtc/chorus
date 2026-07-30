/-  *chorus
/+  *wick
|_  val=(set listing:bio)
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ::  json gives the wick as a wire, which a client can hand
  ::  back to chorus/verify-wire, and the plaintext bio
  ++  json
    ^-  ^json
    :-  %a
    %+  turn  ~(tap in val)
    |=  lit=listing:bio
    %-  pairs:enjs:format
    :~  ['bio' s+txt.lit]
        ['wire' s+(wick-to-wire wick.lit)]
    ==
  --
++  grab
  |%
  ++  noun  ,(set listing:bio)
  --
--
