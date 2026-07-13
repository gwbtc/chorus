/-  *wick
/+  nym=mnemonyms
/*  english  %txt  /fil/wordlists/english/txt
::
|%
++  validate-tag-path
  |=  pax=path
  ^-  path
  ?~  pax
    ~|(%tag-path-empty !!)
  =/  pat=@t   (spat pax)
  =/  len=@ud  (met 3 pat)
  ?.  (lte len 256)
    ~|(%tag-path-too-long !!)
  =/  txt=tape  (trip pat)
  ?.  ?=(^ txt)
    !!
  ?.  =('/' i.txt)
    ~|(%tag-path-invalid !!)
  =/  tag-end=(unit @)  (find "/" t.txt)
  ?~  tag-end
    ~|(%tag-path-without-path !!)
  =/  tag=tape  (scag u.tag-end t.txt)
  ?.  ?=(^ tag)
    ~|(%tag-path-without-tag !!)
  =/  parsed-tag
    %+  rush
      (crip tag)
    ;~  plug
      ;~  pose
          (shim 'a' 'z')
          hep
      ==
      (star ;~(pose (shim 'a' 'z') (shim '0' '9') hep))
    ==
  ?~  parsed-tag
    ~|(%tag-path-with-invalid-tag !!)
  pax
::
++  sign-digest
  |=  [rot=@ud pax=path]
  ^-  @uvI
  ?~  pax
    ~|(%sign-digest-no-path !!)
  ?>  &((gth rot 0) (lte rot 65.535))
  =/  pat=@t         (spat pax)
  =/  len=@ud        (met 3 pat)
  ?>  (lte len 256)
  =/  msg
    %+  can
      3
    :~  [2 rot]
        [len pat]
    ==
  (sha-256l:sha (add 2 len) msg)
::
++  sign-payload
  |=  [=flag rot=@ud pax=path sig=@uxJ]
  ^-  @
  ?>  &((gth rot 0) (lte rot 65.535))
  =/  pat=@t         (spat pax)
  =/  len=@ud        (met 3 pat)
  ?>  (gth len 0)
  ?>  (lte len 256)
  %+  can  3
  :~  :-  1
      %+  add
        ?:(flag 0x80 0)
      0x70
      [1 (dec len)]
      [2 rot]
      [len pat]
      [64 sig]
  ==
::
++  wick-to-wire
  |=  =wick
  ^-  cord
  =/  who=cord  (~(name me:nym [.y 128 english]) ship.wick)
  ?:  =(0x0 sig.wick)
    %-  crip
    %+  welp
      "wire://"
    %+  welp
      (slag 1 (trip who))
    %-  trip
    %-  spat
    (validate-tag-path path.wick)
  ?<  =(0x0 sig.wick)
  =/  pay=@
    (sign-payload flag.wick rot.wick path.wick sig.wick)
  =/  len=@ud
    (add 66 (add 2 (met 3 (spat path.wick))))
  =/  enc=@t
    (~(en base64:mimes:html | &) [len pay])
  (crip (weld "wire://" (weld (slag 1 (trip who)) ['/' (trip enc)])))
::
::  XX should not take sec, should scry for Ed25519 seed
::     or maybe should take path / rof to privkey
::     maybe +make-wick should wrap a +make-wick-with-key
++  make-wick
  |=  [=flag =beak rot=@ud pax=path sec=ring]
  ^-  wick
  ?~  pax
    ~|(%empty-path !!)
  =/  who=@pH  p.beak
  =/  pat=@t   (spat pax)
  ?>  (lte (lent pax) 256)
  ?>  (lte rot 65.535)
  =/  dig=@uvI  (sign-digest rot pax)
  ::  XX placeholder: use the Groundwire HD wallet's Ed25519 seed here
  ::  once that key is exposed, instead of deriving one from Jael's ring.
  =/  sed=@uvI  (shax sec)
  =/  sig=@uxJ  (sign-octs:ed:crypto [32 dig] sed)
  [%7 who rot flag pax sig]
::
::  XX maybe +verify-wick should wrap a +verify-wick-with-key
::  XX add support for verifying signed content
++  verify-wick
  |=  [=wick pubkey=@]
  ^-  ?
  ?:  =(0x0 sig.wick)
    .n
  =/  dig=@uvI  (sign-digest rot.wick path.wick)
  (veri-octs:ed:crypto sig.wick [32 dig] pubkey)
::
++  wire-to-wick
  |=  wir=cord
  ^-  wick
  =/  txt=tape  (trip wir)
  ?.  =("wire://" (scag 7 txt))
    ~|(%not-a-wire !!)
  =/  rest=tape  (slag 7 txt)
  =/  who-end=(unit @)  (find "/" rest)
  ?~  who-end
    ~|(%not-a-wire !!)
  =/  who-tape=tape  (scag u.who-end rest)
  =/  bod=tape       (slag +(u.who-end) rest)
  =/  who=ship
    (~(ship me:nym [.y 128 english]) (crip ['.' who-tape]))
  ?:  ?=(^ (find "/" bod))
    ::  return wick from unsigned wire
    [%7 who 1 & (validate-tag-path (stab (crip ['/' bod]))) 0x0]
  ::  parse base64url from signed wire
  =/  oct=(unit octs)  (~(de base64:mimes:html | &) (crip bod))
  ?~  oct
    ~|(%bad-base64url !!)
  =/  dat=octs  u.oct
  ?>  (gte p.dat 68)
  =/  first=@  (cut 3 [0 1] q.dat)
  =/  =flag  =(1 (cut 0 [7 1] first))
  ?>  =(7 (cut 0 [4 3] first))
  ?>  =(0 (cut 0 [0 4] first))
  =/  path-width=@ud  (add 1 (cut 3 [1 1] q.dat))
  ?>  =(p.dat (add 68 path-width))
  =/  rot=@ud  (cut 3 [2 2] q.dat)
  ?>  (gth rot 0)
  =/  pat=@t  (cut 3 [4 path-width] q.dat)
  =/  sig=@uxJ  (cut 3 [(add 4 path-width) 64] q.dat)
  ::  return wick from signed wire
  [%7 who rot flag (stab pat) sig]
--
