/-  chorus, mcp, spider
/+  io=strandio
^-  tool:mcp
:*  'chorus/hearsay'
    '''
    Publish text at a topic of our own choosing. Chorus keeps
    no rules for such topics and makes no promises about them:
    a ship that knows the topic may ask for it, and hears
    whatever we last put there. Topics under /chorus are
    reserved.
    '''
    %-  my
    :~  :-  'topic'
        :-  %string
        '''
        The topic, a path beginning with a /, of at most eight
        segments of lowercase letters, numbers, and hyphens,
        e.g. /recipes/soup.
        '''
        :-  'text'
        :-  %string
        'The text to publish.'
        :-  'public'
        :-  %boolean
        '''
        Publish to any ship that asks. Defaults to true. False
        keeps the text in this ship's own namespace.
        '''
    ==
    ~['topic' 'text']
    ^-  thread-builder:tool:mcp
    |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
    ^-  shed:khan
    =/  m  (strand:spider ,vase)
    ^-  form:m
    =/  top  (~(get by args) 'topic')
    =/  txt  (~(get by args) 'text')
    ?~  top
      (pure:m !>([%error %missing-topic ~]))
    ?~  txt
      (pure:m !>([%error %missing-text ~]))
    ?>  ?=([%string @t] u.top)
    ?>  ?=([%string @t] u.txt)
    =/  public=?  !=([~ %boolean |] (~(get by args) 'public'))
    =/  pax=(unit path)  (rush p.u.top stap)
    ?:  |(?=(~ pax) ?=(~ u.pax) (gth (lent u.pax) 8))
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error 'could not parse the topic; it must look like /one/two' ~]
    ?:  ?=([%chorus *] u.pax)
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error 'topics under /chorus are reserved' ~]
    ;<  our=ship  bind:m  get-our:io
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /hearsay
          %agent  [our %chorus]
          %poke   %chorus-hearsay
          !>(`hearsay:chorus`[public u.pax %txt p.u.txt])
      ==
    ;<  ~  bind:m  (take-poke-ack:io /hearsay)
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %structured
    (frond:enjs:format %published s+p.u.top)
==
