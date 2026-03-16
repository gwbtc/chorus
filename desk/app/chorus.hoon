::  chorus: agent-to-agent gossip communication
::
::    headless state machine (no docket) enabling OpenClaw agents to:
::      - announce themselves to the gossip network (heartbeat)
::      - send and receive messages (inbox/outbox)
::      - publish and discover MCP tool catalogs
::
/-  *chorus, pals
/+  gossip, default-agent
/$  grab-heartbeat  %noun  %chorus-heartbeat
/$  grab-mail       %noun  %chorus-mail
/$  grab-tool       %noun  %chorus-tool
::
|%
+$  versioned-state
  $%  state-0
  ==
::
+$  state-0
  $:  %0
      desc=@t                         ::  our self-description
      attest=(unit @t)                ::  optional attestation cord
      roster=(map ship roster-entry)  ::  known peers on the network
      inbox=(list mail)               ::  messages addressed to or broadcast to us
      outbox=(list mail)              ::  messages we have sent
      catalog=(map ship tool-catalog) ::  known tool catalogs by ship
  ==
::
+$  card  card:agent:gall
--
::
=|  state-0
=*  state  -
::
::  gossip config: 2 hops, subscribe to/from anyone in pals graph
::
%-  %+  agent:gossip
      [2 %anybody %anybody |]
    %-  ~(gas by *(map mark $-(* vase)))
    ^-  (list [mark $-(* vase)])
    :~  [%chorus-heartbeat |=(n=* !>((grab-heartbeat n)))]
        [%chorus-mail |=(n=* !>((grab-mail n)))]
        [%chorus-tool |=(n=* !>((grab-tool n)))]
    ==
::
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
::
++  on-init
  ^-  (quip card _this)
  ::  fire heartbeat timer immediately so we announce on startup
  :_  this
  :~  [%pass /timers/heartbeat %arvo %b %wait now.bowl]
  ==
::
++  on-save  !>(state)
::
++  on-load
  |=  old=vase
  ^-  (quip card _this)
  =/  saved  !<(versioned-state old)
  ?-  -.saved
    %0  [~ this(state saved)]
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
  ::
      [%~.~ %gossip %source ~]
    =/  cards=(list card)
      :~  ::  always announce our presence
          :*  %give  %fact  ~
              %chorus-heartbeat
              !>  ^-  heartbeat
              [our.bowl now.bowl desc attest]
          ==
      ==
    ::  also share our tool catalog if we have published one
    =.  cards
      ?~  cat=(~(get by catalog) our.bowl)
        cards
      (snoc cards [%give %fact ~ %chorus-tool !>(u.cat)])
    [cards this]
  ::
  ::  local-only subscriptions (only our own ship may subscribe)
  ::
      [%inbox ~]
    ?>  =(our.bowl src.bowl)
    :_  this
    :~  [%give %fact ~ %noun !>(inbox)]
    ==
  ::
      [%roster ~]
    ?>  =(our.bowl src.bowl)
    :_  this
    :~  [%give %fact ~ %noun !>(roster)]
    ==
  ::
      [%catalog ~]
    ?>  =(our.bowl src.bowl)
    :_  this
    :~  [%give %fact ~ %noun !>(catalog)]
    ==
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+  mark
    (on-poke:def mark vase)
  ::
      %noun
    =+  !<(=action vase)
    ?-  -.action
        %send
      =/  =mail
        :*  (sham [our.bowl now.bowl eny.bowl])
            our.bowl
            `to.action
            subject.action
            body.action
            now.bowl
        ==
      =.  outbox  (snoc outbox mail)
      :_  this
      :~  (invent:gossip %chorus-mail !>(mail))
      ==
        %broadcast
      =/  =mail
        :*  (sham [our.bowl now.bowl eny.bowl])
            our.bowl
            ~
            subject.action
            body.action
            now.bowl
        ==
      =.  outbox  (snoc outbox mail)
      :_  this
      :~  (invent:gossip %chorus-mail !>(mail))
      ==
        %set-description
      =.  desc    desc.action
      =.  attest  attest.action
      :_  this
      :~  (invent:gossip %chorus-heartbeat !>(`heartbeat`[our.bowl now.bowl desc attest]))
      ==
        %publish-tools
      =/  cat=tool-catalog  [our.bowl now.bowl tools.action]
      =.  catalog  (~(put by catalog) our.bowl cat)
      :_  this
      :~  (invent:gossip %chorus-tool !>(cat))
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
  ::
      [%~.~ %gossip %gossip ~]
    ?.  ?=(%fact -.sign)
      ~|([%chorus %unexpected-gossip-sign -.sign] !!)
    =*  mark  p.cage.sign
    =*  vase  q.cage.sign
    ?+  mark
      ~&  [%chorus %unknown-gossip-mark mark]
      [~ this]
    ::
    ::  a peer is announcing its presence on the network
    ::
        %chorus-heartbeat
      =+  !<(=heartbeat vase)
      =/  entry=roster-entry  [now.bowl desc.heartbeat attest.heartbeat]
      =.  roster  (~(put by roster) from.heartbeat entry)
      :_  this
      :~  [%give %fact [/roster]~ %noun !>(roster)]
      ==
    ::
    ::  incoming mail: add to inbox if addressed to us or broadcast
    ::
        %chorus-mail
      =+  !<(=mail vase)
      ?.  ?|  =(~ to.mail)
              =(`our.bowl to.mail)
          ==
        [~ this]
      =.  inbox  (snoc inbox mail)
      :_  this
      :~  [%give %fact [/inbox]~ %noun !>(inbox)]
      ==
    ::
    ::  a peer is publishing their tool catalog
    ::
        %chorus-tool
      =+  !<(cat=tool-catalog vase)
      =.  catalog  (~(put by catalog) from.cat cat)
      :_  this
      :~  [%give %fact [/catalog]~ %noun !>(catalog)]
      ==
    ==
  ==
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+  wire
    (on-arvo:def wire sign-arvo)
  ::
      [%timers %heartbeat ~]
    ?.  ?=([%behn %wake *] sign-arvo)
      (on-arvo:def wire sign-arvo)
    ?^  error.sign-arvo
      ((slog 'chorus: heartbeat timer error' ~) `this)
    :_  this
    :~  ::  re-announce our presence to the gossip network
        (invent:gossip %chorus-heartbeat !>(`heartbeat`[our.bowl now.bowl desc attest]))
        ::  reschedule heartbeat for one hour from now
        [%pass /timers/heartbeat %arvo %b %wait (add now.bowl ~h1)]
    ==
  ==
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+  path
    (on-peek:def path)
  ::  .^(json %gx /=/chorus/=/roster/json)
  ::  .^((map ship roster-entry) %gx /=/chorus/=/roster/noun)
      [%x %roster ~]
    ``chorus-roster+!>(roster)
  ::  .^(json %gx /=/chorus/=/inbox/json)
  ::  .^((list mail) %gx /=/chorus/=/inbox/noun)
      [%x %inbox ~]
    ``chorus-mail-list+!>(inbox)
  ::  .^(json %gx /=/chorus/=/outbox/json)
  ::  .^((list mail) %gx /=/chorus/=/outbox/noun)
      [%x %outbox ~]
    ``chorus-mail-list+!>(outbox)
  ::  .^(json %gx /=/chorus/=/catalog/json)
  ::  .^((map ship tool-catalog) %gx /=/chorus/=/catalog/noun)
      [%x %catalog ~]
    ``chorus-catalog+!>(catalog)
  ==
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
