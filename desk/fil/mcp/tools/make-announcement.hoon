/-  chorus, mcp, spider
/+  io=strandio, gossip
^-  tool:mcp
:*  'chorus/make-announcement'
    '''
    Announce something to the Chorus network.
    '''
    %-  my
    :~  :-  'announcement'
        :-  %string
        '''
        Our announcement.
        (Must be 256 characters or less.)
        '''
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
    ~['announcement']
    ^-  thread-builder:tool:mcp
    |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
    ^-  shed:khan
    =/  m  (strand:spider ,vase)
    ^-  form:m
    =/  ano  (~(get by args) 'announcement')
    ?~  ano
      ~|(%missing-argument !!)
    ?>  ?=([%string @t] u.ano)
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
      :*  %pass   /make-announcement
          %agent  [our %chorus]
          %poke   %chorus-action
          !>(`action:chorus`[%publish crowd %announcement p.u.ano])
      ==
    ;<  ~  bind:m  (take-poke-ack:io /make-announcement)
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %structured
    (frond:enjs:format %announcement-sent b+&)
==
