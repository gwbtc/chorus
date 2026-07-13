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
  ^-  @uxJ
  0x77e.96c4.a01a.bc9b.2eba.01a3.6524.b619.53ac.e01b.567f.c03e.c8fc.375b.dbe7.142e.79cf.ecf2.71b3.0ee1.fe57.c0b3.a09b.a093.a6a1.5361.0cd9.2668.01ef.6054.2edb.a616
::
++  mock-pubkey
  ^-  @uxI
  0xdea5.dc8b.fb0e.8eeb.5439.fd58.b607.aa8a.0dc2.dc15.daea.9449.e9b3.9240.fe6b.0443
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
    (trip '/8BEBAC9odHRwcy9leGFtcGxlLmNvbRam2y5UYO8BaCbZDGFToaaToJugs8BX_uEOs3Hy7M95LhTn21s3_Mg-wH9WG-CsUxm2JGWjAboum7waoMSWfgc')
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
::
++  test-verify-wick-signed
  %+  expect-eq
    !>  .y
  !>  (verify-wick mock-signed-wick mock-pubkey)
--
