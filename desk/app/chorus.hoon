::
::  chorus: peer-to-peer agent swarm coordination
/-  *chorus, pals
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
    :~  [%chorus-broadcast |=(n=* !>((,[ship *] n)))]
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
  |=  =path
  ^-  (unit (unit cage))
  ?+  path
    (on-peek:def path)
  ::
  ::  .^(json %gx /=/chorus/=/catalog/json)
  ::  .^((map ship (set tool-listing)) %gx /=/chorus/=/catalog/noun)
      [%x %catalog ~]
    ``chorus-catalog+!>(tool-catalog)
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+  path
    (on-watch:def path)
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
    ::  =/  cards=(list card)
      ::  :~  ::  send our latest announcement to new subscriber
          ::  :*  %give  %fact  ~
              ::  %chorus-broadcast
              ::  !>  ^-  broadcast
              ::  [our.bowl desc]
          ::  ==
      ::  ==
    ::  ::  also share our tool catalog if we have published one
    ::  =.  cards
      ::  ?~  cat=(~(get by catalog) our.bowl)
        ::  cards
      ::  (snoc cards [%give %fact ~ %chorus-tool !>([our.bowl u.cat])])
    ::  [cards this]
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
        %set-description
      :_  this(bio text.act)
      :~  [%give %fact ~[/bio] %chorus-bio !>(text.act)]
          :*  %give  %fact  ~[/client]
              %chorus-update  !>([%updated-bio our.bowl text.act])
          ==
      ==
    ==
  ::
      %broadcast
    =/  lyf  .^(@ud %j (welp s.pyk /[p.pyk]))
    =/  cic  (nol:nu:cric:crypto .^(ring %j (welp s.pyk /(scot %ud lyf))))
    =/  act  !<(chorus-action vase)
    =/  jmd  (jam act)
    ?~  sek.cic
      ~|  %no-private-key
      !!
    =/  sig  (sign-raw:ed:crypto jmd sgn.pub.cic sgn.sek.cic)
    :_  this
    :~  (invent:gossip %chorus-broadcast !>([our.bowl sig jmd]))
    ==
  ==
::
++  on-agent
  ::  XX update to use =(pole knot)
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+  wire
    (on-agent:def wire sign)
  ::
  ::  bio update from a subscribed ship
      [%bio @ ~]
    =/  =ship  (slav %p i.t.wire)
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
      =/  lyf  .^((unit @ud) %j (welp s.pyk /(scot %p ship.bod)))
      ?~  lyf
        `this
      =/  ded
        .^([* =pass *] %j (welp s.pyk /(scot %p ship.bod)/(scot %ud u.lyf)))
      =/  cic  (com:nu:cric:crypto pass.ded)
      ?.  (veri:ed:crypto sig.bod data.bod sgn.pub.cic)
        `this
      =/  act  ;;(chorus-action (cue data.bod))
      ?+  -.act
        `this
      ::
          %announce
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
