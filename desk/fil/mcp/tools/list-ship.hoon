/-  chorus, mcp, spider
/+  io=strandio
^-  tool:mcp
:*  'chorus/list-ship'
    '''
    Add a comet to, or remove a ship from, the ships Chorus polls
    for listings. Chorus shows what it hears from these ships and
    from no others, and seeds its Kademlia table with them. Only
    a comet has a Groundwire nym, so Chorus polls comets alone
    and refuses to add any other ship.
    '''
    %-  my
    :~  :-  'who'
        :-  %string
        '''
        The ship, as a @p like ~sampel-palnet, or as a Groundwire
        nym: words joined by dots, with one or two leading dots.
        '''
        :-  'remove'
        :-  %boolean
        'Remove the ship. Defaults to false, which adds it.'
    ==
    ~['who']
    ^-  thread-builder:tool:mcp
    |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
    ^-  shed:khan
    =/  m  (strand:spider ,vase)
    ^-  form:m
    =/  who  (~(get by args) 'who')
    ?~  who
      (pure:m !>([%error %missing-who ~]))
    ?>  ?=([%string @t] u.who)
    =/  him=(unit $%([%ship ship] [%nym nym:chorus]))
      ?:  =('.' (end 3 p.u.who))
        `[%nym p.u.who]
      (bind (slaw %p p.u.who) (lead %ship))
    ?~  him
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error 'could not parse who; it must be a @p or a nym' ~]
    ;<  our=ship  bind:m  get-our:io
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /list-ship
          %agent  [our %chorus]
          %poke   %chorus-list
          !>  ^-  list-action:chorus
          :_  u.him
          ?:(=([~ %boolean &] (~(get by args) 'remove')) %remove %add)
      ==
    ;<  ~  bind:m  (take-poke-ack:io /list-ship)
    ;<  polled=json  bind:m
      (scry:io json /gx/chorus/polled/json)
    %-  pure:m
    !>  ^-  response:tool:mcp
    [%result %structured (frond:enjs:format %polled polled)]
==
