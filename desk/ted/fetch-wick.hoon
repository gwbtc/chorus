::
::  fetch-wick: fetch the content a wick's path serves,
::  check the wick, and return a $haul
::
::  the wick itself says what its signature covers: a path-only
::  wick signed its path alone, so jael settles it before we
::  bother fetching, and a contentful wick signed the response
::  its path serves, so we fetch that response to check it. an
::  unsigned wick proves nothing, but we fetch its contents as requested
::
::  a haul is only %failed if the signature is bad,
::  if its signature is unverifiable it is %unknown
::
/-  spider, *wick
/+  io=strandio, *wick
=,  strand=strand:spider
=>
|%
::
::  rebuild the sage a remote requester would
::  receive for one of our own paths
++  scry-sage
  |=  [our=ship pax=path]
  ^-  sage:mess:ames
  =/  rest=path  (slag 2 pax)
  ?.  (gte (lent rest) 4)
    ~|(%unsupported-wick-path !!)
  =/  rev=@ta    (snag 2 rest)
  =/  nam=@ta    (snag 3 rest)
  =/  spur=path  (slag 4 rest)
  :-  [our rest]
  ?+    rest  ~|(%unsupported-wick-path !!)
      [%c %x *]
    ?~  spur
      ~|(%unsupported-wick-path !!)
    =/  nun=(unit *)
      (mole |.(.^(* %cx [(scot %p our) nam rev spur])))
    ?~  nun
      ~
    [(slav %tas (rear spur)) u.nun]
  ::
      [%c %z *]
    =/  nun=(unit *)
      (mole |.(.^(* %cz [(scot %p our) nam rev spur])))
    ?~  nun
      ~
    [%uvi u.nun]
  ::
      [%g %x @ @ %$ @ ^]
    =/  nun=(unit *)
      (mole |.(.^(* %gx [(scot %p our) nam rev spur])))
    ?~  nun
      ~
    ::  XX generalise the grow mark once gall exposes it
    ::
    ::  clay names its mark in the path, and while gall
    ::  does not name the mark of a grown page locally,
    ::  every grow path chorus signs carries a %txt page
    [%txt u.nun]
  ==
::
::  fetch the sage a /fine path serves
++  fetch-fine
  |=  [our=ship target=ship rest=path pax=path]
  =/  m  (strand ,(unit sage:mess:ames))
  ^-  form:m
  ?:  =(our target)
    (pure:m `(scry-sage our pax))
  ::  XX we never yawn a keen we gave up on, so ames goes on
  ::     asking for it; cancel it here once we can
  %+  (set-timeout:io ,(unit sage:mess:ames))  ~m2
  ;<  ~  bind:m  (keen:io /fetch [target rest] ~)
  ;<  =sage:mess:ames  bind:m  (take-sage:io /fetch)
  (pure:m `sage)
::
::  content from a sage, unless the wrong spar answered
++  vet
  |=  [target=ship rest=path sag=(unit sage:mess:ames)]
  ^-  (unit cage)
  ?~  sag
    ~
  ?.  &(=(target ship.p.u.sag) =(rest path.p.u.sag))
    ~
  ?@  q.u.sag
    ~
  =/  pag  `page`q.u.sag
  `[p.pag !>(q.pag)]
::
::  fetch whatever content a path serves; each tag protocol
::  fetches its own way and cages its own content type
++  fetch-content
  |=  [our=ship host=(unit ship) tag=@ta rest=path pax=path]
  =/  m  (strand ,(unit cage))
  ^-  form:m
  ?+    tag  (pure:m ~)
    ::  XX slot /https etc. code paths here
      %fine
    ?~  host
      (pure:m ~)
    ;<  sag=(unit sage:mess:ames)  bind:m  (fetch-fine our u.host rest pax)
    (pure:m (vet u.host rest sag))
  ==
--
::
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
::  handle unit from dojo
=/  =wick
  ?:  ?=([%7 *] q.arg)
    !<(wick arg)
  wick:!<([~ =wick] arg)
=/  who=tape  (scow %p ship.id.wick)
;<  our=ship  bind:m  get-our:io
::
::  a pathless wick can be neither fetched nor checked
?~  path.wick
  (pure:m !>([[%failed (crip "the wick from {who} signed an empty path")] ~]))
?.  &((gth rot.wick 0) (lte rot.wick 65.535))
  (pure:m !>([[%failed (crip "the wick from {who} has a bad key rotation {<rot.wick>}")] ~]))
?.  (lte (met 3 (spat path.wick)) 256)
  (pure:m !>([[%failed (crip "the wick from {who} signed a path over 256 bytes")] ~]))
=/  fin=(unit [tag=@ta pub=@ta rest=path])
  =/  pax=path  path.wick
  ?~  pax
    ~
  ?~  t.pax
    ~
  `[i.pax i.t.pax t.t.pax]
?~  fin
  (pure:m !>([[%failed (crip "the wick from {who} has no tag path")] ~]))
::
::  a /fine path names its hosting ship; other tags host their
::  content off-ship, so their paths say nothing about hosts
=/  host=(unit ship)
  ?.  =(%fine tag.u.fin)
    ~
  (slaw %p pub.u.fin)
?:  &(=(%fine tag.u.fin) ?=(~ host))
  (pure:m !>([[%failed (crip "the /fine wick from {who} names no ship in its path")] ~]))
=/  rest=path  rest.u.fin
::
::  resolve the signing key from the wick's id, never from where
::  the content lives: a ship may sign a path it does not host
;<  kid=(unit [crypto-suite=@ud =pass])  bind:m
  %+  scry:io  ,(unit [crypto-suite=@ud =pass])
  /j/puby/(scot %p ship.id.wick)/(scot %ud rot.wick)
;<  key=(unit pass)  bind:m
  =/  n  (strand ,(unit pass))
  ?^  kid
    (pure:n `pass.u.kid)
  ?~  host
    (pure:n ~)
  ;<  hoy=(unit [crypto-suite=@ud =pass])  bind:n
    %+  scry:io  ,(unit [crypto-suite=@ud =pass])
    /j/puby/(scot %p u.host)/(scot %ud rot.wick)
  ?~  hoy
    (pure:n ~)
  ?.  =(ship.id.wick `@pH`fig:ex:(com:nu:cric:crypto pass.u.hoy))
    (pure:n ~)
  (pure:n `pass.u.hoy)
?~  key
  (pure:m !>([[%unknown (crip "cannot resolve a key for {who} at rotation {<rot.wick>}")] ~]))
::
::  a signed path-only wick is settled by jael alone, so it is
::  checked before we bother fetching
?:  &(flag.wick !=(0x0 sig.wick))
  ?.  (verify-wick wick key ~)
    (pure:m !>([[%failed (crip "{who} did not sign {(spud path.wick)}")] ~]))
  ;<  con=(unit cage)  bind:m
    (fetch-content our host tag.u.fin rest path.wick)
  (pure:m !>([[%verified ~] con]))
::  an unsigned wick proves nothing, but may still serve content
?:  =(0x0 sig.wick)
  ;<  con=(unit cage)  bind:m
    (fetch-content our host tag.u.fin rest path.wick)
  (pure:m !>([[%unknown (crip "the wick from {who} carries no signature")] con]))
::
::  a contentful wick signed the response its path serves, so
::  we have to fetch that response before we can check it, and
::  each tag protocol checks its own way
?+    tag.u.fin
    (pure:m !>([[%unknown (crip "the wick from {who} uses a tag we cannot check yet")] ~]))
  ::  XX slot /https content verification here
    %fine
  ?~  host
    (pure:m !>([[%failed (crip "the /fine wick from {who} names no ship in its path")] ~]))
  ;<  sag=(unit sage:mess:ames)  bind:m  (fetch-fine our u.host rest path.wick)
  ?~  sag
    (pure:m !>([[%unknown (crip "{<u.host>} serves nothing at {(spud rest)}")] ~]))
  ?:  !=(u.host ship.p.u.sag)
    (pure:m !>([[%unknown (crip "{<ship.p.u.sag>} answered for {<u.host>}")] ~]))
  ?:  !=(rest path.p.u.sag)
    (pure:m !>([[%unknown (crip "{<u.host>} answered for the wrong path")] ~]))
  ?@  q.u.sag
    (pure:m !>([[%unknown (crip "{<u.host>} serves nothing at {(spud rest)}")] ~]))
  ?.  (verify-wick wick key `(fine-octs u.sag))
    (pure:m !>([[%failed (crip "{who} did not sign what {<u.host>} serves at {(spud rest)}")] ~]))
  =/  pag  `page`q.u.sag
  (pure:m !>([[%verified ~] `[p.pag !>(q.pag)]]))
==
