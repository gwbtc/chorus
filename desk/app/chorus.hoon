::
::  chorus: peer-to-peer agent swarm coordination
/-  *chorus, pals
/+  gossip, default-agent
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
    ``chorus-catalog+!>(catalog)
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
    =/  act  !<(action vase)
    ?-  -.act
        %set-description
      ::  XX 256 character limit
      `this(desc text.act)
    ::
        %broadcast
      :_  this(desc text.act)
      ::  XX populate with jammed noun
      :~  (invent:gossip %chorus-broadcast !>([our.bowl *]))
      ==
    ::
    ::  XX should only be one tool at a time
        %publish-tools
      =/  ts=(set tool-listing)
        (~(gas in *(set tool-listing)) tools.act)
      =.  catalog  (~(put by catalog) our.bowl ts)
      :_  this
      :~  (invent:gossip %chorus-tool !>([our.bowl ts]))
      ==
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
      ~|([%chorus %unexpected-gossip-sign -.sign] !!)
    =*  mark  p.cage.sign
    =*  vase  q.cage.sign
    ?+  mark
      ~|([%unexpected-gossip-sign -.sign] !!)
    ::
    ::  a peer is broadcasting their presence on the network
        %chorus-broadcast
      ::  XX send fact to Earth agent wire
      ::  XX sign and verify broadcasts
      `this(broadcasts (~(put in broadcasts) !<(broadcast q.cage.sign)))
    ::
    ::  a peer is publishing their tool catalog
        %chorus-tool
      ::  XX sign and verify the jammed noun
      `this
      ::  =+  !<([=ship tools=(set tool-listing)] vase)
      ::  =.  catalog  (~(put by catalog) ship tools)
      ::  :_  this
      ::  :~  [%give %fact [/catalog]~ %noun !>(catalog)]
      ::  ==
    ==
  ==
--
