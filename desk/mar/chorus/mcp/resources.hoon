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
    =*  info  mcp-resource-metadata.r
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
  ++  noun  ,(map ship (set mcp-resource-listing))
  --
--
