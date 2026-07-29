/-  mcp, *chorus
|_  val=(map ship (set listing:tool:mcp))
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %o
    %-  ~(gas by *(map @t ^json))
    %+  turn  ~(tap by val)
    |=  [=ship tools=(set listing:tool:mcp)]
    :-  (scot %p ship)
    :-  %a
    %+  turn  ~(tap in tools)
    |=  t=listing:tool:mcp
    =*  info  meta.t
    %-  pairs:enjs:format
    :~  ['name' s+name.info]
        ['description' s+desc.info]
        :-  'inputSchema'
        %-  pairs:enjs:format
        :~  ['type' s+'object']
            :-  'properties'
            :-  %o
            %-  ~(gas by *(map @t ^json))
            %+  turn  ~(tap by parameters.info)
            |=  [pname=@t =def:parameter:tool:^mcp]
            :-  pname
            %-  pairs:enjs:format
            :~  ['type' s+type.def]
                ['description' s+desc.def]
            ==
            ['required' a+(turn required.info |=(r=@t s+r))]
        ==
    ==
  --
++  grab
  |%
  ++  noun  ,(map ship (set listing:tool:mcp))
  --
--
