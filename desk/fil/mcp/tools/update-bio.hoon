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
        :-  'local'
        :-  %boolean
        '''
        Only update the local /bio file instead of publishing a signed wick.
        '''
    ==
    ~['bio' 'local']
    ^-  thread-builder:tool:mcp
    |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
    ^-  shed:khan
    =/  m  (strand:spider ,vase)
    ^-  form:m
    =/  bio  (~(get by args) 'bio')
    ?~  bio
      ~|(%missing-argument !!)
    ?>  ?=([%string @t] u.bio)
    =/  loc  (~(get by args) 'local')
    ?~  loc
      ~|(%missing-argument !!)
    ?>  ?=([%boolean ?] u.loc)
    ;<  our=ship  bind:m  get-our:io
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /update-bio
          %agent  [our %chorus]
          %poke   %chorus-action  !>(`action:chorus`[%update-bio p.u.loc p.u.bio])
      ==
    ;<  ~  bind:m  (take-poke-ack:io /update-bio)
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %unstructured
    :~  [%text (crip "Updated our bio.")]
    ==
==
