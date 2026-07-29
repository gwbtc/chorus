/-  chorus, mcp, spider
/+  io=strandio, gossip
^-  tool:mcp
:*  'chorus/publish-tool'
    '''
    Publish an MCP tool listing from a Clay path to the Chorus network.
    '''
    %-  my
    :~  ['desk' [%string 'The desk containing the MCP tool file.']]
        ['path' [%string 'The Clay path to the MCP tool noun. Must begin with a /.']]
        :-  'crowd'
        :-  %array
        '''
        Optional audience, an array of strings: ['local'] keeps
        it on this ship; a single class like ['kids'], ['fief'],
        ['sein'], or ['city'] sends it straight to those ships;
        ship names like ['~sampel', '~palnet'] send it to the
        listed ships. Leave out to gossip to our subscribers.
        '''
    ==
    ~['desk' 'path']
    ^-  thread-builder:tool:mcp
    |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
    ^-  shed:khan
    =/  m  (strand:spider ,vase)
    ^-  form:m
    =/  dek  (~(get by args) 'desk')
    =/  pax  (~(get by args) 'path')
    ?~  dek  ~|(%missing-desk !!)
    ?~  pax  ~|(%missing-path !!)
    ?>  ?=([%string @t] u.dek)
    ?>  ?=([%string @t] u.pax)
    =/  =path
      ?:  =('/' (snag 0 (trip p.u.pax)))
        (stab p.u.pax)
      (stab (crip (slag 1 (trip p.u.pax))))
    ::  sanitise the crowd argument: absent defers to the
    ::  standing gossip config
    =/  crowd=(unit crowd:gossip)
      =/  arg  (~(get by args) 'crowd')
      ?.  ?=([~ %array *] arg)  ~
      =/  txts=(list @t)
        %+  turn  p.u.arg
        |=  a=argument:tool:mcp
        ?>(?=([%string @t] a) p.a)
      ?:  =(~['local'] txts)  `~
      =/  who=(unit whos:gossip)
        ?.  ?=([@ ~] txts)  ~
        ((soft whos:gossip) i.txts)
      ?^  who  `[%whos u.who]
      `[%ships (turn txts |=(t=@t (slav %p t)))]
    ;<  our=ship  bind:m  get-our:io
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /publish-tool
          %agent  [our %chorus]
          %poke   %chorus-action
          !>(`action:chorus`[%publish crowd %mcp-tool `@tas`p.u.dek path])
      ==
    ;<  ~  bind:m  (take-poke-ack:io /publish-tool)
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %structured
    (frond:enjs:format %published-mcp-tool s+p.u.pax)
==
