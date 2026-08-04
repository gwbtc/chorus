/-  mcp, spider, *wick
/+  io=strandio, *wick
^-  tool:mcp
:*  'chorus/fetch-wire'
    '''
    Fetch the content a wire:// URI points at, and verify what
    its signature covers: a contentful wire signed the content
    itself, while a path-only wire signed only the path, so its
    content comes back unverified. Reports the content with the
    verification status.
    '''
    %-  my
    :~  :-  'wire'
        :-  %string
        '''
        The wire:// URI to fetch.
        '''
    ==
    ~['wire']
    ^-  thread-builder:tool:mcp
    |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
    ^-  shed:khan
    =/  m  (strand:spider ,vase)
    ^-  form:m
    =/  wir  (~(get by args) 'wire')
    ?~  wir
      ~|(%missing-argument !!)
    ?>  ?=([%string @t] u.wir)
    ;<  =bowl:spider  bind:m  get-bowl:io
    =/  =wick  (wire-to-wick our.bowl now.bowl p.u.wir)
    ::  +await-thread:io would look for the thread on the desk that
    ::  ran this tool, which is not ours, so we name our own beak
    =/  tid=@ta
      (scot %ta (cat 3 'strand_' (scot %uv (sham %fetch-wick eny.bowl))))
    ;<  ~  bind:m
      (watch-our:io /awaiting/[tid] %spider /thread-result/[tid])
    ;<  ~  bind:m
      %+  poke-our:io  %spider
      :-  %spider-start
      !>  ^-  start-args:spider
      [`tid.bowl `tid [our.bowl %chorus da+now.bowl] %fetch-wick !>(wick)]
    ;<  =cage  bind:m  (take-fact:io /awaiting/[tid])
    ;<  ~      bind:m  (take-kick:io /awaiting/[tid])
    %-  pure:m
    !>  ^-  response:tool:mcp
    ?:  =(%thread-fail p.cage)
      =+  !<([=term =tang] q.cage)
      [%error (crip "could not fetch the wire: {<term>}") ~]
    ?>  =(%thread-done p.cage)
    =/  =haul  !<(haul q.cage)
    ?:  ?=(%failed -.verdict.haul)
      [%error err.verdict.haul ~]
    ::  each tag protocol vases its own content type
    ?+    ?~(path.wick %$ i.path.wick)
        ::  XX de-vase /https content here
        [%error 'the wire uses a tag protocol we cannot read yet' ~]
        %fine
      ?~  content.haul
        ?:  ?=(%unknown -.verdict.haul)
          [%error err.verdict.haul ~]
        [%error 'the wire serves nothing at its path' ~]
      =/  con=^cage  u.content.haul
      :-  %result
      :-  %structured
      %-  pairs:enjs:format
      :~  ['verified' b+?=(%verified -.verdict.haul)]
        ::
          :-  'status'
          :-  %s
          ?:  ?=(%unknown -.verdict.haul)
            (cat 3 'unverified: ' err.verdict.haul)
          ?:  flag.wick
            'the ship signed the path of this wire, but its signature does not cover this content'
          'the ship signed this content'
        ::
          ['mark' s+p.con]
        ::
          :-  'content'
          :-  %s
          ?:  &(?=(@ q.q.con) ((sane %t) `@t`q.q.con))
            `@t`q.q.con
          (crip (noah q.con))
      ==
    ==
==
