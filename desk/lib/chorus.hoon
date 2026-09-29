/-  mcp, chorus, *content-routing
/+  md=markdown, slp=slip, mne=mnemonyms
/*  english  %txt  /fil/wordlists/english/txt
::
=>
|%
++  me  ~(. me:mne [.y 128 english])
++  mu  ~(. me:mne [.n 128 english])
--
|%
::
::  strip leading whitespace from a tape
++  strip-fore
  |=  t=tape
  ^-  tape
  ?~  t  ~
  ?:  ?|(=(' ' i.t) =('\09' i.t) =('\0d' i.t))
    $(t t.t)
  t
::
::  strip trailing whitespace from a tape
++  strip-aft
  |=  t=tape
  ^-  tape
  (flop (strip-fore (flop t)))
::
::  drop one pair of matching quotes around a tape
++  unquote
  |=  t=tape
  ^-  tape
  ?.  ?=([@ @ *] t)  t
  ?.  ?&  =(i.t (rear t))
          ?|(=('"' i.t) =('\'' i.t))
      ==
    t
  (snip `tape`t.t)
::
::  parse simple yaml frontmatter lines: unindented
::  key: value pairs, plus one optional indented block
::  of string pairs under the metadata key
++  parse-frontmatter
  |=  lines=(list @t)
  ^-  (each frontmatter:skill:chorus @t)
  =|  fields=(map @t @t)
  =|  metadata=(unit (map @t @t))
  |-
  ?~  lines
    ?~  nam=(~(get by fields) 'name')
      [%| 'missing required frontmatter field: name']
    ?~  des=(~(get by fields) 'description')
      [%| 'missing required frontmatter field: description']
    :-  %&
    ^-  frontmatter:skill:chorus
    :*  u.nam
        u.des
        (~(get by fields) 'license')
        (~(get by fields) 'compatibility')
        metadata
        (~(get by fields) 'allowed-tools')
    ==
  =/  lin=tape  (strip-aft (trip i.lines))
  ?~  lin  $(lines t.lines)
  ?:  |(=(' ' i.lin) =('\09' i.lin))
    [%| 'unexpected indented line in frontmatter']
  =/  col=(unit @ud)  (find ":" `tape`lin)
  ?~  col  [%| 'frontmatter line is not a key: value pair']
  =/  key=@t  (crip (scag u.col `tape`lin))
  ?.  =('metadata' key)
    %=  $
      lines   t.lines
      fields  %+  ~(put by fields)  key
              (crip (unquote (strip-fore (slag +(u.col) `tape`lin))))
    ==
  ::
  ::  consume the indented block under the metadata key
  =/  sub
    =/  rest=(list @t)  t.lines
    =|  acc=(map @t @t)
    |-  ^-  [acc=(map @t @t) rest=(list @t)]
    ?~  rest  [acc rest]
    =/  sin=tape  (strip-aft (trip i.rest))
    ?~  sin  $(rest t.rest)
    ?.  |(=(' ' i.sin) =('\09' i.sin))
      [acc rest]
    =/  tin=tape  (strip-fore sin)
    =/  loc=(unit @ud)  (find ":" tin)
    ?~  loc  [acc rest]
    %=  $
      rest  t.rest
      acc   %+  ~(put by acc)
              (crip (scag u.loc tin))
            (crip (unquote (strip-fore (slag +(u.loc) tin))))
    ==
  $(lines rest.sub, metadata `acc.sub)
::
::  read a SKILL.md document's typed frontmatter, checking
::  that its markdown body parses, or say why we could not
++  read-skill
  |=  txt=@t
  ^-  (each frontmatter:skill:chorus @t)
  =/  lines=(list @t)  (to-wain:format txt)
  ?.  &(?=(^ lines) =("---" (strip-aft (trip i.lines))))
    [%| 'skill must open with --- yaml frontmatter']
  =/  parts
    =/  rest=(list @t)  t.lines
    =|  yaml=(list @t)
    |-  ^-  (unit [yaml=(list @t) body=(list @t)])
    ?~  rest  ~
    ?:  =("---" (strip-aft (trip i.rest)))
      `[(flop yaml) t.rest]
    $(rest t.rest, yaml [i.rest yaml])
  ?~  parts  [%| 'frontmatter is missing its closing ---']
  =/  fam  (parse-frontmatter yaml.u.parts)
  ?:  ?=(%| -.fam)  [%| p.fam]
  ?~  (de:md (of-wain:format body.u.parts))
    [%| 'markdown body failed to parse']
  fam
::
::  check the agentskills.io constraints visible in a
::  skill's metadata; produce an error message on failure
++  vet-skill-meta
  |=  =meta:skill:chorus
  ^-  (unit @t)
  =/  nam=tape  (trip name.meta)
  =/  nel  (lent nam)
  ?:  |(=(0 nel) (gth nel 64))
    `'name must be 1-64 characters'
  ?.  %+  levy  nam
      |=  c=@t
      ?|  &((gte c 'a') (lte c 'z'))
          &((gte c '0') (lte c '9'))
          =('-' c)
      ==
    `'name may only contain lowercase letters, numbers, and hyphens'
  ?:  |(=('-' (snag 0 nam)) =('-' (rear nam)))
    `'name must not start or end with a hyphen'
  ?:  ?=(^ (find "--" nam))
    `'name must not contain consecutive hyphens'
  =/  del  (lent (trip description.meta))
  ?:  |(=(0 del) (gth del 1.024))
    `'description must be 1-1024 characters'
  ?:  (gth (lent (trip compatibility.meta)) 500)
    `'compatibility must be 500 characters or fewer'
  ~
::
::  the nym we credit a ship's words to: one-dot if the ship
::  exists under the %gw-btc domain, two-dot if not. only comets
::  have nyms, so any other ship takes the nym of its cometized
::  form
++  author-nym
  |=  [=bowl:gall who=ship]
  ^-  nym:chorus
  =/  paw=@pH
    ?:  =(%pawn (clan:title who))
      who
    (come:mu bowl who)
  ?:  (veri:mu bowl %gw-btc who)
    (de:ship:me paw)
  (de:ship:mu paw)
::
::  the comet a nym names: two-dot nyms are unverified, one-dot
::  nyms verified
++  nym-ship
  |=  =nym:chorus
  ^-  ship
  ?:  =('..' (end [3 2] nym))
    (en:ship:mu nym)
  (en:ship:me nym)
::
::  the reserved topics
++  topics
  ^-  (list topic:chorus)
  :~  %desks
      %rolodex
      %announcements
      %cabinet
      %skills
      %mcp-tools
      %mcp-prompts
      %mcp-resources
      %mcp-resource-templates
  ==
::
::  where a topic lives: its name in the %chorus namespace of
::  the content store, its topic in content discovery, and its
::  path in our %grow namespace
++  topic-path
  |=  =topic:chorus
  ^-  path
  ?-  topic
    %desks                   /chorus/desks
    %rolodex                 /chorus/rolodex
    %announcements           /chorus/announcements
    %cabinet                 /chorus/cabinet
    %skills                  /chorus/skills
    %mcp-tools               /chorus/mcp/tools
    %mcp-prompts             /chorus/mcp/prompts
    %mcp-resources           /chorus/mcp/resources
    %mcp-resource-templates  /chorus/mcp/resources/templates
  ==
::
++  path-topic
  |=  pax=path
  ^-  (unit topic:chorus)
  =/  all  topics
  |-
  ?~  all  ~
  ?:  =(pax (topic-path i.all))
    `i.all
  $(all t.all)
::
::  the mark a topic's shelf travels under
++  topic-mark
  |=  =topic:chorus
  ^-  mark
  (cat 3 'chorus-' topic)
::
::  an empty shelf
++  bare
  |=  =topic:chorus
  ^-  shelf:chorus
  ?:  ?=(%cabinet topic)
    [%cabinet *cabinet:chorus]
  ;;(shelf:chorus [topic ~])
::
::  how many things a shelf holds
++  count
  |=  =shelf:chorus
  ^-  @ud
  ?:  ?=(%cabinet -.shelf)
    (lent ~(tap of p.shelf))
  ~(wyt in `(set *)`p.shelf)
::
::  type a cask heard from .who under a topic, and check that
::  it keeps the rules we keep when we publish. produce
::  nothing for a cask that fails
++  vet-shelf
  |=  [who=ship =topic:chorus cask=(cask)]
  ^-  (unit shelf:chorus)
  ?.  =(p.cask (topic-mark topic))
    ~
  =/  got=(unit shelf:chorus)
    (mole |.(;;(shelf:chorus [topic q.cask])))
  ?~  got  ~
  =*  shelf  u.got
  =/  short  |=(txt=@t (lte (lent (trip txt)) 256))
  ?.  ?-    -.shelf
          %rolodex
        ?&  (lte ~(wyt in p.shelf) 1)
            %-  ~(all in p.shelf)
            |=(lit=listing:bio:chorus &(=(who ship.lit) (short txt.lit)))
        ==
      ::
          %announcements
        %-  ~(all in p.shelf)
        |=(lit=listing:announcement:chorus &(=(who ship.lit) (short txt.lit)))
      ::
          %desks
        %-  ~(all in p.shelf)
        |=(lit=listing:desk:chorus &(=(who ship.lit) (short desc.lit)))
      ::
          %skills
        %-  ~(all in p.shelf)
        |=  lit=listing:skill:chorus
        &(=(who ship.lit) ?=(~ (vet-skill-meta meta.lit)))
      ::
          %cabinet
        %+  levy  ~(tap of p.shelf)
        |=  [pax=path =slip:chorus]
        &(=(who ship.slip) ?=(~ (vet-slip:slp pax txt.slip)))
      ::
          %mcp-tools
        (~(all in p.shelf) |=(lit=listing:tool:mcp:chorus =(who ship.lit)))
      ::
          %mcp-prompts
        (~(all in p.shelf) |=(lit=listing:prompt:mcp:chorus =(who ship.lit)))
      ::
          %mcp-resources
        (~(all in p.shelf) |=(lit=listing:resource:mcp:chorus =(who ship.lit)))
      ::
          %mcp-resource-templates
        %-  ~(all in p.shelf)
        |=(lit=listing:template:resource:mcp:chorus =(who ship.lit))
      ==
    ~
  got
::
::  one thing to put on a shelf
+$  item
  $%  [%rolodex p=listing:bio:chorus]
      [%announcements p=listing:announcement:chorus]
      [%desks p=listing:desk:chorus]
      [%skills p=listing:skill:chorus]
      [%cabinet p=[=path =slip:chorus]]
      [%mcp-tools p=listing:tool:mcp:chorus]
      [%mcp-prompts p=listing:prompt:mcp:chorus]
      [%mcp-resources p=listing:resource:mcp:chorus]
      [%mcp-resource-templates p=listing:template:resource:mcp:chorus]
  ==
::
::  put an item on its shelf, in place of any listing of the
::  same thing: we hold one bio, one listing per desk, tool,
::  prompt, resource, template and skill, and one slip per path
++  stock
  |=  [=shelf:chorus =item]
  ^-  shelf:chorus
  ?>  =(-.shelf -.item)
  =.  shelf  (strip shelf (item-key item))
  ?-  -.item
    %rolodex        ?>(?=(%rolodex -.shelf) shelf(p (~(put in p.shelf) p.item)))
    %announcements  ?>(?=(%announcements -.shelf) shelf(p (~(put in p.shelf) p.item)))
    %desks          ?>(?=(%desks -.shelf) shelf(p (~(put in p.shelf) p.item)))
    %skills         ?>(?=(%skills -.shelf) shelf(p (~(put in p.shelf) p.item)))
    %mcp-tools      ?>(?=(%mcp-tools -.shelf) shelf(p (~(put in p.shelf) p.item)))
    %mcp-prompts    ?>(?=(%mcp-prompts -.shelf) shelf(p (~(put in p.shelf) p.item)))
    %mcp-resources  ?>(?=(%mcp-resources -.shelf) shelf(p (~(put in p.shelf) p.item)))
  ::
      %mcp-resource-templates
    ?>  ?=(%mcp-resource-templates -.shelf)
    shelf(p (~(put in p.shelf) p.item))
  ::
      %cabinet
    ?>  ?=(%cabinet -.shelf)
    shelf(p (~(put of p.shelf) path.p.item slip.p.item))
  ==
::
::  what a retraction would name to take this item back
++  item-key
  |=  =item
  ^-  retract:chorus
  ?-  -.item
    %rolodex                 [%bio ~]
    %announcements           [%announcement time.p.item]
    %desks                   [%desk desk.p.item]
    %skills                  [%agent-skill name.meta.p.item]
    %cabinet                 [%slip path.p.item]
    %mcp-tools               [%mcp-tool name.meta.p.item]
    %mcp-prompts             [%mcp-prompt name.meta.p.item]
    %mcp-resources           [%mcp-resource uri.meta.p.item]
    %mcp-resource-templates  [%mcp-resource-template uri-template.meta.p.item]
  ==
::
::  the topic a retraction touches
++  retract-topic
  |=  =retract:chorus
  ^-  topic:chorus
  ?-  -.retract
    %bio                    %rolodex
    %announcement           %announcements
    %desk                   %desks
    %agent-skill            %skills
    %slip                   %cabinet
    %mcp-tool               %mcp-tools
    %mcp-prompt             %mcp-prompts
    %mcp-resource           %mcp-resources
    %mcp-resource-template  %mcp-resource-templates
  ==
::
::  take a listing off its shelf
++  strip
  |=  [=shelf:chorus =retract:chorus]
  ^-  shelf:chorus
  ?>  =(-.shelf (retract-topic retract))
  ?-    -.shelf
      %rolodex  shelf(p ~)
      %cabinet
    ?>  ?=(%slip -.retract)
    ::  rebuild the tree, so no empty drawer stays behind
    %=    shelf
        p
      %-  ~(gas of *cabinet:chorus)
      %+  skip  ~(tap of p.shelf)
      |=([pax=path *] =(pax path.retract))
    ==
  ::
      %announcements
    ?>  ?=(%announcement -.retract)
    %=    shelf
        p
      %-  silt
      %+  skip  ~(tap in p.shelf)
      |=(lit=listing:announcement:chorus =(time.retract time.lit))
    ==
  ::
      %desks
    ?>  ?=(%desk -.retract)
    %=    shelf
        p
      %-  silt
      %+  skip  ~(tap in p.shelf)
      |=(lit=listing:desk:chorus =(desk.retract desk.lit))
    ==
  ::
      %skills
    ?>  ?=(%agent-skill -.retract)
    %=    shelf
        p
      %-  silt
      %+  skip  ~(tap in p.shelf)
      |=(lit=listing:skill:chorus =(name.retract name.meta.lit))
    ==
  ::
      %mcp-tools
    ?>  ?=(%mcp-tool -.retract)
    %=    shelf
        p
      %-  silt
      %+  skip  ~(tap in p.shelf)
      |=(lit=listing:tool:mcp:chorus =(name.retract name.meta.lit))
    ==
  ::
      %mcp-prompts
    ?>  ?=(%mcp-prompt -.retract)
    %=    shelf
        p
      %-  silt
      %+  skip  ~(tap in p.shelf)
      |=(lit=listing:prompt:mcp:chorus =(name.retract name.meta.lit))
    ==
  ::
      %mcp-resources
    ?>  ?=(%mcp-resource -.retract)
    %=    shelf
        p
      %-  silt
      %+  skip  ~(tap in p.shelf)
      |=(lit=listing:resource:mcp:chorus =(uri.retract uri.meta.lit))
    ==
  ::
      %mcp-resource-templates
    ?>  ?=(%mcp-resource-template -.retract)
    %=    shelf
        p
      %-  silt
      %+  skip  ~(tap in p.shelf)
      |=  lit=listing:template:resource:mcp:chorus
      =(uri-template.retract uri-template.meta.lit)
    ==
  ==
::
::  the shelves of many ships as one, as the old state held
::  them. sets join; cabinets merge by +shuffle
++  blend
  |=  [our=ship =topic:chorus all=(list [who=ship =shelf:chorus])]
  ^-  shelf:chorus
  ?:  ?=(%cabinet topic)
    :-  %cabinet
    %+  shuffle  our
    %+  turn  all
    |=  [who=ship =shelf:chorus]
    ?>  ?=(%cabinet -.shelf)
    [who p.shelf]
  =/  out=(set *)  ~
  |-
  ?~  all
    ;;(shelf:chorus [topic out])
  ?<  ?=(%cabinet -.shelf.i.all)
  $(all t.all, out (~(uni in out) `(set *)`p.shelf.i.all))
::
::  merge the cabinets of many ships into one tree. a slip
::  sits at the path its author keeps it at. where authors
::  share a path, ours stays put and each other author's slip
::  moves under the path to a segment naming their ship:
::  /foo/bar/~sampel and /foo/bar/~palnet
++  shuffle
  |=  [our=ship all=(list [who=ship =cabinet:chorus])]
  ^-  cabinet:chorus
  =/  slips=(list [pax=path =slip:chorus])
    %-  zing
    %+  turn  all
    |=([who=ship =cabinet:chorus] ~(tap of cabinet))
  =/  tally=(map path @ud)
    %+  roll  slips
    |=  [[pax=path *] out=(map path @ud)]
    (~(put by out) pax +((~(gut by out) pax 0)))
  %-  ~(gas of *cabinet:chorus)
  %+  turn  slips
  |=  [pax=path =slip:chorus]
  :_  slip
  ?:  |(=(our ship.slip) =(1 (~(got by tally) pax)))
    pax
  (snoc pax (scot %p ship.slip))
::
::  where a ship's slip at a path sits in the merged tree
++  spot
  |=  [our=ship all=(list [who=ship =cabinet:chorus]) who=ship pax=path]
  ^-  path
  ?:  =(our who)  pax
  ?:  %+  lien  all
      |=  [him=ship =cabinet:chorus]
      &(!=(him who) ?=(^ (~(get of cabinet) pax)))
    (snoc pax (scot %p who))
  pax
::
::  the facts a client hears when one ship's shelf changes
::  from .old to .new; slip paths are as that ship keeps them
++  updates-of
  |=  [old=shelf:chorus new=shelf:chorus]
  ^-  (list update:chorus)
  ?>  =(-.old -.new)
  ?-    -.new
      %cabinet
    ?>  ?=(%cabinet -.old)
    %+  weld
      %+  murn  ~(tap of p.old)
      |=  [pax=path *]
      ^-  (unit update:chorus)
      ?^  (~(get of p.new) pax)  ~
      `[%chorus-slip-discarded pax]
    %+  murn  ~(tap of p.new)
    |=  [pax=path =slip:chorus]
    ^-  (unit update:chorus)
    ?:  =(`slip (~(get of p.old) pax))  ~
    `[%chorus-slip pax slip]
  ::
      %rolodex
    ?>  ?=(%rolodex -.old)
    %+  turn  ~(tap in (~(dif in p.new) p.old))
    |=(lit=listing:bio:chorus `update:chorus`[%chorus-bio-updated lit])
  ::
      %announcements
    ?>  ?=(%announcements -.old)
    %+  turn  ~(tap in (~(dif in p.new) p.old))
    |=(lit=listing:announcement:chorus `update:chorus`[%chorus-announcement lit])
  ::
      %desks
    ?>  ?=(%desks -.old)
    %+  turn  ~(tap in (~(dif in p.new) p.old))
    |=(lit=listing:desk:chorus `update:chorus`[%chorus-desk-published lit])
  ::
      %skills
    ?>  ?=(%skills -.old)
    %+  turn  ~(tap in (~(dif in p.new) p.old))
    |=(lit=listing:skill:chorus `update:chorus`[%agent-skill-listed lit])
  ::
      %mcp-tools
    ?>  ?=(%mcp-tools -.old)
    %+  turn  ~(tap in (~(dif in p.new) p.old))
    |=(lit=listing:tool:mcp:chorus `update:chorus`[%mcp-tool-listed lit])
  ::
      %mcp-prompts
    ?>  ?=(%mcp-prompts -.old)
    %+  turn  ~(tap in (~(dif in p.new) p.old))
    |=(lit=listing:prompt:mcp:chorus `update:chorus`[%mcp-prompt-listed lit])
  ::
      %mcp-resources
    ?>  ?=(%mcp-resources -.old)
    %+  turn  ~(tap in (~(dif in p.new) p.old))
    |=(lit=listing:resource:mcp:chorus `update:chorus`[%mcp-resource-listed lit])
  ::
      %mcp-resource-templates
    ?>  ?=(%mcp-resource-templates -.old)
    %+  turn  ~(tap in (~(dif in p.new) p.old))
    |=  lit=listing:template:resource:mcp:chorus
    `update:chorus`[%mcp-resource-template-listed lit]
  ==
::
::  a mcp tool's metadata as json, less its closing brace:
::  pairs a caller adds to
++  tool-pairs
  |=  t=meta:tool:mcp:chorus
  ^-  (list [@t json])
  :~  ['name' s+name.t]
      ['description' s+desc.t]
      :-  'inputSchema'
      %-  pairs:enjs:format
      :~  ['type' s+'object']
          :-  'properties'
          :-  %o
          %-  ~(gas by *(map @t json))
          %+  turn  ~(tap by parameters.t)
          |=  [pname=@t =def:parameter:tool:mcp]
          :-  pname
          %-  pairs:enjs:format
          :~  ['type' s+type.def]
              ['description' s+desc.def]
          ==
          ['required' a+(turn required.t |=(r=@t s+r))]
      ==
  ==
::
++  prompt-pairs
  |=  p=meta:prompt:mcp:chorus
  ^-  (list [@t json])
  :~  ['name' s+name.p]
      ['title' s+title.p]
      ['description' s+desc.p]
      :-  'arguments'
      :-  %a
      %+  turn  arguments.p
      |=  arg=argument:prompt:mcp
      %-  pairs:enjs:format
      :~  ['name' s+name.arg]
          ['description' s+desc.arg]
          ['required' b+required.arg]
      ==
  ==
::
++  resource-pairs
  |=  r=meta:resource:mcp:chorus
  ^-  (list [@t json])
  :~  ['uri' s+uri.r]
      ['name' s+name.r]
      ['title' ?~(title.r ~ s+u.title.r)]
      ['description' ?~(desc.r ~ s+u.desc.r)]
  ==
::
++  template-pairs
  |=  r=meta:template:resource:mcp:chorus
  ^-  (list [@t json])
  :~  ['uriTemplate' s+uri-template.r]
      ['name' s+name.r]
      ['title' ?~(title.r ~ s+u.title.r)]
      ['description' ?~(desc.r ~ s+u.desc.r)]
  ==
::
++  skill-pairs
  |=  s=meta:skill:chorus
  ^-  (list [@t json])
  :~  ['name' s+name.s]
      ['description' s+description.s]
      ['compatibility' s+compatibility.s]
  ==
::
::  an update as json, shared by the update and updates marks
++  enjs-update
  |=  val=update:chorus
  ^-  json
  %-  pairs:enjs:format
  :-  ['type' [%s -.val]]
  ?-    -.val
      %chorus-bio-updated
    :~  ['ship' s+(scot %p ship.val)]
        ['bio' s+txt.val]
    ==
  ::
      %chorus-announcement
    :~  ['ship' s+(scot %p ship.val)]
        ['time' s+(scot %da time.val)]
        ['text' s+txt.val]
    ==
  ::
      %chorus-desk-published
    :~  ['ship' s+(scot %p ship.val)]
        ['desk' s+desk.val]
        ['desc' s+desc.val]
        ['hash' s+(scot %uv hash.val)]
    ==
  ::
      %mcp-tool-listed
    :*  ['ship' s+(scot %p ship.val)]
        ['source' s+(scot %uv source.val)]
        (tool-pairs meta.val)
    ==
  ::
      %mcp-prompt-listed
    :*  ['ship' s+(scot %p ship.val)]
        ['source' s+(scot %uv source.val)]
        (prompt-pairs meta.val)
    ==
  ::
      %mcp-resource-listed
    :*  ['ship' s+(scot %p ship.val)]
        ['source' s+(scot %uv source.val)]
        (resource-pairs meta.val)
    ==
  ::
      %mcp-resource-template-listed
    :*  ['ship' s+(scot %p ship.val)]
        ['source' s+(scot %uv source.val)]
        (template-pairs meta.val)
    ==
  ::
      %agent-skill-listed
    :*  ['ship' s+(scot %p ship.val)]
        ['skill' s+(scot %uv skill.val)]
        (skill-pairs meta.val)
    ==
  ::
      %chorus-slip
    ['path' s+(spat path.val)]^(slip-pairs:slp path.val slip.val)
  ::
      %chorus-slip-discarded
    ['path' s+(spat path.val)]~
  ::
      %chorus-published
    :~  ['topic' s+(spat topic.val)]
        ['done' b+done.val]
    ==
  ==
--
