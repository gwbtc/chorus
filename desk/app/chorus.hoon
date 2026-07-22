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
::  sign a contentful wick over a grown %txt path and the full
::  sage:mess:ames the requester will receive in +on-arvo
++  make-grow-wick
  |=  [=bowl:gall seg=@tas txt=@t]
  ^-  wick
  =/  pax=path
    /fine/(scot %p our.bowl)/g/x/1/chorus//1/[seg]/(scot %da now.bowl)
  =/  =sage:mess:ames  [[our.bowl (slag 2 pax)] %txt txt]
  (make-wick | (feed-to-seed bowl) pax `(fine-octs sage))
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
  ::     each wick as a message:chrous without re-growing or re-signing
      [%~.~ %gossip %source ~]
    ::  ~&  >>  [%chorus %publish-watch-bio our=our.bowl path=path]
    :_  this
    :~  :*  %give
            %fact
            ~
            %chorus-message
            !>  ^-  message:chorus
            :*  %chorus-message
                %bio
                (make-grow-wick bowl %bio (~(gut by rolodex) our.bowl ''))
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
      :_  %=  this
            rolodex  (~(put by rolodex) [our.bowl bio.act])
          ==
      ?:  local.act
        :~  :*  %pass  ~
                %grow  /bio/[r.pyk]
                [%txt bio.act]
            ==
        ==
      =/  =wick  (make-grow-wick bowl %bio bio.act)
      ::  ~&  >>  [%chorus %publish-updated-bio our=our.bowl path=path.wick]
      :~  (invent:gossip %chorus-message !>([%chorus-message %bio wick]))
          :*  %pass  ~
              %grow  /bio/[r.pyk]
              [%txt bio.act]
          ==
      ==
    ::
        %make-announcement
      ?.  (lte (lent (trip announcement.act)) 256)
        ~|  "{<dap.bowl>}: announcement must be 256 characters or less"
        !!
      :_   %=  this
             announcements  %-  ~(put by announcements)
                            :-  our.bowl
                            %-  ~(put in (~(gut by announcements) our.bowl ~))
                            [now.bowl announcement.act]
           ==
      ?:  local.act
        :~  :*  %pass  ~
                %grow
                /announcements/[r.pyk]
                [%txt announcement.act]
            ==
        ==
      =/  =wick  (make-grow-wick bowl %announcements announcement.act)
      :~  (invent:gossip %chorus-message !>([%chorus-message %announcement wick]))
          :*  %pass  ~
              %grow
              /announcements/[r.pyk]
              [%txt announcement.act]
          ==
      ==
    ::
        %publish-desk
      =/  =cass:clay  .^(cass:clay %cw /[p.pyk]/[desk.act]/[r.pyk])
      ::  =/  =wick
        ::  %:  make-wick
            ::  &
            ::  (feed-to-seed bowl)
            ::  /fine/[p.pyk]/c/z/(scot %tas ud.cass)/[desk.act]
            ::  ~
        ::  ==
      ::  XX gossip wick
      :-  ~
      %=  this
        desks  %-  ~(put by desks)
               :-  our.bowl
               %-  ~(put in (~(gut by desks) our.bowl ~))
               [desk.act desc.act]
      ==
    ::
        %publish-mcp-tool
      =/  =cass:clay  .^(cass:clay %cw /[p.pyk]/[desk.act]/[r.pyk])
      =/  =tool:mcp   !<(tool:mcp .^(^vase %ca (welp /[p.pyk]/[desk.act]/[r.pyk] path.act)))
      ::  XX content wick
      =/  =wick
        %:  make-wick
            &
            (feed-to-seed bowl)
            %+  welp
              /fine/[p.pyk]/c/x/(scot %ud ud.cass)/[desk.act]
            path.act
            ~
        ==
      ::  XX gossip wick
      :-  ~
      %=  this
        mcp-tools  %-  ~(put by mcp-tools)
                   :-  our.bowl
                   %-  ~(put in (~(gut by mcp-tools) our.bowl ~))
                   :*  name.tool
                       desc.tool
                       parameters.tool
                       required.tool
                       wick
                   ==
      ==
    ::
        %publish-mcp-prompt
      =/  =cass:clay  .^(cass:clay %cw /[p.pyk]/[desk.act]/[r.pyk])
      =/  =prompt:mcp
        !<(prompt:mcp .^(^vase %ca (welp /[p.pyk]/[desk.act]/[r.pyk] path.act)))
      =/  =wick
        %:  make-wick
            &
            (feed-to-seed bowl)
            %+  welp
              /fine/[p.pyk]/c/x/(scot %ud ud.cass)/[desk.act]
            path.act
            ~
        ==
      ::  XX gossip wick
      :-  ~
      %=  this
        mcp-prompts  %-  ~(put by mcp-prompts)
                     :-  our.bowl
                     %-  ~(put in (~(gut by mcp-prompts) our.bowl ~))
                     :*  name.prompt
                         title.prompt
                         desc.prompt
                         arguments.prompt
                         wick
                     ==
      ==
    ::
        %publish-mcp-resource
      =/  =cass:clay  .^(cass:clay %cw /[p.pyk]/[desk.act]/[r.pyk])
      =/  =resource:mcp
        !<(resource:mcp .^(^vase %ca (welp /[p.pyk]/[desk.act]/[r.pyk] path.act)))
      =/  =wick
        %:  make-wick
            &
            (feed-to-seed bowl)
            %+  welp
              /fine/[p.pyk]/c/x/(scot %ud ud.cass)/[desk.act]
            path.act
            ~
        ==
      ::  XX gossip wick
      :-  ~
      %=  this
        mcp-resources  %-  ~(put by mcp-resources)
                       :-  our.bowl
                       %-  ~(put in (~(gut by mcp-resources) our.bowl ~))
                       :*  uri.resource
                           name.resource
                           title.resource
                           desc.resource
                           wick
                       ==
      ==
    ::
        %publish-mcp-resource-template
      =/  =cass:clay  .^(cass:clay %cw /[p.pyk]/[desk.act]/[r.pyk])
      =/  =template:resource:mcp
        !<(template:resource:mcp .^(^vase %ca (welp /[p.pyk]/[desk.act]/[r.pyk] path.act)))
      =/  =wick
        %:  make-wick
            &
            (feed-to-seed bowl)
            %+  welp
              /fine/[p.pyk]/c/x/(scot %ud ud.cass)/[desk.act]
            path.act
            ~
        ==
      ::  XX gossip wick
      :-  ~
      %=  this
        mcp-resource-templates  %-  ~(put by mcp-resource-templates)
                                :-  our.bowl
                                %-  ~(put in (~(gut by mcp-resource-templates) our.bowl ~))
                                :*  uri-template.template
                                    name.template
                                    title.template
                                    desc.template
                                    wick
                                ==
      ==
    ==
  ==
::
++  on-agent
  |=  [=(pole knot) =sign:agent:gall]
  ^-  (quip card _this)
  ?+  pole
    (on-agent:def pole sign)
  ::
      [%~.~ %gossip %gossip ~]
    ?.  ?=([%fact %chorus-message *] sign)
      `this
    =/  =message:chorus  !<(message:chorus q.cage.sign)
    ?+    message
        `this
    ::
        [%chorus-message %bio *]
      =/  =wick  wick.message
      ::  ~&  >>  :*  %chorus  %received-bio-wick
                  ::  our=our.bowl
                  ::  source=src.bowl
                  ::  signer=ship.wick
                  ::  path=path.wick
              ::  ==
      ::  bio wicks sign the path and the response; we can only
      ::  verify after fetching the content, in +on-arvo
      ?:  flag.wick
        %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping %bio message without signed content"]))
        `this
      =/  =spar:ames  [ship.wick (slag 2 path.wick)]
      ?.  ?=([%fine @t %g %x @t %chorus %$ @t %bio @t ~] path.wick)
        %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping %bio message with wrong path"]))
        `this
      ?.  =((scot %p ship.wick) i.t.path.wick)
        %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping %bio message with wrong source"]))
        `this
      :_  this
      :~  :*  %pass
              /fine/bio/(scot %p ship.wick)/(scot %uv (jam wick))
              %arvo  %a  %keen  ~
              spar
          ==
      ==
    ::
        [%chorus-message %announcement *]
      =/  =wick  wick.message
      ::  announcement wicks sign the path and the response; we can
      ::  only verify after fetching the content, in +on-arvo
      ?:  flag.wick
        %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping %announcement message without signed content"]))
        `this
      =/  =spar:ames  [ship.wick (slag 2 path.wick)]
      ?.  ?=([%fine @t %g %x @t %chorus %$ @t %announcements @t ~] path.wick)
        %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping %announcement message with wrong path"]))
        `this
      ?.  =((scot %p ship.wick) i.t.path.wick)
        %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping %announcement message with wrong source"]))
        `this
      :_  this
      :~  :*  %pass
              /fine/announcement/(scot %p ship.wick)/(scot %uv (jam wick))
              %arvo  %a  %keen  ~
              spar
          ==
      ==
    ==
  ==
::
++  on-arvo
  |=  [=(pole knot) =sign-arvo]
  ^-  (quip card _this)
  ?+    pole
      (on-arvo:def pole sign-arvo)
  ::
      [%fine msg=@ta who=@ta hax=@ta ~]
    ?+    sign-arvo
        (on-arvo:def pole sign-arvo)
    ::
        [%ames %sage *]
      =/  =sage:mess:ames  sage.sign-arvo
      ?+    msg.pole
          (on-arvo:def pole sign-arvo)
      ::
          %bio
        ?~  q.sage
          %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping %keen result with empty sage"]))
          `this
        =/  =ship  (slav %p who.pole)
        ?.  =(ship ship.p.sage)
          %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping %keen result with ship mismatch; expected {<ship>}, got {<ship.p.sage>}"]))
          `this
        =/  =wick  ;;(wick (cue (slav %uv hax.pole)))
        ?.  =(ship ship.wick)
          %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping wick with ship mismatch; expected {<ship>}, got {<ship.wick>}"]))
          `this
        ?.  =((slag 2 path.wick) path.p.sage)
          %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping wick with path mismatch; expected {<ship>}, got {<ship.wick>}"]))
          `this
        =/  =page  q.sage
        ?.  =(%txt p.page)
          %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping message with wrong mark; expected %txt, got {<p.page>}"]))
          `this
        =/  bio=@t  ;;(@t q.page)
        ?.  (lte (lent (trip bio)) 256)
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
        `this(rolodex (~(put by rolodex) ship bio))
      ::
          %announcement
        ?~  q.sage
          %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping %keen result with empty sage"]))
          `this
        =/  =ship  (slav %p who.pole)
        ?.  =(ship ship.p.sage)
          %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping %keen result with ship mismatch; expected {<ship>}, got {<ship.p.sage>}"]))
          `this
        =/  =wick  ;;(wick (cue (slav %uv hax.pole)))
        ?.  =(ship ship.wick)
          %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping wick with ship mismatch; expected {<ship>}, got {<ship.wick>}"]))
          `this
        ?.  =((slag 2 path.wick) path.p.sage)
          %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping wick with path mismatch; expected {<ship>}, got {<ship.wick>}"]))
          `this
        =/  =page  q.sage
        ?.  =(%txt p.page)
          %-  (slog :_(~ [%leaf "{<dap.bowl>}: dropping message with wrong mark; expected %txt, got {<p.page>}"]))
          `this
        =/  =announcement:chorus  ;;(@t q.page)
        ?.  (lte (lent (trip announcement)) 256)
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
        =/  =time  (slav %da (rear path.wick))
        :-  ~
        %=  this
          announcements  %-  ~(put by announcements)
                         :-  ship
                         %-  ~(put in (~(gut by announcements) ship ~))
                         [time announcement]
        ==
      ==
    ==
  ==
--
