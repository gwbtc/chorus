::
::  Gossip $whos and relay tests over the chorus fleet snapshot
::  built by -chorus!ph-fleet. Each arm runs against a fresh
::  restore, so tests are independent.
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
::  state (fiefs, saxos, nails); re-introduce the restored
::  fleet, sponsee-first, so routes re-register before the test
::  drives any ship-to-ship traffic
::
++  setup
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (watch-our /effect %aqua /effect)
  ;<  ~  bind:m
    %+  cross-hi  %gossip-test
    :~  [ship-k ship-a]
        [ship-c ship-b]
        [ship-c ship-a]
        [ship-a ship-b]
        [ship-k ship-b]
    ==
  (leave-our /effect %aqua)
::
++  expect-whos
  |=  [who=ship =whos:gossip want=(set ship)]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  have=(unit (set ship))  bind:m  (read-whos who whos)
  (ex-equal !>(have) !>(`want))
::
::  poll until .who has heard .text from .from
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
::  gossip facts are fire-once: an announcement made before a
::  subscriber's watch lands is never replayed. wait until each
::  ship's gossip wrapper has heard at least one rumor -- the
::  initial bio fact -- proving its subscription is live.
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
::  subscribe .subs to ship-a, wait for the .live subscriptions
::  we expect to be admitted, and have ship-a announce .text
++  subscribe-and-announce
  |=  [subs=(list ship) live=(list ship) text=cord]
  =/  m  (strand ,~)
  ^-  form:m
  |-  ^-  form:m
  ?^  subs
    ;<  ~  bind:m  (subscribe i.subs ship-a)
    $(subs t.subs)
  ;<  ~  bind:m  (await-live-subs live)
  (make-announcement ship-a text)
--
|%
::  +resolve-whos on the source fief, and on the kid
::
++  ph-test-whos-resolve
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  setup
  ;<  ~  bind:m  (expect-whos ship-a %kids (silt ~[ship-k]))
  ;<  ~  bind:m  (expect-whos ship-a %fief (silt ~[ship-a ship-b]))
  ;<  ~  bind:m  (expect-whos ship-a %city (silt ~[ship-a ship-b ship-k ship-c]))
  (expect-whos ship-k %kids ~)
::  tell %kids: only the sponsee may subscribe
::
++  ph-test-tell-kids
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  setup
  ;<  ~  bind:m  (set-tell ship-a [%whos %kids])
  ;<  ~  bind:m  (subscribe-and-announce ~[ship-k ship-b ship-c] ~[ship-k] 'kids only')
  ;<  ~  bind:m  (expect-heard ship-k ship-a 'kids only')
  ;<  ~  bind:m  (expect-not-heard ship-b ship-a 'kids only')
  (expect-not-heard ship-c ship-a 'kids only')
::  tell %fief: only fiefs may subscribe
::
++  ph-test-tell-fief
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  setup
  ;<  ~  bind:m  (set-tell ship-a [%whos %fief])
  ;<  ~  bind:m  (subscribe-and-announce ~[ship-b ship-k ship-c] ~[ship-b] 'fiefs only')
  ;<  ~  bind:m  (expect-heard ship-b ship-a 'fiefs only')
  ;<  ~  bind:m  (expect-not-heard ship-k ship-a 'fiefs only')
  (expect-not-heard ship-c ship-a 'fiefs only')
::  tell %city: everyone in the domain may subscribe
::
++  ph-test-tell-city
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  setup
  ;<  ~  bind:m  (set-tell ship-a [%whos %city])
  ;<  ~  bind:m
    (subscribe-and-announce ~[ship-b ship-k ship-c] ~[ship-b ship-k ship-c] 'whole city')
  ;<  ~  bind:m  (expect-heard ship-b ship-a 'whole city')
  ;<  ~  bind:m  (expect-heard ship-k ship-a 'whole city')
  (expect-heard ship-c ship-a 'whole city')
::  tell %wild: anyone at all may subscribe
::
++  ph-test-tell-wild
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  setup
  ;<  ~  bind:m  (set-tell ship-a [%whos %wild])
  ;<  ~  bind:m
    (subscribe-and-announce ~[ship-b ship-k ship-c] ~[ship-b ship-k ship-c] 'anyone at all')
  ;<  ~  bind:m  (expect-heard ship-b ship-a 'anyone at all')
  ;<  ~  bind:m  (expect-heard ship-k ship-a 'anyone at all')
  (expect-heard ship-c ship-a 'anyone at all')
::  two-hop relay: ship-a announces, ship-b relays, ship-k hears
::  without ever subscribing to ship-a
::
++  ph-test-relay
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  setup
  ;<  ~  bind:m  (set-tell ship-a [%whos %wild])
  ;<  ~  bind:m  (set-tell ship-b [%whos %wild])
  ;<  ~  bind:m  (subscribe ship-b ship-a)
  ;<  ~  bind:m  (subscribe ship-k ship-b)
  ;<  ~  bind:m  (await-live-subs ~[ship-b ship-k])
  ;<  ~  bind:m  (make-announcement ship-a 'two hop relay')
  ;<  ~  bind:m  (expect-heard ship-b ship-a 'two hop relay')
  (expect-heard ship-k ship-a 'two hop relay')
--
