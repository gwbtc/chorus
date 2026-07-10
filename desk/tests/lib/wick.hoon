/-  *wick
/+  *test, *wick, nym=mnemonyms
/*  english  %txt  /fil/wordlists/english/txt
=>
|%
++  mock-nym
  ^-  @t
  '.collate.therein.rebut.betrayed.equips.behest.coerce.befall.create.befoul.forestall.informs'
::
++  mock-ship
  ^-  ship
  (~(ship me:nym [.y 128 english]) mock-nym)
::
++  mock-rot
  ^-  @ud
  1
::
++  mock-path
  ^-  path
  (stab '/https/example.com')
::
++  mock-sec
  ^-  ring
  `ring`1
::
++  mock-sig
  ^-  @uxI
  %+  can  3
  :~  [32 0x1111]
      [32 0x2222]
      [1 1]
  ==
::
++  mock-unsigned-wick
  ^-  wick
  [%7 mock-ship mock-rot .y mock-path 0x0]
::
++  mock-signed-wick
  ^-  wick
  [%7 mock-ship mock-rot .y mock-path mock-sig]
::
++  mock-unsigned-wire
  ^-  cord
  %-  crip
  ;:  welp
    (trip 'wire://')
    (slag 1 (trip mock-nym))
    (trip '/https/example.com')
  ==
::
++  mock-signed-wire
  ^-  cord
  %-  crip
  ;:  welp
    (trip 'wire://')
    (slag 1 (trip mock-nym))
    (trip '/8REBL2h0dHBzL2V4YW1wbGUuY29tEREAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAiIgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAE')
  ==
--
::
|%
::
++  test-wire-to-wick-signed
  %+  expect-eq
    !>  mock-signed-wick
  !>  (wire-to-wick mock-signed-wire)
::
++  test-wire-to-wick-unsigned
  %+  expect-eq
    !>  mock-unsigned-wick
  !>  (wire-to-wick mock-unsigned-wire)
::
++  test-wick-to-wire-signed
  %+  expect-eq
    !>  mock-signed-wire
  !>  (wick-to-wire mock-signed-wick)
::
++  test-wick-to-wire-unsigned
  %+  expect-eq
    !>  mock-unsigned-wire
  !>  (wick-to-wire mock-unsigned-wick)
::
++  test-roundtrip-signed
  %+  expect-eq
    !>  mock-signed-wick
  !>  (wire-to-wick (wick-to-wire mock-signed-wick))
::
++  test-roundtrip-unsigned
  %+  expect-eq
    !>  mock-unsigned-wick
  !>  (wire-to-wick (wick-to-wire mock-unsigned-wick))
--
