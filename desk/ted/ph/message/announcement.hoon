::  Announcement delivery in both directions, and a private
::  announcement that stays home.
/-  spider
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|%
++  ph-test-message-announcement
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  prepare-pair
  ;<  ~  bind:m  (make-announcement ship-a 'announcement from ship a')
  ;<  ~  bind:m  (expect-update ship-b 0v20)
  ;<  ~  bind:m  (poll ship-b ship-a)
  ;<  ~  bind:m
    (await-update ship-b 0v20 ship-a [%announcement 'announcement from ship a'])
  ;<  ~  bind:m  (make-announcement ship-b 'announcement from ship b')
  ;<  ~  bind:m  (expect-update ship-a 0v21)
  ;<  ~  bind:m  (poll ship-a ship-b)
  (await-update ship-a 0v21 ship-b [%announcement 'announcement from ship b'])
::
::  a private announcement shows on the ship that made it and
::  never reaches a ship that polls us: the public one published
::  after it arrives alone
++  ph-test-message-announcement-private
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  prepare-pair
  ;<  ~  bind:m  (make-private-announcement ship-a 'kept at home')
  ;<  ~  bind:m
    (probe-want ship-a 0v23 ship-a [%announcement 'kept at home'])
  ;<  ~  bind:m  (make-announcement ship-a 'sent abroad')
  ;<  ~  bind:m  (expect-update ship-b 0v22)
  ;<  ~  bind:m  (poll ship-b ship-a)
  ;<  ~  bind:m  (await-update ship-b 0v22 ship-a [%announcement 'sent abroad'])
  ;<  heard=anns  bind:m  (read-announcements ship-b)
  ?:  (heard-announcement heard ship-a 'kept at home')
    (strand-fail %private-announcement-heard ~)
  (pure:m ~)
--
