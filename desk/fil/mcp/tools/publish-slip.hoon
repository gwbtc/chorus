/-  chorus, mcp, spider, *wick
/+  io=strandio, slp=slip, *wick
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
    /~host/g/x/{revision-number}/chorus//1/cabinet/{+path}/<slug>.
    Returns the slip's FQSP and wire, or an error explaining
    why the slip was refused.
    '''
    %-  my
    :~  :-  'path'
        :-  %string
        '''
        The cabinet path, beginning with a /, e.g.
        /projects/chorus/wick-signing. Must be a valid Hoon path / (list knot).
        The last path segment is the slip's title; the rest are nested drawers.
        '''
        :-  'text'
        :-  %string
        'The Markdown body of the slip.'
        :-  'gossip'
        :-  %boolean
        '''
        Share the slip with our gossip subscribers. Defaults to
        false, which keeps the slip on this ship.
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
    ;<  =bowl:spider  bind:m  get-bowl:io
    =*  our  our.bowl
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
    =/  err  (vet-slip:slp our u.pax p.u.txt)
    ?^  err
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error u.err ~]
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /publish-slip
          %agent  [our %chorus]
          %poke   %chorus-action
          !>  ^-  action:chorus
          :+  %publish
            ?:(=([~ %boolean &] (~(get by args) 'gossip')) ~ `~)
          [%slip u.pax our now.bowl p.u.txt]
      ==
    ;<  ~  bind:m  (take-poke-ack:io /publish-slip)
    ;<  [* =wick]  bind:m
      %+  scry:io  ,[slip:chorus wick]
      (weld /gx/chorus/cabinet/slip (snoc u.pax %noun))
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %structured
    %-  pairs:enjs:format
    :~  ['fqsp' s+(spat (slag 1 `path`path.wick))]
        ['wire' s+(wick-to-wire wick)]
    ==
==
