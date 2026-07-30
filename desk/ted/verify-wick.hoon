::
::  verify-wick: check a wick, and say why if it fails
::
::  takes any wick and produces a $verdict. a contentless wick
::  signed its path alone, so jael settles it; a contentful wick
::  signed the response its path serves, so we fetch that
::  response first. +verify-wick:wick answers yes or no, so we
::  walk the same checks here to name the one that failed
::
::  a wick we cannot check is %unknown, not %failed: a key we
::  have never heard of and a path that serves nothing say
::  nothing about the signature
::
/-  spider, *wick
/+  io=strandio, *wick
=,  strand=strand:spider
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
::
;<  key=(unit [crypto-suite=@ud =pass])  bind:m
  %+  scry:io  ,(unit [crypto-suite=@ud =pass])
  /j/puby/(scot %p ship.id.wick)/(scot %ud rot.wick)
?~  key
  (pure:m !>([%unknown (crip "jael has no key for {who} at life {<rot.wick>}")]))
?:  =(0x0 sig.wick)
  (pure:m !>([%failed (crip "the wick from {who} carries no signature")]))
?~  path.wick
  (pure:m !>([%failed (crip "the wick from {who} signed an empty path")]))
?.  &((gth rot.wick 0) (lte rot.wick 65.535))
  (pure:m !>([%failed (crip "the wick from {who} has a bad key rotation {<rot.wick>}")]))
?.  (lte (met 3 (spat path.wick)) 256)
  (pure:m !>([%failed (crip "the wick from {who} signed a path over 256 bytes")]))
?:  flag.wick
  ?.  (verify-wick wick `pass.u.key ~)
    (pure:m !>([%failed (crip "{who} did not sign {(spud path.wick)}")]))
  (pure:m !>([%verified ~]))
::  a contentful wick signed the response its path serves, so we
::  have to fetch that response before we can check it
=/  =spar:ames  [ship.id.wick (slag 2 `path`path.wick)]
;<  =sage:mess:ames  bind:m
  ::  XX we never yawn a keen we gave up on, so ames goes on
  ::     asking for it; cancel it here once we can
  %+  (set-timeout:io ,sage:mess:ames)  ~m2
  =/  m  (strand ,sage:mess:ames)
  ;<  ~  bind:m  (keen:io /verify spar ~)
  (take-sage:io /verify)
?~  q.sage
  (pure:m !>([%unknown (crip "{who} serves nothing at {(spud path.spar)}")]))
?.  =(ship.spar ship.p.sage)
  (pure:m !>([%unknown (crip "{<ship.p.sage>} answered for {who}")]))
?.  =(path.spar path.p.sage)
  (pure:m !>([%unknown (crip "{who} answered for the wrong path")]))
?:  (verify-wick wick `pass.u.key `(fine-octs sage))
  (pure:m !>([%verified ~]))
(pure:m !>([%failed (crip "{who} did not sign what it serves at {(spud path.spar)}")]))
