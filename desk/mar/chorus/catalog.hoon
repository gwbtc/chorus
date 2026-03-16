/-  *chorus
|_  val=(map ship (set tool-listing))
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %o
    %-  ~(gas by *(map @t ^json))
    %+  turn  ~(tap by val)
    |=  [=ship tools=(set tool-listing)]
    :-  (scot %p ship)
    :-  %a
    %+  turn  ~(tap in tools)
    |=  t=tool-listing
    :-  %o
    %-  ~(gas by *(map @t ^json))
    :~  ['name' s+name.t]
        ['desc' s+desc.t]
        :-  'parameters'
        :-  %o
        %-  ~(gas by *(map @t ^json))
        %+  turn  ~(tap by parameters.t)
        |=  [pname=@t =def:parameter:tool:mcp]
        :-  pname
        :-  %o
        %-  ~(gas by *(map @t ^json))
        :~  ['type' s+(crip (trip type.def))]
            ['desc' s+desc.def]
        ==
        ['required' a+(turn required.t |=(r=@t s+r))]
    ==
  --
++  grab
  |%
  ++  noun  ,(map ship (set tool-listing))
  --
--
