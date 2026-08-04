/-  chorus
/+  *wick
|_  val=(set listing:skill:chorus)
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %a
    %+  turn  ~(tap in val)
    |=  lit=listing:skill:chorus
    %-  pairs:enjs:format
    :~  ['name' s+name.meta.lit]
        ['description' s+description.meta.lit]
        ['compatibility' s+compatibility.meta.lit]
        ['wire' s+(wick-to-wire wick.lit)]
    ==
  --
++  grab
  |%
  ++  noun  ,(set listing:skill:chorus)
  --
--
