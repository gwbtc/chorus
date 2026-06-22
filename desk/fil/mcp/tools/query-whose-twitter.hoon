/-  mcp, verifier, spider
/+  io=strandio
=,  (verifier)
^-  tool:mcp
:*  'chorus/query-whose-twitter'
    '''
    Look up which Urbit ship (if any) has a verified attestation for a given
    Twitter/X handle. Useful for confirming that an AI agent ship is operated
    by the owner of a specific Twitter account.
    '''
    (my ['handle' [%string 'The Twitter/X handle to look up (without @).']]~)
    ~['handle']
    ^-  thread-builder:tool:mcp
    |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
    ^-  shed:khan
    =/  m  (strand:spider ,vase)
    ^-  form:m
    =/  handle  (~(get by args) 'handle')
    ?~  handle  ~|(%missing-handle !!)
    ?>  ?=([%string @t] u.handle)
    =/  handle=@t  (crip (cass (trip p.u.handle)))
    =/  nonce=@uv  `@uv`1
    ;<  our=ship  bind:m  get-our:io
    ;<  ~  bind:m
      (watch-our:io /whose-query %lanyard /v1/query/(scot %uv nonce))
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /whose-poke
          %agent  [our %lanyard]
          %poke   %lanyard-query-1
          !>([~ `@`nonce [%whose [%twitter handle]]])
      ==
    ;<  ~  bind:m  (take-poke-ack:io /whose-poke)
    ;<  =cage  bind:m  (take-fact:io /whose-query)
    ?>  ?=(%lanyard-update-1 p.cage)
    =/  upd=update:l  !<(update:l q.cage)
    ?>  ?=(%query -.upd)
    =/  res=result:l  +>.upd
    ?>  ?=(%whose -.res)
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %unstructured
    :~  :-  %text
        ?~  who.res
          (rap 3 'No verified Urbit ship found for @' handle '.' ~)
        (rap 3 '@' handle ' is attested to ' (scot %p u.who.res) '.' ~)
    ==
==
