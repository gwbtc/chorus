/-  *chorus
|_  val=(map ship (set mcp-resource-listing))
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %o
    %-  ~(gas by *(map @t ^json))
    %+  turn  ~(tap by val)
    |=  [=ship resources=(set mcp-resource-listing)]
    :-  (scot %p ship)
    :-  %a
    %+  turn  ~(tap in resources)
    |=  r=mcp-resource-listing
    %-  pairs:enjs:format
    %+  welp
      :~  ['uri' s+uri.r]
          ['name' s+name.r]
      ==
    %+  welp
      ?~  title.r
        ~
      :~  ['title' s+u.title.r]
      ==
    ?~  desc.r
      ~
    :~  ['description' s+u.desc.r]
    ==
  --
++  grab
  |%
  ++  noun  ,(map ship (set mcp-resource-listing))
  --
--
