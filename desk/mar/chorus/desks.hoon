/-  chorus
/+  *wick
|_  val=(set listing:desk:chorus)
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ::  json gives the wick as a wire, which a client can hand
  ::  back to chorus/verify-wire, and the desk and description
  ++  json
    ^-  ^json
    :-  %a
    %+  turn  ~(tap in val)
    |=  lit=listing:desk:chorus
    %-  pairs:enjs:format
    :~  ['desk' s+desk.lit]
        ['desc' s+desc.lit]
        ['wire' s+(wick-to-wire wick.lit)]
    ==
  --
++  grab
  |%
  ++  noun  ,(set listing:desk:chorus)
  --
--
