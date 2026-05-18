/-  mcp, pals, spider
/+  io=strandio
^-  tool:mcp
:*  'chorus__add-pal'
    'Add a ship as a pal (tagged chorus).'
    %-  my
    :~  :-  'ship'
        :-  %string
        '''
        The @p of the ship to add as a pal (e.g. '~sampel-palnet').
        '''
    ==
    ~['ship']
    ^-  thread-builder:tool:mcp
    |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
    ^-  shed:khan
    =/  m  (strand:spider ,vase)
    ^-  form:m
    =/  who  (~(get by args) 'ship')
    ?~  who  ~|(%missing-ship !!)
    ?>  ?=([%string @t] u.who)
    =/  who=ship  (slav %p p.u.who)
    ;<  our=ship  bind:m  get-our:io
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /add-pal
          %agent  [our %pals]
          %poke   %pals-command  !>(`command:pals`[%meet who (sy ~[%chorus])])
      ==
    ;<  ~  bind:m  (take-poke-ack:io /add-pal)
    %-  pure:m
    !>  ^-  json
    %-  pairs:enjs:format
    :~  ['type' s+'text']
        ['text' s+(rap 3 'Added ' (scot %p who) ' as a pal.' ~)]
    ==
==
