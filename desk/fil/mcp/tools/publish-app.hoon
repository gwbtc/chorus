/-  chorus, mcp, spider
/+  io=strandio
^-  tool:mcp
:*  'chorus/publish-app'
    '''
    Announce a new Gall app to the Chorus network.
    '''
    %-  my
    :~  :-  'desk'
        :-  %string
        '''
        The desk name of the app to publish (e.g. 'my-app').
        (Must be 256 characters or less.)
        '''
        :-  'desc'
        :-  %string
        '''
        A description of the app.
        (Must be 256 characters or less.)
        '''
        :-  'public'
        :-  %boolean
        '''
        Publish to every ship that polls us. Defaults to false,
        which lists it on this ship alone: our own scries show
        it, and no ship that polls us hears of it.
        '''
    ==
    ~['desk' 'desc']
    ^-  thread-builder:tool:mcp
    |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
    ^-  shed:khan
    =/  m  (strand:spider ,vase)
    ^-  form:m
    =/  dek  (~(get by args) 'desk')
    =/  dec  (~(get by args) 'desc')
    ?~  dek
      ~|(%missing-argument !!)
    ?>  ?=([%string @t] u.dek)
    ?~  dec
      ~|(%missing-argument !!)
    ?>  ?=([%string @t] u.dec)
    =/  public=?  =([~ %boolean &] (~(get by args) 'public'))
    ;<  our=ship  bind:m  get-our:io
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /publish-app
          %agent  [our %chorus]
          %poke   %chorus-publish
          !>(`publish:chorus`[public %desk `@tas`p.u.dek p.u.dec])
      ==
    ;<  ~  bind:m  (take-poke-ack:io /publish-app)
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %structured
    (frond:enjs:format %published-desk s+p.u.dek)
==
