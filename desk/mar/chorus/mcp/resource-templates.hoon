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
    =*  info  mcp-resource-template-metadata.r
    %-  pairs:enjs:format
    %+  welp
      :~  ['uriTemplate' s+uri-template.info]
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
  ++  noun  ,(map ship (set mcp-resource-template-listing))
  --
--
