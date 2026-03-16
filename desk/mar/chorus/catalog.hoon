/-  *chorus
|_  val=(map ship tool-catalog)
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %o
    %-  ~(gas by *(map @t ^json))
    %+  turn  ~(tap by val)
    |=  [=ship cat=tool-catalog]
    :-  (scot %p ship)
    :-  %o
    %-  ~(gas by *(map @t ^json))
    :~  ['from' s+(scot %p from.cat)]
        ['time' s+(scot %da time.cat)]
        :-  'tools'
        :-  %a
        %+  turn  tools.cat
        |=  =tool-entry
        :-  %o
        %-  ~(gas by *(map @t ^json))
        :~  ['name' s+(crip (trip name.tool-entry))]
            ['desc' s+desc.tool-entry]
            ['schema' s+schema.tool-entry]
        ==
    ==
  --
++  grab
  |%
  ++  noun  ,(map ship tool-catalog)
  --
--
