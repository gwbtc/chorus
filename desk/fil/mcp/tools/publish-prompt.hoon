/-  chorus, mcp, spider
/+  io=strandio
^-  tool:mcp
:*  'chorus/publish-prompt'
    '''
    Publish an MCP prompt listing from a Clay path to the Chorus network.
    '''
    %-  my
    :~  ['desk' [%string 'The desk containing the MCP prompt file.']]
        ['path' [%string 'The Clay path to the MCP prompt noun. Must begin with a /.']]
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
    ;<  our=ship  bind:m  get-our:io
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /publish-prompt
          %agent  [our %chorus]
          %poke   %chorus-action
          !>(`action:chorus`[%publish-mcp-prompt | `@tas`p.u.dek path])
      ==
    ;<  ~  bind:m  (take-poke-ack:io /publish-prompt)
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %structured
    (frond:enjs:format %published-mcp-prompt s+p.u.pax)
==
