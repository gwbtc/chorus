::
::  Per-fact $crowd tests over the chorus fleet snapshot built
::  by -chorus!ph-fleet: an action's (unit crowd) picks who
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
::  the aqua vane threads restart per test, losing their lane
::  state; re-introduce the restored fleet, sponsee-first, so
::  routes re-register before the test drives any traffic.
::  +send-hi reads dojo output from /effect, which a runner arm
::  may watch on its own tid-namespaced wire
::
++  setup
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (watch-our /effect %aqua /effect)
  ;<  ~  bind:m
    %+  cross-hi  %ph-crowd
    :~  [ship-k ship-a]
        [ship-c ship-b]
        [ship-c ship-a]
        [ship-a ship-b]
        [ship-k ship-b]
    ==
  (leave-our /effect %aqua)
::
::  poll until .who has heard .text from .from
::
++  expect-heard
  |=  [who=ship from=ship text=cord]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ok=?  bind:m
    %+  poll  40
    =/  n  (strand ,?)
    ^-  form:n
    ;<  heard=anns  bind:n  (read-announcements who)
    (pure:n (heard-announcement heard from text))
  ?:  ok  (pure:m ~)
  ::  which leg broke: empty memory on the hearer means the fact
  ::  never arrived; a full memory means the keen back to the
  ::  teller is what failed
  ::
  ;<  mem=(unit (set @uv))  bind:m  (read-gossip-memory who)
  ;<  shd=(unit (set @uv))  bind:m  (read-gossip-shared from)
  ~&  >>>  [%gossip-diagnostic hearer-memory=mem teller-shared=shd]
  (strand-fail %announcement-not-heard ~[>[who=who from=from text=text]<])
::
++  expect-not-heard
  |=  [who=ship from=ship text=cord]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (sleep ~s10)
  ;<  heard=anns  bind:m  (read-announcements who)
  ?.  (heard-announcement heard from text)  (pure:m ~)
  (strand-fail %announcement-wrongly-heard ~[>[who=who from=from text=text]<])
::
::  gossip facts are fire-once: wait until each ship's gossip
::  wrapper has heard at least one rumor -- the %chorus-state
::  fact the teller gives every new subscriber -- proving its
::  subscription (and the ames flow the later keen rides on) is
::  live. the app folds that state fact into its own, but the
::  teller has said nothing yet when the subscription opens, so
::  hearing it changes no ship's announcements
::
++  await-live-subs
  |=  whos=(list ship)
  =/  m  (strand ,~)
  ^-  form:m
  |-  ^-  form:m
  ?~  whos  (pure:m ~)
  ;<  ok=?  bind:m
    %+  poll  40
    =/  n  (strand ,?)
    ^-  form:n
    ;<  mem=(unit (set @uv))  bind:n  (read-gossip-memory i.whos)
    (pure:n ?&(?=(^ mem) !=(~ u.mem)))
  ?.  ok
    (strand-fail %subscription-never-live ~[>[who=i.whos]<])
  $(whos t.whos)
::
::  every arm starts here: introduce the fleet, then subscribe
::  all three hearers to ship-a and wait for the subscriptions
::  to go live. a keen at a ship we have no flow with goes
::  unanswered on this fork (see aqua-notes.md), so the crowd
::  targets must be subscribers too, even where the crowd
::  bypasses the subscription. ship-a tells %city, so all three
::  are admitted
::
++  setup-subscribed
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  setup
  ;<  ~  bind:m  (subscribe ship-b ship-a)
  ;<  ~  bind:m  (subscribe ship-c ship-a)
  ;<  ~  bind:m  (subscribe ship-k ship-a)
  (await-live-subs ~[ship-b ship-c ship-k])
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
  ;<  ~  bind:m
    (make-crowd-announcement ship-a [%ships ~[ship-b]] 'for ship b only')
  ;<  ~  bind:m  (expect-heard ship-b ship-a 'for ship b only')
  ;<  ~  bind:m  (expect-not-heard ship-c ship-a 'for ship b only')
  (expect-not-heard ship-k ship-a 'for ship b only')
::  the same, aimed at a sponsee rather than a fief
::
++  ph-test-crowd-ships-sponsee
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  setup-subscribed
  ;<  ~  bind:m
    (make-crowd-announcement ship-a [%ships ~[ship-c]] 'for ship c only')
  ;<  ~  bind:m  (expect-heard ship-c ship-a 'for ship c only')
  ;<  ~  bind:m  (expect-not-heard ship-b ship-a 'for ship c only')
  (expect-not-heard ship-k ship-a 'for ship c only')
::  a %whos crowd resolves through jael: %kids is ship-a's
::  sponsee alone, not the other subscribers
::
++  ph-test-crowd-kids
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  setup-subscribed
  ;<  ~  bind:m
    (make-crowd-announcement ship-a [%whos %kids] 'for the kids')
  ;<  ~  bind:m  (expect-heard ship-k ship-a 'for the kids')
  ;<  ~  bind:m  (expect-not-heard ship-b ship-a 'for the kids')
  (expect-not-heard ship-c ship-a 'for the kids')
--
