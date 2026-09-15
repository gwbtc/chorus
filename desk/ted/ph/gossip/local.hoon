::  A local publication stays on its source. A subsequent observed
::  broadcast is the causal fence for the negative assertion.
/-  spider
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|%
++  ph-test-gossip-local
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (prepare-pair %gossip-local)
  ;<  ~  bind:m  (make-local-announcement ship-a 'local announcement')
  ;<  ~  bind:m  (expect-bulla ship-b 0v80)
  ;<  ~  bind:m  (make-announcement ship-a 'local fence')
  ;<  ~  bind:m  (await-bulla ship-b 0v80 ship-a [%announcement 'local fence'])
  ;<  anns-a=anns  bind:m  (read-announcements ship-a)
  ;<  anns-b=anns  bind:m  (read-announcements ship-b)
  ?.  (heard-announcement anns-a ship-a 'local announcement')
    (strand-fail %local-announcement-not-stored ~)
  ?:  (heard-announcement anns-b ship-a 'local announcement')
    (strand-fail %local-announcement-leaked ~)
  (pure:m ~)
--
