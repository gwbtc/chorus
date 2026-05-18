/-  mcp, *chorus, spider
/+  io=strandio
^-  tool:mcp
:*  'chorus__make-announcement'
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
    ;<  our=ship  bind:m  get-our:io
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /make-announcement
          %agent  [our %chorus]
          %poke   %chorus-broadcast  !>([%announce p.u.ano])
      ==
    ;<  ~  bind:m  (take-poke-ack:io /make-announcement)
    %-  pure:m
    !>  ^-  json
    %-  pairs:enjs:format
    :~  ['type' s+'text']
        ['text' s+(crip "Announcement sent.")]
    ==
==
