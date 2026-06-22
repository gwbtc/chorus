/-  mcp, *chorus, spider
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
    ;<  our=ship  bind:m  get-our:io
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /update-bio
          %agent  [our %chorus]
          %poke   %chorus-action  !>(`chorus-action`[%update-bio p.u.bio])
      ==
    ;<  ~  bind:m  (take-poke-ack:io /update-bio)
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %unstructured
    :~  [%text (crip "Updated our bio.")]
    ==
==
