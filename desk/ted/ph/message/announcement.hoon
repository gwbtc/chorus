::  Bidirectional announcement delivery over %chorus-message.
/-  spider
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|%
++  ph-test-message-announcement
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (prepare-pair %message-announcement)
  ;<  ~  bind:m  (expect-bulla ship-b 0v20)
  ;<  ~  bind:m  (make-announcement ship-a 'announcement from ship a')
  ;<  ~  bind:m  (await-bulla ship-b 0v20 ship-a [%announcement 'announcement from ship a'])
  ;<  ~  bind:m  (expect-bulla ship-a 0v21)
  ;<  ~  bind:m  (make-announcement ship-b 'announcement from ship b')
  (await-bulla ship-a 0v21 ship-b [%announcement 'announcement from ship b'])
--
