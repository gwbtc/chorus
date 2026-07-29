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
::  canonical content octets for a /fine wire: the jam of the
::  response sage the requester receives
::  XX rename to jam-sage, sage-octs, etc.
++  fine-octs
  |=  content=*
  ^-  octs
  =/  jammed=@  (jam content)
  [(met 3 jammed) jammed]
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
::  digest over rotation, path, and the sha-256 of the
::  content's octet stream; each tag protocol defines its
::  canonical octets (e.g. /fine jams the response sage)
++  content-digest
  |=  [rot=@ud pax=path content=octs]
  ^-  @uvI
  ?~  pax
    ~|(%content-digest-no-path !!)
  ?>  &((gth rot 0) (lte rot 65.535))
  =/  pat=@t     (spat pax)
  =/  len=@ud    (met 3 pat)
  ?>  (lte len 256)
  =/  cig=@uvI   (sha-256l:sha content)
  =/  msg=@
    %+  can
      3
    :~  [2 rot]
        [len pat]
        [32 cig]
    ==
  (sha-256l:sha (add 34 len) msg)
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
++  make-wick
  |=  [path-only=? =seed:jael pax=path content=(unit octs)]
  ^-  wick
  ?~  pax
    ~|(%empty-path !!)
  ?:  &(path-only ?=(^ content))
    ~|(%unexpected-content !!)
  ?:  &(!path-only ?=(~ content))
    ~|(%missing-content !!)
  =/  who=@pH  who.seed
  =/  rot=@ud  lyf.seed
  =/  pat=@t   (spat pax)
  ?>  (lte (lent pax) 256)
  ?>  (lte rot 65.535)
  =/  dig=@uvI
    ?~  content
      (sign-digest rot pax)
    (content-digest rot pax u.content)
  =/  keys  (nol:nu:cric:crypto key.seed)
  ?>  ?=(^ sek.+<.keys)
  =/  sig=@uxJ
    (sign-octs-raw:ed:crypto [32 dig] [sgn.pub sgn.sek]:+<:keys)
  [%7 who rot path-only pax sig]
::
++  verify-wick
  |=  [=wick pubkey=(unit pass) content=(unit octs)]
  ^-  ?
  ?:  =(0x0 sig.wick)
    %-  (slog [leaf+"wick: no signature on wick from {<ship.wick>}"]~)
    |
  ?~  pubkey
    %-  (slog [leaf+"wick: no key for {<ship.wick>} at rotation {<rot.wick>}"]~)
    |
  ?~  path.wick
    %-  (slog [leaf+"wick: empty path on wick from {<ship.wick>}"]~)
    |
  ::  urbit ships cannot have a key rotation number of 0
  ?.  &((gth rot.wick 0) (lte rot.wick 65.535))
    %-  (slog [leaf+"wick: bad rotation {<rot.wick>} on wick from {<ship.wick>}"]~)
    |
  ?.  (lte (met 3 (spat path.wick)) 256)
    %-  (slog [leaf+"wick: path over 256 bytes on wick from {<ship.wick>}"]~)
    |
  =/  keys  (com:nu:cric:crypto u.pubkey)
  ?:  flag.wick
    ?^  content
      %-  (slog [leaf+"wick: path-only wick from {<ship.wick>} signed no content"]~)
      |
    (veri-octs:ed:crypto sig.wick [32 (sign-digest rot.wick path.wick)] sgn:ded:ex:keys)
  ?~  content
    %-  (slog [leaf+"wick: no content to check wick from {<ship.wick>} against"]~)
    |
  (veri-octs:ed:crypto sig.wick [32 (content-digest rot.wick path.wick u.content)] sgn:ded:ex:keys)
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
