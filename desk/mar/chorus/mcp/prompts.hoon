/-  *chorus
|_  val=(map ship (set mcp-prompt-listing))
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %o
    %-  ~(gas by *(map @t ^json))
    %+  turn  ~(tap by val)
    |=  [=ship prompts=(set mcp-prompt-listing)]
    :-  (scot %p ship)
    :-  %a
    %+  turn  ~(tap in prompts)
    |=  p=mcp-prompt-listing
    %-  pairs:enjs:format
    :~  ['name' s+name.p]
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
  --
++  grab
  |%
  ++  noun  ,(map ship (set mcp-prompt-listing))
  --
--
