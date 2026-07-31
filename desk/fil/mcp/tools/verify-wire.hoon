/-  mcp, spider, *wick
/+  io=strandio, *wick
^-  tool:mcp
:*  'chorus/verify-wire'
    '''
    Verify a wire:// URI: check that the ship it names really
    signed the path it points at, and the content served there
    if its wick signed content. Reports the reason on failure.
    '''
    %-  my
    :~  :-  'wire'
        :-  %string
        '''
        The wire:// URI to verify.
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
      [%error (crip "could not verify the wick: {<term>}") ~]
    ?>  =(%thread-done p.cage)
    =/  =verdict  verdict:!<(haul q.cage)
    ?:  ?=(%verified -.verdict)
      :-  %result
      :-  %structured
      (frond:enjs:format %verified b+&)
    ?:  ?=(%unknown -.verdict)
      [%error (crip "could not check the wire: {(trip err.verdict)}") ~]
    [%error err.verdict ~]
==
