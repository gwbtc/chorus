::
::  A publisher picks per-message who hears: ship b subscribes to
::  ship a, a broadcasts an announcement and b hears it, then a
::  makes a zero-hop announcement and b, still subscribed, must
::  not hear that one. The broadcast comes first to prove the
::  pipe works before we trust the silence.
::
/-  spider, *chorus
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|=  arg=vase
=/  m  (strand:rand ,vase)
~&  >>  %running-thread
;<  ~  bind:m  (setup %gossip-local)
;<  ~  bind:m  (make-announcement ship-a 'broadcast announcement from ship a')
~&  >  %made-broadcast-announcement
;<  ok=?  bind:m
  %+  poll  40
  =/  n  (strand ,?)
  ;<  anns-b=anns  bind:n  (read-announcements ship-b)
  %-  pure:n
  (heard-announcement anns-b ship-a 'broadcast announcement from ship a')
?.  ok
  ~&  >>>  %broadcast-announcement-not-heard
  ;<  ~  bind:m  (teardown %gossip-local)
  (pure:m arg)
~&  >  %ship-b-heard-broadcast
;<  ~  bind:m  (make-local-announcement ship-a 'local announcement from ship a')
~&  >  %made-local-announcement
::  a zero-hop message never arrives; give a leak time to show
::
;<  ~  bind:m  (sleep ~s15)
;<  anns-a=anns  bind:m  (read-announcements ship-a)
;<  anns-b=anns  bind:m  (read-announcements ship-b)
=/  ok=?
  ?&  (heard-announcement anns-a ship-a 'local announcement from ship a')
      !(heard-announcement anns-b ship-a 'local announcement from ship a')
  ==
?:  ok
  ~&  >  %gossip-local-ok
  ;<  ~  bind:m  (teardown %gossip-local)
  (pure:m arg)
~&  >>>  %gossip-local-failed
;<  ~  bind:m  (teardown %gossip-local)
(pure:m arg)
