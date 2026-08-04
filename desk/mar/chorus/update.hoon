/-  mcp, *chorus
|_  val=update
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    ?-  -.val
        %chorus-bio-updated
      %-  pairs:enjs:format
      :~  ['type' s+'chorus-bio-updated']
          ['wire' s+wire.val]
          ['bio' s+txt.val]
      ==
    ::
        %chorus-announcement
      %-  pairs:enjs:format
      :~  ['type' s+'chorus-announcement']
          ['wire' s+wire.val]
          ['time' s+(scot %da time.val)]
          ['text' s+txt.val]
      ==
    ::
        %chorus-desk-published
      %-  pairs:enjs:format
      :~  ['type' s+'chorus-desk-published']
          ['wire' s+wire.val]
          ['desk' s+desk.val]
          ['desc' s+desc.val]
      ==
    ::
        %mcp-tool-listed
      =/  t  meta.val
      %-  pairs:enjs:format
      :~  ['type' s+'mcp-tool-listed']
          ['wire' s+wire.val]
          ['name' s+name.t]
          ['description' s+desc.t]
          :-  'inputSchema'
          %-  pairs:enjs:format
          :~  ['type' s+'object']
              :-  'properties'
              :-  %o
              %-  ~(gas by *(map @t ^json))
              %+  turn  ~(tap by parameters.t)
              |=  [pname=@t =def:parameter:tool:^mcp]
              :-  pname
              %-  pairs:enjs:format
              :~  ['type' s+type.def]
                  ['description' s+desc.def]
              ==
              ['required' a+(turn required.t |=(r=@t s+r))]
          ==
      ==
    ::
        %mcp-prompt-listed
      =/  p  meta.val
      %-  pairs:enjs:format
      :~  ['type' s+'mcp-prompt-listed']
          ['wire' s+wire.val]
          ['name' s+name.p]
          ['title' s+title.p]
          ['description' s+desc.p]
          :-  'arguments'
          :-  %a
          %+  turn
            arguments.p
          |=  arg=argument:prompt:^mcp
          %-  pairs:enjs:format
          :~  ['name' s+name.arg]
              ['description' s+desc.arg]
              ['required' b+required.arg]
          ==
      ==
    ::
        %mcp-resource-listed
      =/  r  meta.val
      %-  pairs:enjs:format
      :~  ['type' s+'mcp-resource-listed']
          ['wire' s+wire.val]
          ['uri' s+uri.r]
          ['name' s+name.r]
          :-  'title'
          ?~  title.r  ~  s+u.title.r
          :-  'description'
          ?~  desc.r  ~  s+u.desc.r
      ==
    ::
        %mcp-resource-template-listed
      =/  r  meta.val
      %-  pairs:enjs:format
      :~  ['type' s+'mcp-resource-template-listed']
          ['wire' s+wire.val]
          ['uriTemplate' s+uri-template.r]
          ['name' s+name.r]
          :-  'title'
          ?~  title.r  ~  s+u.title.r
          :-  'description'
          ?~  desc.r  ~  s+u.desc.r
      ==
    ::
        %agent-skill-listed
      =/  s  meta.val
      %-  pairs:enjs:format
      :~  ['type' s+'agent-skill-listed']
          ['wire' s+wire.val]
          ['name' s+name.s]
          ['description' s+description.s]
          ['compatibility' s+compatibility.s]
      ==
    ==
  --
++  grab
  |%
  ++  noun  ,update
  --
--
