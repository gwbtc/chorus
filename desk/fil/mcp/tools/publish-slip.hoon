/-  chorus, mcp, spider
/+  io=strandio, slp=slip
^-  tool:mcp
:*  'chorus/publish-slip'
    '''
    Publish a slip to this ship's cabinet: a note of at most
    2,048 characters of GitHub-flavoured Markdown, with no HTML
    and no frontmatter. Publishing to a path that already holds
    our slip replaces it. Open the slip with a one-line summary;
    clients show that line in their indexes. Link to other slips
    with [[<address>]], where the address is the author's ship
    and then the slip's cabinet path, e.g. /~sampel/projects/foo.
    Returns the slip's path and address, or an error explaining
    why the slip was refused.
    '''
    %-  my
    :~  :-  'path'
        :-  %string
        '''
        The cabinet path, beginning with a /, e.g.
        /projects/chorus/kademlia. Must be a valid Hoon path / (list knot).
        The last path segment is the slip's title; the rest are nested drawers.
        '''
        :-  'text'
        :-  %string
        'The Markdown body of the slip.'
        :-  'public'
        :-  %boolean
        '''
        Publish to every ship that polls us. Defaults to true.
        False keeps the slip in this ship's own namespace,
        where Chorus cannot yet read it back.
        '''
        :-  'created'
        :-  %string
        '''
        Optional @da the slip was first written, e.g.
        ~2026.9.17..16.37.23, for restoring a slip from a backup.
        Leave out to stamp the slip with the present time.
        '''
    ==
    ~['path' 'text']
    ^-  thread-builder:tool:mcp
    |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
    ^-  shed:khan
    =/  m  (strand:spider ,vase)
    ^-  form:m
    =/  pat  (~(get by args) 'path')
    =/  txt  (~(get by args) 'text')
    ?~  pat
      (pure:m !>([%error %missing-path ~]))
    ?~  txt
      (pure:m !>([%error %missing-text ~]))
    ?>  ?=([%string @t] u.pat)
    ?>  ?=([%string @t] u.txt)
    =/  public=?  !=([~ %boolean |] (~(get by args) 'public'))
    =/  wen  (~(get by args) 'created')
    =/  created=(unit @da)
      ?.  ?=([~ %string @t] wen)  `*@da
      (slaw %da p.u.wen)
    ?~  created
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error 'could not parse created; it must be a @da' ~]
    ;<  our=ship  bind:m  get-our:io
    ::  vet the slip here, so a bad one comes back as a
    ::  helpful error rather than a failed poke
    =/  pax=(unit path)  (rush p.u.pat stap)
    ?~  pax
      %-  pure:m
      !>  ^-  response:tool:mcp
      :+  %error
        '''
        could not parse the path; it must look like /drawer/slug,
        in lowercase letters, numbers, and hyphens
        '''
      ~
    =/  err  (vet-slip:slp u.pax p.u.txt)
    ?^  err
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error u.err ~]
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /publish-slip
          %agent  [our %chorus]
          %poke   %chorus-publish
          !>  ^-  publish:chorus
          [public %slip u.pax our u.created p.u.txt]
      ==
    ;<  ~  bind:m  (take-poke-ack:io /publish-slip)
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %structured
    %-  pairs:enjs:format
    :~  ['path' s+(spat u.pax)]
        ['address' s+(spat (address:slp our u.pax))]
    ==
==
