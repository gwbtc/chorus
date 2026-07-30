/-  *chorus
/+  *wick
|_  val=(set listing:resource:mcp)
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %a
    %+  turn  ~(tap in val)
    |=  r=listing:resource:mcp
    =*  info  meta.r
    %-  pairs:enjs:format
    %+  welp
      :~  ['uri' s+uri.info]
          ['name' s+name.info]
      ==
    %+  welp
      ?~  title.info
        ~
      :~  ['title' s+u.title.info]
      ==
    %+  welp
      ?~  desc.info
        ~
      :~  ['description' s+u.desc.info]
      ==
    :~  ['wire' s+(wick-to-wire wick.r)]
    ==
  --
++  grab
  |%
  ++  noun  ,(set listing:resource:mcp)
  --
--
