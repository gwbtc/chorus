/-  mcp, *chorus, verifier, spider, pals
/+  io=strandio
=,  (verifier)
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
              %poke   %chorus-action  !>(`chorus-action`[%update-bio p.u.bio])
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
              %poke   %chorus-broadcast  !>([%announce p.u.ano])
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
              %poke   %chorus-broadcast  !>([%publish-app `@tas`p.u.dek p.u.dec])
          ==
        ;<  ~  bind:m  (take-poke-ack:io /publish-app)
        %-  pure:m
        !>  ^-  json
        %-  pairs:enjs:format
        :~  ['type' s+'text']
            ['text' s+(crip "Published app %{(trip p.u.dek)}!")]
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
        ?>  ?=([%string @t] u.req)
        ?>  ?=([%string @t] u.par)
        =/  req-json  (need (de:json:html p.u.req))
        =/  par-json  (need (de:json:html p.u.par))
        ?>  ?=([%a *] req-json)
        ?>  ?=([%o *] par-json)
        =/  rex=(list @t)
          %+  turn  p.req-json
          |=  =json
          ?>  ?=([%s @t] json)
          p.json
        =/  pars=(map name:parameter:tool:mcp def:parameter:tool:mcp)
          %-  ~(gas by *(map name:parameter:tool:mcp def:parameter:tool:mcp))
          %+  turn
            ~(tap by p.par-json)
          |=  [name=@t =json]
          ^-  [name:parameter:tool:mcp def:parameter:tool:mcp]
          ?>  ?=([%o *] json)
          =/  typ  (~(get by p.json) 'type')
          =/  dec  (~(get by p.json) 'description')
          ?~  typ  ~|(%missing-parameter-type !!)
          ?~  dec  ~|(%missing-parameter-description !!)
          ?>  ?=([%s @t] u.typ)
          ?>  ?=([%s @t] u.dec)
          [name [(type:parameter:tool:mcp p.u.typ) p.u.dec]]
        ;<  our=ship  bind:m  get-our:io
        ;<  ~  bind:m
          %-  send-raw-card:io
          :*  %pass   /publish-tool
              %agent  [our %chorus]
              %poke   %chorus-broadcast  !>([%publish-tool p.u.nam p.u.dec pars rex])
          ==
        ;<  ~  bind:m  (take-poke-ack:io /publish-tool)
        %-  pure:m
        !>  ^-  json
        %-  pairs:enjs:format
        :~  ['type' s+'text']
            ['text' s+(crip "Published tool {(trip p.u.nam)}.")]
    ==  ==
    ::
    ::  Twitter/X identity attestation via %verifier / %lanyard.
    ::  Call without tweet-id to start (or resume) the process.
    ::  The tool returns tweet text to post from your Twitter account.
    ::  Once posted, call again with the numeric tweet ID to complete.
    ::
    :*  'chorus__attest-twitter'
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
        ::  XX probably not needed, just use p.u.handle
        ::  normalise handle to lowercase
        =/  handle=@t  (crip (cass (trip p.u.handle)))
        ::
        ?@  tweet-id
          ::
          ::  Phase 1: no tweet-id, check existing state then start if needed
          ::
          ;<  recs=*  bind:m
            (scry:io * /gx/lanyard/v1/records)
          =/  rec=(unit [=config why=@t =status])
            %-  ~(get by ;;((map [h=@p id=identifier] [=config why=@t =status]) recs))
            [~patpet-dopped [%twitter handle]]
          ::
          ::  already verified
          ::
          ?:  ?&  ?=(^ rec)
                  ?=(%done -.status.u.rec)
              ==
            %-  pure:m
            !>  ^-  json
            %-  pairs:enjs:format
            :~  ['type' s+'text']
                ['text' s+(rap 3 '@' handle ' is already verified on this ship.' ~)]
            ==
          ::  pending: tweet already requested, just return the text
          ::
          ?:  ?&  ?=(^ rec)
                  ?=([%want %twitter %post *] status.u.rec)
              ==
            ;<  tweet-text=tape  bind:m
              (scry:io tape [%gx %lanyard %v1 %proof %twitter handle %text ~])
            %-  pure:m
            !>  ^-  json
            %-  pairs:enjs:format
            :~  ['type' s+'text']
                :-  'text'
                :-  %s
                %-  crip
                ""
                ::  """
                ::  Attestation already in progress. Post this tweet from @{handle}, then call this tool again with the numeric tweet ID
::  
                ::  {tweet-text}
                ::  """
            ==
          ::
          ::  verifier is mid-flight, nothing to do yet
          ::
          ?:  ?&  ?=(^ rec)
                  ?=(%wait -.status.u.rec)
              ==
            %-  pure:m
            !>  ^-  json
            %-  pairs:enjs:format
            :~  ['type' s+'text']
                ['text' s+(rap 3 'Attestation of @' handle ' is in progress (' why.u.rec '). Try again shortly.' ~)]
            ==
          ::
          ::  not started: subscribe, poke %start, wait for %want
          ::
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
          !>  ^-  json
          %-  pairs:enjs:format
          :~  ['type' s+'text']
              :-  'text'
              :-  %s
              %-  crip
              """
              Post this tweet from @{(trip handle)}, then call this tool again with the numeric tweet ID:

              {tweet-text}
              """
          ==
        ::
        ::  Phase 2: tweet-id provided, submit and await result
        ::
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
        ::
            %done
          %-  pure:m
          !>  ^-  json
          %-  pairs:enjs:format
          :~  ['type' s+'text']
              ['text' s+(rap 3 'Verified! @' handle ' is now attested to ' (scot %p our) '.' ~)]
          ==
        ::
            %want
          ?.  ?=([%want %twitter %post *] status.upd)  $
          ::  nonce rotated — must post a new tweet
          ;<  tweet-text=tape  bind:m
            (scry:io tape [%gx %lanyard %v1 %proof %twitter handle %text ~])
          %-  pure:m
          !>  ^-  json
          %-  pairs:enjs:format
          :~  ['type' s+'text']
              :-  'text'
              :-  %s
              %-  crip
              """
              Tweet check failed (nonce rotated — you may need to wait 15 min before retrying).
              Post this new tweet, then call this tool again with the new tweet ID:

              {tweet-text}
              """
          ==
        ::
            %gone
          %-  pure:m
          !>  ^-  json
          %-  pairs:enjs:format
          :~  ['type' s+'text']
              ['text' s+(rap 3 'Verification failed: ' why.upd ~)]
          ==
        ==
    ==
    ::
    ::  Inverse lookup: which ship (if any) has attested a given Twitter handle?
    ::
    :*  'chorus__query-whose-twitter'
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
        !>  ^-  json
        %-  pairs:enjs:format
        :~  ['type' s+'text']
            :-  'text'
            :-  %s
            ?~  who.res
              (rap 3 'No verified Urbit ship found for @' handle '.' ~)
            (rap 3 '@' handle ' is attested to ' (scot %p u.who.res) '.' ~)
    ==  ==
    ::
    :*  'chorus__add-pal'
        'Add a ship as a pal (tagged chorus).'
        %-  my
        :~  :-  'ship'
            :-  %string
            '''
            The @p of the ship to add as a pal (e.g. '~sampel-palnet').
            '''
        ==
        ~['ship']
        ^-  thread-builder:tool:mcp
        |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
        ^-  shed:khan
        =/  m  (strand:spider ,vase)
        ^-  form:m
        =/  who  (~(get by args) 'ship')
        ?~  who  ~|(%missing-ship !!)
        ?>  ?=([%string @t] u.who)
        =/  who=ship  (slav %p p.u.who)
        ;<  our=ship  bind:m  get-our:io
        ;<  ~  bind:m
          %-  send-raw-card:io
          :*  %pass   /add-pal
              %agent  [our %pals]
              %poke   %pals-command  !>(`command:pals`[%meet who (sy ~[%chorus])])
          ==
        ;<  ~  bind:m  (take-poke-ack:io /add-pal)
        %-  pure:m
        !>  ^-  json
        %-  pairs:enjs:format
        :~  ['type' s+'text']
            ['text' s+(rap 3 'Added ' (scot %p who) ' as a pal.' ~)]
    ==  ==
    ::
    :*  'chorus__remove-pal'
        'Remove a ship from pals.'
        %-  my
        :~  :-  'ship'
            :-  %string
            '''
            The @p of the ship to remove from pals (e.g. '~sampel-palnet').
            '''
        ==
        ~['ship']
        ^-  thread-builder:tool:mcp
        |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
        ^-  shed:khan
        =/  m  (strand:spider ,vase)
        ^-  form:m
        =/  who  (~(get by args) 'ship')
        ?~  who  ~|(%missing-ship !!)
        ?>  ?=([%string @t] u.who)
        =/  who=ship  (slav %p p.u.who)
        ;<  our=ship  bind:m  get-our:io
        ;<  ~  bind:m
          %-  send-raw-card:io
          :*  %pass   /remove-pal
              %agent  [our %pals]
              %poke   %pals-command  !>(`command:pals`[%part who *(set @ta)])
          ==
        ;<  ~  bind:m  (take-poke-ack:io /remove-pal)
        %-  pure:m
        !>  ^-  json
        %-  pairs:enjs:format
        :~  ['type' s+'text']
            ['text' s+(rap 3 'Removed ' (scot %p who) ' from pals.' ~)]
    ==  ==
==
