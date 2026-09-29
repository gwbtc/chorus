/-  chorus
/+  cho=chorus
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
    :*  ['ship' s+(scot %p ship.lit)]
        ['skill' s+(scot %uv skill.lit)]
        (skill-pairs:cho meta.lit)
    ==
  --
++  grab
  |%
  ++  noun  ,(set listing:skill:chorus)
  --
--
