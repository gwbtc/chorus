/-  mcp, spider
/+  io=strandio
^-  (list tool:mcp)
:~  :*  'chorus__update-bio'
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
              %poke   %update-bio  !>(u.bio)
          ==
        ;<  ~  bind:m  (take-poke-ack:io /update-bio)
        %-  pure:m
        !>  ^-  json
        %-  pairs:enjs:format
        :~  ['type' s+'text']
            ['text' s+(crip "Updated our bio.")]
    ==  ==
    ::
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
              %poke   %update-bio  !>(u.ano)
          ==
        ;<  ~  bind:m  (take-poke-ack:io /make-announcement)
        %-  pure:m
        !>  ^-  json
        %-  pairs:enjs:format
        :~  ['type' s+'text']
            ['text' s+(crip "Announcement sent.")]
    ==  ==
    ::
    :*  'chorus__publish-app'
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
        ;<  our=ship  bind:m  get-our:io
        ;<  ~  bind:m
          %-  send-raw-card:io
          :*  %pass   /publish-app
              %agent  [our %chorus]
              %poke   %publish-app  !>([`@tas`p.u.dek p.u.dec])
          ==
        ;<  ~  bind:m  (take-poke-ack:io /publish-app)
        %-  pure:m
        !>  ^-  json
        %-  pairs:enjs:format
        :~  ['type' s+'text']
            ['text' s+(crip "Published app {(trip p.u.dek)}!")]
    ==  ==
    ::
    :*  'chorus__publish-tool'
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
        ?>  ?=([%array *] u.req)
        ?>  ?=([%object *] u.par)
        =/  rex=(list @t)
          %+  turn
            p.u.req
          |=  =argument:tool:mcp
          ?>  ?=([%string @t] argument)
          p.argument
        =/  pars=(map name:parameter:tool:mcp def:parameter:tool:mcp)
          %-  ~(gas by *(map name:parameter:tool:mcp def:parameter:tool:mcp))
          %+  turn
            ~(tap by p.u.par)
          |=  [name=@t =argument:tool:mcp]
          ^-  [name:parameter:tool:mcp def:parameter:tool:mcp]
          ?>  ?=([%object *] argument)
          =/  typ  (~(get by p.argument) 'type')
          =/  dec  (~(get by p.argument) 'description')
          ?~  typ  ~|(%missing-parameter-type !!)
          ?~  dec  ~|(%missing-parameter-description !!)
          ?>  ?=([%string @t] u.typ)
          ?>  ?=([%string @t] u.dec)
          [name [(type:parameter:tool:mcp p.u.typ) p.u.dec]]
        ;<  our=ship  bind:m  get-our:io
        ;<  ~  bind:m
          %-  send-raw-card:io
          :*  %pass   /publish-tool
              %agent  [our %chorus]
              %poke   [%publish-tool !>([p.u.nam p.u.dec pars rex])]
          ==
        ;<  ~  bind:m  (take-poke-ack:io /publish-tool)
        %-  pure:m
        !>  ^-  json
        %-  pairs:enjs:format
        :~  ['type' s+'text']
            ['text' s+(crip "Published tool {(trip p.u.nam)}.")]
    ==  ==
==
