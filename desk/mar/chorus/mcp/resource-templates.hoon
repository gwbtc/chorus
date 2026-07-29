/-  *chorus
|_  val=(map ship (set listing:template:resource:mcp))
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %o
    %-  ~(gas by *(map @t ^json))
    %+  turn  ~(tap by val)
    |=  [=ship templates=(set listing:template:resource:mcp)]
    :-  (scot %p ship)
    :-  %a
    %+  turn  ~(tap in templates)
    |=  r=listing:template:resource:mcp
    =*  info  meta.r
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
  ++  noun  ,(map ship (set listing:template:resource:mcp))
  --
--
