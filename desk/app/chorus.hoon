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
    sour  (scot %p our.bowl)
    snow  (scot %da now.bowl)
    def   ~(. (default-agent this %|) bowl)
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
  ?+  mark
    (on-poke:def mark vase)
  ::
      %noun
    =/  lyf  .^(@ud %j /sour/life/snow/sour)
    =/  cic  (nol:nu:cric:crypto .^(ring %j /sour/vein/snow/(scot %ud lyf)))
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
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+  wire
    (on-agent:def wire sign)
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
      =/  lyf  .^((unit @ud) %j /sour/life/snow/(scot %p ship.bod))
      ?~  lyf
        `this
      =/  ded
        .^([* =pass *] %j /sour/deed/snow/(scot %p ship.bod)/(scot %ud u.lyf))
      =/  cic  (com:nu:cric:crypto pass.ded)
      ?.  (veri:ed:crypto sig.bod data.bod sgn.pub.cic)
        `this
      =/  act  ;;(chorus-action (cue data.bod))
      ?-  -.act
      ::
          %set-description
        ::  XX give fact
        `this(rolodex (~(put in rolodex) ship.bod text.act))
      ::
          %announce
        ::  XX give fact
        :-  ~
        %=  this
          announcements  %-  ~(put in announcements)
                         :*  ship.bod
                             ::  XX could include timestamp in msg
                             now.bowl
                             text.act
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
        ==
      ==
    ==
  ==
--
