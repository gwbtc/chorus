::
::  chorus: peer-to-peer multiplayer agent harness
/-  mcp, *wick, chorus
/+  dbug, verb, cho=chorus, default-agent, gossip, *wick
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
      ::  [%x %desks who=*]
    ::  =/  lis=(list listing:desk:chorus)
      ::  %-  zing
      ::  %+  turn  ~(val by desks)
      ::  |=(liz=(set listing:desk:chorus) ~(tap in liz))
    ::  :^  ~  ~  %chorus-desks
    ::  !>  ^-  (set listing:desk:chorus)
    ::  %-  silt
    ::  ?~  who.pole
      ::  lis
    ::  =/  =nym  (slav %t i:((lest knot) who.pole))
    ::  (skim lis |=(lit=listing:desk:chorus =(nym nym.id.wick.lit)))
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
  ==
::
++  on-watch
  |=  =(pole knot)
  ^-  (quip card _this)
  ?+  pole
    (on-watch:def pole)
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
      ?+    -.body.act  (on-poke:def mark vase)
          %bio
        ?.  (lte (lent (trip bio.body.act)) 256)
          ~|  "{<dap.bowl>}: bio must be 256 characters or less"
          !!
        =/  =wick  (make-grow-wick:cho bowl /bio txt+bio.body.act)
        =/  =bulla:chorus
          (sign-bulla:cho bowl [%chorus-bio bio.body.act wick])
        :_  %=  this
              rolodex  (~(put by rolodex) our.bowl [bio.body.act wick])
              sigs     (~(put by sigs) wick [ship sig]:bulla)
            ==
        :-  [%pass ~ %grow (snoc /bio (scot %da now.bowl)) txt+bio.body.act]
        ?:  =(`~ crowd.act)
          ~
        :_  ~
        %^    confect:gossip
            [`%2 crowd.act ~]
          %chorus-bulla
        !>(bulla)
      ::
          %announcement
        ?.  (lte (lent (trip announcement.body.act)) 256)
          ~|  "{<dap.bowl>}: announcement must be 256 characters or less"
          !!
        =/  =wick  (make-grow-wick:cho bowl /announcements txt+announcement.body.act)
        =/  =bulla:chorus
          (sign-bulla:cho bowl [%chorus-announcement announcement.body.act wick])
        :_  %=  this
              announcements  %-  ~(put by announcements)
                             :-  our.bowl
                             %-  ~(put in (~(gut by announcements) our.bowl ~))
                             [now.bowl announcement.body.act wick]
              sigs           (~(put by sigs) wick [ship sig]:bulla)
            ==
        :-  :*  %pass  ~  %grow
                (snoc /announcements (scot %da now.bowl))
                txt+announcement.body.act
            ==
        ?:  =(`~ crowd.act)
          ~
        :_  ~
        %^    confect:gossip
            [`%2 crowd.act ~]
          %chorus-bulla
        !>(bulla)
      ::
          ::  %desk
        ::  ::  XX gossip a wick of /fine/[p.pyk]/c/z/[ud.cass]/[desk];
        ::  ::     there is no %desk bulla:chorus kind yet
        ::  =/  =wick  (make-grow-wick:cho bowl /desks txt+desc.body.act)
        ::  :-  ~
        ::  %=  this
          ::  desks  %-  ~(put by desks)
                 ::  :-  our.bowl
                 ::  %-  ~(put in (~(gut by desks) our.bowl ~))
                 ::  [desk.body.act desc.body.act wick]
        ::  ==
      ::
          %mcp-tool
        =*  dek  desk.body.act
        =*  pax  path.body.act
        =/  =tool:mcp
          !<(tool:mcp .^(^vase %ca (welp /[p.pyk]/[dek]/[r.pyk] pax)))
        =/  =wick  (make-clay-wick:cho bowl dek pax)
        =/  =bulla:chorus
          %+  sign-bulla:cho
            bowl
          :+  %mcp-tool
            [name.tool desc.tool parameters.tool required.tool]
          wick
        :_  %=  this
              mcp-tools  %-  ~(put by mcp-tools)
                         :-  our.bowl
                         %-  ~(put in (~(gut by mcp-tools) our.bowl ~))
                         :_  wick
                         :*  name.tool
                             desc.tool
                             parameters.tool
                             required.tool
                         ==
              sigs       (~(put by sigs) wick [ship sig]:bulla)
            ==
        ?:  =(`~ crowd.act)
          ~
        :_  ~
        %^    confect:gossip
            [`%2 crowd.act ~]
          %chorus-bulla
        !>(bulla)
      ::
          %mcp-prompt
        =*  dek  desk.body.act
        =*  pax  path.body.act
        =/  =prompt:mcp
          !<(prompt:mcp .^(^vase %ca (welp /[p.pyk]/[dek]/[r.pyk] pax)))
        =/  =wick  (make-clay-wick:cho bowl dek pax)
        =/  =bulla:chorus
          %+  sign-bulla:cho
            bowl
          :+  %mcp-prompt
            [name.prompt title.prompt desc.prompt arguments.prompt]
          wick
        :_  %=  this
              mcp-prompts  %-  ~(put by mcp-prompts)
                           :-  our.bowl
                           %-  ~(put in (~(gut by mcp-prompts) our.bowl ~))
                           :_  wick
                           :*  name.prompt
                               title.prompt
                               desc.prompt
                               arguments.prompt
                           ==
              sigs         (~(put by sigs) wick [ship sig]:bulla)
            ==
        ?:  =(`~ crowd.act)
          ~
        :_  ~
        %^    confect:gossip
            [`%2 crowd.act ~]
          %chorus-bulla
        !>(bulla)
      ::
          %mcp-resource
        =*  dek  desk.body.act
        =*  pax  path.body.act
        =/  =resource:mcp
          !<(resource:mcp .^(^vase %ca (welp /[p.pyk]/[dek]/[r.pyk] pax)))
        =/  =wick  (make-clay-wick:cho bowl dek pax)
        =/  =bulla:chorus
          %+  sign-bulla:cho
            bowl
          :+  %mcp-resource
            [uri.resource name.resource title.resource desc.resource]
          wick
        :_  %=  this
              mcp-resources  %-  ~(put by mcp-resources)
                             :-  our.bowl
                             %-  ~(put in (~(gut by mcp-resources) our.bowl ~))
                             :_  wick
                             :*  uri.resource
                                 name.resource
                                 title.resource
                                 desc.resource
                             ==
              sigs           (~(put by sigs) wick [ship sig]:bulla)
            ==
        ?:  =(`~ crowd.act)
          ~
        :_  ~
        %^    confect:gossip
            [`%2 crowd.act ~]
          %chorus-bulla
        !>(bulla)
      ::
          %mcp-resource-template
        =*  dek  desk.body.act
        =*  pax  path.body.act
        =/  =template:resource:mcp
          !<  template:resource:mcp
          .^(^vase %ca (welp /[p.pyk]/[dek]/[r.pyk] pax))
        =/  =wick  (make-clay-wick:cho bowl dek pax)
        =/  =bulla:chorus
          %+  sign-bulla:cho
            bowl
          :+  %mcp-resource-template
            [uri-template.template name.template title.template desc.template]
          wick
        :_  %=  this
              mcp-resource-templates
              %-  ~(put by mcp-resource-templates)
              :-  our.bowl
              %-  ~(put in (~(gut by mcp-resource-templates) our.bowl ~))
              :_  wick
              :*  uri-template.template
                  name.template
                  title.template
                  desc.template
              ==
              sigs  (~(put by sigs) wick [ship sig]:bulla)
            ==
        ?:  =(`~ crowd.act)
          ~
        :_  ~
        %^    confect:gossip
            [`%2 crowd.act ~]
          %chorus-bulla
        !>(bulla)
      ==
    ::
        %delete
      :-  ~
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
          sigs                    %-  malt
                                  %+  skip
                                    ~(tap by sigs)
                                  |=  [=wick *]
                                  =(target.act ship.id.wick)
        ==
      ::  remove wick from state
      %=  this
        state  %.  [state wick.target.act]
               |=  [sat=state-0:chorus =wick]
               ^-  state-0:chorus
               ::  XX .desks has no missive kind yet, so its wicks
               ::     are invisible to +sing:cho and cannot be forgotten here
               =-  -(desks desks.sat)
               %+  roll
                 %+  skip
                   (sing:cho sat)
                 |=(=bulla:chorus =(wick wick.msg.bulla))
               |=  [=bulla:chorus acc=state-0:chorus]
               (hear:cho acc bulla)
      ==
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
  =/  pre=path
    =/  who=@ta  (scot %p ship.bulla)
    ?-  -.msg.bulla
      %chorus-announcement    /fine/[who]/g/x/1/chorus//1/announcements
      %chorus-bio             /fine/[who]/g/x/1/chorus//1/bio
      %mcp-prompt             /fine/[who]/c/x
      %mcp-resource           /fine/[who]/c/x
      %mcp-resource-template  /fine/[who]/c/x
      %mcp-tool               /fine/[who]/c/x
    ==
  ?.  =(pre (scag (lent pre) path.wick))
    %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping bulla with invalid path prefix"]))
    `this
  ?.  flag.wick
    ::  don't verify contentful wicks right away
    `this(state (hear:cho state bulla))
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
    `this(state (hear:cho state bulla))
  ?.  (verify-wick wick `pass.u.u.key ~)
    %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping wick that {<ship.bulla>} did not sign"]))
    `this
  `this(state (hear:cho state bulla))
::
++  on-arvo  on-arvo:def
--
