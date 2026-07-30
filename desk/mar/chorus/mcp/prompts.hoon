/-  mcp, *chorus
/+  *wick
|_  val=(set listing:prompt:mcp)
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %a
    %+  turn  ~(tap in val)
    |=  p=listing:prompt:mcp
    =*  info  meta.p
    %-  pairs:enjs:format
    :~  ['name' s+name.info]
        ['title' s+title.info]
        ['description' s+desc.info]
        :-  'arguments'
        :-  %a
        %+  turn
          arguments.info
        |=  arg=argument:prompt:^mcp
        %-  pairs:enjs:format
        :~  ['name' s+name.arg]
            ['description' s+desc.arg]
            ['required' b+required.arg]
        ==
        ['wire' s+(wick-to-wire wick.p)]
    ==
  --
++  grab
  |%
  ++  noun  ,(set listing:prompt:mcp)
  --
--
