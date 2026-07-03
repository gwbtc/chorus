/-  *chorus
|_  val=(map ship (set mcp-resource-template-listing))
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %o
    %-  ~(gas by *(map @t ^json))
    %+  turn  ~(tap by val)
    |=  [=ship templates=(set mcp-resource-template-listing)]
    :-  (scot %p ship)
    :-  %a
    %+  turn  ~(tap in templates)
    |=  r=mcp-resource-template-listing
    %-  pairs:enjs:format
    %+  welp
      :~  ['uriTemplate' s+uri-template.r]
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
  ++  noun  ,(map ship (set mcp-resource-template-listing))
  --
--
