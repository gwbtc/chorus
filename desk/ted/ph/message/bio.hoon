::  Bio delivery in both directions: each ship polls the other.
/-  spider
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|%
++  ph-test-message-bio
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  prepare-pair
  ;<  ~  bind:m  (update-bio ship-a 'new bio from ship a')
  ;<  ~  bind:m  (expect-update ship-b 0v30)
  ;<  ~  bind:m  (poll ship-b ship-a)
  ;<  ~  bind:m  (await-update ship-b 0v30 ship-a [%bio 'new bio from ship a'])
  ;<  ~  bind:m  (update-bio ship-b 'new bio from ship b')
  ;<  ~  bind:m  (expect-update ship-a 0v31)
  ;<  ~  bind:m  (poll ship-a ship-b)
  (await-update ship-a 0v31 ship-b [%bio 'new bio from ship b'])
--
