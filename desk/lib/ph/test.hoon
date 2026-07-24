::
::  Aqua test-strand helpers, ported from tlon-apps: timeouts,
::  virtual-ship app IO, and expectation combinators.
::
/-  spider
/+  *strandio, *ph-io, test
=,  strand=strand:spider
=+  timeout=~m2
|%
::  +ph-test-init: setup test strand environment
::
++  ph-test-init
  (watch-our /effect/unto %aqua /effect/unto)
:: +ph-test-shut: teardown test strand environment
::
++  ph-test-shut
  (leave-our /effect/unto %aqua)
::  +set-timeout-err: set timeout with error message
::
++  set-timeout-err
  |*  computation-result=mold
  =/  m  (strand ,computation-result)
  |=  [time=@dr error=tang computation=form:m]
  ^-  form:m
  ;<  now=@da  bind:m  get-time
  =/  when  (add now time)
  =/  =card:agent:gall
    [%pass /timeout/(scot %da when) %arvo %b %wait when]
  ;<  ~        bind:m  (send-raw-card card)
  |=  tin=strand-input:strand
  =*  loop  $
  ?:  ?&  ?=([~ %sign [%timeout @ ~] %behn %wake *] in.tin)
          =((scot %da when) i.t.wire.u.in.tin)
      ==
    `[%fail %timeout error]
  =/  c-res  (computation tin)
  ?:  ?=(%cont -.next.c-res)
    c-res(self.next ..loop(computation self.next.c-res))
  ?:  ?=(%done -.next.c-res)
    =/  =card:agent:gall
      [%pass /timeout/(scot %da when) %arvo %b %rest when]
    c-res(cards [card cards.c-res])
  c-res
::  +poke-app: poke a gall agent on a virtual ship
::
::  note that the poke is a $page, not a $vase, because pokes to
::  virtual ships are injected through an untyped interface.
::
++  poke-app
  |=  [=dock =page]
  =/  m  (strand ,~)
  ^-  form:m
  =/  =task:gall
    [%deal [p.dock p.dock /aqua] q.dock %raw-poke page]
  =/  =aqua-event
    [%event p.dock /g/aqua/deal task]
  ;<  ~  bind:m  (send-events ~[aqua-event])
  ;<  res=^cage  bind:m  (take-fact /effect/unto)
  ?>  ?=(%aqua-effect p.res)
  =+  !<(=aqua-effect q.res)
  ?>  =(p.dock who.aqua-effect)
  ?>  ?=([%unto %poke-ack *] q.ufs.aqua-effect)
  =/  sign=sign:agent:gall  +.q.ufs.aqua-effect
  ?>  ?=(%poke-ack -.sign)
  ?^  p.sign
    (strand-fail %poke-ack u.p.sign)
  (pure:m ~)
::  +watch-app: watch a gall subscription to a virtual ship
::
++  watch-app
  |=  [=wire =dock =path]
  =/  m  (strand ,~)
  ^-  form:m
  =/  =task:gall
    [%deal [p.dock p.dock /aqua] q.dock %watch path]
  =/  =aqua-event
    [%event p.dock [%g wire] task]
  ;<  ~  bind:m  (send-events ~[aqua-event])
  ;<  res=^cage  bind:m  (take-fact /effect/unto)
  ?>  ?=(%aqua-effect p.res)
  =+  !<(=aqua-effect q.res)
  ?>  =(p.dock who.aqua-effect)
  ?>  ?=([%unto %watch-ack *] q.ufs.aqua-effect)
  =/  sign=sign:agent:gall  +.q.ufs.aqua-effect
  ?>  ?=(%watch-ack -.sign)
  ?^  p.sign
    (strand-fail %watch-ack u.p.sign)
  (pure:m ~)
::  +leave-app: leave a gall subscription to a virtual ship
::
++  leave-app
  |=  [=wire =dock]
  =/  m  (strand ,~)
  ^-  form:m
  =/  =task:gall
    [%deal [p.dock p.dock /aqua] q.dock %leave ~]
  =/  =aqua-event
    [%event p.dock [%g wire] task]
  (send-events ~[aqua-event])
::  +wait-for-app-fact: receive a gall fact from a virtual ship
::
++  wait-for-app-fact
  |=  [=wire [our=ship dap=term]]
  =/  m  (strand cage)
  ^-  form:m
  %^  (set-timeout-err ,cage)  timeout
    :~  'wait-for-app-fact'
        leaf+"expected a fact from {<our>}/{<dap>}"
        leaf+"on wire {<wire>}"
    ==
  ;<  =bowl:strand  bind:m  get-bowl
  |-
  =*  loop  $
  ;<  =^cage  bind:m  (take-fact /effect/unto)
  ?>  ?=(%aqua-effect p.cage)
  =+  !<(=aqua-effect q.cage)
  =/  [from=^ship =unix-effect]  aqua-effect
  ?.  =(from our)  loop
  ?.  =(wire p.unix-effect)  loop
  ?.  ?=([%unto %raw-fact *] q.unix-effect)  loop
  =*  mark  mark.unto.q.unix-effect
  ::  note: this assumes that the marks on the virtual ship and the
  ::  host match
  ::
  =+  .^(=dais:clay %cb /(scot %p our.bowl)/chorus/(scot %da now.bowl)/[mark])
  =/  =vase  (vale:dais noun.unto.q.unix-effect)
  (pure:m [mark vase])
::  +ex-equal: expect .actual to be equal to .expected
::
++  ex-equal
  |=  [actual=vase expected=vase]
  =/  m  (strand ,~)
  ^-  form:m
  |=  tin=strand-input:strand
  =/  =tang  (expect-eq:test expected actual)
  ?~  tang
    `[%done ~]
  `[%fail %ex-equal tang]
::  +ex-app-fact: expect app fact on a wire
::
++  ex-app-fact
  |=  [=wire =dock ex-fact=cage]
  =/  m  (strand ,~)
  ^-  form:m
  %^  (set-timeout-err ,~)  timeout
    :~  'ex-app-fact'
        leaf+"expected a fact from {<p.dock>}/{<q.dock>}"
        leaf+"on wire {<wire>}"
        leaf+"with mark {<p.ex-fact>}:"
        (sell q.ex-fact)
    ==
  ;<  fact=cage  bind:m  (wait-for-app-fact wire dock)
  ;<  ~  bind:m  (ex-equal !>(p.fact) !>(p.ex-fact))
  (ex-equal q.fact q.ex-fact)
--
