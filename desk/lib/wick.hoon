/-  *wick
/+  mne=mnemonyms
/*  english  %txt  /fil/wordlists/english/txt
::
=>
|%
++  me  ~(. me:mne [.y 128 english])
++  mu  ~(. me:mne [.n 128 english])
--
|%
::  does this ship at this key rotation have a tweak we accept?
::
::  XX stub: a suite C pubkey ('c') carries plaintext tweak data
::     in .tw ([ugn dat xtr], see +cric:crypto), but we have not
::     settled on what tweak data this protocol accepts. until we
::     have, we cannot in good conscience call anyone verified,
::     so nobody gets a one-dot nym
++  verified-nym
  |=  [our=ship now=@da who=ship rot=@ud]
  ^-  ?
  ::  a key we cannot even look up is a key we cannot check
  =/  key=(unit (unit [crypto-suite=@ud =pass]))
    %-  mole
    |.
    .^  (unit [crypto-suite=@ud =pass])
        %j
        /(scot %p our)/puby/(scot %da now)/(scot %p who)/(scot %ud rot)
    ==
  ?~  key  .n
  ?~  u.key  .n
  ?.  =('c' (end 3 pass.u.u.key))  .n
  ::  XX check .dat.tw of (com:nu:cric:crypto pass) here
  .n
::
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
::  a wire names its id in bare words: the leading dots that mark
::  a nym tweaked or untweaked are not part of the wire
++  bare-nym
  |=  =nym
  ^-  tape
  =/  txt=tape  (trip nym)
  |-
  ?~  txt
    ~|(%nym-without-words !!)
  ?.  =('.' i.txt)
    txt
  $(txt t.txt)
::
++  wick-to-wire
  |=  =wick
  ^-  cord
  ?:  =(0x0 sig.wick)
    %-  crip
    %+  welp
      "wire://"
    %+  welp
      (bare-nym nym.id.wick)
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
  (crip (weld "wire://" (weld (bare-nym nym.id.wick) ['/' (trip enc)])))
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
  ::  only comets can have nyms, so a ship that is not a comet is
  ::  named by the fingerprint of the key that signed here
  =/  paw=@pH
    ?:  =(%pawn (clan:title who.seed))
      who.seed
    `@pH`fig:ex:keys
  [%7 [(de:ship:mu paw) paw] rot path-only pax sig]
::
++  verify-wick
  |=  [=wick pubkey=(unit pass) content=(unit octs)]
  ^-  ?
  ?:  =(0x0 sig.wick)
    %-  (slog [leaf+"wick: no signature on wick from {<ship.id.wick>}"]~)
    |
  ?~  pubkey
    %-  (slog [leaf+"wick: no key for {<ship.id.wick>} at rotation {<rot.wick>}"]~)
    |
  ?~  path.wick
    %-  (slog [leaf+"wick: empty path on wick from {<ship.id.wick>}"]~)
    |
  ::  urbit ships cannot have a key rotation number of 0
  ?.  &((gth rot.wick 0) (lte rot.wick 65.535))
    %-  (slog [leaf+"wick: bad rotation {<rot.wick>} on wick from {<ship.id.wick>}"]~)
    |
  ?.  (lte (met 3 (spat path.wick)) 256)
    %-  (slog [leaf+"wick: path over 256 bytes on wick from {<ship.id.wick>}"]~)
    |
  =/  keys  (com:nu:cric:crypto u.pubkey)
  ?:  flag.wick
    ?^  content
      %-  (slog [leaf+"wick: path-only wick from {<ship.id.wick>} signed no content"]~)
      |
    (veri-octs:ed:crypto sig.wick [32 (sign-digest rot.wick path.wick)] sgn:ded:ex:keys)
  ?~  content
    %-  (slog [leaf+"wick: no content to check wick from {<ship.id.wick>} against"]~)
    |
  (veri-octs:ed:crypto sig.wick [32 (content-digest rot.wick path.wick u.content)] sgn:ded:ex:keys)
::
::
++  wire-to-wick
  |=  [our=ship now=@da wir=cord]
  ^-  wick
  =/  par=wook  (wire-to-wook wir)
  =/  gib
    ?:  (verified-nym our now ship.par rot.par)
      me
    mu
  :*  %7
      [(de:ship:gib ship.par) ship.par]
      rot.par
      flag.par
      path.par
      sig.par
  ==
::
++  wire-to-wook
  |=  wir=cord
  ^-  wook
  =/  txt=tape  (trip wir)
  ?.  =("wire://" (scag 7 txt))
    ~|(%not-a-wire !!)
  =/  rest=tape  (slag 7 txt)
  =/  who-end=(unit @)  (find "/" rest)
  ?~  who-end
    ~|(%not-a-wire !!)
  =/  who-tape=tape  (scag u.who-end rest)
  =/  bod=tape       (slag +(u.who-end) rest)
  ::  a wire's nym is bare words, and both dot forms resolve to
  ::  the same ship
  =/  who=ship  (en:ship:mu (crip ['.' who-tape]))
  ::  is wire signed /0x0... or unsigned /foo/bar
  ?:  ?=(^ (find "/" bod))
    ::  return parts from unsigned wire
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
  ::  return parts from signed wire
  [%7 who rot flag (stab pat) sig]
--
