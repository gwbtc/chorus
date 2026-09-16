::
::  Gossip $whos and relay tests over the four-ship %chorus-gossip
::  snapshot built by -chorus!ph-fleet. Each arm runs against a fresh
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
++  expect-whos
  |=  [who=ship =whos:gossip want=(set ship)]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  have=(unit (set ship))  bind:m  (read-whos who whos)
  (ex-equal !>(have) !>(`want))
::
::  Negative assertions are used only after an observed positive
::  event has fenced the relevant network path.
++  expect-not-heard
  |=  [who=ship from=ship text=cord]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  heard=anns  bind:m  (read-announcements who)
  ?.  (heard-announcement heard from text)  (pure:m ~)
  (strand-fail %announcement-wrongly-heard ~[>[who=who from=from text=text]<])
::
++  ready-to-source
  |=  [who=ship source=ship]
  =/  m  (strand ,~)
  ^-  form:m
  ::  After a fleet restore, a sponsee must first announce itself to
  ::  its sponsor before it can address another ship through that route.
  ?:  =(who ship-c)
    ?:  =(source ship-b)
      (send-hi ship-c ship-b)
    ;<  ~  bind:m  (send-hi ship-c ship-b)
    (send-hi ship-c source)
  ?:  =(who ship-k)
    ?:  =(source ship-a)
      (send-hi ship-k ship-a)
    ;<  ~  bind:m  (send-hi ship-k ship-a)
    (send-hi ship-k source)
  (send-hi who source)
::
++  subscribe-all-ready
  |=  [todo=(list ship) live=(set ship) id=@uv]
  =/  m  (strand ,~)
  ^-  form:m
  ?~  todo  (pure:m ~)
  =/  accepted  (~(has in live) i.todo)
  ;<  ~  bind:m  (ready-to-source i.todo ship-a)
  ?:  accepted
    ;<  ~  bind:m  (expect-bulla i.todo id)
    ;<  ~  bind:m  (subscribe i.todo ship-a)
    ;<  ~  bind:m  (await-bulla i.todo id ship-a [%bio 'subscription ready'])
    $(todo t.todo, id +(id))
  ;<  ~  bind:m  (subscribe i.todo ship-a)
  $(todo t.todo)
::
++  expect-all-bullas
  |=  [todo=(list ship) id=@uv]
  =/  m  (strand ,~)
  ^-  form:m
  |-
  ?~  todo  (pure:m ~)
  ;<  ~  bind:m  (expect-bulla i.todo id)
  $(todo t.todo, id +(id))
::
++  announce-all
  |=  [todo=(list ship) id=@uv text=cord]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (expect-all-bullas todo id)
  ;<  ~  bind:m  (make-announcement ship-a text)
  (await-bullas (bulla-expectations todo id ship-a [%announcement text]))
::
::  subscribe .subs to ship-a, wait for the .live subscriptions
::  admitted by the tell policy, then publish and observe .text.
++  subscribe-and-announce
  |=  [subs=(list ship) live=(list ship) text=cord]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (publish-ready ship-a 0v599 'subscription ready')
  ;<  ~  bind:m  (subscribe-all-ready subs (silt live) 0v600)
  (announce-all live 0v700 text)
--
|%
::  +resolve-whos on the source fief, and on the kid
::
++  ph-test-whos-resolve
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (expect-whos ship-a %kids (silt ~[ship-k]))
  ;<  ~  bind:m  (expect-whos ship-a %fief (silt ~[ship-a ship-b]))
  ;<  ~  bind:m  (expect-whos ship-a %city (silt ~[ship-a ship-b ship-k ship-c]))
  (expect-whos ship-k %kids ~)
::  tell %kids: only the sponsee may subscribe
::
++  ph-test-tell-kids
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (set-tell ship-a [%whos %kids])
  ;<  ~  bind:m  (subscribe-and-announce ~[ship-k ship-b ship-c] ~[ship-k] 'kids only')
  ;<  ~  bind:m  (expect-not-heard ship-b ship-a 'kids only')
  (expect-not-heard ship-c ship-a 'kids only')
::  tell %fief: only fiefs may subscribe
::
++  ph-test-tell-fief
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (set-tell ship-a [%whos %fief])
  ;<  ~  bind:m  (subscribe-and-announce ~[ship-b ship-k ship-c] ~[ship-b] 'fiefs only')
  ;<  ~  bind:m  (expect-not-heard ship-k ship-a 'fiefs only')
  (expect-not-heard ship-c ship-a 'fiefs only')
::  tell %city: everyone in the domain may subscribe
::
++  ph-test-tell-city
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (set-tell ship-a [%whos %city])
  ;<  ~  bind:m
    (subscribe-and-announce ~[ship-b ship-k ship-c] ~[ship-b ship-k ship-c] 'whole city')
  (pure:m ~)
::  tell %wild: anyone at all may subscribe
::
++  ph-test-tell-wild
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (set-tell ship-a [%whos %wild])
  ;<  ~  bind:m
    (subscribe-and-announce ~[ship-b ship-k ship-c] ~[ship-b ship-k ship-c] 'anyone at all')
  (pure:m ~)
::  two-hop relay: ship-a announces, ship-b relays, ship-k hears
::  without ever subscribing to ship-a
::
++  ph-test-relay
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (set-tell ship-a [%whos %wild])
  ;<  ~  bind:m  (set-tell ship-b [%whos %wild])
  ;<  ~  bind:m  (publish-ready ship-a 0v800 'relay ready')
  ;<  ~  bind:m  (ready-to-source ship-b ship-a)
  ;<  ~  bind:m  (expect-bulla ship-b 0v801)
  ;<  ~  bind:m  (subscribe ship-b ship-a)
  ;<  ~  bind:m  (await-bulla ship-b 0v801 ship-a [%bio 'relay ready'])
  ;<  ~  bind:m  (ready-to-source ship-k ship-b)
  ;<  ~  bind:m  (expect-bulla ship-k 0v802)
  ;<  ~  bind:m  (subscribe ship-k ship-b)
  ;<  ~  bind:m  (await-bulla ship-k 0v802 ship-a [%bio 'relay ready'])
  ;<  ~  bind:m  (expect-bulla ship-b 0v803)
  ;<  ~  bind:m  (make-announcement ship-a 'two hop relay')
  ;<  ~  bind:m  (await-bulla ship-b 0v803 ship-a [%announcement 'two hop relay'])
  ::  K receives A's bulla at hop zero, where Gossip intentionally does
  ::  not re-emit an observer fact. A later B-to-K bulla on the same
  ::  subscription is the causal fence for the terminal delivery.
  ;<  ~  bind:m  (expect-bulla ship-k 0v804)
  ;<  ~  bind:m  (update-bio ship-b 'relay delivered')
  ;<  ~  bind:m  (await-bulla ship-k 0v804 ship-b [%bio 'relay delivered'])
  (probe-want ship-k 0v805 ship-a [%announcement 'two hop relay'])
::  the opening %chorus-state fact carries what the teller said
::  before we arrived: ship-b subscribes after the announcement,
::  which fire-once gossip alone would never replay, and folds
::  it into its own state
::
++  ph-test-state-on-subscribe
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (make-announcement ship-a 'said before you arrived')
  ;<  ~  bind:m  (ready-to-source ship-b ship-a)
  ;<  ~  bind:m  (expect-bulla ship-b 0v901)
  ;<  ~  bind:m  (subscribe ship-b ship-a)
  (await-bulla ship-b 0v901 ship-a [%announcement 'said before you arrived'])
--
