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
    %+  ~(put by *(map mark $-(* vase)))  %chorus-message
    |=(n=* !>(;;(message:chorus n)))
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
  ::  .^((map ship listing:bio) %gx /=/chorus/=/rolodex/noun)
  ::  .^((map ship listing:bio) %gx /=/chorus/=/rolodex/~ship/noun)
      [%x %rolodex who=*]
    ?~  who.pole
      ``chorus-rolodex+!>(rolodex)
    ::  .whom, not =ship: a =ship face here shadows the mold the
    ::  cast below needs
    =/  whom=ship  (slav %p i:((lest knot) who.pole))
    =/  had=(unit listing:bio:chorus)  (~(get by rolodex) whom)
    :^  ~  ~  %chorus-rolodex
    !>  ^-  (map ship listing:bio:chorus)
    ?~  had  ~
    (~(put by *(map ship listing:bio:chorus)) whom u.had)
  ::
  ::  .^((map ship (set listing:announcement)) %gx /=/chorus/=/announcements/noun)
  ::  .^((map ship (set listing:announcement)) %gx /=/chorus/=/announcements/~ship/noun)
      [%x %announcements who=*]
    ?~  who.pole
      ``chorus-announcements+!>(announcements)
    =/  =ship  (slav %p i:((lest knot) who.pole))
    ``chorus-announcements+!>((malt ~[[ship (~(gut by announcements) ship ~)]]))
  ::
  ::  .^((map ship (set listing:desk)) %gx /=/chorus/=/desks/noun)
  ::  .^((map ship (set listing:desk)) %gx /=/chorus/=/desks/~ship/noun)
      [%x %desks who=*]
    ?~  who.pole
      ``chorus-desks+!>(desks)
    =/  =ship  (slav %p i:((lest knot) who.pole))
    ``chorus-desks+!>((malt ~[[ship (~(gut by desks) ship ~)]]))
  ::
  ::  .^((map ship (set listing:tool:mcp)) %gx /=/chorus/=/mcp-tools/noun)
  ::  .^((map ship (set listing:tool:mcp)) %gx /=/chorus/=/mcp-tools/~ship/noun)
      [%x %mcp-tools who=*]
    ?~  who.pole
      ``chorus-mcp-tools+!>(mcp-tools)
    =/  =ship  (slav %p i:((lest knot) who.pole))
    ``chorus-mcp-tools+!>((malt ~[[ship (~(gut by mcp-tools) ship ~)]]))
  ::
  ::  .^((map ship (set listing:prompt:mcp)) %gx /=/chorus/=/mcp-prompts/noun)
  ::  .^((map ship (set listing:prompt:mcp)) %gx /=/chorus/=/mcp-prompts/~ship/noun)
      [%x %mcp-prompts who=*]
    ?~  who.pole
      ``chorus-mcp-prompts+!>(mcp-prompts)
    =/  =ship  (slav %p i:((lest knot) who.pole))
    ``chorus-mcp-prompts+!>((malt ~[[ship (~(gut by mcp-prompts) ship ~)]]))
  ::
  ::  .^((map ship (set listing:resource:mcp)) %gx /=/chorus/=/mcp-resources/noun)
  ::  .^((map ship (set listing:resource:mcp)) %gx /=/chorus/=/mcp-resources/~ship/noun)
      [%x %mcp-resources who=*]
    ?~  who.pole
      ``chorus-mcp-resources+!>(mcp-resources)
    =/  =ship  (slav %p i:((lest knot) who.pole))
    ``chorus-mcp-resources+!>((malt ~[[ship (~(gut by mcp-resources) ship ~)]]))
  ::
  ::  .^((map ship (set listing:template:resource:mcp)) %gx /=/chorus/=/mcp-resource-templates/noun)
  ::  .^((map ship (set listing:template:resource:mcp)) %gx /=/chorus/=/mcp-resource-templates/~ship/noun)
      [%x %mcp-resource-templates who=*]
    ?~  who.pole
      ``chorus-mcp-resource-templates+!>(mcp-resource-templates)
    =/  =ship  (slav %p i:((lest knot) who.pole))
    ``chorus-mcp-resource-templates+!>((malt ~[[ship (~(gut by mcp-resource-templates) ship ~)]]))
  ==
::
++  on-watch
  |=  =(pole knot)
  ^-  (quip card _this)
  ?+  pole
    (on-watch:def pole)
  ::
  ::  replay heard messages to new subscribers
  ::  XX need to not leak state to subscribers that's
  ::     just for us; punt on this for now
      [%~.~ %gossip %source ~]
    :_  this
    %+  turn  (sing:cho state)
    |=  =message:chorus
    ^-  card
    [%give %fact ~ %chorus-message !>(message)]
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
        :_  this(rolodex (~(put by rolodex) our.bowl [bio.body.act wick]))
        :-  [%pass ~ %grow (snoc /bio (scot %da now.bowl)) txt+bio.body.act]
        ?:  =(`~ crowd.act)
          ~
        :_  ~
        %^    confect:gossip
            [`%2 crowd.act ~]
          %chorus-message
        !>  ^-  message:chorus
        [%chorus-message %chorus-bio bio.body.act wick]
      ::
          %announcement
        ?.  (lte (lent (trip announcement.body.act)) 256)
          ~|  "{<dap.bowl>}: announcement must be 256 characters or less"
          !!
        =/  =wick  (make-grow-wick:cho bowl /announcements txt+announcement.body.act)
        :_  %=  this
              announcements  %-  ~(put by announcements)
                             :-  our.bowl
                             %-  ~(put in (~(gut by announcements) our.bowl ~))
                             [now.bowl announcement.body.act wick]
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
          %chorus-message
        !>  ^-  message:chorus
        [%chorus-message %chorus-announcement announcement.body.act wick]
      ::
          ::  %desk
        ::  ::  XX gossip a wick of /fine/[p.pyk]/c/z/[ud.cass]/[desk];
        ::  ::     there is no %desk message:chorus kind yet
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
            ==
        ?:  =(`~ crowd.act)
          ~
        :_  ~
        %^    confect:gossip
            [`%2 crowd.act ~]
          %chorus-message
        !>  ^-  message:chorus
        :*  %chorus-message
            %mcp-tool
            :_  wick
            :*  name.tool
                desc.tool
                parameters.tool
                required.tool
            ==
        ==
      ::
          %mcp-prompt
        =*  dek  desk.body.act
        =*  pax  path.body.act
        =/  =prompt:mcp
          !<(prompt:mcp .^(^vase %ca (welp /[p.pyk]/[dek]/[r.pyk] pax)))
        =/  =wick  (make-clay-wick:cho bowl dek pax)
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
            ==
        ?:  =(`~ crowd.act)
          ~
        :_  ~
        %^    confect:gossip
            [`%2 crowd.act ~]
          %chorus-message
        !>  ^-  message:chorus
        :*  %chorus-message
            %mcp-prompt
            :_  wick
            :*  name.prompt
                title.prompt
                desc.prompt
                arguments.prompt
            ==
        ==
      ::
          %mcp-resource
        =*  dek  desk.body.act
        =*  pax  path.body.act
        =/  =resource:mcp
          !<(resource:mcp .^(^vase %ca (welp /[p.pyk]/[dek]/[r.pyk] pax)))
        =/  =wick  (make-clay-wick:cho bowl dek pax)
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
            ==
        ?:  =(`~ crowd.act)
          ~
        :_  ~
        %^    confect:gossip
            [`%2 crowd.act ~]
          %chorus-message
        !>  ^-  message:chorus
        :*  %chorus-message
            %mcp-resource
            :_  wick
            :*  uri.resource
                name.resource
                title.resource
                desc.resource
            ==
        ==
      ::
          %mcp-resource-template
        =*  dek  desk.body.act
        =*  pax  path.body.act
        =/  =template:resource:mcp
          !<  template:resource:mcp
          .^(^vase %ca (welp /[p.pyk]/[dek]/[r.pyk] pax))
        =/  =wick  (make-clay-wick:cho bowl dek pax)
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
            ==
        ?:  =(`~ crowd.act)
          ~
        :_  ~
        %^    confect:gossip
            [`%2 crowd.act ~]
          %chorus-message
        !>  ^-  message:chorus
        :*  %chorus-message
            %mcp-resource-template
            :_  wick
            :*  uri-template.template
                name.template
                title.template
                desc.template
            ==
        ==
      ==
    ::
    ::  verify saved content by its wick
    ::  and delete listing if this fails
        %verify
      =/  who=ship
        ?@(target.act target.act ship.target.act)
      =/  wix=(list wick)
        %+  murn
          (sing:cho state)
        |=  =message:chorus
        ^-  (unit wick)
        =/  =wick  wick.message
        ?.(=(who ship.wick) ~ `wick)
      =?  wix  ?=(^ target.act)
        ?.  (~(has in (silt wix)) wick.target.act)
          ~|("{<dap.bowl>}: no such wick in state" !!)
        ~[wick.target.act]
      ::
      =|  caz=(list card)
      =/  sat  state
      |-  ^-  (quip card _this)
      ?~  wix
        [caz this(state sat)]
      ::
      ::  if the wick signed content, we fetch
      ::  that content and verify in +on-arvo
      ?.  flag.i.wix
        %=  $
          wix  t.wix
          caz  :_  caz
               :*  %pass
                   /verify/(scot %p ship.i.wix)/(scot %uv (jam i.wix))
                   %arvo  %a  %keen  ~
                   [ship.i.wix (slag 2 path.i.wix)]
               ==
        ==
      ::  if not, we can verify right away
      =/  key=(unit [crypto-suite=@ud =pass])
        .^  (unit [crypto-suite=@ud =pass])
            %j
            /(scot %p our.bowl)/puby/(scot %da now.bowl)/(scot %p ship.i.wix)/(scot %ud rot.i.wix)
        ==
      ?~  key
        %-  (slog :_(~ [%leaf "{<dap.bowl>}: no pubkey in jael for {<ship.i.wix>}"]))
        `this
      ?:  (verify-wick i.wix `pass.u.key ~)
        $(wix t.wix)
      %-  (slog :_(~ [%leaf "{<dap.bowl>}: bad wick, forgetting ship {<ship.i.wix>}"]))
      %=  $
        wix  t.wix
        caz  :_  caz
             :*  %pass   ~
                 %agent  [our.bowl %chorus]
                 %poke   %chorus-action
                 !>([%delete who])
             ==
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
        ==
      ::  remove wick from state
      %=  this
        state  %.  [state wick.target.act]
               |=  [sat=state-0:chorus =wick]
               ^-  state-0:chorus
               ::  XX .desks has no message kind yet, so its wicks
               ::     are invisible to +sing:cho and cannot be forgotten here
               =-  -(desks desks.sat)
               %+  roll
                 %+  skip  (sing:cho sat)
                 |=(=message:chorus =(wick wick.message))
               |=  [=message:chorus acc=state-0:chorus]
               (hear:cho acc message)
      ==
    ==
  ==
::
++  on-agent
  |=  [=(pole knot) =sign:agent:gall]
  ^-  (quip card _this)
  ?.  ?=([%~.~ %gossip %gossip ~] pole)
    (on-agent:def pole sign)
  ?.  ?=([%fact %chorus-message *] sign)
    `this
  =/  =message:chorus  !<(message:chorus q.cage.sign)
  ::  XX handle %chorus-disavow here
  =/  =wick  wick.message
  ?:  =(our.bowl ship.wick)
    `this
  =/  pre=path
    %.  message
    |=  =message:chorus
    ^-  path
    =/  who=@ta  (scot %p ship.wick)
    ?-  -.+.message
      %chorus-announcement    /fine/[who]/g/x/1/chorus//1/announcements
      %chorus-bio             /fine/[who]/g/x/1/chorus//1/bio
      %mcp-prompt             /fine/[who]/c/x
      %mcp-resource           /fine/[who]/c/x
      %mcp-resource-template  /fine/[who]/c/x
      %mcp-tool               /fine/[who]/c/x
    ==
  ?.  =(pre (scag (lent pre) path.wick))
    %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping message with invalid path prefix"]))
    `this
  ::
  ::  we verify a path-only wick as soon as we hear about it,
  ::  and leave it to the client to verify fetched content against
  ::  the wick that signed it when they decide to fetch that content
  ?.  flag.wick
    `this(state (hear:cho state message))
  =/  key=(unit [crypto-suite=@ud =pass])
    .^  (unit [crypto-suite=@ud =pass])
        %j
        /(scot %p our.bowl)/puby/(scot %da now.bowl)/(scot %p ship.wick)/(scot %ud rot.wick)
    ==
  ?~  key
    %-  (slog :_(~ [%leaf "{<dap.bowl>}: no pubkey in jael for {<ship.wick>}"]))
    `this
  ?.  (verify-wick wick `pass.u.key ~)
    %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping message with bad signature from {<ship.wick>}"]))
    `this
  `this(state (hear:cho state message))
::
++  on-arvo
  |=  [=(pole knot) =sign-arvo]
  ^-  (quip card _this)
  ?+    pole  (on-arvo:def pole sign-arvo)
      ::
      ::  the answer to a %verify poke for a contentful wick
      ::
      ::  XX handle keen | -> keen & -> chum fallback for
      ::     two-way- and multi-party-encrypted remote scry
      ::     paths; start with [%verify *] and branch on
      ::     [%keen | *], [%keen & *], [%chum *]
      [%verify who=@ta wik=@ta ~]
    ?+    sign-arvo  (on-arvo:def pole sign-arvo)
        [%ames %sage *]
      =/  =ship  (slav %p who.pole)
      =/  =wick  ;;(wick (cue (slav %uv wik.pole)))
      =/  =sage:mess:ames  sage.sign-arvo
      =/  key=(unit [crypto-suite=@ud =pass])
        .^  (unit [crypto-suite=@ud =pass])
            %j
            /(scot %p our.bowl)/puby/(scot %da now.bowl)/(scot %p ship)/(scot %ud rot.wick)
        ==
      ::  an empty sage means the path is gone, which is a failure to
      ::  verify like any other
      =/  ok=?
        ?&  =(ship ship.wick)
            =(ship ship.p.sage)
            =((slag 2 path.wick) path.p.sage)
            ?=(^ q.sage)
            (verify-wick wick ?~(key ~ `pass.u.key) `(fine-octs sage))
        ==
      ?:  ok  `this
      %-  (slog :_(~ [%leaf "{<dap.bowl>}: forgetting unverified entry from {<ship>}"]))
      :-  ~
      ::  remove wick from state
      %=  this
        state  %.  [state wick]
               |=  [sat=state-0:chorus =^wick]
               ^-  state-0:chorus
               ::  XX .desks has no message kind yet, so its wicks
               ::     are invisible to +sing:cho and cannot be forgotten here
               =-  -(desks desks.sat)
               %+  roll
                 %+  skip  (sing:cho sat)
                 |=(=message:chorus =(wick wick.message))
               |=  [=message:chorus acc=state-0:chorus]
               (hear:cho acc message)
      ==
    ==
  ==
--
