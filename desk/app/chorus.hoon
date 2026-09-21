::
::  chorus: peer-to-peer multiplayer agent harness
/-  mcp, *wick, chorus
/+  dbug, verb, cho=chorus, default-agent, gossip, slp=slip, *wick
::
|%
+$  card  card:agent:gall
--
::
=|  state-0:chorus
=*  state  -
::
%-  %+  agent:gossip
      :*  %2             ::  hops
          [%whos %sein]  ::  hear
          [%whos %city]  ::  tell
          .n             ::  pass
          %urb-watcher   ::  pki domain
      ==
    %+  ~(put by *(map mark $-(* vase)))
      %chorus-bulla
    |=(n=* !>(;;(bulla:chorus n)))
%-  agent:dbug
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    pyk   :*  p=(scot %p our.bowl)
              q=q.byk.bowl
              r=(scot %da now.bowl)
              s=/(scot %p our.bowl)/[q.byk.bowl]/(scot %da now.bowl)
          ==
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
++  on-save   !>(state)
++  on-init   `this
::
++  on-load
  |=  old=vase
  ^-  (quip card _this)
  =/  saved  !<(versioned-state:chorus old)
  ?-  -.saved
    %0  [~ this(state saved)]
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole
      (on-peek:def pole)
  ::
  ::  every bulla of one feature heard after a time, as
  ::  updates: a state field name like /announcements, an
  ::  action body tag like /announcement, or /updates for
  ::  every feature; see +replay-feature
  ::  .^((list update) %gx /=/chorus/=/updates/since/(scot %da wen)/noun)
  ::  .^((list update) %gx /=/chorus/=/announcements/since/(scot %da wen)/noun)
      [%x feat=@ %since wen=@ ~]
    =/  msgs  (replay-feature:cho state `@tas`feat.pole)
    ?~  msgs
      (on-peek:def pole)
    ``chorus-updates+!>((since:cho state u.msgs (slav %da wen.pole)))
  ::
  ::  .^((list tool:mcp) %gx /=/chorus/=/mcp/tools/noun)
      [%x %mcp %tools ~]
    %-  some
    %-  some
    :-  %mcp-tools
    !>  ^-  (list tool:mcp)
    %+  turn
      .^  (list path)
          %ct
          (welp s.pyk /fil/mcp/tools)
      ==
    |=  pax=path
    !<(tool:mcp .^(vase %ca (welp s.pyk pax)))
  ::
  ::  .^((list resource:mcp) %gx /=/chorus/=/mcp/resources/noun)
      [%x %mcp %resources ~]
    %-  some
    %-  some
    :-  %mcp-resources
    !>  ^-  (list resource:mcp)
    %+  turn
      .^  (list path)
          %ct
          (welp s.pyk /fil/mcp/resources)
      ==
    |=  pax=path
    !<(resource:mcp .^(vase %ca (welp s.pyk pax)))
  ::
  ::  .^((list template:resource:mcp) %gx /=/chorus/=/mcp/templates/noun)
      [%x %mcp %templates ~]
    %-  some
    %-  some
    :-  %mcp-templates
    !>  ^-  (list template:resource:mcp)
    %+  turn
      .^  (list path)
          %ct
          (welp s.pyk /fil/mcp/templates)
      ==
    |=  pax=path
    !<(template:resource:mcp .^(vase %ca (welp s.pyk pax)))
  ::
  ::  .^((set listing:bio) %gx /=/chorus/=/rolodex/noun)
  ::  .^((set listing:bio) %gx /=/chorus/=/rolodex/(scot %t nym)/noun)
      [%x %rolodex who=*]
    =/  lis=(list listing:bio:chorus)  ~(val by rolodex)
    :^  ~  ~  %chorus-rolodex
    !>  ^-  (set listing:bio:chorus)
    %-  silt
    ?~  who.pole
      lis
    =/  =nym  (slav %t i:((lest knot) who.pole))
    (skim lis |=(lit=listing:bio:chorus =(nym nym.id.wick.lit)))
  ::
  ::  .^((set listing:announcement) %gx /=/chorus/=/announcements/noun)
  ::  .^((set listing:announcement) %gx /=/chorus/=/announcements/(scot %t nym)/noun)
      [%x %announcements who=*]
    =/  lis=(list listing:announcement:chorus)
      %-  zing
      %+  turn  ~(val by announcements)
      |=(liz=(set listing:announcement:chorus) ~(tap in liz))
    :^  ~  ~  %chorus-announcements
    !>  ^-  (set listing:announcement:chorus)
    %-  silt
    ?~  who.pole
      lis
    =/  =nym  (slav %t i:((lest knot) who.pole))
    (skim lis |=(lit=listing:announcement:chorus =(nym nym.id.wick.lit)))
  ::
  ::  .^((set listing:desk) %gx /=/chorus/=/desks/noun)
  ::  .^((set listing:desk) %gx /=/chorus/=/desks/(scot %t nym)/noun)
      [%x %desks who=*]
    =/  lis=(list listing:desk:chorus)
      %-  zing
      %+  turn  ~(val by desks)
      |=(liz=(set listing:desk:chorus) ~(tap in liz))
    :^  ~  ~  %chorus-desks
    !>  ^-  (set listing:desk:chorus)
    %-  silt
    ?~  who.pole
      lis
    =/  =nym  (slav %t i:((lest knot) who.pole))
    (skim lis |=(lit=listing:desk:chorus =(nym nym.id.wick.lit)))
  ::
  ::  .^((set listing:tool:mcp) %gx /=/chorus/=/mcp-tools/noun)
  ::  .^((set listing:tool:mcp) %gx /=/chorus/=/mcp-tools/(scot %t nym)/noun)
      [%x %mcp-tools who=*]
    =/  lis=(list listing:tool:mcp:chorus)
      %-  zing
      %+  turn  ~(val by mcp-tools)
      |=(liz=(set listing:tool:mcp:chorus) ~(tap in liz))
    :^  ~  ~  %chorus-mcp-tools
    !>  ^-  (set listing:tool:mcp:chorus)
    %-  silt
    ?~  who.pole
      lis
    =/  =nym  (slav %t i:((lest knot) who.pole))
    (skim lis |=(lit=listing:tool:mcp:chorus =(nym nym.id.wick.lit)))
  ::
  ::  .^((set listing:prompt:mcp) %gx /=/chorus/=/mcp-prompts/noun)
  ::  .^((set listing:prompt:mcp) %gx /=/chorus/=/mcp-prompts/(scot %t nym)/noun)
      [%x %mcp-prompts who=*]
    =/  lis=(list listing:prompt:mcp:chorus)
      %-  zing
      %+  turn  ~(val by mcp-prompts)
      |=(liz=(set listing:prompt:mcp:chorus) ~(tap in liz))
    :^  ~  ~  %chorus-mcp-prompts
    !>  ^-  (set listing:prompt:mcp:chorus)
    %-  silt
    ?~  who.pole
      lis
    =/  =nym  (slav %t i:((lest knot) who.pole))
    (skim lis |=(lit=listing:prompt:mcp:chorus =(nym nym.id.wick.lit)))
  ::
  ::  .^((set listing:resource:mcp) %gx /=/chorus/=/mcp-resources/noun)
  ::  .^((set listing:resource:mcp) %gx /=/chorus/=/mcp-resources/(scot %t nym)/noun)
      [%x %mcp-resources who=*]
    =/  lis=(list listing:resource:mcp:chorus)
      %-  zing
      %+  turn  ~(val by mcp-resources)
      |=(liz=(set listing:resource:mcp:chorus) ~(tap in liz))
    :^  ~  ~  %chorus-mcp-resources
    !>  ^-  (set listing:resource:mcp:chorus)
    %-  silt
    ?~  who.pole
      lis
    =/  =nym  (slav %t i:((lest knot) who.pole))
    (skim lis |=(lit=listing:resource:mcp:chorus =(nym nym.id.wick.lit)))
  ::
  ::  .^((set listing:template:resource:mcp) %gx /=/chorus/=/mcp-resource-templates/noun)
  ::  .^((set listing:template:resource:mcp) %gx /=/chorus/=/mcp-resource-templates/(scot %t nym)/noun)
      [%x %mcp-resource-templates who=*]
    =/  lis=(list listing:template:resource:mcp:chorus)
      %-  zing
      %+  turn  ~(val by mcp-resource-templates)
      |=(liz=(set listing:template:resource:mcp:chorus) ~(tap in liz))
    :^  ~  ~  %chorus-mcp-resource-templates
    !>  ^-  (set listing:template:resource:mcp:chorus)
    %-  silt
    ?~  who.pole
      lis
    =/  =nym  (slav %t i:((lest knot) who.pole))
    (skim lis |=(lit=listing:template:resource:mcp:chorus =(nym nym.id.wick.lit)))
  ::
  ::  .^((set listing:skill) %gx /=/chorus/=/skills/noun)
  ::  .^((set listing:skill) %gx /=/chorus/=/skills/(scot %t nym)/noun)
      [%x %skills who=*]
    =/  lis=(list listing:skill:chorus)
      %-  zing
      %+  turn  ~(val by skills)
      |=(liz=(set listing:skill:chorus) ~(tap in liz))
    :^  ~  ~  %chorus-skills
    !>  ^-  (set listing:skill:chorus)
    %-  silt
    ?~  who.pole
      lis
    =/  =nym  (slav %t i:((lest knot) who.pole))
    (skim lis |=(lit=listing:skill:chorus =(nym nym.id.wick.lit)))
  ::
  ::  the nym to credit a ship with; see +author-nym
  ::  .^(json %gx /=/chorus/=/nym/(scot %p who)/json)
      [%x %nym who=@ ~]
    ``json+!>(`json`s+(author-nym:cho bowl (slav %p who.pole)))
  ::
  ::  .^([slip wick] %gx /=/chorus/=/cabinet/slip/notes/foo/noun)
      [%x %cabinet %slip pax=*]
    =/  lef  (~(get of cabinet) ;;(path pax.pole))
    ?~  lef
      [~ ~]
    ``chorus-slip+!>(u.lef)
  ::
  ::  .^(cabinet %gx /=/chorus/=/cabinet/drawer/noun)
  ::  .^(cabinet %gx /=/chorus/=/cabinet/drawer/notes/noun)
      [%x %cabinet %drawer pax=*]
    ``chorus-cabinet+!>((~(dip of cabinet) ;;(path pax.pole)))
  ::
  ::  the same tree with every body blanked, for listing
  ::  .^(cabinet %gx /=/chorus/=/cabinet/paths/noun)
      [%x %cabinet %paths pax=*]
    :^    ~
        ~
      %chorus-cabinet
    !>  ^-  cabinet:chorus
    =/  fat  (~(dip of cabinet) ;;(path pax.pole))
    |-
    ^-  cabinet:chorus
    :-  ?~(fil.fat ~ `u.fil.fat(txt.slip ''))
    (~(run by dir.fat) |=(kid=cabinet:chorus ^$(fat kid)))
  ==
::
++  on-watch
  |=  =(pole knot)
  ^-  (quip card _this)
  ?+  pole
    (on-watch:def pole)
  ::
  ::  every slip that lands in the cabinet
      [%cabinet ~]
    `this
  ::
  ::  slips that land in the cabinet except ours
      [%heard ~]
    `this
  ::
  ::  replay heard bullas to new subscribers
  ::  XX need to not leak state to subscribers that's
  ::     just for us; punt on this for now
      [%~.~ %gossip %source ~]
    :_  this
    %+  turn  (sing:cho state)
    |=  =bulla:chorus
    ^-  card
    [%give %fact ~ %chorus-bulla !>(bulla)]
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(src our):bowl
  ?+    mark  (on-poke:def mark vase)
      %chorus-action
    =/  act  !<(action:chorus vase)
    ?-    -.act
        %publish
      ::
      ::  each kind of listing makes its wick, and any cards
      ::  that grow its content; the missive is then signed,
      ::  filed under us, and gossiped alike
      =/  [cards=(list card) msg=missive:chorus]
        ?-    -.body.act
            %bio
          ?.  (lte (lent (trip bio.body.act)) 256)
            ~|  "{<dap.bowl>}: bio must be 256 characters or less"
            !!
          =/  =wick  (make-grow-wick:cho our.bowl now.bowl /bio txt+bio.body.act)
          :-  [%pass ~ %grow (snoc /bio (scot %da now.bowl)) txt+bio.body.act]~
          [%chorus-bio bio.body.act wick]
        ::
            %announcement
          ?.  (lte (lent (trip announcement.body.act)) 256)
            ~|  "{<dap.bowl>}: announcement must be 256 characters or less"
            !!
          =/  =wick
            (make-grow-wick:cho our.bowl now.bowl /announcements txt+announcement.body.act)
          :-  :_  ~
              :*  %pass  ~  %grow
                  (snoc /announcements (scot %da now.bowl))
                  txt+announcement.body.act
              ==
          [%chorus-announcement announcement.body.act wick]
        ::
            %desk
          ?.  (lte (lent (trip desc.body.act)) 256)
            ~|  "{<dap.bowl>}: desk description must be 256 characters or less"
            !!
          =/  =wick  (make-desk-wick:cho our.bowl now.bowl desk.body.act)
          :-  ~
          [%chorus-desk [desk.body.act desc.body.act] wick]
        ::
            %mcp-tool
          =*  dek  desk.body.act
          =*  pax  path.body.act
          =/  =tool:mcp
            !<(tool:mcp .^(^vase %ca (welp /[p.pyk]/[dek]/[r.pyk] pax)))
          =/  =wick  (make-clay-wick:cho our.bowl now.bowl dek pax)
          :-  ~
          :+  %mcp-tool
            [name.tool desc.tool parameters.tool required.tool]
          wick
        ::
            %mcp-prompt
          =*  dek  desk.body.act
          =*  pax  path.body.act
          =/  =prompt:mcp
            !<(prompt:mcp .^(^vase %ca (welp /[p.pyk]/[dek]/[r.pyk] pax)))
          =/  =wick  (make-clay-wick:cho our.bowl now.bowl dek pax)
          :-  ~
          :+  %mcp-prompt
            [name.prompt title.prompt desc.prompt arguments.prompt]
          wick
        ::
            %mcp-resource
          =*  dek  desk.body.act
          =*  pax  path.body.act
          =/  =resource:mcp
            !<(resource:mcp .^(^vase %ca (welp /[p.pyk]/[dek]/[r.pyk] pax)))
          =/  =wick  (make-clay-wick:cho our.bowl now.bowl dek pax)
          :-  ~
          :+  %mcp-resource
            [uri.resource name.resource title.resource desc.resource]
          wick
        ::
            %mcp-resource-template
          =*  dek  desk.body.act
          =*  pax  path.body.act
          =/  =template:resource:mcp
            !<  template:resource:mcp
            .^(^vase %ca (welp /[p.pyk]/[dek]/[r.pyk] pax))
          =/  =wick  (make-clay-wick:cho our.bowl now.bowl dek pax)
          :-  ~
          :+  %mcp-resource-template
            [uri-template.template name.template title.template desc.template]
          wick
        ::
            %agent-skill
          ::  gossiped metadata, with '' standing in for no
          ::  compatibility field
          =/  =meta:skill:chorus
            =*  fm  frontmatter.skill.body.act
            [name.fm description.fm (fall compatibility.fm '')]
          =/  err  (vet-skill-meta:cho meta)
          ?^  err
            ~|  "{<dap.bowl>}: {(trip u.err)}"
            !!
          =/  nam=@ta  `@ta`name.meta
          =/  rev=@ud  (next-grow-rev:cho our.bowl now.bowl /skills/[nam])
          =/  =wick
            %^  make-grow-wick-at:cho  our.bowl  now.bowl
            [rev /skills/[nam] chorus-skill+skill.body.act]
          :-  [%pass ~ %grow /skills/[nam] chorus-skill+skill.body.act]~
          [%agent-skill meta wick]
        ::
            %slip
          =*  pax  path.body.act
          =/  err  (vet-slip:slp our.bowl pax txt.slip.body.act)
          ?^  err
            ~|  "{<dap.bowl>}: {(trip u.err)}"
            !!
          =/  =slip:chorus  [our.bowl now.bowl txt.slip.body.act]
          =/  rev=@ud  (next-grow-rev:cho our.bowl now.bowl [%cabinet pax])
          =/  =wick  %^    make-grow-wick-at:cho
                         our.bowl
                       now.bowl
                     [rev [%cabinet pax] md+txt.slip]
          :-  [%pass ~ %grow [%cabinet pax] md+txt.slip]~
          [%chorus-slip slip wick]
        ==
      =/  =bulla:chorus  (sign-bulla:cho our.bowl now.bowl msg)
      =/  new  (shelve:cho state our.bowl now.bowl bulla)
      :_  this(state new)
      ;:  weld
        cards
      ::
        ?.  ?=(%chorus-slip -.msg)  ~
        :_  ~
        :*  %give  %fact  ~[/cabinet]  %chorus-update
            !>((update-of:cho new msg))
        ==
      ::
        ?:  =(`~ crowd.act)  ~
        :_  ~
        %^    confect:gossip
            [`%2 crowd.act ~]
          %chorus-bulla
        !>(bulla)
      ==
    ::
        %delete
      ::  every slip this takes out of the cabinet gives a
      ::  discard fact, so clients can drop their copies
      :-  %+  turn
            %+  skim  ~(tap of cabinet)
            |=  [* =slip:chorus =wick]
            ?@  target.act
              =(target.act ship.slip)
            =(wick.target.act wick)
          |=  [pax=path * =wick]
          ^-  card
          :*  %give  %fact  ~[/cabinet]  %chorus-update
              !>(`update:chorus`[%chorus-slip-discarded pax (wick-to-wire wick)])
          ==
      ?@  target.act
        ::  remove ship from state
        %=  this
          rolodex                 (~(del by rolodex) target.act)
          announcements           (~(del by announcements) target.act)
          desks                   (~(del by desks) target.act)
          mcp-tools               (~(del by mcp-tools) target.act)
          mcp-prompts             (~(del by mcp-prompts) target.act)
          mcp-resources           (~(del by mcp-resources) target.act)
          mcp-resource-templates  (~(del by mcp-resource-templates) target.act)
          skills                  (~(del by skills) target.act)
          cabinet                 %-  ~(gas of *cabinet:chorus)
                                  %+  skip  ~(tap of cabinet)
                                  |=([* =slip:chorus *] =(target.act ship.slip))
          sigs                    %-  malt
                                  %+  skip
                                    ~(tap by sigs)
                                  |=  [=wick *]
                                  =(target.act ship.id.wick)
        ==
      ::  remove wick from state
      this(state (forget:cho state wick.target.act))
    ==
  ==
::
++  on-agent
  |=  [=(pole knot) =sign:agent:gall]
  ^-  (quip card _this)
  ?.  ?=([%~.~ %gossip %gossip ~] pole)
    (on-agent:def pole sign)
  ?.  ?=([%fact %chorus-bulla *] sign)
    `this
  =/  =bulla:chorus  !<(bulla:chorus q.cage.sign)
  ::  XX handle %chorus-disavow here
  =/  =wick  wick.msg.bulla
  ?:  =(our.bowl ship.bulla)
    `this
  ::
  ::  the sender signed the whole missive: check the outer
  ::  signature and the wick id before we believe the metadata
  ?.  (verify-bulla:cho bowl bulla)
    %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping unverified bulla from {<ship.bulla>}"]))
    `this
  ::
  ::  the wick must point at the sender's own namespace, and
  ::  at the path shape this kind of missive grows or serves
  =/  who=@ta  (scot %p ship.bulla)
  =/  fit=?
    ?-  -.msg.bulla
      %chorus-announcement    ?=([%fine @ %g %x @ %chorus %$ @ %announcements *] path.wick)
      %chorus-bio             ?=([%fine @ %g %x @ %chorus %$ @ %bio *] path.wick)
      %chorus-desk            ?=([%fine @ %c %z *] path.wick)
      %mcp-prompt             ?=([%fine @ %c %x *] path.wick)
      %mcp-resource           ?=([%fine @ %c %x *] path.wick)
      %mcp-resource-template  ?=([%fine @ %c %x *] path.wick)
      %mcp-tool               ?=([%fine @ %c %x *] path.wick)
      %agent-skill            ?=([%fine @ %g %x @ %chorus %$ @ %skills *] path.wick)
      %chorus-slip            ?=([%fine @ %g %x @ %chorus %$ @ %cabinet *] path.wick)
    ==
  ?.  &(fit ?=([@ @ *] path.wick) =(who (snag 1 `path`path.wick)))
    %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping bulla with invalid path prefix"]))
    `this
  ::
  ::  a skill listing must meet the agentskills.io
  ::  constraints before we take it into state
  =/  bad=(unit @t)
    ?.  ?=(%agent-skill -.msg.bulla)  ~
    (vet-skill-meta:cho meta.msg.bulla)
  ?^  bad
    %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping invalid skill from {<ship.bulla>}: {(trip u.bad)}"]))
    `this
  ::
  ::  a slip travels whole, so we can rebuild the sage its
  ::  wick signed and check it on the spot; the fqsp must
  ::  name the sender, and so must the slip
  ?:  ?=(%chorus-slip -.msg.bulla)
    =*  slip  slip.msg.bulla
    =/  fin  (wick-fqsp:slp path.wick)
    ?.  &(?=(^ fin) =(ship.bulla host.u.fin) =(ship.bulla ship.slip))
      %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping slip from {<ship.bulla>} that names another ship"]))
      `this
    =/  bad=(unit @t)  (vet-slip:slp ship.bulla pax.u.fin txt.slip)
    ?^  bad
      %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping invalid slip from {<ship.bulla>}: {(trip u.bad)}"]))
      `this
    =/  key=(unit (unit [crypto-suite=@ud =pass]))
      %-  mole
      |.
      .^  (unit [crypto-suite=@ud =pass])
          %j
          /(scot %p our.bowl)/puby/(scot %da now.bowl)/(scot %p ship.bulla)/(scot %ud rot.wick)
      ==
    ?:  |(?=(~ key) ?=(~ u.key))
      %-  (slog :_(~ [%leaf "{<dap.bowl>}: could not check slip from {<ship.bulla>}"]))
      `this
    =/  octs  (fine-octs [[ship.bulla (slag 2 `path`path.wick)] md+txt.slip])
    ?.  (verify-wick wick `pass.u.u.key `octs)
      %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping slip that {<ship.bulla>} did not sign"]))
      `this
    =/  new  (hear:cho state our.bowl now.bowl bulla)
    ?:  =(cabinet cabinet.new)
      `this
    :_  this(state new)
    :_  ~
    :*  %give  %fact  ~[/cabinet /heard]  %chorus-update
        !>((update-of:cho new msg.bulla))
    ==
  ?.  flag.wick
    ::  don't verify contentful wicks right away
    `this(state (hear:cho state our.bowl now.bowl bulla))
  ::  a path-only wick signed its path alone, so jael settles
  ::  it right here; a key we cannot find leaves the wick
  ::  unverified, not caught out
  =/  key=(unit (unit [crypto-suite=@ud =pass]))
    %-  mole
    |.
    .^  (unit [crypto-suite=@ud =pass])
        %j
        /(scot %p our.bowl)/puby/(scot %da now.bowl)/(scot %p ship.bulla)/(scot %ud rot.wick)
    ==
  ?:  |(?=(~ key) ?=(~ u.key))
    %-  (slog :_(~ [%leaf "{<dap.bowl>}: could not check wick from {<ship.bulla>}"]))
    `this(state (hear:cho state our.bowl now.bowl bulla))
  ?.  (verify-wick wick `pass.u.u.key ~)
    %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping wick that {<ship.bulla>} did not sign"]))
    `this
  `this(state (hear:cho state our.bowl now.bowl bulla))
::
++  on-arvo  on-arvo:def
--
