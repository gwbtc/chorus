::
::  chorus: peer-to-peer agent swarm coordination
/-  *chorus, pals, mcp
/+  gossip, default-agent, verb
::
|%
+$  versioned-state
  $%  state-0
  ==
::
+$  card  card:agent:gall
--
::
=|  state-0
=*  state  -
::
::  gossip config: 2 hops, subscribe to/from anyone in pals graph
%+  verb  &
%-  %+  agent:gossip
      [2 %anybody %anybody |]
    %-  ~(gas by *(map mark $-(* vase)))
    ^-  (list [mark $-(* vase)])
    :~  [%chorus-broadcast |=(n=* !>(;;(broadcast n)))]
    ==
::
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
++  on-arvo   |=([=wire =sign-arvo] (on-arvo:def wire sign-arvo))
++  on-save   !>(state)
++  on-init
  ^-  (quip card _this)
  `this
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
  ?+  pole
    (on-peek:def pole)
  ::
  ::  .^(@t %gx /=/chorus/=/bio/noun)
  ::  .^(json %gx /=/chorus/=/bio/json)
      [%x %bio ~]
    ``chorus-bio+!>(bio)
  ::
  ::  .^(json %gx /=/chorus/=/rolodex/json)
  ::  .^((map ship @t) %gx /=/chorus/=/rolodex/noun)
      [%x %rolodex ~]
    ``chorus-rolodex+!>(rolodex)
  ::
  ::  .^(json %gx /=/chorus/=/rolodex/~ship/json)
  ::  .^((map ship @t) %gx /=/chorus/=/rolodex/~ship/noun)
      [%x %rolodex who=@ta ~]
    =/  =ship  (slav %p who.pole)
    ``chorus-rolodex+!>((malt ~[[ship (~(gut by rolodex) ship '')]]))
  ::
  ::  .^(json %gx /=/chorus/=/announcements/json)
  ::  .^((set announcement) %gx /=/chorus/=/announcements/noun)
      [%x %announcements ~]
    ``chorus-announcements+!>(announcements)
  ::
  ::  .^(json %gx /=/chorus/=/apps/json)
  ::  .^((map ship (set [desk @t])) %gx /=/chorus/=/apps/noun)
      [%x %apps ~]
    ``chorus-apps+!>(apps)
  ::
  ::  .^(json %gx /=/chorus/=/apps/~ship/json)
  ::  .^((map ship (set [desk @t])) %gx /=/chorus/=/apps/~ship/noun)
      [%x %apps who=@ta ~]
    =/  =ship  (slav %p who.pole)
    ``chorus-apps+!>((malt ~[[ship (~(gut by apps) ship ~)]]))
  ::
  ::  .^(json %gx /=/chorus/=/catalog/json)
  ::  .^((map ship (set tool-listing)) %gx /=/chorus/=/catalog/noun)
      [%x %catalog ~]
    ``chorus-catalog+!>(tool-catalog)
  ::
  ::  .^(json %gx /=/chorus/=/catalog/~ship/json)
  ::  .^((map ship (set tool-listing)) %gx /=/chorus/=/catalog/~ship/noun)
      [%x %catalog who=@ta ~]
    =/  =ship  (slav %p who.pole)
    ``chorus-catalog+!>((malt ~[[ship (~(gut by tool-catalog) ship ~)]]))
  ::
      [%x %mcp %tools ~]
    %-  some
    %-  some
    :-  %mcp-tools
    !>  ^-  (list tool:mcp)
    %+  turn
      .^  (list path)
          %ct
          /[p.pyk]/[q.pyk]/[r.pyk]/fil/mcp/tools
      ==
    |=  =path
    ^-  tool:mcp
    !<(tool:mcp .^(vase %ca (welp s.pyk path)))
  ==
::
++  on-watch
  |=  =(pole knot)
  ^-  (quip card _this)
  ?+  pole
    (on-watch:def pole)
  ::
  ::  gossip library calls this when a peer subscribes to us;
  ::  return our current state as initial facts for them
      [%~.~ %gossip %source ~]
    `this
  ::
  ::  bio subscription: send current bio as initial fact
      [%bio ~]
    :_  this
    :~  [%give %fact ~ %chorus-bio !>(bio)]
    ==
  ::
  ::  clients subscribe here for updates
      [%client ~]
    `this
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(src our):bowl
  ?+  mark
    (on-poke:def mark vase)
  ::
      %chorus-action
    =/  act  !<(chorus-action vase)
    ?+  -.act
      (on-poke:def mark vase)
    ::
        %update-bio
      ?:  (gth (lent (trip text.act)) 256)
        ~|  %bio-too-long
        !!
      :_  this(bio text.act)
      :~  [%give %fact ~[/bio] %chorus-bio !>(text.act)]
          :*  %give  %fact  ~[/client]
              %chorus-update  !>([%updated-bio our.bowl text.act])
          ==
      ==
    ==
    ::
        %chorus-broadcast
      =/  lyf  .^((unit @ud) %j /[p.pyk]/lyfe/[r.pyk]/[p.pyk])
      =/  cic  (nol:nu:cric:crypto .^(ring %j /[p.pyk]/vein/[r.pyk]/(scot %ud (need lyf))))
      =/  act  !<(chorus-action vase)
      ?:  ?&  ?=([%announce *] act)
              (gth (lent (trip text.act)) 256)
          ==
        ~|  %announcement-too-long
        !!
      ?:  ?&  ?=([%publish-app *] act)
              ?|  (gth (lent (trip desk.act)) 256)
                  (gth (lent (trip desc.act)) 256)
              ==
          ==
        ~|  %desk-name-or-description-too-long
        !!
      =/  jmd  (jam act)
      ?~  sek.cic
        ~|  %no-private-key
        !!
      =/  sig  (sign-raw:ed:crypto jmd sgn.pub.cic sgn.sek.cic)
      :-  :~  (invent:gossip %chorus-broadcast !>([our.bowl sig jmd]))
          ==
      ?+  -.act  this
          %announce
        %=  this
          announcements  %-  ~(put in announcements)
                         [our.bowl now.bowl text.act]
        ==
      ::
          %publish-tool
        %=  this
          tool-catalog  %-  ~(put by tool-catalog)
                        :-  our.bowl
                        %-  ~(put in (~(gut by tool-catalog) our.bowl ~))
                        tool-listing.act
        ==
      ::
          %publish-app
        %=  this
          apps  %-  ~(put by apps)
                :-  our.bowl
                %-  ~(put in (~(gut by apps) our.bowl ~))
                [desk.act desc.act]
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
  ::  bio update from a subscribed ship
      [%bio who=@ta ~]
    =/  =ship  (slav %p who.pole)
    ?.  ?=(%fact -.sign)
      `this
    `this(rolodex (~(put by rolodex) ship !<(@t q.cage.sign)))
  ::
  ::  gossip library delivers unwrapped rumors here
      [%~.~ %gossip %gossip ~]
    ?.  ?=(%fact -.sign)
      `this
    =*  mark  p.cage.sign
    =*  vase  q.cage.sign
    ?+  mark
      `this
    ::
      %chorus-broadcast
      =/  bod  !<(broadcast q.cage.sign)
      =/  m-act=(unit chorus-action)
        =/  lyf  .^((unit @ud) %j /[p.pyk]/lyfe/[r.pyk]/(scot %p ship.bod))
        ?~  lyf
          ::  XX temporary development fallback: accept when PKI lookup is unavailable.
          `;;(chorus-action (cue data.bod))
        =/  ded
          .^([* =pass *] %j /[p.pyk]/deed/[r.pyk]/(scot %p ship.bod)/(scot %ud u.lyf))
        =/  cic  (com:nu:cric:crypto pass.ded)
        ?.  (veri:ed:crypto sig.bod data.bod sgn.pub.cic)
          ~
        `;;(chorus-action (cue data.bod))
      ?~  m-act
        `this
      =/  act  u.m-act
      ?+  -.act
        `this
      ::
          %announce
        ?:  (gth (lent (trip text.act)) 256)
          `this
        :_  %=  this
              announcements  %-  ~(put in announcements)
                             :*  ship.bod
                                 now.bowl
                                 text.act
                             ==
            ==
        =/  client-update=card
          :*  %give  %fact  ~[/client]
              %chorus-update
              !>([%announcement ship.bod now.bowl text.act])
          ==
        ?:  (~(has by rolodex) ship.bod)
          ~[client-update]
        :~  client-update
            :*  %pass   /bio/(scot %p ship.bod)
                %agent  [ship.bod %chorus]
                %watch  /bio
            ==
        ==
      ::
          %publish-tool
        =/  cur  (~(gut by tool-catalog) ship.bod ~)
        =/  new-catalog
          %-  ~(put by tool-catalog)
          [ship.bod (~(put in cur) tool-listing.act)]
        :_  this(tool-catalog new-catalog)
        :~  [%give %fact ~[/catalog] %chorus-catalog !>(new-catalog)]
            :*  %give  %fact  ~[/client]
                %chorus-update
                !>([%new-tool-listing ship.bod tool-listing.act])
            ==
        ==
      ::
          %publish-app
        ?:  ?|  (gth (lent (trip desk.act)) 256)
                (gth (lent (trip desc.act)) 256)
            ==
          `this
        :-  :~  :*  %give  %fact  ~[/client]
                    %chorus-update
                    !>([%new-app-published ship.bod desk.act desc.act])
                ==
            ==
        %=  this
            apps  %-  ~(put by apps)
                  :-  ship.bod
                  %-  ~(put in (~(gut by apps) ship.bod ~))
                  [desk.act desc.act]
          ==
      ==
    ==
  ==
--
