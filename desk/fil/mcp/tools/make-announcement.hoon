/-  chorus, mcp, spider
/+  io=strandio
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
        :-  'public'
        :-  %boolean
        '''
        Publish to every ship that polls us. Defaults to true.
        False keeps the listing in this ship's own namespace,
        where Chorus cannot yet read it back.
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
    =/  public=?  !=([~ %boolean |] (~(get by args) 'public'))
    ;<  our=ship  bind:m  get-our:io
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /make-announcement
          %agent  [our %chorus]
          %poke   %chorus-publish
          !>(`publish:chorus`[public %announcement p.u.ano])
      ==
    ;<  ~  bind:m  (take-poke-ack:io /make-announcement)
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %structured
    (frond:enjs:format %announcement-sent b+&)
==
