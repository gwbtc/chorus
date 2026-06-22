/-  mcp, *chorus, spider
/+  io=strandio
^-  tool:mcp
:*  'chorus/publish-tool'
    '''
    Publish an MCP tool listing to the Chorus network.
    '''
    %-  my
    :~  ['name' [%string 'The name of the MCP tool.']]
        ['desc' [%string 'The description of the MCP tool.']]
        :-  'parameters'
        :-  %object
        '''
        The parameters the MCP tool takes, as an object
        mapping parameter names to objects with "type"
        and "description" keys.
        '''
        ['required' [%array 'The names of the required parameters.']]
    ==
    ~['name' 'desc' 'parameters' 'required']
    ^-  thread-builder:tool:mcp
    |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
    ^-  shed:khan
    =/  m  (strand:spider ,vase)
    ^-  form:m
    =/  nam  (~(get by args) 'name')
    =/  dec  (~(get by args) 'desc')
    =/  req  (~(get by args) 'required')
    =/  par  (~(get by args) 'parameters')
    ?~  nam  ~|(%missing-name !!)
    ?~  dec  ~|(%missing-desc !!)
    ?~  req  ~|(%missing-required !!)
    ?~  par  ~|(%missing-parameters !!)
    ?>  ?=([%string @t] u.nam)
    ?>  ?=([%string @t] u.dec)
    ?>  ?=([%string @t] u.req)
    ?>  ?=([%string @t] u.par)
    =/  req-json  (need (de:json:html p.u.req))
    =/  par-json  (need (de:json:html p.u.par))
    ?>  ?=([%a *] req-json)
    ?>  ?=([%o *] par-json)
    =/  rex=(list @t)
      %+  turn  p.req-json
      |=  =json
      ?>  ?=([%s @t] json)
      p.json
    =/  pars=(map name:parameter:tool:mcp def:parameter:tool:mcp)
      %-  ~(gas by *(map name:parameter:tool:mcp def:parameter:tool:mcp))
      %+  turn
        ~(tap by p.par-json)
      |=  [name=@t =json]
      ^-  [name:parameter:tool:mcp def:parameter:tool:mcp]
      ?>  ?=([%o *] json)
      =/  typ  (~(get by p.json) 'type')
      =/  dec  (~(get by p.json) 'description')
      ?~  typ  ~|(%missing-parameter-type !!)
      ?~  dec  ~|(%missing-parameter-description !!)
      ?>  ?=([%s @t] u.typ)
      ?>  ?=([%s @t] u.dec)
      [name [(type:parameter:tool:mcp p.u.typ) p.u.dec]]
    ;<  our=ship  bind:m  get-our:io
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /publish-tool
          %agent  [our %chorus]
          %poke   %chorus-broadcast  !>([%publish-tool p.u.nam p.u.dec pars rex])
      ==
    ;<  ~  bind:m  (take-poke-ack:io /publish-tool)
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %unstructured
    :~  [%text (crip "Published tool {(trip p.u.nam)}.")]
    ==
==
