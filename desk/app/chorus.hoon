::
::  chorus: peer-to-peer multiplayer agent harness
/-  mcp, *wick, chorus
/+  dbug, verb, *chorus, default-agent, *wick
::
|%
+$  versioned-state
  $%  state-0:chorus
  ==
::
+$  card  card:agent:gall
--
::
=|  state-0:chorus
=*  state  -
::
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
  `this
  ::  ?+  pole
    ::  (on-watch:def pole)
  ::  ::
  ::  ::  gossip library calls this when a peer subscribes to us;
  ::  ::  return our current state as initial facts for them
      ::  ::  [%~.~ %gossip %source ~]
    ::  ::  `this
  ::  ::
  ::  ::  bio subscription: send current bio as initial fact
      ::  [%bio ~]
    ::  :_  this
    ::  :~  [%give %fact ~ %chorus-bio !>(bio)]
    ::  ==
  ::  ::
  ::  ::  clients subscribe here for updates
      ::  [%client ~]
    ::  `this
  ::  ==
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
     :_   %=  this
            rolodex  (~(put by rolodex) [our.bowl bio.act])
          ==
     ?:  local.act
       :~  :*  %pass  ~
               %grow  /bio
               [%txt bio.act]
           ==
       ==
     =/  rev=@ud  (tail .^((pair @tas @ud) %gw /[p.pyk]/[q.pyk]/[r.pyk]//1/bio))
     =/  =path  /fine/[p.pyk]/g/x/(scot %ud rev)/chorus//1/bio
     =/  lyf  .^((unit @ud) %j /[p.pyk]/lyfe/[r.pyk]/[p.pyk])
     ::  XX placeholder: use the Groundwire HD wallet's secp256k1 scalar here
     ::  once that key is exposed, instead of deriving one from Jael's ring.
     =/  sec=ring  .^(ring %j /[p.pyk]/vein/[r.pyk]/(scot %ud (need lyf)))
     =/  =wick  (make-wick & byk.bowl path sec)
     ::  XX gossip wick
     :~  :*  %pass  ~
             %grow  /bio
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
      =/  rev=@ud  (tail .^((pair @tas @ud) %gw /[p.pyk]/[q.pyk]/[r.pyk]//1/announcements/[r.pyk]))
      =/  =path
        /fine/[p.pyk]/g/x/(scot %ud rev)/chorus//1/announcements/[r.pyk]
      =/  lyf  .^((unit @ud) %j /[p.pyk]/lyfe/[r.pyk]/[p.pyk])
      =/  sec=ring  .^(ring %j /[p.pyk]/vein/[r.pyk]/(scot %ud (need lyf)))
      =/  =wick  (make-wick & byk.bowl path sec)
      ::  XX gossip wick
      :~  :*  %pass  ~
              %grow
              /announcements/[r.pyk]
              [%txt announcement.act]
          ==
      ==
    ::
        %publish-desk
      =/  =cass:clay  .^(cass:clay %cw /[p.pyk]/[desk.act]/[r.pyk])
      =/  =path  /fine/[p.pyk]/c/z/(scot %tas ud.cass)/[desk.act]
      =/  lyf  .^((unit @ud) %j /[p.pyk]/lyfe/[r.pyk]/[p.pyk])
      =/  sec=ring  .^(ring %j /[p.pyk]/vein/[r.pyk]/(scot %ud (need lyf)))
      =/  =wick  (make-wick | byk.bowl path sec)
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
      =/  =tool:mcp  !<(tool:mcp .^(^vase %ca (welp /[p.pyk]/[desk.act]/[r.pyk] path.act)))
      =/  =path  (welp /fine/[p.pyk]/c/x/(scot %ud ud.cass)/[desk.act] path.act)
      =/  lyf  .^((unit @ud) %j /[p.pyk]/lyfe/[r.pyk]/[p.pyk])
      =/  sec=ring  .^(ring %j /[p.pyk]/vein/[r.pyk]/(scot %ud (need lyf)))
      =/  =wick  (make-wick & byk.bowl path sec)
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
      =/  =path  (welp /fine/[p.pyk]/c/x/(scot %ud ud.cass)/[desk.act] path.act)
      =/  lyf  .^((unit @ud) %j /[p.pyk]/lyfe/[r.pyk]/[p.pyk])
      =/  sec=ring  .^(ring %j /[p.pyk]/vein/[r.pyk]/(scot %ud (need lyf)))
      =/  =wick  (make-wick & byk.bowl path sec)
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
      =/  =path  (welp /fine/[p.pyk]/c/x/(scot %ud ud.cass)/[desk.act] path.act)
      =/  lyf  .^((unit @ud) %j /[p.pyk]/lyfe/[r.pyk]/[p.pyk])
      =/  sec=ring  .^(ring %j /[p.pyk]/vein/[r.pyk]/(scot %ud (need lyf)))
      =/  =wick  (make-wick & byk.bowl path sec)
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
      =/  =path  (welp /fine/[p.pyk]/c/x/(scot %ud ud.cass)/[desk.act] path.act)
      =/  lyf  .^((unit @ud) %j /[p.pyk]/lyfe/[r.pyk]/[p.pyk])
      =/  sec=ring  .^(ring %j /[p.pyk]/vein/[r.pyk]/(scot %ud (need lyf)))
      =/  =wick  (make-wick & byk.bowl path sec)
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
  ::  ?+  mark
    ::  (on-poke:def mark vase)
  ::  ::
      ::  %chorus-action
    ::  =/  act  !<(chorus-action vase)
    ::  ?+  -.act
      ::  (on-poke:def mark vase)
    ::  ::
        ::  %update-bio
      ::  ?:  (gth (lent (trip text.act)) 256)
        ::  ~|  %bio-too-long
        ::  !!
      ::  :_  this(bio text.act)
      ::  :~  [%give %fact ~[/bio] %chorus-bio !>(text.act)]
          ::  :*  %give  %fact  ~[/client]
              ::  %chorus-update  !>([%updated-bio our.bowl text.act])
          ::  ==
      ::  ==
    ::  ==
    ::  ::
        ::  %chorus-broadcast
      ::  =/  lyf  .^((unit @ud) %j /[p.pyk]/lyfe/[r.pyk]/[p.pyk])
      ::  =/  cic  (nol:nu:cric:crypto .^(ring %j /[p.pyk]/vein/[r.pyk]/(scot %ud (need lyf))))
      ::  =/  act  !<(chorus-action vase)
      ::  ?:  ?&  ?=([%announce *] act)
              ::  (gth (lent (trip text.act)) 256)
          ::  ==
        ::  ~|  %announcement-too-long
        ::  !!
      ::  ?:  ?&  ?=([%publish-app *] act)
              ::  ?|  (gth (lent (trip desk.act)) 256)
                  ::  (gth (lent (trip desc.act)) 256)
              ::  ==
          ::  ==
        ::  ~|  %desk-name-or-description-too-long
        ::  !!
      ::  =/  jmd  (jam act)
      ::  ?~  sek.cic
        ::  ~|  %no-private-key
        ::  !!
      ::  =/  sig  (sign-raw:ed:crypto jmd sgn.pub.cic sgn.sek.cic)
      ::  ::  :-  :~  (invent:gossip %chorus-broadcast !>([our.bowl sig jmd]))
          ::  ::  ==
      ::  :-  ~
      ::  ?+  -.act  this
          ::  %announce
        ::  %=  this
          ::  announcements  %-  ~(put in announcements)
                         ::  [our.bowl now.bowl text.act]
        ::  ==
      ::  ::
          ::  %publish-tool
        ::  %=  this
          ::  tool-catalog  %-  ~(put by tool-catalog)
                        ::  :-  our.bowl
                        ::  %-  ~(put in (~(gut by tool-catalog) our.bowl ~))
                        ::  tool-listing.act
        ::  ==
      ::  ::
          ::  %publish-app
        ::  %=  this
          ::  apps  %-  ~(put by apps)
                ::  :-  our.bowl
                ::  %-  ~(put in (~(gut by apps) our.bowl ~))
                ::  [desk.act desc.act]
        ::  ==
      ::  ==
  ::  ==
::
++  on-arvo
  |=  [=(pole knot) =sign-arvo]
  (on-arvo:def pole sign-arvo)
::
++  on-agent
  |=  [=(pole knot) =sign:agent:gall]
  ^-  (quip card _this)
  `this
  ::  ?+  pole
    ::  (on-agent:def pole sign)
  ::  ::
  ::  ::  bio update from a subscribed ship
      ::  [%bio who=@ta ~]
    ::  =/  =ship  (slav %p who.pole)
    ::  ?.  ?=(%fact -.sign)
      ::  `this
    ::  `this(rolodex (~(put by rolodex) ship !<(@t q.cage.sign)))
  ::
  ::  gossip library delivers unwrapped rumors here
      ::  [%~.~ %gossip %gossip ~]
    ::  ?.  ?=(%fact -.sign)
      ::  `this
    ::  =*  mark  p.cage.sign
    ::  =*  vase  q.cage.sign
    ::  ?+  mark
      ::  `this
    ::  ::
      ::  %chorus-broadcast
      ::  =/  bod  !<(broadcast q.cage.sign)
      ::  =/  m-act=(unit chorus-action)
        ::  =/  lyf  .^((unit @ud) %j /[p.pyk]/lyfe/[r.pyk]/(scot %p ship.bod))
        ::  ?~  lyf
          ::  ::  XX temporary development fallback: accept when PKI lookup is unavailable.
          ::  `;;(chorus-action (cue data.bod))
        ::  =/  ded
          ::  .^([* =pass *] %j /[p.pyk]/deed/[r.pyk]/(scot %p ship.bod)/(scot %ud u.lyf))
        ::  =/  cic  (com:nu:cric:crypto pass.ded)
        ::  ?.  (veri:ed:crypto sig.bod data.bod sgn.pub.cic)
          ::  ~
        ::  `;;(chorus-action (cue data.bod))
      ::  ?~  m-act
        ::  `this
      ::  =/  act  u.m-act
      ::  ?+  -.act
        ::  `this
      ::  ::
          ::  %announce
        ::  ?:  (gth (lent (trip text.act)) 256)
          ::  `this
        ::  :_  %=  this
              ::  announcements  %-  ~(put in announcements)
                             ::  :*  ship.bod
                                 ::  now.bowl
                                 ::  text.act
                             ::  ==
            ::  ==
        ::  =/  client-update=card
          ::  :*  %give  %fact  ~[/client]
              ::  %chorus-update
              ::  !>([%announcement ship.bod now.bowl text.act])
          ::  ==
        ::  ?:  (~(has by rolodex) ship.bod)
          ::  ~[client-update]
        ::  :~  client-update
            ::  :*  %pass   /bio/(scot %p ship.bod)
                ::  %agent  [ship.bod %chorus]
                ::  %watch  /bio
            ::  ==
        ::  ==
      ::  ::
          ::  %publish-tool
        ::  =/  cur  (~(gut by tool-catalog) ship.bod ~)
        ::  =/  new-catalog
          ::  %-  ~(put by tool-catalog)
          ::  [ship.bod (~(put in cur) tool-listing.act)]
        ::  :_  this(tool-catalog new-catalog)
        ::  :~  [%give %fact ~[/catalog] %chorus-catalog !>(new-catalog)]
            ::  :*  %give  %fact  ~[/client]
                ::  %chorus-update
                ::  !>([%new-tool-listing ship.bod tool-listing.act])
            ::  ==
        ::  ==
      ::  ::
          ::  %publish-app
        ::  ?:  ?|  (gth (lent (trip desk.act)) 256)
                ::  (gth (lent (trip desc.act)) 256)
            ::  ==
          ::  `this
        ::  :-  :~  :*  %give  %fact  ~[/client]
                    ::  %chorus-update
                    ::  !>([%new-app-published ship.bod desk.act desc.act])
                ::  ==
            ::  ==
        ::  %=  this
            ::  apps  %-  ~(put by apps)
                  ::  :-  ship.bod
                  ::  %-  ~(put in (~(gut by apps) ship.bod ~))
                  ::  [desk.act desc.act]
          ::  ==
      ::  ==
    ::  ==
  ::  ==
--
