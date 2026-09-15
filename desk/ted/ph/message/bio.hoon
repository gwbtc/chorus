::  Bidirectional bio delivery over %chorus-message.
/-  spider
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|%
++  ph-test-message-bio
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (prepare-pair %message-bio)
  ;<  ~  bind:m  (expect-bulla ship-b 0v30)
  ;<  ~  bind:m  (update-bio ship-a 'new bio from ship a')
  ;<  ~  bind:m  (await-bulla ship-b 0v30 ship-a [%bio 'new bio from ship a'])
  ;<  ~  bind:m  (expect-bulla ship-a 0v31)
  ;<  ~  bind:m  (update-bio ship-b 'new bio from ship b')
  (await-bulla ship-a 0v31 ship-b [%bio 'new bio from ship b'])
--
