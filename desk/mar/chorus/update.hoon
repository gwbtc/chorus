/-  *chorus
|_  val=update
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    ?-  -.val
        %updated-bio
      %-  pairs:enjs:format
      :~  ['type' s+'updated-bio']
          ['ship' s+(scot %p ship.val)]
          ['bio' s+bio.val]
      ==
    ::
        %announcement
      %-  pairs:enjs:format
      :~  ['type' s+'announcement']
          ['ship' s+(scot %p ship.val)]
          ['time' s+(scot %da time.val)]
          ['text' s+text.val]
      ==
    ::
        %desk-published
      %-  pairs:enjs:format
      :~  ['type' s+'desk-published']
          ['ship' s+(scot %p ship.val)]
          ['desk' s+desk.val]
          ['desc' s+desc.val]
      ==
    ::
        %mcp-tool-listed
      =/  t  mcp-tool-metadata.mcp-tool-listing.val
      %-  pairs:enjs:format
      :~  ['type' s+'mcp-tool-listed']
          ['ship' s+(scot %p ship.val)]
          ['name' s+name.t]
          ['description' s+desc.t]
          :-  'inputSchema'
          %-  pairs:enjs:format
          :~  ['type' s+'object']
              :-  'properties'
              :-  %o
              %-  ~(gas by *(map @t ^json))
              %+  turn  ~(tap by parameters.t)
              |=  [pname=@t =def:parameter:tool:mcp]
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
      =/  p  mcp-prompt-metadata.mcp-prompt-listing.val
      %-  pairs:enjs:format
      :~  ['type' s+'mcp-prompt-listed']
          ['ship' s+(scot %p ship.val)]
          ['name' s+name.p]
          ['title' s+title.p]
          ['description' s+desc.p]
          :-  'arguments'
          :-  %a
          %+  turn
            arguments.p
          |=  arg=argument:prompt:mcp
          %-  pairs:enjs:format
          :~  ['name' s+name.arg]
              ['description' s+desc.arg]
              ['required' b+required.arg]
          ==
      ==
    ::
        %mcp-resource-listed
      =/  r  mcp-resource-metadata.mcp-resource-listing.val
      %-  pairs:enjs:format
      :~  ['type' s+'mcp-resource-listed']
          ['ship' s+(scot %p ship.val)]
          ['uri' s+uri.r]
          ['name' s+name.r]
          :-  'title'
          ?~  title.r  ~  s+u.title.r
          :-  'description'
          ?~  desc.r  ~  s+u.desc.r
      ==
    ::
        %mcp-resource-template-listed
      =/  r  mcp-resource-template-metadata.mcp-resource-template-listing.val
      %-  pairs:enjs:format
      :~  ['type' s+'mcp-resource-template-listed']
          ['ship' s+(scot %p ship.val)]
          ['uriTemplate' s+uri-template.r]
          ['name' s+name.r]
          :-  'title'
          ?~  title.r  ~  s+u.title.r
          :-  'description'
          ?~  desc.r  ~  s+u.desc.r
      ==
    ==
  --
++  grab
  |%
  ++  noun  ,update
  --
--
