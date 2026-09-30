/-  chorus, mcp, spider
/+  io=strandio, slp=slip
^-  tool:mcp
:*  'chorus/publish-slip'
    '''
    Publish a slip to this ship's cabinet: a note of at most
    2,048 characters of GitHub-flavoured Markdown, with no HTML
    and no frontmatter. Publishing to a path that already holds
    our slip replaces it with a new revision. Open the slip with
    a one-line summary; clients show that line in their indexes.
    Link to other slips with [[<fqsp>]], where the FQSP is the
    remote scry path of a slip revision, e.g.
    /~host/g/x/{revision-number}/chorus//1/chorus/cabinet/{+path}.
    Returns the slip's path and FQSP, or an error explaining
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
        Publish to every ship that polls us. Defaults to false,
        which keeps the slip on this ship alone: our own cabinet
        shows it, and no ship that polls us hears of it.
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
    =/  public=?  =([~ %boolean &] (~(get by args) 'public'))
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
          [public %slip u.pax p.u.txt]
      ==
    ;<  ~  bind:m  (take-poke-ack:io /publish-slip)
    ::  the agent stamps the slip, so read its fqsp back
    ;<  [* =slip:chorus]  bind:m
      %+  scry:io  ,[path slip:chorus]
      (weld /gx/chorus/cabinet/slip (snoc u.pax %noun))
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %structured
    %-  pairs:enjs:format
    :~  ['path' s+(spat u.pax)]
        ['fqsp' s+(spat fqsp.slip)]
    ==
==
