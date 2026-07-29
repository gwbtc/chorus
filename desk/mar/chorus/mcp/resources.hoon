/-  *chorus
|_  val=(map ship (set listing:resource:mcp))
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %o
    %-  ~(gas by *(map @t ^json))
    %+  turn  ~(tap by val)
    |=  [=ship resources=(set listing:resource:mcp)]
    :-  (scot %p ship)
    :-  %a
    %+  turn  ~(tap in resources)
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
    ?~  desc.info
      ~
    :~  ['description' s+u.desc.info]
    ==
  --
++  grab
  |%
  ++  noun  ,(map ship (set listing:resource:mcp))
  --
--
