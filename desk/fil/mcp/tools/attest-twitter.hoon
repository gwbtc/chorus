/-  mcp, *chorus, verifier, spider
/+  io=strandio
=,  (verifier)
^-  tool:mcp
:*  'chorus/attest-twitter'
    '''
    Attest that a Twitter/X account is associated with this Urbit ship.

    Call without tweet-id to start the attestation and get the tweet to post.
    After posting that tweet, call again with the numeric tweet ID (from the
    tweet URL) to complete verification.
    '''
    %-  my
    :~  :-  'handle'
        :-  %string
        'The Twitter/X handle to attest (lowercase, without @).'
        :-  'tweet-id'
        :-  %string
        'Numeric tweet ID after posting the attestation tweet. Omit on first call.'
    ==
    ~['handle']
    ^-  thread-builder:tool:mcp
    |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
    ^-  shed:khan
    =/  m  (strand:spider ,vase)
    ^-  form:m
    =/  handle    (~(get by args) 'handle')
    =/  tweet-id  (~(get by args) 'tweet-id')
    ?~  handle
      ~|(%missing-handle !!)
    ?>  ?=([%string @t] u.handle)
    =/  handle=@t  (crip (cass (trip p.u.handle)))
    ?@  tweet-id
      ;<  recs=*  bind:m
        (scry:io * /gx/lanyard/v1/records)
      =/  rec=(unit [=config why=@t =status])
        %-  ~(get by ;;((map [h=@p id=identifier] [=config why=@t =status]) recs))
        [~patpet-dopped [%twitter handle]]
      ?:  ?&  ?=(^ rec)
              ?=(%done -.status.u.rec)
          ==
        %-  pure:m
        !>  ^-  response:tool:mcp
        :-  %result
        :-  %unstructured
        :~  [%text (rap 3 '@' handle ' is already verified on this ship.' ~)]
        ==
      ?:  ?&  ?=(^ rec)
              ?=([%want %twitter %post *] status.u.rec)
          ==
        ;<  tweet-text=tape  bind:m
          (scry:io tape [%gx %lanyard %v1 %proof %twitter handle %text ~])
        %-  pure:m
        !>  ^-  response:tool:mcp
        :-  %result
        :-  %unstructured
        :~  [%text '']
        ==
      ?:  ?&  ?=(^ rec)
              ?=(%wait -.status.u.rec)
          ==
        %-  pure:m
        !>  ^-  response:tool:mcp
        :-  %result
        :-  %unstructured
        :~  [%text (rap 3 'Attestation of @' handle ' is in progress (' why.u.rec '). Try again shortly.' ~)]
        ==
      ;<  our=ship  bind:m  get-our:io
      ;<  ~  bind:m
        (watch-our:io /attest-wait %lanyard /v1/records)
      ;<  ~  bind:m
        %-  send-raw-card:io
        :*  %pass   /attest-start
            %agent  [our %lanyard]
            %poke   %lanyard-command-1
            !>(`command:l`[~ %start [%twitter handle]])
        ==
      ;<  ~  bind:m  (take-poke-ack:io /attest-start)
      |-  ^-  form:m
      ;<  =cage  bind:m  (take-fact:io /attest-wait)
      ?>  ?=(%lanyard-update-1 p.cage)
      =/  upd=update:l  !<(update:l q.cage)
      ?.  ?=(%status -.upd)  $
      ?.  =(~patpet-dopped host.upd)  $
      ?.  =([%twitter handle] id.upd)  $
      ?.  ?=([%want %twitter %post *] status.upd)  $
      ;<  tweet-text=tape  bind:m
        (scry:io tape [%gx %lanyard %v1 %proof %twitter handle %text ~])
      %-  pure:m
      !>  ^-  response:tool:mcp
      :-  %result
      :-  %unstructured
      :~  :-  %text
          %-  crip
          """
          Post this tweet from @{(trip handle)}, then call this tool again with the numeric tweet ID:

          {tweet-text}
          """
      ==
    ?>  ?=([%string @t] u.tweet-id)
    =/  tweet-id=@t  p.u.tweet-id
    ;<  our=ship  bind:m  get-our:io
    ;<  ~  bind:m
      (watch-our:io /attest-wait %lanyard /v1/records)
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /attest-work
          %agent  [our %lanyard]
          %poke   %lanyard-command-1
          !>(`command:l`[~ %work [%twitter handle] %twitter %post tweet-id])
      ==
    ;<  ~  bind:m  (take-poke-ack:io /attest-work)
    |-  ^-  form:m
    ;<  =cage  bind:m  (take-fact:io /attest-wait)
    ?>  ?=(%lanyard-update-1 p.cage)
    =/  upd=update:l  !<(update:l q.cage)
    ?.  ?=(%status -.upd)  $
    ?.  =(~patpet-dopped host.upd)  $
    ?.  =([%twitter handle] id.upd)  $
    ?+  -.status.upd  $
        %done
      %-  pure:m
      !>  ^-  response:tool:mcp
      :-  %result
      :-  %unstructured
      :~  [%text (rap 3 'Verified! @' handle ' is now attested to ' (scot %p our) '.' ~)]
      ==
        %want
      ?.  ?=([%want %twitter %post *] status.upd)  $
      ;<  tweet-text=tape  bind:m
        (scry:io tape [%gx %lanyard %v1 %proof %twitter handle %text ~])
      %-  pure:m
      !>  ^-  response:tool:mcp
      :-  %result
      :-  %unstructured
      :~  :-  %text
          %-  crip
          """
          Tweet check failed (nonce rotated — you may need to wait 15 min before retrying).
          Post this new tweet, then call this tool again with the new tweet ID:

          {tweet-text}
          """
      ==
        %gone
      %-  pure:m
      !>  ^-  response:tool:mcp
      :-  %result
      :-  %unstructured
      :~  [%text (rap 3 'Verification failed: ' why.upd ~)]
      ==
    ==
==
