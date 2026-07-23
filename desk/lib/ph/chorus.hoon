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
++  set-tell-wild
  |=  who=ship
  =/  m  (strand ,~)
  ^-  form:m
  (poke-chorus who gossip-action+!>([%config-tell %whos %wild]))
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
