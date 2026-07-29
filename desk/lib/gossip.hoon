/-  *gossip
/+  dbug, verb
::
|%
++  pass-timeout  ~s30
::
++  invent
  |=  =cage
  ^-  card:agent:gall
  [%give %fact [/~/gossip/source]~ cage]
::
++  confect
  |=  [=once =cage]
  ^-  card:agent:gall
  :^  %give  %fact  [/~/gossip/confect]~
  [%gossip-confect !>([once `(cask *)`[p.cage q.q.cage]])]
::
++  configure
  |=  =config
  ^-  card:agent:gall
  [%give %fact [/~/gossip/config]~ %gossip-config !>(config)]
::
++  read-config
  |=  =bowl:gall
  ^-  config
  .^(config %gx /(scot %p our.bowl)/[dap.bowl]/(scot %da now.bowl)/~/gossip/config/noun)
::
++  agent
  |=  $:  init=config
          grab=(map mark $-(* vase))
      ==
  ^-  $-(agent:gall agent:gall)
  |^  agent
  ::
  +$  state-4
    $:  %4
        manner=config                  ::  latest config
        memory=(set hash)              ::  datums seen (by inner agent)
        shared=(set hash)              ::  datums shared (as fact)
        passed=(map hash [rumor @da])  ::  pending relays & timeouts
        misses=(set ship)              ::  ships that won't relay
        future=(list rumor)            ::  rumors of unknown kinds
    ==
  ::
  +$  card  card:agent:gall
  ::
  ++  helper
    |_  [=bowl:gall state-4]
    +*  state  +<+
    ++  city
      ^-  (set ship)
      =/  etn
        .^  state-eth-node:jael
            %j
            /(scot %p our.bowl)/sources/(scot %da now.bowl)
        ==
      ?~  sid=(~(get by sources-reverse.etn) `source:jael`[%| domain.manner])
        ~&  [gossip+dap.bowl %missing-domain-source domain.manner]
        ~
      =/  ships  (~(get ju ship-sources-reverse.etn) u.sid)
      ?:  =(~ ships)
        ~&  [gossip+dap.bowl %empty-urb-watcher-source source-id=u.sid]
        ~
      ships
    ::
    ++  fiefs
      ^-  (set ship)
      %-  ~(gas in *(set ship))
      %+  skim  ~(tap in city)
      |=  who=ship
      =/  point=(unit point:jael)
        .^  (unit point:jael)
            %j
            /(scot %p our.bowl)/pynt/(scot %da now.bowl)/(scot %p who)
        ==
      ?~  point
        |
      ?=(^ fief.u.point)
    ::
    ++  kids
      ^-  (set ship)
      %-  ~(gas in *(set ship))
      %+  skim  ~(tap in city)
      |=  who=ship
      ?:  =(our.bowl who)
        |
      =/  point=(unit point:jael)
        .^  (unit point:jael)
            %j
            /(scot %p our.bowl)/pynt/(scot %da now.bowl)/(scot %p who)
        ==
      ?~  point
        |
      =(`our.bowl sponsor.u.point)
    ::
    ++  sponsor
      ^-  ship
      ?:  =(%pawn (clan:title our.bowl))
        our.bowl
      .^  ship
          %j
          /(scot %p our.bowl)/sein/(scot %da now.bowl)/(scot %p our.bowl)
      ==
    ::
    ++  resolve-whos
      |=  who=whos
      ^-  (set ship)
      ?-  who
        %saxo
          ?:  =(%pawn (clan:title our.bowl))  ~
          =/  chain
            .^  (list ship)
                %j
                /(scot %p our.bowl)/saxo/(scot %da now.bowl)/(scot %p our.bowl)
            ==
          (~(del in (~(gas in *(set ship)) chain)) our.bowl)
        %sein
          ?:  =(sponsor our.bowl)  ~
          (~(put in *(set ship)) sponsor)
        %kids  kids
        %fief  fiefs
        %city  city
        %wild  ~
      ==
    ::
    ++  resolve-crowd
      |=  =crowd
      ^-  (set ship)
      ?~  crowd  ~
      ?-  -.crowd
        %whos   (resolve-whos who.crowd)
        %ships  (~(gas in *(set ship)) ships.crowd)
      ==
    ::
    ++  resolve-hear
      |=  =crowd
      ^-  (set ship)
      ?:  ?=([%whos ?(%city %wild)] crowd)  ~
      (resolve-crowd crowd)
    ::
    ++  initial-config
      ^-  config
      init
    ++  en-cage
      |=  =(cask *)
      ^-  cage
      ?^  to=(~(get by grab) p.cask)
        ::TODO  +soft or otherwise virtualize? don't want to risk crashes, right?
        [p.cask (u.to q.cask)]
      ~&  [gossip+dap.bowl %no-mark p.cask]
      [%gossip-unknown !>(cask)]
    ::
    ++  de-cage
      |=(cage `(cask *)`[p q.q])
    ::
    ++  en-rumor  ::NOTE  assumes !=(0 hops.manner)
      |=  =cage
      ^-  rumor
      :_  (de-cage cage)
      ~|  [%en-rumor initial-hops=hops.manner]
      [%0 `meta-0`(dec hops.manner)]
    ::
    ++  en-hash
      |=  rumor
      (sham data)
    ::
    ++  play-card  ::  en-rumor relevant facts, handle config changes
      |=  =card
      ^-  (quip ^card _state)
      ?.  ?=([%give %fact *] card)  [[card]~ state]
      ?:  =(~ paths.p.card)  [[card]~ state]
      =/  [int=(list path) ext=(list path)]
        %+  skid  paths.p.card
        |=  =path
        ?=([%~.~ %gossip *] path)
      =/  caz=(list ^card)
        ?:  =(~ ext)  ~
        [card(paths.p ext)]~
      ?:  ?=(~ int)  [caz state]
      =*  path  i.int
      ::  there may only be one gossip-internal path per card
      ::
      ?.  =(~ t.int)
        ~&  [gossip+dap.bowl %too-many-internal-targets int]
        ~|([%too-many-internal-targets int] !!)
      ?:  =(/~/gossip/config path)
        ~|  [%weird-fact-on-config p.cage.p.card]
        ?>  =(%gossip-config p.cage.p.card)
        =/  old=config  manner
        =.  manner  !<(config q.cage.p.card)
        :_  state
        ;:  weld
          (hear-changed hear.old)
          (tell-changed tell.old)
          caz
        ==
      ?:  =(/~/gossip/confect path)
        ~|  [%weird-fact-on-confect p.cage.p.card]
        ?>  =(%gossip-confect p.cage.p.card)
        =+  !<([=once data=(cask *)] q.cage.p.card)
        =^  cas  state  (confect-rumor once data)
        [(weld cas caz) state]
      ~|  [%strange-internal-target path]
      ?>  =(/~/gossip/source path)
      ::  if hops is configured at 0, we don't broadcast at all.
      ::
      =/  =rumor  (en-rumor cage.p.card)
      =.  memory  (~(put in memory) (en-hash rumor))
      ?:  =(0 hops.manner)
        [caz state]
      =^  cas  state  (emit-rumor rumor)
      [(weld cas caz) state]
    ::
    ++  emit-rumor  ::  gossip a rumor as-is
      |=  =rumor
      ^-  (quip card _state)
      =/  =hash  (en-hash rumor)
      =*  fact
        :-  [%give %fact [/~/gossip/gossip]~ %gossip-rumor !>(rumor)]~
        %_  state
          passed  (~(del by passed) hash)
          shared  (~(put in shared) hash)
        ==
      ::  if we don't want to proxy, always send as fact
      ::
      ?.  pass.manner
        fact
      ::  if we want to proxy, do so 50% of the time
      ::
      ?.  =(0 (~(rad og eny.bowl) 2))
        fact
      ::  if we're proxying, but there's no reasonable targets, send as fact
      ::
      =/  aides=(set ship)
        ::  reasonable targets do not include ourselves, whoever
        ::  caused us to want to (re)send this rumor, or ships that failed
        ::  to proxy for us before.
        ::  that last one is important because we need to avoid the mistake of
        ::  occasionally sending them pokes that just linger in our outbound
        ::  ames flows and keep retrying. (ideally we'd do those all pokes for
        ::  a target on the same flow, but we really like storing information
        ::  in the wire and don't want to do per-relay queues in state. we also
        ::  don't particularly care about ordering guarantees for gossip.)
        ::  we don't just get the set of ships with active incoming or outgoing
        ::  subscriptions, because that constrains the set unnecessarily. for
        ::  some configs, ships in .tell (that aren't in .hear) might be
        ::  running the agent without actively listening to us.
        ::
        =-  (~(dif in (~(del in (~(del in -) our.bowl)) src.bowl)) misses)
        (resolve-crowd tell.manner)
      =/  count=@ud  ~(wyt in aides)
      ?:  =(0 count)
        fact
      ::  poke a randomly chosen proxy with the rumor
      ::
      =/  proxy=ship  (snag (~(rad og +(eny.bowl)) count) ~(tap in aides))
      =/  =time       (add now.bowl pass-timeout)
      =.  passed      (~(put by passed) hash [rumor time])
      :_  state
      =/  =wire  /~/gossip/passed/(scot %p proxy)/(scot %uv hash)
      =/  =cage  gossip-rumor+!>(rumor)
      :~  [%pass wire %agent [proxy dap.bowl] %poke cage]
          [%pass wire %arvo %b %wait time]
      ==
    ::
    ++  confect-rumor  ::  gossip a datum under one-time config
      |=  [=once data=(cask *)]
      ^-  (quip card _state)
      =/  count=@ud  (fall hops.once hops.manner)
      =/  =rumor
        :_  data
        [%0 `meta-0`?:(=(0 count) 0 (dec count))]
      =.  memory  (~(put in memory) (en-hash rumor))
      ::  at zero hops the datum stays local
      ::
      ?:  =(0 count)
        [~ state]
      ::  an empty audience is no override: the datum goes to
      ::  our subscribers under the standing config
      ::
      =?  tell.once  =(`~ tell.once)  ~
      ?~  tell.once
        =/  real  pass.manner
        =.  pass.manner  (fall pass.once pass.manner)
        =^  caz  state  (emit-rumor rumor)
        =.  pass.manner  real
        [caz state]
      ::  an audience override skips our subscribers: poke the
      ::  rumor straight to the resolved crowd, as with proxies
      ::
      =/  =hash  (en-hash rumor)
      =.  shared  (~(put in shared) hash)
      :_  state
      %+  turn  ~(tap in (~(del in (resolve-crowd u.tell.once)) our.bowl))
      |=  who=ship
      ^-  card
      :+  %pass  /~/gossip/confected/(scot %p who)/(scot %uv hash)
      [%agent [who dap.bowl] %poke %gossip-rumor !>(rumor)]
    ::
    ++  play-cards
      |=  cards=(list card)
      ^-  (quip card _state)
      =|  out=(list card)
      |-
      ?~  cards  [out state]
      =^  caz  state  (play-card i.cards)
      $(out (weld out caz), cards t.cards)
    ::
    ++  play-first-cards
      |=  cards=(list card)
      ^-  (quip card _state)
      =|  out=(list card)
      |-
      ?~  cards  [out state]
      ?.  ?=([%give %fact ~ *] i.cards)
        =^  caz  state  (play-card i.cards)
        $(out (weld out caz), cards t.cards)
      ::  if hops is set to 0, we block even the initial response
      ::
      ?:  =(0 hops.manner)  $(cards t.cards)
      =.  cage.p.i.cards
        [%gossip-rumor !>((en-rumor cage.p.i.cards))]
      $(out (snoc out i.cards), cards t.cards)
    ::
    ++  jump-rumor  ::  relay a rumor if we haven't yet
      |=  =rumor
      ^-  (quip card _state)
      =/  =hash  (en-hash rumor)
      ?:  (~(has in shared) hash)  [~ state]
      ?>  =(%0 kind.rumor)  ::NOTE  should have been checked for already
      ?~  meta=((soft ,hops=@ud) meta.rumor)  [~ state]
      =*  hops  hops.u.meta
      ?:  =(0 hops)  [~ state]
      =.  meta.rumor  (dec hops)
      :-  [%give %fact [/~/gossip/gossip]~ %gossip-rumor !>(rumor)]~
      state(shared (~(put in shared) (en-hash rumor)))
    ::
    ++  may-watch
      |=  who=ship
      ?:  =([%whos %wild] tell.manner)  &
      (~(has in (resolve-crowd tell.manner)) who)
    ::
    ++  watching-target
      |=  s=ship
      %-  ~(has by wex.bowl)
      [/~/gossip/gossip/(scot %p s) s dap.bowl]
    ::
    ++  want-target
      |=  who=ship
      (~(has in (resolve-hear hear.manner)) who)
    ::
    ++  retry-timer
      |=  [t=@dr p=path]
      ^-  card
      :+  %pass  [%~.~ %gossip %retry p]
      [%arvo %b %wait (add now.bowl t)]
    ::
    ++  watch-target
      |=  s=ship
      ^-  (list card)
      ?:  (watching-target s)  ~
      :_  ~
      :+  %pass  /~/gossip/gossip/(scot %p s)
      [%agent [s dap.bowl] %watch /~/gossip/gossip]
    ::
    ++  leave-target
      |=  s=ship
      ^-  card
      :+  %pass  /~/gossip/gossip/(scot %p s)
      [%agent [s dap.bowl] %leave ~]
    ::
    ++  kick-target
      |=  s=ship
      ^-  card
      [%give %kick [/~/gossip/gossip]~ `s]
    ::
    ++  hear-changed
      |=  old=crowd
      ^-  (list card)
      =*  new  hear.manner
      ?:  =(old new)  ~
      =/  listen=(set ship)  (resolve-hear new)
      =/  hearing=(set ship)
        %-  ~(gas in *(set ship))
        %+  murn  ~(tap by wex.bowl)
        |=  [[=wire =ship =term] [acked=? =path]]
        ^-  (unit ^ship)
        ?.  ?=([%~.~ %gossip %gossip @ ~] wire)  ~
        `ship
      %+  weld
        (turn ~(tap in (~(dif in hearing) listen)) leave-target)
      ^-  (list card)
      (zing (turn ~(tap in (~(dif in listen) hearing)) watch-target))
    ::
    ++  tell-changed
      |=  old=crowd
      ^-  (list card)
      =*  new  tell.manner
      ?:  =(old new)  ~
      ?:  =([%whos %wild] new)  ~
      =/  allowed=(set ship)  (resolve-crowd new)
      %+  murn  ~(val by sup.bowl)
      |=  [s=ship p=path]
      ^-  (unit card)
      =;  kick=?
        ?.(kick ~ `(kick-target s))
      ?&  ?=([%~.~ %gossip %gossip ~] p)
          !(~(has in allowed) s)
      ==
    --
  ::
  ++  agent
    |=  inner=agent:gall
    =|  state-4
    =*  state  -
    %+  verb  |
    %-  agent:dbug
    ^-  agent:gall
    |_  =bowl:gall
    +*  this    .
        def     ~(. (default-agent this %|) bowl)
        og      ~(. inner bowl)
        up      ~(. helper bowl state)
    ++  on-init
      ^-  (quip card _this)
      =.  manner  init
      =^  cards   inner  on-init:og
      =^  cards   state  (play-cards:up cards)
      [cards this]
    ::
    ++  on-save  (slop !>([%gossip state]) on-save:og)
    ++  on-load
      |=  ole=vase
      ^-  (quip card _this)
      ?.  ?=([[%gossip *] *] q.ole)
        =.  manner  init
        =^  cards   inner  (on-load:og ole)
        =^  cards   state  (play-cards:up cards)
        [cards this]
      ::
      =/  old  !<([%gossip state-4] (slot 2 ole))
      =/  ile=vase  (slot 3 ole)
      =.  state  +.old
      =^  cards  inner  (on-load:og ile)
      =^  cards  state  (play-cards:up cards)
      [cards this]
    ::
    ++  on-watch
      |=  =path
      ^-  (quip card _this)
      ?.  ?=([%~.~ %gossip *] path)
        =^  cards  inner  (on-watch:og path)
        =^  cards  state  (play-cards:up cards)
      [cards this]
      ::  /~/gossip/gossip
      ?>  =(/gossip t.t.path)
      ?.  (may-watch:up src.bowl)
        ~|(%gossip-forbidden !!)
      =^  cards  inner  (on-watch:og /~/gossip/source)
      =^  cards  state  (play-first-cards:up cards)
      [cards this]
    ::
    ++  on-poke
      |=  [=mark =vase]
      ^-  (quip card _this)
      ?:  =(%gossip-action mark)
        ?>  =(src.bowl our.bowl)
        =/  act  !<(action vase)
        ?-  -.act
          %config-hops
            [~ this(hops.manner hops.act)]
          %config-hear
            ::  XX reconcile active subscriptions with the new hear crowd
            [~ this(hear.manner crowd.act)]
          %config-tell
            ::  XX kick subscriptions no longer allowed by the tell crowd
            [~ this(tell.manner crowd.act)]
          %config-pass
            [~ this(pass.manner pass.act)]
          %config-domain
            [~ this(domain.manner domain.act)]
          %subscribe
            [(watch-target:up who.act) this]
          %unsubscribe
            [[(leave-target:up who.act)]~ this]
        ==
      ?.  =(%gossip-rumor mark)
        =^  cards  inner  (on-poke:og +<)
        =^  cards  state  (play-cards:up cards)
        [cards this]
      ?.  (may-watch:up src.bowl)
        ~|(%gossip-rejected !!)
      ::  we're getting pokes from them, so we should try relaying through
      ::  them again if we stopped doing so
      ::NOTE  this only ever cleans out .misses for ships producing content
      ::
      =.  misses  (~(del in misses) src.bowl)
      ::TODO  dedupe with +on-agent %fact
      =+  !<(=rumor vase)
      =/  =hash  (en-hash:up rumor)
      ?:  (~(has in memory) hash)
        [~ this]
      ?.  =(%0 kind.rumor)
        ~&  [gossip+dap.bowl %delaying-unknown-rumor-kind kind.rumor]
        [~ this(future [rumor future])]
      =.  memory        (~(put in memory) hash)
      =/  mage=cage     (en-cage:up data.rumor)
      =^  cards  inner  (on-agent:og /~/gossip/gossip %fact mage)
      =^  caz1   state  (play-cards:up cards)
      =^  caz2   state  (emit-rumor:up rumor)
      [(weld caz1 caz2) this]
    ::
    ++  on-agent
      |=  [=wire =sign:agent:gall]
      ^-  (quip card _this)
      ?.  ?=([%~.~ %gossip *] wire)
        =^  cards  inner  (on-agent:og wire sign)
        =^  cards  state  (play-cards:up cards)
        [cards this]
      ::
      ?+  t.t.wire  ~|([%gossip %unexpected-wire wire] !!)
          [%gossip @ ~]
        ~|  t.t.wire
        ?>  =(src.bowl (slav %p i.t.t.t.wire))
        ?-  -.sign
            %fact
          =*  mark  p.cage.sign
          =*  vase  q.cage.sign
          ?.  =(%gossip-rumor mark)
            ~&  [gossip+dap.bowl %ignoring-unexpected-fact mark=mark]
            [~ this]
          ::  we're getting facts from them, so we should try relaying through
          ::  them again if we stopped doing so
          ::NOTE  this only ever cleans out .misses for ships in .hear
          ::
          =.  misses  (~(del in misses) src.bowl)
          ::TODO  de-dupe with +on-poke
          =+  !<(=rumor vase)
          =/  =hash  (en-hash:up rumor)
          ?:  (~(has in memory) hash)
            =^  cards  state  (jump-rumor:up rumor)
            [cards this]
          ?.  =(%0 kind.rumor)
            ~&  [gossip+dap.bowl %delaying-unknown-rumor-kind kind.rumor]
            [~ this(future [rumor future])]
          =.  memory        (~(put in memory) hash)
          =/  mage=cage     (en-cage:up data.rumor)
          =^  cards  inner  (on-agent:og /~/gossip/gossip sign(cage mage))
          =^  caz1   state  (play-cards:up cards)
          =^  caz2   state  (jump-rumor:up rumor)
          [(weld caz1 caz2) this]
        ::
            %watch-ack
          :_  this
          ?~  p.sign  ~
          ::  30 minutes might cost us some responsiveness when the other
          ::  party changes their local config, but in return we save both
          ::  ourselves and others from a lot of needless retries.
          ::  (notably, "do we still care" check also lives in %wake logic.)
          ::
          [(retry-timer:up ~m30 /watch/(scot %p src.bowl))]~
        ::
            %kick
          :_  this
          ::  to prevent pathological kicks from exploding, we always
          ::  wait a couple seconds before resubscribing.
          ::  perhaps this is overly careful, but we cannot tell the
          ::  difference between "clog" kicks and "missing mark" kicks,
          ::  so we cannot take more accurate/appropriate action here.
          ::  (notably, "do we still care" check also lives in %wake logic.)
          ::
          [(retry-timer:up ~s15 /watch/(scot %p src.bowl))]~
        ::
            %poke-ack
          ~&  [gossip+dap.bowl %unexpected-poke-ack wire]
          [~ this]
        ==
      ::
          [%passed ?([@ ~] [@ @ ~])]
        ?.  ?=(%poke-ack -.sign)
          ~&  [gossip+dap.bowl %unexpected-sign wire -.sign]
          [~ this]
        ~|  t.t.wire
        ::  regardless of anything else: if they acked the poke, they are
        ::  accepting of relay requests, if they nacked they're unaccepting
        ::
        =.  misses
          ?:  ?=(~ p.sign)
            (~(del in misses) src.bowl)
          (~(put in misses) src.bowl)
        =/  =hash
          ?:  ?=([@ ~] t.t.t.wire)
            (slav %uv i.t.t.t.wire)
          (slav %uv i.t.t.t.t.wire)
        ?~  rum=(~(get by passed) hash)
          [~ this]
        ::NOTE  emitting rest is cute, but doesn't actually work reliably,
        ::      due to userspace duct shenanigans. %wake logic will have to
        ::      be defensive...
        =/  rest=card   [%pass wire %arvo %b %rest +.u.rum]
        ?~  p.sign      [[rest]~ this(passed (~(del by passed) hash))]
        =^  caz  state  (emit-rumor:up -.u.rum)
        [[rest caz] this]
      ::
          [%confected @ @ ~]
        ?.  ?=(%poke-ack -.sign)
          ~&  [gossip+dap.bowl %unexpected-sign wire -.sign]
          [~ this]
        ::  as with relays: an ack means they take rumor pokes,
        ::  a nack means they don't
        ::
        =.  misses
          ?~  p.sign
            (~(del in misses) src.bowl)
          (~(put in misses) src.bowl)
        [~ this]
      ==
    ::
    ++  on-peek
      |=  =path
      ^-  (unit (unit cage))
      ?:  =(/x/whey path)
        :+  ~  ~
        :-  %mass
        !>  ^-  (list mass)
        :-  %gossip^&+state
        =/  dat  (on-peek:og path)
        ?:  ?=(?(~ [~ ~]) dat)  ~
        (fall ((soft (list mass)) q.q.u.u.dat) ~)
      ?:  =(/x/dbug/state path)
        ``noun+(slop on-save:og !>(gossip=state))
      ?.  ?=([@ %~.~ %gossip *] path)
        (on-peek:og path)
      ?.  ?=(%x i.path)  [~ ~]
      ?+  t.t.t.path  [~ ~]
        [%config ~]  ``noun+!>(manner)
        [%memory ~]  ``noun+!>(memory)
        [%shared ~]  ``noun+!>(shared)
        [%whos @ ~]  ``noun+!>((resolve-whos:up ;;(whos i.t.t.t.t.path)))
      ==
    ::
    ++  on-leave
      |=  =path
      ^-  (quip card _this)
      ?:  ?=([%~.~ %gossip *] path)
        [~ this]
      =^  cards  inner  (on-leave:og path)
      =^  cards  state  (play-cards:up cards)
      [cards this]
    ::
    ++  on-arvo
      |=  [=wire sign=sign-arvo:agent:gall]
      ^-  (quip card _this)
      ?.  ?=([%~.~ %gossip *] wire)
        =^  cards  inner  (on-arvo:og wire sign)
        =^  cards  state  (play-cards:up cards)
        [cards this]
      ?+  t.t.wire  ~|(wire !!)
          [%passed ?([@ ~] [@ @ ~])]
        =/  =hash
          ?:  ?=([@ ~] t.t.t.wire)
            (slav %uv i.t.t.t.wire)
          (slav %uv i.t.t.t.t.wire)
        ?~  rum=(~(get by passed) hash)  [~ this]
        ::  since timer cancellation isn't fully reliable, this timer fire
        ::  might be from a relay that nacked our poke. if the timer fired
        ::  earlier than expected, assume that to be the case and no-op.
        ::
        ?:  (gth +.u.rum now.bowl)       [~ this]
        ::  they failed to respond to our relay request in time, mark them as
        ::  unaccepting (if we know who they are from a the new-style wire)
        ::  and try sending the rumor again
        ::
        =?  misses  ?=([@ @ ~] t.t.t.wire)
          (~(put in misses) (slav %p i.t.t.t.wire))
        =^  cards  state  (emit-rumor:up -.u.rum)
        [cards this]
      ::
          [%retry *]
        ?>  ?=(%wake +<.sign)
        ?+  t.t.t.wire  ~|(wire !!)
            [%watch @ ~]
          :_  this
          =/  target=ship  (slav %p i.t.t.t.t.wire)
          ?.  (want-target:up target)  ~
          (watch-target:up target)
        ==
      ==
    ::
    ++  on-fail
      |=  [term tang]
      ^-  (quip card _this)
      =^  cards  inner  (on-fail:og +<)
      =^  cards  state  (play-cards:up cards)
      [cards this]
    --
  --
--
