/-  mcp, *chorus
|_  val=update
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ::  every listing carries the wick that signed it; json gives
  ::  clients the plaintext half alone
  ++  json
    ^-  ^json
    ?-  -.val
        %chorus-bio-updated
      %-  pairs:enjs:format
      :~  ['type' s+'chorus-bio-updated']
          ['ship' s+(scot %p ship.val)]
          ['bio' s+txt.listing.val]
      ==
    ::
        %chorus-announcement
      %-  pairs:enjs:format
      :~  ['type' s+'chorus-announcement']
          ['ship' s+(scot %p ship.val)]
          ['time' s+(scot %da time.listing.val)]
          ['text' s+txt.listing.val]
      ==
    ::
        %chorus-desk-published
      %-  pairs:enjs:format
      :~  ['type' s+'chorus-desk-published']
          ['ship' s+(scot %p ship.val)]
          ['desk' s+desk.listing.val]
          ['desc' s+desc.listing.val]
      ==
    ::
        %mcp-tool-listed
      =/  t  meta.listing.val
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
      =/  p  meta.listing.val
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
          |=  arg=argument:prompt:^mcp
          %-  pairs:enjs:format
          :~  ['name' s+name.arg]
              ['description' s+desc.arg]
              ['required' b+required.arg]
          ==
      ==
    ::
        %mcp-resource-listed
      =/  r  meta.listing.val
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
      =/  r  meta.listing.val
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
