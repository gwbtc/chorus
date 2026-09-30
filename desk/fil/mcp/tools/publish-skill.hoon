/-  chorus, mcp, spider, *content-routing, *content-store
/+  io=strandio, cho=chorus, cr=content-routing
/+  client=content-store-client
=>
|%
::
::  read each extra skill file, a path into the given clay
::  desk, as a cask of its text
++  aux-casks
  |=  [our=ship now=@da dek=@tas args=(list argument:tool:mcp)]
  ^-  (each (list (cask)) @t)
  =|  out=(list (cask))
  |-
  ?~  args
    [%& (flop out)]
  ?.  ?=([%string @t] i.args)
    [%| 'skill file paths must be strings']
  =*  txt  p.i.args
  ?:  =('https://' (end [3 8] txt))
    [%| 'https skill files are not yet supported']
  =/  pax=(unit path)  (rush txt stap)
  ?:  |(?=(~ pax) ?=(~ u.pax))
    [%| (crip "could not parse the path {(trip txt)}")]
  =/  got=(unit @t)  (read-text our now dek u.pax)
  ?~  got
    [%| (crip "no readable file at {(trip txt)} on desk %{(trip dek)}")]
  $(args t.args, out [[(rear u.pax) u.got] out])
::
::  read the text at a clay path on the given desk
++  read-text
  |=  [our=ship now=@da dek=@tas pax=path]
  ^-  (unit @t)
  ?.  .^(? %cu (welp /(scot %p our)/[dek]/(scot %da now) pax))
    ~
  (mole |.(;;(@t .^(* %cx (welp /(scot %p our)/[dek]/(scot %da now) pax)))))
--
^-  tool:mcp
:*  'chorus/publish-skill'
    '''
    Publish an agent skill, per the agentskills.io specification,
    to the Chorus network. Takes a Clay path to the SKILL.md file
    and optional lists of paths to its references, scripts, and
    assets files. Checks the skill against the spec, stores every
    file in the content store, and lists the skill with the
    digest of each. Returns an error explaining any spec violation.
    '''
    %-  my
    :~  :-  'desk'
        :-  %string
        'The desk holding the skill files.'
        :-  'skill'
        :-  %string
        '''
        The path to the SKILL.md file: a Clay path on the desk,
        beginning with a / and ending with its mark, e.g.
        /fil/skills/my-skill/skill/md.
        '''
        :-  'references'
        :-  %array
        '''
        Optional paths to the files in the skill's references
        directory, as an array of strings. Each is a Clay path on
        the same desk. The published skill carries the digest of
        each file.
        '''
        :-  'scripts'
        :-  %array
        'Like references, for the scripts directory.'
        :-  'assets'
        :-  %array
        'Like references, for the assets directory.'
        :-  'public'
        :-  %boolean
        '''
        Publish to every ship that polls us. Defaults to false,
        which lists it on this ship alone: our own scries show
        it, and no ship that polls us hears of it.
        '''
    ==
    ~['desk' 'skill']
    ^-  thread-builder:tool:mcp
    |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
    ^-  shed:khan
    =/  m  (strand:spider ,vase)
    ^-  form:m
    =/  dek  (~(get by args) 'desk')
    =/  pat  (~(get by args) 'skill')
    ?~  dek  ~|(%missing-desk !!)
    ?~  pat  ~|(%missing-skill !!)
    ?>  ?=([%string @t] u.dek)
    ?>  ?=([%string @t] u.pat)
    =/  dsk  `@tas`p.u.dek
    =/  public=?  =([~ %boolean &] (~(get by args) 'public'))
    ;<  =bowl:spider  bind:m  get-bowl:io
    =*  our  our.bowl
    =*  now  now.bowl
    ::  read and vet the skill document, so a bad one comes
    ::  back as a helpful error rather than a failed poke
    =/  pax=(unit path)  (rush p.u.pat stap)
    ?~  pax
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error 'could not parse the skill path' ~]
    =/  txt=(unit @t)  (read-text our now dsk u.pax)
    ?~  txt
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error (crip "no readable skill file at {(trip p.u.pat)}") ~]
    =/  red  (read-skill:cho u.txt)
    ?:  ?=(%| -.red)
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error p.red ~]
    =/  err
      %-  vet-skill-meta:cho
      [name.p.red description.p.red (fall compatibility.p.red '')]
    ?^  err
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error u.err ~]
    ::  read the extra skill files
    =/  ref-args=(list argument:tool:mcp)
      =/  a  (~(get by args) 'references')
      ?.(?=([~ %array *] a) ~ p.u.a)
    =/  scr-args=(list argument:tool:mcp)
      =/  a  (~(get by args) 'scripts')
      ?.(?=([~ %array *] a) ~ p.u.a)
    =/  ass-args=(list argument:tool:mcp)
      =/  a  (~(get by args) 'assets')
      ?.(?=([~ %array *] a) ~ p.u.a)
    =/  refs  (aux-casks our now dsk ref-args)
    ?:  ?=(%| -.refs)
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error p.refs ~]
    =/  scrs  (aux-casks our now dsk scr-args)
    ?:  ?=(%| -.scrs)
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error p.scrs ~]
    =/  asts  (aux-casks our now dsk ass-args)
    ?:  ?=(%| -.asts)
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error p.asts ~]
    =/  bod=(cask)  [%md u.txt]
    =/  ski=skill:chorus
      :*  p.red
          (digest-cask:cr bod)
          (turn p.refs digest-cask:cr)
          (turn p.scrs digest-cask:cr)
          (turn p.asts digest-cask:cr)
      ==
    ::  a public skill's files go in the content store, where
    ::  a peer fetches each by its digest
    ;<  ~  bind:m
      ?.  public  (pure:(strand:spider ,~) ~)
      %-  send-raw-cards:io
      %-  zing
      %+  turn  [bod :(weld p.refs p.scrs p.asts)]
      |=  file=(cask)
      ::  chorus forgets the operation when it hears the result
      =/  id=content-store-id  (end 6 (shax (jam [now file])))
      %:  start:client
        our
        %chorus
        id
        %chorus
        /stow/(scot %uv id)
        (put:client id file unnamed:client ~)
      ==
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /publish-skill
          %agent  [our %chorus]
          %poke   %chorus-publish
          !>(`publish:chorus`[public %agent-skill ski])
      ==
    ;<  ~  bind:m  (take-poke-ack:io /publish-skill)
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %structured
    (frond:enjs:format %published-agent-skill s+name.frontmatter.ski)
==
