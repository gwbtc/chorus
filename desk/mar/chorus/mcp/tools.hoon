/-  mcp, *chorus
/+  *wick
|_  val=(set listing:tool:mcp)
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %a
    %+  turn  ~(tap in val)
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
        ['wire' s+(wick-to-wire wick.t)]
    ==
  --
++  grab
  |%
  ++  noun  ,(set listing:tool:mcp)
  --
--
