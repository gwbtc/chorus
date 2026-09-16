::
::  Aqua test-strand helpers: timeouts and expectations. Virtual
::  ship IO comes from /lib/ph/io.
::
/-  spider
/+  *strandio, *ph-io, test
=,  strand=strand:spider
|%
::  +ph-test-init: setup test strand environment
::
++  ph-test-init
  =/  m  (strand ,~)
  ^-  form:m
  (watch-our /effect %aqua /effect)
:: +ph-test-shut: teardown test strand environment
::
++  ph-test-shut
  (leave-our /effect %aqua)
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
--
