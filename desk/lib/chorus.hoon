/-  mcp, chorus, *wick
/+  *wick, md=markdown, slp=slip
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
::  replay heard listings from state as missives,
::  one arm per kind of listing
::
++  replay-bios
  |=  sat=state-0:chorus
  ^-  (list missive:chorus)
  %+  turn  ~(tap by rolodex.sat)
  |=  [* lit=listing:bio:chorus]
  ^-  missive:chorus
  [%chorus-bio txt.lit wick.lit]
::
++  replay-announcements
  |=  sat=state-0:chorus
  ^-  (list missive:chorus)
  %-  zing
  %+  turn  ~(tap by announcements.sat)
  |=  [* liz=(set listing:announcement:chorus)]
  %+  turn  ~(tap in liz)
  |=  lit=listing:announcement:chorus
  ^-  missive:chorus
  [%chorus-announcement txt.lit wick.lit]
::
++  replay-desks
  |=  sat=state-0:chorus
  ^-  (list missive:chorus)
  %-  zing
  %+  turn  ~(tap by desks.sat)
  |=  [* liz=(set listing:desk:chorus)]
  %+  turn  ~(tap in liz)
  |=  lit=listing:desk:chorus
  ^-  missive:chorus
  [%chorus-desk [desk.lit desc.lit] wick.lit]
::
++  replay-mcp-tools
  |=  sat=state-0:chorus
  ^-  (list missive:chorus)
  %-  zing
  %+  turn  ~(tap by mcp-tools.sat)
  |=  [* liz=(set listing:tool:mcp:chorus)]
  %+  turn  ~(tap in liz)
  |=  lit=listing:tool:mcp:chorus
  ^-  missive:chorus
  [%mcp-tool meta.lit wick.lit]
::
++  replay-mcp-prompts
  |=  sat=state-0:chorus
  ^-  (list missive:chorus)
  %-  zing
  %+  turn  ~(tap by mcp-prompts.sat)
  |=  [* liz=(set listing:prompt:mcp:chorus)]
  %+  turn  ~(tap in liz)
  |=  lit=listing:prompt:mcp:chorus
  ^-  missive:chorus
  [%mcp-prompt meta.lit wick.lit]
::
++  replay-mcp-resources
  |=  sat=state-0:chorus
  ^-  (list missive:chorus)
  %-  zing
  %+  turn  ~(tap by mcp-resources.sat)
  |=  [* liz=(set listing:resource:mcp:chorus)]
  %+  turn  ~(tap in liz)
  |=  lit=listing:resource:mcp:chorus
  ^-  missive:chorus
  [%mcp-resource meta.lit wick.lit]
::
++  replay-mcp-resource-templates
  |=  sat=state-0:chorus
  ^-  (list missive:chorus)
  %-  zing
  %+  turn  ~(tap by mcp-resource-templates.sat)
  |=  [* liz=(set listing:template:resource:mcp:chorus)]
  %+  turn  ~(tap in liz)
  |=  lit=listing:template:resource:mcp:chorus
  ^-  missive:chorus
  [%mcp-resource-template meta.lit wick.lit]
::
++  replay-skills
  |=  sat=state-0:chorus
  ^-  (list missive:chorus)
  %-  zing
  %+  turn  ~(tap by skills.sat)
  |=  [* liz=(set listing:skill:chorus)]
  %+  turn  ~(tap in liz)
  |=  lit=listing:skill:chorus
  ^-  missive:chorus
  [%agent-skill meta.lit wick.lit]
::
++  replay-slips
  |=  sat=state-0:chorus
  ^-  (list missive:chorus)
  %+  turn  ~(tap of cabinet.sat)
  |=  [* =slip:chorus =wick]
  ^-  missive:chorus
  [%chorus-slip slip wick]
::
::  every listing in state as a missive
++  replay
  |=  sat=state-0:chorus
  ^-  (list missive:chorus)
  %-  zing
  :~  (replay-bios sat)
      (replay-announcements sat)
      (replay-desks sat)
      (replay-mcp-tools sat)
      (replay-mcp-prompts sat)
      (replay-mcp-resources sat)
      (replay-mcp-resource-templates sat)
      (replay-skills sat)
      (replay-slips sat)
  ==
::
::  the listings a client may ask to replay by name: the
::  state field a peek path names, or the tag of the action
::  body that published them, or %updates for everything
++  replay-feature
  |=  [sat=state-0:chorus feat=@tas]
  ^-  (unit (list missive:chorus))
  ?+  feat  ~
    %updates                                (some (replay sat))
    ?(%rolodex %bio)                        (some (replay-bios sat))
    ?(%announcements %announcement)         (some (replay-announcements sat))
    ?(%desks %desk)                         (some (replay-desks sat))
    ?(%mcp-tools %mcp-tool)                 (some (replay-mcp-tools sat))
    ?(%mcp-prompts %mcp-prompt)             (some (replay-mcp-prompts sat))
    ?(%mcp-resources %mcp-resource)         (some (replay-mcp-resources sat))
    %mcp-resource-templates                 (some (replay-mcp-resource-templates sat))
    %mcp-resource-template                  (some (replay-mcp-resource-templates sat))
    ?(%skills %agent-skill)                 (some (replay-skills sat))
    ?(%cabinet %slip)                       (some (replay-slips sat))
  ==
::
::  replay heard, signed bullas to new subscribers
::
::  XX does this replay bullas in the order
::     they were received? does it matter?
::     not if we add dates to missives
::
++  sing
  |=  sat=state-0:chorus
  ^-  (list bulla:chorus)
  %+  murn  (replay sat)
  |=  msg=missive:chorus
  ^-  (unit bulla:chorus)
  =/  gis  (~(get by sigs.sat) wick.msg)
  ?~  gis
    ~
  `[%chorus-bulla ship.u.gis sig.u.gis msg]
::
::  the fact a client hears for a missive in state; a
::  slip's path is where it sits in our cabinet, or the
::  path its wick names if it has not landed yet
++  update-of
  |=  [sat=state-0:chorus msg=missive:chorus]
  ^-  update:chorus
  =/  wire=@t  (wick-to-wire wick.msg)
  ?-  -.msg
    %chorus-bio             [%chorus-bio-updated txt.msg wire]
    %chorus-announcement    [%chorus-announcement (slav %da (rear path.wick.msg)) txt.msg wire]
    %chorus-desk            [%chorus-desk-published desk.meta.msg desc.meta.msg wire]
    %mcp-tool               [%mcp-tool-listed meta.msg wire]
    %mcp-prompt             [%mcp-prompt-listed meta.msg wire]
    %mcp-resource           [%mcp-resource-listed meta.msg wire]
    %mcp-resource-template  [%mcp-resource-template-listed meta.msg wire]
    %agent-skill            [%agent-skill-listed meta.msg wire]
  ::
      %chorus-slip
    =/  pax=(unit path)  (slip-path sat wick.msg)
    ?^  pax  [%chorus-slip u.pax slip.msg wire]
    [%chorus-slip pax:(need (wick-fqsp:slp path.wick.msg)) slip.msg wire]
  ==
::
::  replay some missives heard since .when as updates,
::  oldest first
++  since
  |=  [sat=state-0:chorus msgs=(list missive:chorus) when=@da]
  ^-  (list update:chorus)
  %-  turn
  :_  |=([* =update:chorus] update)
  %-  sort
  :_  |=([a=[=time *] b=[=time *]] (lth time.a time.b))
  ^-  (list [=time =update:chorus])
  %+  murn  msgs
  |=  msg=missive:chorus
  ^-  (unit [=time =update:chorus])
  =/  gis  (~(get by sigs.sat) wick.msg)
  ?~  gis
    ~
  ?.  (gth when.u.gis when)
    ~
  `[when.u.gis (update-of sat msg)]
::
::  file a signed bulla in state under .who, recording
::  its signature; a slip lands at the path its wick
::  names, which is right for our own slips, and +hear
::  places heard ones
++  shelve
  |=  [sat=state-0:chorus who=ship now=@da =bulla:chorus]
  ^-  state-0:chorus
  =/  msg  msg.bulla
  =/  =wick  wick.msg
  =.  sigs.sat  (~(put by sigs.sat) wick [ship.bulla sig.bulla now])
  ?-    -.msg
      %chorus-bio
    sat(rolodex (~(put by rolodex.sat) who [txt.msg wick]))
  ::
      %chorus-announcement
    ::  a grow path ends with the moment it was grown
    =/  =time  (slav %da (rear path.wick))
    %=  sat
      announcements  %-  ~(put by announcements.sat)
                     :-  who
                     %-  ~(put in (~(gut by announcements.sat) who ~))
                     [time txt.msg wick]
    ==
  ::
      %chorus-desk
    %=  sat
      desks  %-  ~(put by desks.sat)
             :-  who
             %-  ~(put in (~(gut by desks.sat) who ~))
             [desk.meta.msg desc.meta.msg wick]
    ==
  ::
      %mcp-tool
    %=  sat
      mcp-tools  %-  ~(put by mcp-tools.sat)
                 :-  who
                 %-  ~(put in (~(gut by mcp-tools.sat) who ~))
                 [meta.msg wick]
    ==
  ::
      %mcp-prompt
    %=  sat
      mcp-prompts  %-  ~(put by mcp-prompts.sat)
                   :-  who
                   %-  ~(put in (~(gut by mcp-prompts.sat) who ~))
                   [meta.msg wick]
    ==
  ::
      %mcp-resource
    %=  sat
      mcp-resources  %-  ~(put by mcp-resources.sat)
                     :-  who
                     %-  ~(put in (~(gut by mcp-resources.sat) who ~))
                     [meta.msg wick]
    ==
  ::
      %mcp-resource-template
    %=  sat
      mcp-resource-templates
      %-  ~(put by mcp-resource-templates.sat)
      :-  who
      %-  ~(put in (~(gut by mcp-resource-templates.sat) who ~))
      [meta.msg wick]
    ==
  ::
      %agent-skill
    %=  sat
      skills  %-  ~(put by skills.sat)
              :-  who
              %-  ~(put in (~(gut by skills.sat) who ~))
              [meta.msg wick]
    ==
  ::
      %chorus-slip
    =/  fin  (need (wick-fqsp:slp path.wick))
    sat(cabinet (~(put of cabinet.sat) pax.fin [slip.msg wick]))
  ==
::
::  fold a heard bulla into state,
::  keyed to the ship that signed the wick
++  hear
  |=  [sat=state-0:chorus our=ship now=@da =bulla:chorus]
  ^-  state-0:chorus
  =/  msg  msg.bulla
  =/  =wick  wick.msg
  =*  who  ship.id.wick
  ?.  ?=(%chorus-slip -.msg)
    (shelve sat who now bulla)
  ::
  ::  a heard slip lands at the cabinet path its fqsp names,
  ::  the same tree path its author keeps it at. only its
  ::  author replaces it, at a newer revision. two heard
  ::  authors at one path split it: each lands under the
  ::  path at a segment naming their ship, /foo/bar/~sampel
  ::  and /foo/bar/~palnet, and later arrivals at a split
  ::  path do the same. our own slip at a path stays put
  =.  sigs.sat  (~(put by sigs.sat) wick [ship.bulla sig.bulla now])
  =/  fin  (need (wick-fqsp:slp path.wick))
  =/  spot=path  (snoc pax.fin (scot %p ship.bulla))
  =/  old=(unit [=slip:chorus w=^wick])  (~(get of cabinet.sat) pax.fin)
  =/  own=(unit [=slip:chorus w=^wick])  (~(get of cabinet.sat) spot)
  =/  split=?
    %+  lien  ~(tap in ~(key by dir:(~(dip of cabinet.sat) pax.fin)))
    |=(seg=@ta =('~' (end 3 seg)))
  ::  where this author's slip at this path lives,
  ::  and what we hold there now
  =/  [at=path cur=(unit [=slip:chorus w=^wick])]
    ?^  own  [spot own]
    ?~  old  ?:(split [spot ~] [pax.fin ~])
    ?:  =(ship.bulla ship.slip.u.old)  [pax.fin old]
    [spot ~]
  ?:  &(?=(^ cur) =(wick w.u.cur))
    sat
  ?:  ?&  ?=(^ cur)
          =/  fon  (wick-fqsp:slp path.w.u.cur)
          &(?=(^ fon) (gte rev.u.fon rev.fin))
      ==
    sat(sigs (~(del by sigs.sat) wick))
  =?  sigs.sat  ?=(^ cur)  (~(del by sigs.sat) w.u.cur)
  ::  another heard author at the bare path moves under
  ::  their own ship as this one lands under theirs
  =?    cabinet.sat
      ?&  ?=(^ old)
          !=(our ship.slip.u.old)
          !=(ship.bulla ship.slip.u.old)
      ==
    %+  ~(put of (~(del of cabinet.sat) pax.fin))
      (snoc pax.fin (scot %p ship.slip.u.old))
    u.old
  sat(cabinet (~(put of cabinet.sat) at [slip.msg wick]))
::
::  where the slip signed by .wick sits in our tree
++  slip-path
  |=  [sat=state-0:chorus =wick]
  ^-  (unit path)
  =/  hit  (skim ~(tap of cabinet.sat) |=([* * w=^wick] =(wick w)))
  ?~  hit  ~
  `-.i.hit
::
::  drop one wick, and whatever it signed, from state
++  forget
  |=  [sat=state-0:chorus =wick]
  ^-  state-0:chorus
  =*  who  ship.id.wick
  %=    sat
      sigs  (~(del by sigs.sat) wick)
      rolodex
    =/  lit  (~(get by rolodex.sat) who)
    ?:  &(?=(^ lit) =(wick wick.u.lit))
      (~(del by rolodex.sat) who)
    rolodex.sat
  ::
      announcements
    %-  ~(run by announcements.sat)
    |=  liz=(set listing:announcement:chorus)
    (silt (skip ~(tap in liz) |=(lit=listing:announcement:chorus =(wick wick.lit))))
  ::
      desks
    %-  ~(run by desks.sat)
    |=  liz=(set listing:desk:chorus)
    (silt (skip ~(tap in liz) |=(lit=listing:desk:chorus =(wick wick.lit))))
  ::
      mcp-tools
    %-  ~(run by mcp-tools.sat)
    |=  liz=(set listing:tool:mcp:chorus)
    (silt (skip ~(tap in liz) |=(lit=listing:tool:mcp:chorus =(wick wick.lit))))
  ::
      mcp-prompts
    %-  ~(run by mcp-prompts.sat)
    |=  liz=(set listing:prompt:mcp:chorus)
    (silt (skip ~(tap in liz) |=(lit=listing:prompt:mcp:chorus =(wick wick.lit))))
  ::
      mcp-resources
    %-  ~(run by mcp-resources.sat)
    |=  liz=(set listing:resource:mcp:chorus)
    (silt (skip ~(tap in liz) |=(lit=listing:resource:mcp:chorus =(wick wick.lit))))
  ::
      mcp-resource-templates
    %-  ~(run by mcp-resource-templates.sat)
    |=  liz=(set listing:template:resource:mcp:chorus)
    (silt (skip ~(tap in liz) |=(lit=listing:template:resource:mcp:chorus =(wick wick.lit))))
  ::
      skills
    %-  ~(run by skills.sat)
    |=  liz=(set listing:skill:chorus)
    (silt (skip ~(tap in liz) |=(lit=listing:skill:chorus =(wick wick.lit))))
  ::
      cabinet
    %-  ~(gas of *cabinet:chorus)
    %+  skip  ~(tap of cabinet.sat)
    |=([* * w=^wick] =(wick w))
  ==
::
++  feed-to-seed
  |=  [our=ship now=@da]
  ^-  seed:jael
  =/  =feed:jael
    ;;  feed:jael
    (cue .^(@ %j /(scot %p our)/vile/(scot %da now)))
  ?>  ?=([%2 ~] -.feed)
  ?~  kyz.feed
    ~|(%chorus-vile-without-keys !!)
  [who.feed lyf.i.kyz.feed key.i.kyz.feed ~]
::
::  rebuild the sage a remote requester would receive for
::  one of our own /fine paths, clay or gall
++  our-sage
  |=  [our=ship pax=path]
  ^-  sage:mess:ames
  =/  rest=path  (slag 2 pax)
  ?.  (gte (lent rest) 4)
    ~|(%unsupported-wick-path !!)
  =/  rev=@ta    (snag 2 rest)
  =/  nam=@ta    (snag 3 rest)
  =/  spur=path  (slag 4 rest)
  :-  [our rest]
  ?+    rest  ~|(%unsupported-wick-path !!)
      [%c %x *]
    ?~  spur
      ~|(%unsupported-wick-path !!)
    =/  nun=(unit *)
      (mole |.(.^(* %cx [(scot %p our) nam rev spur])))
    ?~  nun
      ~
    [(slav %tas (rear spur)) u.nun]
  ::
      [%c %z *]
    =/  nun=(unit *)
      (mole |.(.^(* %cz [(scot %p our) nam rev spur])))
    ?~  nun
      ~
    [%uvi u.nun]
  ::
      [%g %x @ @ %$ @ ^]
    =/  nun=(unit *)
      (mole |.(.^(* %gx [(scot %p our) nam rev spur])))
    ?~  nun
      ~
    ::  XX generalise the grow mark once gall exposes it
    ::
    ::  clay names its mark in the path, and while gall
    ::  does not name the mark of a grown page locally,
    ::  chorus grows %chorus-skill pages under /skills and
    ::  %txt pages under every other grow path
    ?:  ?=([@ @ @ @ @ @ %skills *] rest)
      [%chorus-skill u.nun]
    ?:  ?=([@ @ @ @ @ @ %cabinet *] rest)
      [%md u.nun]
    [%txt u.nun]
  ==
::
::  the revision the next %grow at this path will land at:
::  one past the latest revision gall's %w care reports, or
::  1 for a path never grown. a %w scry on a path gall has
::  not grown blocks rather than failing, and +mole forwards
::  the block, so ask the %t care whether the path exists
::  before asking %w for its revision
++  next-grow-rev
  |=  [our=ship now=@da seg=path]
  ^-  @ud
  ?~  seg
    1
  =/  bek=path  /(scot %p our)/chorus/(scot %da now)//1
  =/  grown=(list path)
    .^((list path) %gt (welp bek (snip `path`seg)))
  ?.  (lien grown |=(pax=path =(pax seg)))
    1
  =/  las  .^(case %gw (welp bek seg))
  ?.  ?=(%ud -.las)
    1
  +(p.las)
::
::  sign a contentful wick over a grow path as given, with
::  no date appended, at the revision the grow will land
::  at: for content at one stable path, like a skill at
::  /skills/<name>
++  make-grow-wick-at
  |=  [our=ship now=@da rev=@ud seg=path =page]
  ^-  wick
  =/  pax=path
    (welp /fine/(scot %p our)/g/x/(scot %ud rev)/chorus//1 seg)
  (make-wick | (feed-to-seed our now) pax `(fine-octs [[our (slag 2 pax)] page]))
::
::  sign a contentful wick over a grown path and the full
::  sage:mess:ames the requester will receive in +on-arvo;
::  a dated path is always fresh, so it grows at revision 1
::  XX will eventually have to handle non-/fine paths = no pages
++  make-grow-wick
  |=  [our=ship now=@da seg=path =page]
  ^-  wick
  (make-grow-wick-at our now 1 (snoc seg (scot %da now)) page)
::
::  sign a contentful wick over any /fine path we serve
::  ourselves, and the full sage a remote scry will receive
++  make-fine-wick
  |=  [our=ship now=@da pax=path]
  ^-  wick
  ?>  ?=([%fine @ *] pax)
  (make-wick | (feed-to-seed our now) pax `(fine-octs (our-sage our pax)))
::
::  sign a contentful wick over the clay fine path for a source
::  file and the full sage:mess:ames a remote scry will receive
++  make-clay-wick
  |=  [our=ship now=@da =desk pax=path]
  ^-  wick
  =/  bek=path  /(scot %p our)/[desk]/(scot %da now)
  =/  cas=cass:clay  .^(cass:clay %cw bek)
  =/  fyn=path
    :(welp /fine/(scot %p our)/c/x/(scot %ud ud.cas)/[desk] pax)
  =/  =page  [(slav %tas (rear pax)) .^(* %cx (welp bek pax))]
  (make-wick | (feed-to-seed our now) fyn `(fine-octs [[our (slag 2 fyn)] page]))
::
::  sign a path-only wick over the clay fine path for a desk
::  at its current revision; a requester verifies the content
::  by scrying files at that revision themselves
++  make-desk-wick
  |=  [our=ship now=@da =desk]
  ^-  wick
  =/  cas=cass:clay
    .^(cass:clay %cw /(scot %p our)/[desk]/(scot %da now))
  =/  fyn=path
    /fine/(scot %p our)/c/z/(scot %ud ud.cas)/[desk]
  (make-wick & (feed-to-seed our now) fyn ~)
::
::  seal a missive in a bulla: .sig signs (jam msg) with the
::  same networking key that signed the wick, so a hearer can
::  check the metadata without fetching the content
++  sign-bulla
  |=  [our=ship now=@da msg=missive:chorus]
  ^-  bulla:chorus
  =/  =seed:jael  (feed-to-seed our now)
  =/  keys  (nol:nu:cric:crypto key.seed)
  ?>  ?=(^ sek.+<.keys)
  =/  jammed=@  (jam msg)
  :*  %chorus-bulla
      our
      `@ux`(sign-octs-raw:ed:crypto [(met 3 jammed) jammed] [sgn.pub sgn.sek]:+<:keys)
      msg
  ==
::
::  check a heard bulla: the outer signature must match
::  (jam msg) under the key .ship holds in jael at the wick's
::  rotation, and the wick id must name the sending ship under
::  the same nym rules we apply ourselves
++  verify-bulla
  |=  [=bowl:gall =bulla:chorus]
  ^-  ?
  =/  who=tape  (scow %p ship.bulla)
  =/  =wick  wick.msg.bulla
  ?:  =(0x0 sig.bulla)
    %-  (slog [leaf+"chorus: no signature on bulla from {who}"]~)
    |
  ::  we expect every ship to hold a pubkey in jael
  =/  key=(unit (unit [crypto-suite=@ud =pass]))
    %-  mole
    |.
    .^  (unit [crypto-suite=@ud =pass])
        %j
        /(scot %p our.bowl)/puby/(scot %da now.bowl)/(scot %p ship.bulla)/(scot %ud rot.wick)
    ==
  ?~  key
    %-  (slog [leaf+"chorus: could not look up a key for {who}"]~)
    |
  ?~  u.key
    %-  (slog [leaf+"chorus: jael has no key for {who} at life {<rot.wick>}"]~)
    |
  =/  jammed=@  (jam msg.bulla)
  ?.  %^    veri-octs:ed:crypto
          sig.bulla
        [(met 3 jammed) jammed]
      sgn:ded:ex:(com:nu:cric:crypto pass.u.u.key)
    %-  (slog [leaf+"chorus: {who} did not sign the bulla"]~)
    |
  ::  only comets have nyms, so a non-comet sender must be
  ::  named in its wick by its cometized form: the fingerprint
  ::  of the key it signed with. planets registering with the
  ::  groundwire pki as comets may change this someday, but for
  ::  now we expect the nym untweaked
  =/  paw=(unit @pH)
    ?:  =(%pawn (clan:title ship.bulla))
      `ship.bulla
    (mole |.((come:mu bowl ship.bulla)))
  ?~  paw
    %-  (slog [leaf+"chorus: could not cometize {who}"]~)
    |
  ?.  =(u.paw ship.id.wick)
    %-  (slog [leaf+"chorus: the wick from {who} names another ship"]~)
    |
  ::  XX all nyms are two-dot unverified nyms until we settle
  ::     the tweak data the pki accepts; see +verified-nym
  =/  gib
    ?:  (verified-nym our.bowl now.bowl ship.bulla rot.wick)
      me
    mu
  ?.  =((de:ship:gib u.paw) nym.id.wick)
    %-  (slog [leaf+"chorus: the wick from {who} carries the wrong nym"]~)
    |
  &
::
::  an update as json, shared by the update and updates marks
++  enjs-update
  |=  val=update:chorus
  ^-  json
  ?-  -.val
      %chorus-bio-updated
    %-  pairs:enjs:format
    :~  ['type' s+'chorus-bio-updated']
        ['wire' s+wire.val]
        ['bio' s+txt.val]
    ==
  ::
      %chorus-announcement
    %-  pairs:enjs:format
    :~  ['type' s+'chorus-announcement']
        ['wire' s+wire.val]
        ['time' s+(scot %da time.val)]
        ['text' s+txt.val]
    ==
  ::
      %chorus-desk-published
    %-  pairs:enjs:format
    :~  ['type' s+'chorus-desk-published']
        ['wire' s+wire.val]
        ['desk' s+desk.val]
        ['desc' s+desc.val]
    ==
  ::
      %mcp-tool-listed
    =/  t  meta.val
    %-  pairs:enjs:format
    :~  ['type' s+'mcp-tool-listed']
        ['wire' s+wire.val]
        ['name' s+name.t]
        ['description' s+desc.t]
        :-  'inputSchema'
        %-  pairs:enjs:format
        :~  ['type' s+'object']
            :-  'properties'
            :-  %o
            %-  ~(gas by *(map @t ^json))
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
      %mcp-prompt-listed
    =/  p  meta.val
    %-  pairs:enjs:format
    :~  ['type' s+'mcp-prompt-listed']
        ['wire' s+wire.val]
        ['name' s+name.p]
        ['title' s+title.p]
        ['description' s+desc.p]
        :-  'arguments'
        :-  %a
        %+  turn
          arguments.p
        |=  arg=argument:prompt:mcp
        %-  pairs:enjs:format
        :~  ['name' s+name.arg]
            ['description' s+desc.arg]
            ['required' b+required.arg]
        ==
    ==
  ::
      %mcp-resource-listed
    =/  r  meta.val
    %-  pairs:enjs:format
    :~  ['type' s+'mcp-resource-listed']
        ['wire' s+wire.val]
        ['uri' s+uri.r]
        ['name' s+name.r]
        :-  'title'
        ?~  title.r  ~  s+u.title.r
        :-  'description'
        ?~  desc.r  ~  s+u.desc.r
    ==
  ::
      %mcp-resource-template-listed
    =/  r  meta.val
    %-  pairs:enjs:format
    :~  ['type' s+'mcp-resource-template-listed']
        ['wire' s+wire.val]
        ['uriTemplate' s+uri-template.r]
        ['name' s+name.r]
        :-  'title'
        ?~  title.r  ~  s+u.title.r
        :-  'description'
        ?~  desc.r  ~  s+u.desc.r
    ==
  ::
      %agent-skill-listed
    =/  s  meta.val
    %-  pairs:enjs:format
    :~  ['type' s+'agent-skill-listed']
        ['wire' s+wire.val]
        ['name' s+name.s]
        ['description' s+description.s]
        ['compatibility' s+compatibility.s]
    ==
  ::
      %chorus-slip
    %-  pairs:enjs:format
    :~  ['type' s+'chorus-slip']
        ['wire' s+wire.val]
        ['path' s+(spat path.val)]
        :-  'fqsp'
        =/  wok  (mole |.((wire-to-wook wire.val)))
        ?~  wok  ~
        s+(spat (slag 1 `path`path.u.wok))
        ['author' s+(scot %p ship.slip.val)]
        ['created' s+(scot %da time.slip.val)]
        ['links' a+(turn (links:slp txt.slip.val) |=(l=@t s+l))]
        ['text' s+txt.slip.val]
    ==
  ::
      %chorus-slip-discarded
    %-  pairs:enjs:format
    :~  ['type' s+'chorus-slip-discarded']
        ['wire' s+wire.val]
        ['path' s+(spat path.val)]
    ==
  ==
--
