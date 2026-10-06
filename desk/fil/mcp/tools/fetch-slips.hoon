/-  chorus, mcp, spider
/+  io=strandio
^-  tool:mcp
:*  'chorus/fetch-slips'
    '''
    Fetch the text of the slips other ships list under one
    drawer of the cabinet. A ship we poll lists each slip's
    path and author; this ship holds a slip's text only once
    it has been fetched. Each text comes from its author's
    ship, and this ship keeps it from then on. The fetch runs
    in the background: read the drawer afterwards to see the
    slips that have arrived.
    '''
    %-  my
    :~  :-  'drawer'
        :-  %string
        '''
        The cabinet path prefix to fetch under, beginning with
        a /, e.g. /projects/chorus. Use / for the whole cabinet.
        '''
        :-  'ship'
        :-  %string
        '''
        Fetch only the slips this ship wrote, as a @p like
        ~sampel-palnet. Defaults to every ship we poll.
        '''
    ==
    ~['drawer']
    ^-  thread-builder:tool:mcp
    |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
    ^-  shed:khan
    =/  m  (strand:spider ,vase)
    ^-  form:m
    =/  dra  (~(get by args) 'drawer')
    ?~  dra
      (pure:m !>([%error %missing-drawer ~]))
    ?>  ?=([%string @t] u.dra)
    =/  pax=(unit path)  (rush p.u.dra stap)
    ?~  pax
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error 'could not parse the drawer; it must look like /drawer' ~]
    =/  who  (~(get by args) 'ship')
    =/  him=(unit ship)
      ?.  ?=([~ %string @t] who)
        ~
      (slaw %p p.u.who)
    ?:  &(?=(^ who) ?=(~ him))
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error 'could not parse the ship; it must be a @p' ~]
    ;<  our=ship  bind:m  get-our:io
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /fetch-slips
          %agent  [our %chorus]
          %poke   %chorus-fetch
          !>  ^-  fetch:chorus
          [u.pax ?~(him ~ [u.him ~ ~])]
      ==
    ;<  ~  bind:m  (take-poke-ack:io /fetch-slips)
    %-  pure:m
    !>  ^-  response:tool:mcp
    [%result %structured (frond:enjs:format %fetching s+p.u.dra)]
==
