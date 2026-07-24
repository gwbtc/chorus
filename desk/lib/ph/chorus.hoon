::
::  Shared helpers for chorus end-to-end tests over two Aqua
::  virtual ships.
::
/-  spider, *chorus
/+  *ph-io, gw-io=ph-gw-io, gossip
=,  strand=strand:spider
|%
++  ship-a  ~fasteg-dinhet-malrum-ransub--hocduc-digtev-radsut-marbud
++  ship-b  ~molpyx-novtyc-wortyc-noswyd--taltyv-loplev-dabwen-mardev
++  ship-k  ~daldyl-nildem-dispec-tilryx--dondus-dirmet-tintyl-marbud
++  ship-c  ~fosnys-noctyd-talfyl-borryl--davhus-disbyn-fotnec-mardev
::
++  take-effect
  |=  =wire
  =/  m  (strand aqua-effect)
  ^-  form:m
  ;<  res=^cage  bind:m  (take-fact wire)
  ?>  ?=(%aqua-effect p.res)
  (pure:m !<(=aqua-effect q.res))
::
++  take-poke-ack
  |=  who=ship
  =/  m  (strand ,~)
  ^-  form:m
  |-
  ;<  =aqua-effect  bind:m  (take-effect /effect/unto)
  ?.  =(who who.aqua-effect)  $(who who)
  ?.  ?=([%unto %poke-ack *] q.ufs.aqua-effect)  $(who who)
  =/  sign=sign:agent:gall  +.q.ufs.aqua-effect
  ?>  ?=(%poke-ack -.sign)
  ?^  p.sign
    (strand-fail %poke-ack u.p.sign)
  (pure:m ~)
::
::  wait for a poke-ack; & on ack, | on nack
++  take-poke-result
  |=  who=ship
  =/  m  (strand ,?)
  ^-  form:m
  |-
  ;<  =aqua-effect  bind:m  (take-effect /effect/unto)
  ?.  =(who who.aqua-effect)  $(who who)
  ?.  ?=([%unto %poke-ack *] q.ufs.aqua-effect)  $(who who)
  =/  sign=sign:agent:gall  +.q.ufs.aqua-effect
  ?>  ?=(%poke-ack -.sign)
  (pure:m =(~ p.sign))
::
++  send-poke
  |=  [who=ship =cage]
  =/  m  (strand ,~)
  ^-  form:m
  =/  =task:gall
    [%deal [who who /aqua] %chorus %poke cage]
  (send-events [%event who /g/aqua/deal task]~)
::
++  poke-chorus
  |=  [who=ship =cage]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (send-poke who cage)
  (take-poke-ack who)
::
::  poke that may nack without failing the thread; & on ack
++  poke-chorus-soft
  |=  [who=ship =cage]
  =/  m  (strand ,?)
  ^-  form:m
  ;<  ~  bind:m  (send-poke who cage)
  (take-poke-result who)
::
++  subscribe
  |=  [who=ship peer=ship]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-chorus who gossip-action+!>([%subscribe peer]))
::
++  set-domain
  |=  [who=ship domain=term]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-chorus who gossip-action+!>([%config-domain domain]))
::
++  set-hops
  |=  [who=ship =hops:gossip]
  =/  m  (strand ,?)
  ^-  form:m
  (poke-chorus-soft who gossip-action+!>([%config-hops hops]))
::
++  set-tell
  |=  [who=ship =crowd:gossip]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-chorus who gossip-action+!>([%config-tell crowd]))
::
++  set-tell-wild
  |=  who=ship
  =/  m  (strand ,~)
  ^-  form:m
  (set-tell who [%whos %wild])
::
++  update-bio
  |=  [who=ship bio=cord]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-chorus who chorus-action+!>([%update-bio | bio]))
::
++  make-announcement
  |=  [who=ship =announcement]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-chorus who chorus-action+!>([%make-announcement | announcement]))
::
::  a local (zero-hop) announcement: stored, never gossipped
++  make-local-announcement
  |=  [who=ship =announcement]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-chorus who chorus-action+!>([%make-announcement & announcement]))
::
++  publish-mcp
  |=  $:  who=ship
          kind=?(%tool %prompt %resource %resource-template)
          =desk
          pax=path
      ==
  =/  m  (strand ,~)
  ^-  form:m
  =/  act=action
    ?-  kind
      %tool               [%publish-mcp-tool | desk pax]
      %prompt             [%publish-mcp-prompt | desk pax]
      %resource           [%publish-mcp-resource | desk pax]
      %resource-template  [%publish-mcp-resource-template | desk pax]
    ==
  (poke-chorus who chorus-action+!>(act))
::
::  write a source file into a virtual ship's %chorus desk
++  insert-file
  |=  [who=ship pax=path txt=@t]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (mount who %chorus)
  ;<  ~  bind:m  (send-events (insert-files:util who %chorus [pax txt] ~))
  (sleep ~s2)
::
::  boot a fleet of comets over one onchain history; the caller
::  handles vane threads and aqua watches
++  boot-comets
  |=  [lab=@tas fleet=(list ship) chain=onchain:gw-io]
  =/  m  (strand ,~)
  =/  io  ~(. gw-io %.y lab)
  |-  ^-  form:m
  ?~  fleet
    ;<  ~  bind:m  (sleep ~s5)
    ~&  >  %started-comets
    (pure:m ~)
  ;<  ~  bind:m  (start-gw-comet:io i.fleet %mesa chain)
  $(fleet t.fleet)
::
::  start the aqua vanes and boot a fleet of comets
++  boot-fleet
  |=  [lab=@tas fleet=(list ship) chain=onchain:gw-io]
  =/  m  (strand ,~)
  =/  io  ~(. gw-io %.y lab)
  ^-  form:m
  ;<  ~  bind:m  start-simple:io
  ;<  ~  bind:m  (watch-our /effect/unto %aqua /effect/unto)
  (boot-comets lab fleet chain)
::
::  sync an aqua ship desk to the host desk
++  sync-desk
  |=  [her=ship =desk]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  =/  sab=path
    /(scot %p our.bowl)/[desk]/(scot %da now.bowl)
  =|  =path
  =|  raw-files=(list [^path page:clay])
  =.  raw-files
    |-
    =*  loop  $
    =+  .^(=arch %cy (weld sab path))
    =.  raw-files
      %+  roll  ~(tap in ~(key by dir.arch))
      |=  [dir=@ta =_raw-files]
      (welp loop(path (snoc path dir)) raw-files)
    ?~  fil.arch  raw-files
    =+  .^(=page:clay %cs (weld sab /blob/(scot %uv u.fil.arch)))
    :_  raw-files
    [path page]
  =/  files
    %+  turn  raw-files
    |=  [=^path =page:clay]
    =+  .^(=dais:clay %cb (snoc sab p.page))
    =+  .^(=tube:clay %cc (weld sab /[p.page]/mime))
    =+  !<(=mime (tube (vale:dais q.page)))
    [path ~ mime]
  =/  =beam  [[her desk ud+1] /]
  ;<  ~  bind:m  (send-events [%event her /c/mount/0v1abc [%mont desk beam]]~)
  =/  =task:clay
    [%into desk & files]
  ;<  ~  bind:m  (send-events [%event her /c/sync/0v1abc task]~)
  (sleep ~s2)
::
::  the standard chorus test fleet:
::  ship-a: fief, fact source     ship-b: second fief
::  ship-k: sponsee of ship-a     ship-c: sponsee of ship-b
::
++  chorus-fleet
  ^-  (list ship)
  ~[ship-a ship-b ship-k ship-c]
::
++  chorus-chain
  ^-  onchain:gw-io
  :~  [ship-a 1 0 ~ %if]
      [ship-b 1 0 ~ %if]
      [ship-k 1 0 `ship-a ~]
      [ship-c 1 0 `ship-b ~]
  ==
::
::  boot the chorus fleet, introduce the ships (fief-less
::  sponsees route through their sponsor, and only become
::  reachable once they have sent a first packet, so each
::  sponsee his its sponsor before anyone his the sponsee),
::  set gossip domains, and sync the %chorus desk in.
::  the caller handles vane threads and aqua watches.
::
++  setup-fleet
  |=  lab=@tas
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (boot-comets lab chorus-fleet chorus-chain)
  ;<  ~  bind:m
    %+  cross-hi  lab
    :~  [ship-k ship-a]
        [ship-c ship-b]
        [ship-c ship-a]
        [ship-a ship-b]
        [ship-k ship-b]
    ==
  ;<  ~  bind:m  (set-domain ship-a %gw)
  ;<  ~  bind:m  (set-domain ship-b %gw)
  ;<  ~  bind:m  (set-domain ship-k %gw)
  ;<  ~  bind:m  (set-domain ship-c %gw)
  ~&  >  %syncing-chorus-desk
  =/  todo  chorus-fleet
  |-  ^-  form:m
  ?~  todo  (pure:m ~)
  ;<  ~  bind:m  (sync-desk i.todo %chorus)
  $(todo t.todo)
::
::  introduce ships to each other, both directions per pair
++  cross-hi
  |=  [lab=@tas pairs=(list [a=ship b=ship])]
  =/  m  (strand ,~)
  =/  io  ~(. gw-io %.y lab)
  |-  ^-  form:m
  ?~  pairs
    (pure:m ~)
  ;<  ~  bind:m  (send-hi:io a.i.pairs b.i.pairs)
  ;<  ~  bind:m  (send-hi:io b.i.pairs a.i.pairs)
  $(pairs t.pairs)
::
::  boot both comets, introduce them, and cross-subscribe
++  setup
  |=  lab=@tas
  =/  m  (strand ,~)
  =/  io  ~(. gw-io %.y lab)
  =/  =onchain:io
    :~  [ship-a 1 0 ~ %if]
        [ship-b 1 0 ~ %if]
    ==
  ^-  form:m
  ;<  ~  bind:m  start-simple:io
  ;<  ~  bind:m  (watch-our /effect/unto %aqua /effect/unto)
  ;<  ~  bind:m  (start-gw-comet:io ship-a %mesa onchain)
  ;<  ~  bind:m  (start-gw-comet:io ship-b %mesa onchain)
  ;<  ~  bind:m  (sleep ~s5)
  ~&  >  %started-comets
  ;<  ~  bind:m  (send-hi:io ship-a ship-b)
  ;<  ~  bind:m  (send-hi:io ship-b ship-a)
  ~&  >  %sent-his
  ;<  ~  bind:m  (set-domain ship-a %gw)
  ;<  ~  bind:m  (set-domain ship-b %gw)
  ;<  ~  bind:m  (set-tell-wild ship-a)
  ;<  ~  bind:m  (set-tell-wild ship-b)
  ~&  >  %set-domains
  ;<  ~  bind:m  (subscribe ship-a ship-b)
  ;<  ~  bind:m  (subscribe ship-b ship-a)
  ~&  >  %set-subscriptions
  (sleep ~s2)
::
++  teardown
  |=  lab=@tas
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (leave-our /effect/unto %aqua)
  end:~(. gw-io %.y lab)
::
::  run a check strand every three seconds until it passes or
::  tries run out
++  poll
  =/  m  (strand ,?)
  |=  [tries=@ud check=form:m]
  ^-  form:m
  |-  ^-  form:m
  ;<  ok=?  bind:m  check
  ?:  ok
    (pure:m &)
  ?:  =(0 tries)
    (pure:m |)
  ~&  >  [%check-pending tries=tries]
  ;<  ~  bind:m  (sleep ~s3)
  $(tries (dec tries))
::
++  scry-path
  |=  [who=ship now=@da pax=path]
  ^-  path
  ;:  welp
    /i/(scot %p who)/gx/(scot %p who)/chorus/(scot %da now)
    pax
    /noun/noun
  ==
::
++  read-gossip-config
  |=  who=ship
  =/  m  (strand (unit config:gossip))
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  %-  pure:m
  %+  scry-aqua:util  (unit config:gossip)
  [our.bowl now.bowl (scry-path who now.bowl /~/gossip/config)]
::
++  read-rolodex
  |=  who=ship
  =/  m  (strand (map ship cord))
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  %-  pure:m
  %-  need
  %+  scry-aqua:util  (unit (map ship cord))
  [our.bowl now.bowl (scry-path who now.bowl /rolodex)]
::
::  datums a ship's gossip wrapper has seen (fact leg proof)
++  read-gossip-memory
  |=  who=ship
  =/  m  (strand (unit (set @uv)))
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  %-  pure:m
  %+  scry-aqua:util  (unit (set @uv))
  [our.bowl now.bowl (scry-path who now.bowl /~/gossip/memory)]
::
::  datums a ship's gossip wrapper has emitted as facts
++  read-gossip-shared
  |=  who=ship
  =/  m  (strand (unit (set @uv)))
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  %-  pure:m
  %+  scry-aqua:util  (unit (set @uv))
  [our.bowl now.bowl (scry-path who now.bowl /~/gossip/shared)]
::
++  read-whos
  |=  [who=ship =whos:gossip]
  =/  m  (strand (unit (set ship)))
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  %-  pure:m
  %+  scry-aqua:util  (unit (set ship))
  [our.bowl now.bowl (scry-path who now.bowl /~/gossip/whos/[whos])]
::
+$  anns  (map ship (set (pair time announcement)))
::
++  read-announcements
  |=  who=ship
  =/  m  (strand anns)
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  %-  pure:m
  %-  need
  %+  scry-aqua:util  (unit anns)
  [our.bowl now.bowl (scry-path who now.bowl /announcements)]
::
++  heard-announcement
  |=  [heard=anns from=ship text=cord]
  ^-  ?
  %-  ~(any in (~(gut by heard) from ~))
  |=  (pair time announcement)
  =(text q)
::
++  read-mcp-tools
  |=  who=ship
  =/  m  (strand (map ship (set mcp-tool-listing)))
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  %-  pure:m
  %-  need
  %+  scry-aqua:util  (unit (map ship (set mcp-tool-listing)))
  [our.bowl now.bowl (scry-path who now.bowl /mcp-tools)]
::
++  read-mcp-prompts
  |=  who=ship
  =/  m  (strand (map ship (set mcp-prompt-listing)))
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  %-  pure:m
  %-  need
  %+  scry-aqua:util  (unit (map ship (set mcp-prompt-listing)))
  [our.bowl now.bowl (scry-path who now.bowl /mcp-prompts)]
::
++  read-mcp-resources
  |=  who=ship
  =/  m  (strand (map ship (set mcp-resource-listing)))
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  %-  pure:m
  %-  need
  %+  scry-aqua:util  (unit (map ship (set mcp-resource-listing)))
  [our.bowl now.bowl (scry-path who now.bowl /mcp-resources)]
::
++  read-mcp-resource-templates
  |=  who=ship
  =/  m  (strand (map ship (set mcp-resource-template-listing)))
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  %-  pure:m
  %-  need
  %+  scry-aqua:util  (unit (map ship (set mcp-resource-template-listing)))
  [our.bowl now.bowl (scry-path who now.bowl /mcp-resource-templates)]
--
