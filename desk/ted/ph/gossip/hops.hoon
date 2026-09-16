::  Gossip accepts the supported hop configurations and persists them.
/-  spider
/+  *ph-io, *ph-chorus, *ph-test, gossip
=,  strand=strand:spider
=>
|%
++  expect-hops
  |=  want=hops:gossip
  =/  m  (strand ,~)
  ^-  form:m
  ;<  cfg=(unit config:gossip)  bind:m  (read-gossip-config ship-a)
  ?~  cfg  (strand-fail %missing-gossip-config ~)
  (ex-equal !>(hops.u.cfg) !>(want))
--
|%
++  ph-test-gossip-hops
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (expect-hops %2)
  ;<  ~  bind:m  (set-hops ship-a %0)
  ;<  ~  bind:m  (expect-hops %0)
  ;<  ~  bind:m  (set-hops ship-a %1)
  (expect-hops %1)
--
