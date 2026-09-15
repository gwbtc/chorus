::
::  Per-fact $crowd tests over the four-ship %chorus-gossip snapshot
::  built by -chorus!ph-fleet: an action's (unit crowd) picks who
::  hears each announcement. ~ defers to the standing config,
::  `~ keeps the datum on the teller, and a concrete crowd
::  goes straight to those ships.
::
::  Run them all with
::    -chorus!ph-test [~ /ted/ph/crowd/ph-test-crowd] ~
::  or one at a time, e.g.
::    -chorus!ph-test [~ /ted/ph/crowd/ph-test-crowd-kids] ~
::
::  ship-a: fief, fact source     ship-b: second fief
::  ship-k: sponsee of ship-a     ship-c: sponsee of ship-b
::
/-  spider
/+  *ph-io, *ph-chorus, *ph-test, gossip
=,  strand=strand:spider
=>
|%
::  The runner fences restoration on all four guest Dojos, after
::  their %born events have re-registered Ames. Subscription replay
::  below is the semantic network-readiness check.
::
++  setup
  =/  m  (strand ,~)
  ^-  form:m
  restore-network
::
::  Negative assertions run only after a positive causal fence.
++  expect-not-heard
  |=  [who=ship from=ship text=cord]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  heard=anns  bind:m  (read-announcements who)
  ?.  (heard-announcement heard from text)  (pure:m ~)
  (strand-fail %announcement-wrongly-heard ~[>[who=who from=from text=text]<])
::
::  A known bio in the initial state replay is the subscription
::  readiness signal. The observer reports only after Chorus has
::  verified and folded that remote bulla.
++  subscribe-ready
  |=  whos=(list ship)
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (publish-ready ship-a 0v99 'subscription ready')
  =/  id=@uv  0v100
  |-  ^-  form:m
  ?~  whos  (pure:m ~)
  ;<  ~  bind:m  (expect-bulla i.whos id)
  ;<  ~  bind:m  (subscribe i.whos ship-a)
  ;<  ~  bind:m  (await-bulla i.whos id ship-a [%bio 'subscription ready'])
  $(whos t.whos, id +(id))
::
::  every arm starts here: introduce the fleet, then subscribe
::  all three hearers to ship-a and wait for the subscriptions
::  to go live. a keen at a ship we have no flow with goes
::  unanswered on this fork, so the crowd targets must be
::  subscribers too, even where the crowd bypasses the subscription.
::  ship-a tells %city, so all three are admitted
::
++  setup-subscribed
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  setup
  (subscribe-ready ~[ship-b ship-c ship-k])
--
|%
::  a `~ crowd stays put: stored on the teller, sent to no one
::  (the gossip side of `~ is covered by -chorus!ph-gossip-local)
::
++  ph-test-crowd-local
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  setup-subscribed
  ;<  ~  bind:m  (make-local-announcement ship-a 'kept at home')
  ::  Later broadcasts received by every subscriber fence the
  ::  preceding local action without relying on elapsed time.
  ;<  ~  bind:m  (expect-bulla ship-b 0v201)
  ;<  ~  bind:m  (expect-bulla ship-c 0v202)
  ;<  ~  bind:m  (expect-bulla ship-k 0v203)
  ;<  ~  bind:m  (make-announcement ship-a 'local fence')
  ;<  ~  bind:m
    %-  await-bullas
    :~  [ship-b 0v201 ship-a [%announcement 'local fence']]
        [ship-c 0v202 ship-a [%announcement 'local fence']]
        [ship-k 0v203 ship-a [%announcement 'local fence']]
    ==
  ;<  had=anns  bind:m  (read-announcements ship-a)
  ?.  (heard-announcement had ship-a 'kept at home')
    (strand-fail %local-announcement-not-stored ~)
  ;<  ~  bind:m  (expect-not-heard ship-b ship-a 'kept at home')
  ;<  ~  bind:m  (expect-not-heard ship-c ship-a 'kept at home')
  (expect-not-heard ship-k ship-a 'kept at home')
::  a %ships crowd goes straight to the named ship as a poke,
::  skipping the other subscribers
::
++  ph-test-crowd-ships
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  setup-subscribed
  ;<  ~  bind:m  (expect-bulla ship-b 0v301)
  ;<  ~  bind:m
    (make-crowd-announcement ship-a [%ships ~[ship-b]] 'for ship b only')
  ;<  ~  bind:m  (await-bulla ship-b 0v301 ship-a [%announcement 'for ship b only'])
  ;<  ~  bind:m  (expect-not-heard ship-c ship-a 'for ship b only')
  (expect-not-heard ship-k ship-a 'for ship b only')
::  the same, aimed at a sponsee rather than a fief
::
++  ph-test-crowd-ships-sponsee
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  setup-subscribed
  ;<  ~  bind:m  (expect-bulla ship-c 0v401)
  ;<  ~  bind:m
    (make-crowd-announcement ship-a [%ships ~[ship-c]] 'for ship c only')
  ;<  ~  bind:m  (await-bulla ship-c 0v401 ship-a [%announcement 'for ship c only'])
  ;<  ~  bind:m  (expect-not-heard ship-b ship-a 'for ship c only')
  (expect-not-heard ship-k ship-a 'for ship c only')
::  a %whos crowd resolves through jael: %kids is ship-a's
::  sponsee alone, not the other subscribers
::
++  ph-test-crowd-kids
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  setup-subscribed
  ;<  ~  bind:m  (expect-bulla ship-k 0v501)
  ;<  ~  bind:m
    (make-crowd-announcement ship-a [%whos %kids] 'for the kids')
  ;<  ~  bind:m  (await-bulla ship-k 0v501 ship-a [%announcement 'for the kids'])
  ;<  ~  bind:m  (expect-not-heard ship-b ship-a 'for the kids')
  (expect-not-heard ship-c ship-a 'for the kids')
--
