/-  mcp, pals, spider
/+  io=strandio
^-  tool:mcp
:*  'chorus/remove-pal'
    'Remove a ship from pals.'
    %-  my
    :~  :-  'ship'
        :-  %string
        '''
        The @p of the ship to remove from pals (e.g. '~sampel-palnet').
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
      :*  %pass   /remove-pal
          %agent  [our %pals]
          %poke   %pals-command  !>(`command:pals`[%part who *(set @ta)])
      ==
    ;<  ~  bind:m  (take-poke-ack:io /remove-pal)
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %unstructured
    :~  [%text (rap 3 'Removed ' (scot %p who) ' from pals.' ~)]
    ==
==
