::
::  Shared helpers for Chorus end-to-end tests over Aqua virtual ships.
::
/-  spider, *chorus
/+  *ph-io, gw-io=ph-gw-io, gossip, ph-util
=,  strand=strand:spider
|%
+$  want
  $%  [%bio txt=cord]
      [%announcement txt=cord]
      [%mcp-tool name=@t]
      [%mcp-prompt name=@t]
      [%mcp-resource name=@t]
      [%mcp-resource-template name=@t]
  ==
+$  bulla-expectation
  [who=ship id=@uv from=ship =want]
::
::  Typed compatibility adapters for this Groundwire ph-io revision.
::  Its generic +poke-app accepts data as *, losing atom auras before
::  formatting the Dojo command.  Keep each payload typed instead.
++  poke-gossip
  |=  [=ship act=action:gossip]
  =/  m  (strand ,~)
  ^-  form:m
  (send-events (dojo:ph-util ship ":chorus &gossip-action {<act>}"))
::
++  poke-chorus
  |=  [=ship act=action]
  =/  m  (strand ,~)
  ^-  form:m
  (send-events (dojo:ph-util ship ":chorus &chorus-action {<act>}"))
::
++  wait-for-probe
  |=  [=ship id=@uv]
  =/  m  (strand ,~)
  =/  yes=tape  "[{(scow %uv id)} %.y]"
  =/  no=tape   "[{(scow %uv id)} %.n]"
  ^-  form:m
  |-
  =*  loop  $
  ;<  [her=^ship =unix-effect]  bind:m  take-unix-effect
  ?:  (is-dojo-output:ph-util ship her unix-effect yes)
    (pure:m ~)
  ?:  (is-dojo-output:ph-util ship her unix-effect no)
    (strand-fail %chorus-probe-failed ~[>[who=ship id=id]<])
  loop
::
++  send-events-wait-probe
  |=  [=ship id=@uv events=(list aqua-event)]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  our=@p  bind:m  get-our
  =/  =card:agent:gall
    [%pass /poke %agent [our %aqua] %poke %aqua-events !>(events)]
  |=  tin=strand-input:strand
  :-  [card ~]
  [%cont (wait-for-probe ship id)]
::
++  ship-a  ~fasteg-dinhet-malrum-ransub--hocduc-digtev-radsut-marbud
++  ship-b  ~molpyx-novtyc-wortyc-noswyd--taltyv-loplev-dabwen-mardev
++  ship-k  ~daldyl-nildem-dispec-tilryx--dondus-dirmet-tintyl-marbud
++  ship-c  ~fosnys-noctyd-talfyl-borryl--davhus-disbyn-fotnec-mardev
::
++  subscribe
  |=  [who=ship peer=ship]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-gossip who [%subscribe peer])
::
++  set-domain
  |=  [who=ship domain=term]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-gossip who [%config-domain domain])
::
++  set-hops
  |=  [who=ship =hops:gossip]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-gossip who [%config-hops hops])
::
++  set-tell
  |=  [who=ship =crowd:gossip]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-gossip who [%config-tell crowd])
::
++  set-tell-wild
  |=  who=ship
  =/  m  (strand ,~)
  ^-  form:m
  (set-tell who [%whos %wild])
::
++  update-bio
  |=  [who=ship bio=cord]
  =/  m  (strand ,~)
  ^-  form:m
  =/  act=action  [%publish ~ [%bio bio]]
  (poke-chorus who act)
::
++  make-announcement
  |=  [who=ship announcement=cord]
  =/  m  (strand ,~)
  ^-  form:m
  =/  act=action  [%publish ~ [%announcement announcement]]
  (poke-chorus who act)
::
::  a local announcement: stored on .who, never gossipped
++  make-local-announcement
  |=  [who=ship announcement=cord]
  =/  m  (strand ,~)
  ^-  form:m
  =/  act=action  [%publish `~ [%announcement announcement]]
  (poke-chorus who act)
::
::  an announcement for a chosen audience, poked straight to
::  the resolved crowd over two hops
++  make-crowd-announcement
  |=  [who=ship =crowd:gossip announcement=cord]
  =/  m  (strand ,~)
  ^-  form:m
  =/  act=action  [%publish `crowd [%announcement announcement]]
  (poke-chorus who act)
::
++  publish-mcp
  |=  $:  who=ship
          kind=?(%tool %prompt %resource %resource-template)
          =desk
          pax=path
      ==
  =/  m  (strand ,~)
  ^-  form:m
  =/  act=action
    ?-  kind
      %tool               [%publish ~ [%mcp-tool desk pax]]
      %prompt             [%publish ~ [%mcp-prompt desk pax]]
      %resource           [%publish ~ [%mcp-resource desk pax]]
      %resource-template  [%publish ~ [%mcp-resource-template desk pax]]
    ==
  (poke-chorus who act)
::
++  probe-want
  |=  [who=ship id=@uv from=ship =want]
  =/  m  (strand ,~)
  ^-  form:m
  =/  kind=term  -.want
  =/  value=@t
    ?-  -.want
      %bio                    txt.want
      %announcement           txt.want
      %mcp-tool               name.want
      %mcp-prompt             name.want
      %mcp-resource           name.want
      %mcp-resource-template  name.want
    ==
  =/  command=tape
    "+chorus!ph/chorus-probe {(scow %uv id)} {(scow %p from)} {<kind>} {<value>}"
  %:  send-events-wait-probe
    who
    id
    (dojo:ph-util who command)
  ==
::
++  bulla-wire
  |=  id=@uv
  ^-  wire
  /aqua/watch/chorus/(scot %uv id)
::
::  Open a local Aqua watch before triggering the remote operation. The
::  Gossip wrapper publishes each accepted rumor on this path only after
::  Chorus has handled the corresponding bulla.
++  expect-bulla
  |=  [who=ship id=@uv]
  =/  m  (strand ,~)
  ^-  form:m
  =/  =task:gall
    [%deal [who who /] %chorus %watch /~/gossip/gossip]
  (send-events [%event who /g/aqua/watch/chorus/(scot %uv id) task]~)
::
++  matches-want
  |=  [from=ship =want val=noun]
  ^-  ?
  ::  %raw-fact deliberately carries an untyped noun, not a vase, so !<
  ::  cannot decode it. Refine its expected wire shape before slot access.
  ?.  ?=([[* *] %chorus-bulla [%chorus-bulla @p @ux *]] val)  |
  =/  raw  .*(val [0 7])
  ?.  =(from .*(raw [0 6]))  |
  =/  msg  .*(raw [0 15])
  ?-  -.want
    %bio
      ?.  ?=([%chorus-bio @t *] msg)  |
      =(txt.want .*(msg [0 6]))
    %announcement
      ?.  ?=([%chorus-announcement @t *] msg)  |
      =(txt.want .*(msg [0 6]))
    %mcp-tool
      ?.  ?=([%mcp-tool [@t *] *] msg)  |
      =(name.want .*(.*(msg [0 6]) [0 2]))
    %mcp-prompt
      ?.  ?=([%mcp-prompt [@t *] *] msg)  |
      =(name.want .*(.*(msg [0 6]) [0 2]))
    %mcp-resource
      ?.  ?=([%mcp-resource [@t *] *] msg)  |
      =(name.want .*(.*(msg [0 6]) [0 6]))
    %mcp-resource-template
      ?.  ?=([%mcp-resource-template [@t *] *] msg)  |
      =(name.want .*(.*(msg [0 6]) [0 6]))
  ==
::
++  observed-bulla
  |=  [her=ship =unix-effect exp=bulla-expectation]
  ^-  ?
  ?&  =(her who.exp)
      =((bulla-wire id.exp) p.unix-effect)
      ?=([%unto %raw-fact *] q.unix-effect)
      =(%gossip-rumor mark.unto.q.unix-effect)
      (matches-want from.exp want.exp noun.unto.q.unix-effect)
  ==
::
++  take-observed
  |=  [her=ship =unix-effect pending=(list bulla-expectation)]
  ^-  [(unit bulla-expectation) (list bulla-expectation)]
  =|  kept=(list bulla-expectation)
  |-
  ?~  pending  [~ (flop kept)]
  ?:  (observed-bulla her unix-effect i.pending)
    [`i.pending (weld (flop kept) t.pending)]
  $(pending t.pending, kept [i.pending kept])
::
++  bulla-expectations
  |=  [whos=(list ship) id=@uv from=ship =want]
  ^-  (list bulla-expectation)
  ?~  whos  ~
  [[i.whos id from want] $(whos t.whos, id +(id))]
::
++  await-bullas
  |=  pending=(list bulla-expectation)
  =/  m  (strand ,~)
  ^-  form:m
  =|  seen=(list bulla-expectation)
  |-
  ?~  pending
    |-
    ?~  seen  (pure:m ~)
    ;<  ~  bind:m
      (probe-want who.i.seen id.i.seen from.i.seen want.i.seen)
    $(seen t.seen)
  ;<  [her=^ship =unix-effect]  bind:m  take-unix-effect
  =/  [hit=(unit bulla-expectation) rest=(list bulla-expectation)]
    (take-observed her unix-effect pending)
  ?~  hit  $
  $(pending rest, seen [u.hit seen])
::
++  await-bulla
  |=  [who=ship id=@uv from=ship =want]
  =/  m  (strand ,~)
  ^-  form:m
  ?:  =(who from)
    (probe-want who id from want)
  (await-bullas ~[[who id from want]])
::
::  Publish a readiness bio and wait until the source Chorus has
::  processed it. This makes a later subscription replay deterministic.
++  publish-ready
  |=  [who=ship id=@uv text=cord]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (update-bio who text)
  (await-bulla who id who [%bio text])
::
::  boot a fleet of comets over one onchain history; the caller
::  handles vane threads and aqua watches
++  boot-comets
  |=  [lab=@tas fleet=(list ship) chain=onchain:gw-io]
  =/  m  (strand ,~)
  =/  io  ~(. gw-io %.y lab)
  |-  ^-  form:m
  ?~  fleet
    ~&  >  %started-comets
    (pure:m ~)
  ;<  ~  bind:m  (start-gw-comet:io i.fleet %mesa chain)
  $(fleet t.fleet)
::
::  the standard chorus test fleet:
::  ship-a: fief, fact source     ship-b: second fief
::  ship-k: sponsee of ship-a     ship-c: sponsee of ship-b
::
++  message-fleet
  ^-  (list ship)
  ~[ship-a ship-b]
::
++  message-chain
  ^-  onchain:gw-io
  :~  [ship-a 1 0 ~ %if]
      [ship-b 1 0 ~ %if]
  ==
::
++  chorus-fleet
  ^-  (list ship)
  ~[ship-a ship-b ship-k ship-c]
::
++  chorus-chain
  ^-  onchain:gw-io
  :~  [ship-a 1 0 ~ %if]
      [ship-b 1 0 ~ %if]
      [ship-k 1 0 `ship-a ~]
      [ship-c 1 0 `ship-b ~]
  ==
::
::  Boot only the two fiefs used by the message tests. They still use
::  Groundwire-backed identities, but do not pay to snapshot either
::  sponsee or the four-ship PKI topology.
++  setup-message-fleet
  |=  lab=@tas
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (boot-comets lab message-fleet message-chain)
  ;<  ~  bind:m  (set-domain ship-a %gw)
  ;<  ~  bind:m  (set-domain ship-b %gw)
  restore-message-groundwire
::
::  boot the chorus fleet, introduce the ships (fief-less
::  sponsees route through their sponsor, and only become
::  reachable once they have sent a first packet, so each
::  sponsee his its sponsor before anyone his the sponsee),
::  set gossip domains. %chorus and the test-only chorus-probe
::  generator are in the guest pill, so no runtime desk copying
::  is needed.
::  the caller handles vane threads and aqua watches.
::
++  setup-fleet
  |=  lab=@tas
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (boot-comets lab chorus-fleet chorus-chain)
  ;<  ~  bind:m  (set-domain ship-a %gw)
  ;<  ~  bind:m  (set-domain ship-b %gw)
  ;<  ~  bind:m  (set-domain ship-k %gw)
  ;<  ~  bind:m  (set-domain ship-c %gw)
  ::  Populate Jael's source index and directory once, before Aqua
  ::  captures the complete guest snapshot used by topology tests.
  restore-groundwire
::
::  Establish only the directed routes needed by the crowd tests. A
::  successful |hi includes its reply, so a second reverse |hi is redundant.
::  ship-c must contact its sponsor before reaching ship-a through it.
++  restore-network
  =/  m  (strand ,~)
  =/  io  ~(. gw-io %.y %chorus-restore)
  ^-  form:m
  ;<  ~  bind:m  (send-hi:io ship-b ship-a)
  ;<  ~  bind:m  (send-hi:io ship-k ship-a)
  ;<  ~  bind:m  (send-hi:io ship-c ship-b)
  (send-hi:io ship-c ship-a)
::
::  Restore-time setup for the original two-ship message tests.
::  Handshake the pair, open both subscriptions, then publish fresh
::  bios and observe them remotely as semantic readiness acknowledgements.
++  prepare-pair
  |=  lab=@tas
  =/  m  (strand ,~)
  =/  io  ~(. gw-io %.y lab)
  ^-  form:m
  ;<  ~  bind:m  (send-hi:io ship-b ship-a)
  ;<  ~  bind:m  (set-tell-wild ship-a)
  ;<  ~  bind:m  (set-tell-wild ship-b)
  ;<  ~  bind:m  (expect-bulla ship-b 0v10)
  ;<  ~  bind:m  (subscribe ship-b ship-a)
  ;<  ~  bind:m  (update-bio ship-a 'pair a ready')
  ;<  ~  bind:m  (await-bulla ship-b 0v10 ship-a [%bio 'pair a ready'])
  ;<  ~  bind:m  (expect-bulla ship-a 0v11)
  ;<  ~  bind:m  (subscribe ship-a ship-b)
  ;<  ~  bind:m  (update-bio ship-b 'pair b ready')
  (await-bulla ship-a 0v11 ship-b [%bio 'pair b ready'])
::
::  Ames emits a ship-tagged %saxo effect while processing %born.
::  Wait for one from every restored ship, then confirm that Aqua
::  exposes each restored pier's typed Chorus endpoint. Later +send-hi
::  calls establish the specific network paths used by each scenario.
++  wait-for-restored-ames
  |=  pending=(set ship)
  =/  m  (strand ,~)
  ^-  form:m
  |-
  ?~  ~(tap in pending)  (pure:m ~)
  ;<  [her=^ship =unix-effect]  bind:m  take-unix-effect
  ?.  ?&  (~(has in pending) her)
          ?=(%saxo -.q.unix-effect)
      ==
    $
  $(pending (~(del in pending) her))
::
++  await-restored
  |=  ships=(list ship)
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (wait-for-restored-ames (silt ships))
  |-
  ?~  ships  (pure:m ~)
  ;<  rolodex=(set listing:bio)  bind:m  (read-rolodex i.ships)
  $(ships t.ships)
::
::  Jael's live source data is not retained by Aqua fleet restore.
::  Replay the minimum Groundwire udiffs needed by this topology:
::  ship-a receives the whole city (for %kids/%fief/%city), and each
::  receiver gets ship-a's key material for bulla verification.
++  restore-groundwire
  =/  m  (strand ,~)
  =/  io  ~(. gw-io %.n %restore-groundwire)
  =/  a-onchain  [ship-a 1 0 ~ %if]
  ^-  form:m
  ::  Recreate the source registration emitted by the %gw fixture's
  ::  on-init, add the explicit source index used by Gossip, then fence
  ::  those events before replaying the directory diffs.
  ;<  ~  bind:m  (listen-gw ship-a)
  ;<  ~  bind:m  (listen-gw ship-b)
  ;<  ~  bind:m  (listen-gw ship-k)
  ;<  ~  bind:m  (listen-gw ship-c)
  ;<  ~  bind:m  (poke-all-udiffs:io ship-a a-onchain)
  ;<  ~  bind:m  (poke-all-udiffs:io ship-a [ship-b 1 0 ~ %if])
  ;<  ~  bind:m  (poke-all-udiffs:io ship-a [ship-k 1 0 `ship-a ~])
  ;<  ~  bind:m  (poke-all-udiffs:io ship-a [ship-c 1 0 `ship-b ~])
  ;<  ~  bind:m  (poke-all-udiffs:io ship-b a-onchain)
  ;<  ~  bind:m  (poke-all-udiffs:io ship-k a-onchain)
  ;<  ~  bind:m  (poke-all-udiffs:io ship-c a-onchain)
  check-groundwire
::
++  restore-message-groundwire
  =/  m  (strand ,~)
  =/  io  ~(. gw-io %.n %restore-message-groundwire)
  =/  a-onchain  [ship-a 1 0 ~ %if]
  ^-  form:m
  ;<  ~  bind:m  (listen-gw-for ship-a message-fleet)
  ;<  ~  bind:m  (listen-gw-for ship-b message-fleet)
  ;<  ~  bind:m  (poke-all-udiffs:io ship-a a-onchain)
  ;<  ~  bind:m  (poke-all-udiffs:io ship-a [ship-b 1 0 ~ %if])
  (poke-all-udiffs:io ship-b a-onchain)
::
++  check-groundwire
  =/  m  (strand ,~)
  ^-  form:m
  ;<  kids=(unit (set ship))  bind:m  (read-whos ship-a %kids)
  ?.  ?&(?=(^ kids) (~(has in u.kids) ship-k))
    (strand-fail %groundwire-pki-not-ready ~[>[kids=kids]<])
  (pure:m ~)
::
++  listen-gw
  |=  who=ship
  (listen-gw-for who chorus-fleet)
::
++  listen-gw-for
  |=  [who=ship ships=(list ship)]
  =/  m  (strand ,~)
  =/  whos=(set ship)  (~(gas in *(set ship)) ships)
  ^-  form:m
  ::  The explicit registration reconstructs Jael's ship-to-source
  ::  reverse index, used by Gossip's %city/%fief/%kids resolution.
  ::  The empty registration then matches the fixture's +on-init,
  ::  selecting %gw as the default source and opening its root watch.
  %-  send-events
  :~  [%event who [/j/gw-listen %listen whos %| %gw]]
      [%event who [/j/gw-listen %listen ~ %| %gw]]
  ==
::
++  teardown
  |=  lab=@tas
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (leave-our /effect/unto %aqua)
  end:~(. gw-io %.y lab)
::
++  scry-path
  |=  [who=ship now=@da pax=path]
  ^-  path
  ;:  welp
    /i/(scot %p who)/gx/(scot %p who)/chorus/(scot %da now)
    pax
    /noun/noun
  ==
::
++  read-gossip-config
  |=  who=ship
  =/  m  (strand (unit config:gossip))
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  %-  pure:m
  %+  scry-aqua:util  (unit config:gossip)
  [our.bowl now.bowl (scry-path who now.bowl /~/gossip/config)]
::
::  bios only: the wick beside each one is the app's business
++  read-rolodex
  |=  who=ship
  =/  m  (strand (set listing:bio))
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  %-  pure:m
  %-  need
  %+  scry-aqua:util  (unit (set listing:bio))
  [our.bowl now.bowl (scry-path who now.bowl /rolodex)]
::
++  read-whos
  |=  [who=ship =whos:gossip]
  =/  m  (strand (unit (set ship)))
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  %-  pure:m
  %+  scry-aqua:util  (unit (set ship))
  [our.bowl now.bowl (scry-path who now.bowl /~/gossip/whos/[whos])]
::
+$  anns  (set listing:announcement)
::
++  read-announcements
  |=  who=ship
  =/  m  (strand anns)
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  %-  pure:m
  %-  need
  %+  scry-aqua:util  (unit anns)
  [our.bowl now.bowl (scry-path who now.bowl /announcements)]
::
++  heard-announcement
  |=  [heard=anns from=ship text=cord]
  ^-  ?
  %-  ~(any in heard)
  |=  listing:announcement
  &(=(from ship.id.wick) =(text txt))
::
--
