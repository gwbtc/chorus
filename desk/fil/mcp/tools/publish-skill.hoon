/-  chorus, mcp, spider, *wick
/+  io=strandio, gossip, cho=chorus, *wick
=>
|%
::
::  sign a contentful wick for each extra skill file: a
::  path into the given clay desk, or a fully-qualified
::  /fine path we serve ourselves
::  XX sign /https and other protocols here
++  aux-wicks
  |=  [our=ship now=@da dek=@tas args=(list argument:tool:mcp)]
  ^-  (each (list wick) @t)
  =|  out=(list wick)
  |-
  ?~  args
    [%& (flop out)]
  ?.  ?=([%string @t] i.args)
    [%| 'skill file paths must be strings']
  =*  txt  p.i.args
  ?:  =('https://' (end [3 8] txt))
    [%| 'https skill files are not yet supported']
  =/  pax=(unit path)  (rush txt stap)
  ?~  pax
    [%| (crip "could not parse the path {(trip txt)}")]
  ?:  ?=([%fine @ *] u.pax)
    ?.  =((scot %p our) i.t.u.pax)
      [%| (crip "{(trip txt)} is not served by our ship")]
    =/  wik=(unit wick)  (mole |.((make-fine-wick:cho our now u.pax)))
    ?~  wik
      [%| (crip "could not sign the content at {(trip txt)}")]
    $(args t.args, out [u.wik out])
  ?.  .^(? %cu (welp /(scot %p our)/[dek]/(scot %da now) u.pax))
    [%| (crip "no file at {(trip txt)} on desk %{(trip dek)}")]
  $(args t.args, out [(make-clay-wick:cho our now dek u.pax) out])
::
::  read the text a skill file path serves: a clay path on
::  the given desk, or a /fine path we serve ourselves
++  read-text
  |=  [our=ship now=@da dek=@tas pax=path]
  ^-  (unit @t)
  ?:  ?=([%fine @ *] pax)
    ?.  =((scot %p our) i.t.pax)
      ~
    %-  mole
    |.
    =/  sag  (our-sage:cho our pax)
    ;;(@t q:;;(page q.sag))
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
    assets files. Checks the skill against the spec, signs a wick
    for every file, and gossips a signed listing. Returns an error
    explaining any spec violation.
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
        /fil/skills/my-skill/skill/md, or a fully-qualified /fine
        remote scry path this ship serves.
        '''
        :-  'references'
        :-  %array
        '''
        Optional paths to the files in the skill's references
        directory, as an array of strings. Each is a Clay path on
        the same desk, or a fully-qualified /fine remote scry path
        this ship serves. The published skill carries a signed
        wire for each file.
        '''
        :-  'scripts'
        :-  %array
        'Like references, for the scripts directory.'
        :-  'assets'
        :-  %array
        'Like references, for the assets directory.'
        :-  'crowd'
        :-  %array
        '''
        Optional audience, an array of strings: ['local'] keeps
        it on this ship; a single class like ['kids'], ['fief'],
        ['sein'], or ['city'] sends it straight to those ships;
        ship names like ['~sampel', '~palnet'] send it to the
        listed ships. Leave out to gossip to our subscribers.
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
    ::  sanitise the crowd argument: absent defers to the
    ::  standing gossip config
    =/  crowd=(unit crowd:gossip)
      =/  arg  (~(get by args) 'crowd')
      ?.  ?=([~ %array *] arg)  ~
      =/  txts=(list @t)
        %+  turn  p.u.arg
        |=  a=argument:tool:mcp
        ?>(?=([%string @t] a) p.a)
      ?:  =(~['local'] txts)  `~
      =/  who=(unit whos:gossip)
        ?.  ?=([@ ~] txts)  ~
        ((soft whos:gossip) i.txts)
      ?^  who  `[%whos u.who]
      `[%ships (turn txts |=(t=@t (slav %p t)))]
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
    ::  sign contentful wicks for the extra skill files
    =/  ref-args=(list argument:tool:mcp)
      =/  a  (~(get by args) 'references')
      ?.(?=([~ %array *] a) ~ p.u.a)
    =/  scr-args=(list argument:tool:mcp)
      =/  a  (~(get by args) 'scripts')
      ?.(?=([~ %array *] a) ~ p.u.a)
    =/  ass-args=(list argument:tool:mcp)
      =/  a  (~(get by args) 'assets')
      ?.(?=([~ %array *] a) ~ p.u.a)
    =/  refs  (aux-wicks our now dsk ref-args)
    ?:  ?=(%| -.refs)
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error p.refs ~]
    =/  scrs  (aux-wicks our now dsk scr-args)
    ?:  ?=(%| -.scrs)
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error p.scrs ~]
    =/  asts  (aux-wicks our now dsk ass-args)
    ?:  ?=(%| -.asts)
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error p.asts ~]
    ::  the body wick signs the SKILL.md file itself
    =/  bod  (aux-wicks our now dsk ~[[%string p.u.pat]])
    ?:  ?=(%| -.bod)
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error p.bod ~]
    ?~  p.bod
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error 'could not sign the skill file' ~]
    =/  ski=skill:chorus
      [p.red i.p.bod p.refs p.scrs p.asts]
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /publish-skill
          %agent  [our %chorus]
          %poke   %chorus-action
          !>(`action:chorus`[%publish crowd %agent-skill ski])
      ==
    ;<  ~  bind:m  (take-poke-ack:io /publish-skill)
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %structured
    (frond:enjs:format %published-agent-skill s+name.frontmatter.ski)
==
