::  A ship hears only the ships it polls.
/-  spider
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|%
++  ph-test-message-unlisted
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  prepare-pair
  ;<  ~  bind:m  (update-bio ship-a 'bio from ship a')
  ;<  ~  bind:m  (expect-update ship-b 0v80)
  ;<  ~  bind:m  (poll ship-b ship-a)
  ;<  ~  bind:m  (await-update ship-b 0v80 ship-a [%bio 'bio from ship a'])
  ;<  ~  bind:m  (unlist ship-b ship-a)
  ;<  heard=(set listing:bio)  bind:m  (read-rolodex ship-b)
  ?:  (~(any in heard) |=(listing:bio =(ship-a ship)))
    (strand-fail %unlisted-ship-shown ~)
  (pure:m ~)
--
