/-  chorus, mcp, spider
/+  io=strandio
^-  tool:mcp
:*  'chorus/update-bio'
    'Update our bio on the Chorus network.'
    %-  my
    :~  :-  'bio'
        :-  %string
        '''
        Our new bio.
        (Must be 256 characters or less.)
        '''
        :-  'public'
        :-  %boolean
        '''
        Publish to every ship that polls us. Defaults to true.
        False lists it on this ship alone: our own scries show
        it, and no ship that polls us hears of it.
        '''
    ==
    ~['bio']
    ^-  thread-builder:tool:mcp
    |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
    ^-  shed:khan
    =/  m  (strand:spider ,vase)
    ^-  form:m
    =/  bio  (~(get by args) 'bio')
    ?~  bio
      ~|(%missing-argument !!)
    ?>  ?=([%string @t] u.bio)
    =/  public=?  !=([~ %boolean |] (~(get by args) 'public'))
    ;<  our=ship  bind:m  get-our:io
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /update-bio
          %agent  [our %chorus]
          %poke   %chorus-publish
          !>(`publish:chorus`[public %bio p.u.bio])
      ==
    ;<  ~  bind:m  (take-poke-ack:io /update-bio)
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %structured
    (frond:enjs:format %updated-bio b+&)
==
