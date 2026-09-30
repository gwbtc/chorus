/-  chorus, mcp, spider
/+  io=strandio
^-  tool:mcp
:*  'chorus/publish-resource-template'
    '''
    Publish an MCP resource template listing from a Clay path to the Chorus network.
    '''
    %-  my
    :~  ['desk' [%string 'The desk containing the MCP resource template file.']]
        ['path' [%string 'The Clay path to the MCP resource template noun. Must begin with a /.']]
        :-  'public'
        :-  %boolean
        '''
        Publish to every ship that polls us. Defaults to true.
        False lists it on this ship alone: our own scries show
        it, and no ship that polls us hears of it.
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
    =/  public=?  !=([~ %boolean |] (~(get by args) 'public'))
    ;<  our=ship  bind:m  get-our:io
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /publish-resource-template
          %agent  [our %chorus]
          %poke   %chorus-publish
          !>  ^-  publish:chorus
          [public %mcp-resource-template `@tas`p.u.dek path]
      ==
    ;<  ~  bind:m  (take-poke-ack:io /publish-resource-template)
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %structured
    (frond:enjs:format %published-mcp-resource-template s+p.u.pax)
==
