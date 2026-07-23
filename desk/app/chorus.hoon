::
::  chorus: peer-to-peer multiplayer agent harness
/-  mcp, *wick, chorus
/+  dbug, verb, *chorus, default-agent, gossip, *wick
::
|%
+$  versioned-state
  $%  state-0:chorus
  ==
::
+$  card  card:agent:gall
::
++  feed-to-seed
  |=  =bowl:gall
  ^-  seed:jael
  =/  =feed:jael
    ;;  feed:jael
    (cue .^(@ %j /(scot %p our.bowl)/vile/(scot %da now.bowl)))
  ?>  ?=([%2 ~] -.feed)
  ?~  kyz.feed
    ~|(%chorus-vile-without-keys !!)
  [who.feed lyf.i.kyz.feed key.i.kyz.feed ~]
::
::  sign a contentful wick over a grown path and the full
::  sage:mess:ames the requester will receive in +on-arvo
::  XX will eventually have to handle non-/fine paths = no pages
++  make-grow-wick
  |=  [=bowl:gall seg=path =page]
  ^-  wick
  =/  pax=path
    :(welp /fine/(scot %p our.bowl)/g/x/1/chorus//1 seg /(scot %da now.bowl))
  (make-wick | (feed-to-seed bowl) pax `(fine-octs [[our.bowl (slag 2 pax)] page]))
::
::  sign a contentful wick over the clay fine path for a source
::  file and the full sage:mess:ames a remote scry will receive
++  make-clay-wick
  |=  [=bowl:gall =desk pax=path]
  ^-  wick
  =/  bek=path  /(scot %p our.bowl)/[desk]/(scot %da now.bowl)
  =/  cas=cass:clay  .^(cass:clay %cw bek)
  =/  fyn=path
    :(welp /fine/(scot %p our.bowl)/c/x/(scot %ud ud.cas)/[desk] pax)
  =/  =page  [(slav %tas (rear pax)) .^(* %cx (welp bek pax))]
  (make-wick | (feed-to-seed bowl) fyn `(fine-octs [[our.bowl (slag 2 fyn)] page]))
::
::  the wick sits at a different axis per message kind, so a
::  generic face lookup forks; extract it per kind
++  message-wick
  |=  =message:chorus
  ^-  wick
  ?-  -.+.message
    %disavow                ~|(%chorus-disavow-has-no-wick !!)
    %bio                    wick.+.message
    %announcement           wick.+.message
    %mcp-tool               wick.+.message
    %mcp-prompt             wick.+.message
    %mcp-resource           wick.+.message
    %mcp-resource-template  wick.+.message
  ==
--
::
=|  state-0:chorus
=*  state  -
::
%-  %+  agent:gossip
      :*  2              ::  hops
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
  =/  saved  !<(versioned-state old)
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
  ::  .^((map ship cord) %gx /=/chorus/=/rolodex/noun)
  ::  .^((map ship cord) %gx /=/chorus/=/rolodex/~ship/noun)
      [%x %rolodex who=*]
    ?~  who.pole
      ``chorus-rolodex+!>(rolodex)
    =/  =ship  (slav %p i:((lest knot) who.pole))
    ``chorus-rolodex+!>((malt ~[[ship (~(gut by rolodex) ship '')]]))
  ::
  ::  .^((map ship (set cord)) %gx /=/chorus/=/announcements/noun)
  ::  .^((map ship (set cord)) %gx /=/chorus/=/announcements/~ship/noun)
      [%x %announcements who=*]
    ?~  who.pole
      ``chorus-announcements+!>(announcements)
    =/  =ship  (slav %p i:((lest knot) who.pole))
    ``chorus-announcements+!>((malt ~[[ship (~(gut by announcements) ship ~)]]))
  ::
  ::  .^((map ship (set [desk cord])) %gx /=/chorus/=/desks/noun)
  ::  .^((map ship (set [desk cord])) %gx /=/chorus/=/desks/~ship/noun)
      [%x %desks who=*]
    ?~  who.pole
      ``chorus-desks+!>(desks)
    =/  =ship  (slav %p i:((lest knot) who.pole))
    ``chorus-desks+!>((malt ~[[ship (~(gut by desks) ship ~)]]))
  ::
  ::  .^((map ship (set mcp-tool-listing)) %gx /=/chorus/=/mcp-tools/noun)
  ::  .^((map ship (set mcp-tool-listing)) %gx /=/chorus/=/mcp-tools/~ship/noun)
      [%x %mcp-tools who=*]
    ?~  who.pole
      ``chorus-mcp-tools+!>(mcp-tools)
    =/  =ship  (slav %p i:((lest knot) who.pole))
    ``chorus-mcp-tools+!>((malt ~[[ship (~(gut by mcp-tools) ship ~)]]))
  ::
  ::  .^((map ship (set mcp-prompt-listing)) %gx /=/chorus/=/mcp-prompts/noun)
  ::  .^((map ship (set mcp-prompt-listing)) %gx /=/chorus/=/mcp-prompts/~ship/noun)
      [%x %mcp-prompts who=*]
    ?~  who.pole
      ``chorus-mcp-prompts+!>(mcp-prompts)
    =/  =ship  (slav %p i:((lest knot) who.pole))
    ``chorus-mcp-prompts+!>((malt ~[[ship (~(gut by mcp-prompts) ship ~)]]))
  ::
  ::  .^((map ship (set mcp-resource-listing)) %gx /=/chorus/=/mcp-resources/noun)
  ::  .^((map ship (set mcp-resource-listing)) %gx /=/chorus/=/mcp-resources/~ship/noun)
      [%x %mcp-resources who=*]
    ?~  who.pole
      ``chorus-mcp-resources+!>(mcp-resources)
    =/  =ship  (slav %p i:((lest knot) who.pole))
    ``chorus-mcp-resources+!>((malt ~[[ship (~(gut by mcp-resources) ship ~)]]))
  ::
  ::  .^((map ship (set mcp-resource-template-listing)) %gx /=/chorus/=/mcp-resource-templates/noun)
  ::  .^((map ship (set mcp-resource-template-listing)) %gx /=/chorus/=/mcp-resource-templates/~ship/noun)
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
  ::  new subscribers listen on this wire
  ::  XX look through all app state and relay
  ::     each wick as a message:chorus without re-growing or re-signing
      [%~.~ %gossip %source ~]
    :_  this
    :~  :*  %give
            %fact
            ~
            %chorus-message
            !>  ^-  message:chorus
            :*  %chorus-message
                %bio
                (make-grow-wick bowl /bio txt+(~(gut by rolodex) our.bowl ''))
            ==
        ==
    ==
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
        %update-bio
      ?.  (lte (lent (trip bio.act)) 256)
        ~|  "{<dap.bowl>}: bio must be 256 characters or less"
        !!
      :_  this(rolodex (~(put by rolodex) [our.bowl bio.act]))
      :-  [%pass ~ %grow (snoc /bio (scot %da now.bowl)) txt+bio.act]
      ?:  local.act
        ~
      :_  ~
      %+  invent:gossip  %chorus-message
      !>  ^-  message:chorus
      [%chorus-message %bio (make-grow-wick bowl /bio txt+bio.act)]
    ::
        %make-announcement
      ?.  (lte (lent (trip announcement.act)) 256)
        ~|  "{<dap.bowl>}: announcement must be 256 characters or less"
        !!
      :_  %=  this
            announcements  %-  ~(put by announcements)
                           :-  our.bowl
                           %-  ~(put in (~(gut by announcements) our.bowl ~))
                           [now.bowl announcement.act]
          ==
      :-  :*  %pass  ~  %grow
              (snoc /announcements (scot %da now.bowl))
              txt+announcement.act
          ==
      ?:  local.act
        ~
      :_  ~
      %+  invent:gossip  %chorus-message
      !>  ^-  message:chorus
      :*  %chorus-message
          %announcement
          (make-grow-wick bowl /announcements txt+announcement.act)
      ==
    ::
        %publish-desk
      ::  XX gossip wick over /fine/[p.pyk]/c/z/[ud.cass]/[desk.act];
      ::     there is no %desk message:chorus kind yet
      :-  ~
      %=  this
        desks  %-  ~(put by desks)
               :-  our.bowl
               %-  ~(put in (~(gut by desks) our.bowl ~))
               [desk.act desc.act]
      ==
    ::
        %publish-mcp-tool
      =/  meta=mcp-tool-metadata
        %-  tool-meta
        !<(tool:mcp .^(^vase %ca (welp /[p.pyk]/[desk.act]/[r.pyk] path.act)))
      =/  =wick  (make-clay-wick bowl desk.act path.act)
      :_  %=  this
            mcp-tools  %-  ~(put by mcp-tools)
                       :-  our.bowl
                       %-  ~(put in (~(gut by mcp-tools) our.bowl ~))
                       [meta wick]
          ==
      ?:  local.act
        ~
      :_  ~
      %+  invent:gossip  %chorus-message
      !>  ^-  message:chorus
      [%chorus-message %mcp-tool meta wick]
    ::
        %publish-mcp-prompt
      =/  meta=mcp-prompt-metadata
        %-  prompt-meta
        !<(prompt:mcp .^(^vase %ca (welp /[p.pyk]/[desk.act]/[r.pyk] path.act)))
      =/  =wick  (make-clay-wick bowl desk.act path.act)
      :_  %=  this
            mcp-prompts  %-  ~(put by mcp-prompts)
                         :-  our.bowl
                         %-  ~(put in (~(gut by mcp-prompts) our.bowl ~))
                         [meta wick]
          ==
      ?:  local.act
        ~
      :_  ~
      %+  invent:gossip  %chorus-message
      !>  ^-  message:chorus
      [%chorus-message %mcp-prompt meta wick]
    ::
        %publish-mcp-resource
      =/  meta=mcp-resource-metadata
        %-  resource-meta
        !<(resource:mcp .^(^vase %ca (welp /[p.pyk]/[desk.act]/[r.pyk] path.act)))
      =/  =wick  (make-clay-wick bowl desk.act path.act)
      :_  %=  this
            mcp-resources  %-  ~(put by mcp-resources)
                           :-  our.bowl
                           %-  ~(put in (~(gut by mcp-resources) our.bowl ~))
                           [meta wick]
          ==
      ?:  local.act
        ~
      :_  ~
      %+  invent:gossip  %chorus-message
      !>  ^-  message:chorus
      [%chorus-message %mcp-resource meta wick]
    ::
        %publish-mcp-resource-template
      =/  meta=mcp-resource-template-metadata
        %-  resource-template-meta
        !<  template:resource:mcp
        .^(^vase %ca (welp /[p.pyk]/[desk.act]/[r.pyk] path.act))
      =/  =wick  (make-clay-wick bowl desk.act path.act)
      :_  %=  this
            mcp-resource-templates
            %-  ~(put by mcp-resource-templates)
            :-  our.bowl
            %-  ~(put in (~(gut by mcp-resource-templates) our.bowl ~))
            [meta wick]
          ==
      ?:  local.act
        ~
      :_  ~
      %+  invent:gossip  %chorus-message
      !>  ^-  message:chorus
      [%chorus-message %mcp-resource-template meta wick]
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
  ::  XX handle %disavow
  ?:  ?=([%chorus-message %disavow *] message)
    `this
  =/  kind=@tas  -.+.message
  =/  =wick  (message-wick message)
  ::  ~&  >>  [%on-agent-got-message kind=kind signer=ship.wick path=path.wick]
  ::  contentful wicks sign the path and the response; we can
  ::  only verify after fetching the content, in +on-arvo
  ?:  flag.wick
    %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping {<kind>} message without signed content"]))
    `this
  ::  bio and announcement wicks sign a gall grow path on this
  ::  app; mcp wicks sign the clay path of the source file
  =/  pre=path
    ?+    kind  ~|(%chorus-unknown-kind !!)
        %bio
      /fine/(scot %p ship.wick)/g/x/1/chorus//1/bio
        %announcement
      /fine/(scot %p ship.wick)/g/x/1/chorus//1/announcements
        ?(%mcp-tool %mcp-prompt %mcp-resource %mcp-resource-template)
      /fine/(scot %p ship.wick)/c/x
    ==
  ?.  =(pre (scag (lent pre) path.wick))
    %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping {<kind>} message with wrong path"]))
    `this
  ::  ~&  >>  [%on-agent-sending-keen kind=kind spar=[ship.wick (slag 2 path.wick)]]
  :_  this
  :~  :*  %pass
          /fine/[kind]/(scot %p ship.wick)/(scot %uv (jam message))
          %arvo  %a  %keen  ~
          [ship.wick (slag 2 path.wick)]
      ==
  ==
::
++  on-arvo
  |=  [=(pole knot) =sign-arvo]
  ^-  (quip card _this)
  ?.  ?=([%fine msg=@ta who=@ta hax=@ta ~] pole)
    (on-arvo:def pole sign-arvo)
  ?.  ?=([%ames %sage *] sign-arvo)
    (on-arvo:def pole sign-arvo)
  =/  =sage:mess:ames  sage.sign-arvo
  ::  ~&  >>  [%on-arvo-got-sage msg=msg.pole who=who.pole empty=?=(~ q.sage)]
  ?~  q.sage
    %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping %keen result with empty sage"]))
    `this
  =/  =ship  (slav %p who.pole)
  ?.  =(ship ship.p.sage)
    %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping %keen result with ship mismatch; expected {<ship>}, got {<ship.p.sage>}"]))
    `this
  =/  =message:chorus  ;;(message:chorus (cue (slav %uv hax.pole)))
  ?:  ?=([%chorus-message %disavow *] message)
    `this
  =/  =wick  (message-wick message)
  ?.  =(ship ship.wick)
    %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping wick with ship mismatch; expected {<ship>}, got {<ship.wick>}"]))
    `this
  ?.  =((slag 2 path.wick) path.p.sage)
    %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping wick with path mismatch; expected {<(slag 2 path.wick)>}, got {<path.p.sage>}"]))
    `this
  ::  verify the signature over the path and the sage we received
  =/  key=(unit [crypto-suite=@ud =pass])
    .^  (unit [crypto-suite=@ud =pass])
        %j
        /(scot %p our.bowl)/puby/(scot %da now.bowl)/(scot %p ship.wick)/(scot %ud rot.wick)
    ==
  ?.  (verify-wick wick ?~(key ~ `pass.u.key) `(fine-octs sage))
    %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping message with bad signature from {<ship.wick>}"]))
    `this
  =/  =page  q.sage
  ::  ~&  >>  [%on-arvo-verified msg=msg.pole mark=p.page]
  ?+    msg.pole
      (on-arvo:def pole sign-arvo)
  ::
      %bio
    ?.  =(%txt p.page)
      %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping message with wrong mark; expected %txt, got {<p.page>}"]))
      `this
    =/  bio=@t  ;;(@t q.page)
    ?.  (lte (lent (trip bio)) 256)
      `this
    ::  ~&  >  [%on-arvo-stored %bio ship]
    `this(rolodex (~(put by rolodex) ship bio))
  ::
      %announcement
    ?.  =(%txt p.page)
      %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping message with wrong mark; expected %txt, got {<p.page>}"]))
      `this
    =/  =announcement:chorus  ;;(@t q.page)
    ?.  (lte (lent (trip announcement)) 256)
      `this
    ::  ~&  >  [%on-arvo-stored %announcement ship]
    :-  ~
    %=  this
      announcements  %-  ~(put by announcements)
                     :-  ship
                     %-  ~(put in (~(gut by announcements) ship ~))
                     [(slav %da (rear path.wick)) announcement]
    ==
  ::
      %mcp-tool
    ?.  ?=([%chorus-message %mcp-tool *] message)
      %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping %mcp-tool wire with mismatched message"]))
      `this
    ::  the wick signs the source; the metadata is unsigned
    ::  ~&  >  [%on-arvo-stored %mcp-tool ship]
    :-  ~
    %=  this
      mcp-tools  %-  ~(put by mcp-tools)
                 :-  ship
                 %-  ~(put in (~(gut by mcp-tools) ship ~))
                 [meta.+.message wick]
    ==
  ::
      %mcp-prompt
    ?.  ?=([%chorus-message %mcp-prompt *] message)
      %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping %mcp-prompt wire with mismatched message"]))
      `this
    ::  ~&  >  [%on-arvo-stored %mcp-prompt ship]
    :-  ~
    %=  this
      mcp-prompts  %-  ~(put by mcp-prompts)
                   :-  ship
                   %-  ~(put in (~(gut by mcp-prompts) ship ~))
                   [meta.+.message wick]
    ==
  ::
      %mcp-resource
    ?.  ?=([%chorus-message %mcp-resource *] message)
      %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping %mcp-resource wire with mismatched message"]))
      `this
    ::  ~&  >  [%on-arvo-stored %mcp-resource ship]
    :-  ~
    %=  this
      mcp-resources  %-  ~(put by mcp-resources)
                     :-  ship
                     %-  ~(put in (~(gut by mcp-resources) ship ~))
                     [meta.+.message wick]
    ==
  ::
      %mcp-resource-template
    ?.  ?=([%chorus-message %mcp-resource-template *] message)
      %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping %mcp-resource-template wire with mismatched message"]))
      `this
    ::  ~&  >  [%on-arvo-stored %mcp-resource-template ship]
    :-  ~
    %=  this
      mcp-resource-templates  %-  ~(put by mcp-resource-templates)
                              :-  ship
                              %-  ~(put in (~(gut by mcp-resource-templates) ship ~))
                              [meta.+.message wick]
    ==
  ==
--
