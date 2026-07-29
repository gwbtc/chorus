/-  mcp, *chorus
|_  val=(map ship (set listing:prompt:mcp))
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %o
    %-  ~(gas by *(map @t ^json))
    %+  turn  ~(tap by val)
    |=  [=ship prompts=(set listing:prompt:mcp)]
    :-  (scot %p ship)
    :-  %a
    %+  turn  ~(tap in prompts)
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
    ==
  --
++  grab
  |%
  ++  noun  ,(map ship (set listing:prompt:mcp))
  --
--
