/-  mcp, spider, *wick
/+  io=strandio, *wick
^-  tool:mcp
:*  'chorus/fetch-wire'
    '''
    Fetch the content a wire:// URI points at.
    Will verify the path/content as appropriate and crash if that fails.
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
    ::  each tag protocol cages its own content type
    ?+    ?~(path.wick %$ i.path.wick)
        ::  XX read /https content here
        [%error 'the wire uses a tag protocol we cannot read yet' ~]
        %fine
      ?~  content.haul
        ?:  ?=(%unknown -.verdict.haul)
          [%error err.verdict.haul ~]
        [%error 'the wire serves nothing at its path' ~]
      =/  con=^cage  u.content.haul
      ::  json content is returned as the object itself
      ?:  =(%json p.con)
        =/  jon=(each json tang)  (mule |.(;;(json q.q.con)))
        ?:  ?=(%| -.jon)
          [%error 'the wire serves malformed json' ~]
        [%result %structured p.jon]
      ::  other marks are converted to mime via their mark
      ::  file; our shed runs under the %mcp desk, so we name
      ::  our own desk for marks, and check the mark exists
      ::  first since a failed scry would kill the thread; a
      ::  hyphenated mark may live flat or in nested folders
      =/  bek=path  /(scot %p our.bowl)/chorus/(scot %da now.bowl)
      =/  marked=?
        ?|  .^(? %cu (welp bek /mar/[p.con]/hoon))
            =/  segs=(unit (list @ta))
              (rush p.con (most hep (cook crip (plus ;~(pose low nud)))))
            ?~  segs  |
            .^(? %cu (welp bek (welp /mar (snoc `path`u.segs %hoon))))
        ==
      ?:  &(!=(%mime p.con) !marked)
        [%error (crip "the wire serves a mark we cannot read: {<p.con>}") ~]
      =/  mym=(each mime tang)
        %-  mule  |.
        ^-  mime
        ?:  =(%mime p.con)
          ;;(mime q.q.con)
        =/  =dais:clay
          .^(dais:clay %cb /(scot %p our.bowl)/chorus/(scot %da now.bowl)/[p.con])
        =/  =tube:clay
          .^(tube:clay %cc /(scot %p our.bowl)/chorus/(scot %da now.bowl)/[p.con]/mime)
        !<(mime (tube (vale:dais q.q.con)))
      ?:  ?=(%| -.mym)
        :+  %error
          (crip "could not convert mark {<p.con>} to mime")
        `a+(turn (scag 10 p.mym) |=(t=tank s+(crip ~(ram re t))))
      :-  %result
      :-  %structured
      %-  pairs:enjs:format
      :~  ['mimeType' s+(rsh 3^1 (spat p.p.mym))]
          ['data' s+(en:base64:mimes:html q.p.mym)]
      ==
    ==
==
