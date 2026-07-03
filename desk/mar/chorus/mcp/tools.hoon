/-  *chorus
|_  val=(map ship (set mcp-tool-listing))
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %o
    %-  ~(gas by *(map @t ^json))
    %+  turn  ~(tap by val)
    |=  [=ship tools=(set mcp-tool-listing)]
    :-  (scot %p ship)
    :-  %a
    %+  turn  ~(tap in tools)
    |=  t=mcp-tool-listing
    %-  pairs:enjs:format
    :~  ['name' s+name.t]
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
  --
++  grab
  |%
  ++  noun  ,(map ship (set mcp-tool-listing))
  --
--
