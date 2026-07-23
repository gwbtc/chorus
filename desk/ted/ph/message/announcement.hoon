::
::  End-to-end %announcement gossip test over two Aqua virtual ships.
::
/-  spider, *chorus
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|=  arg=vase
=/  m  (strand:rand ,vase)
~&  >>  %running-thread
;<  ~  bind:m  (setup %chorus-announcement)
;<  ~  bind:m  (make-announcement ship-a 'announcement from ship a')
;<  ~  bind:m  (make-announcement ship-b 'announcement from ship b')
~&  >  %made-announcements
;<  ok=?  bind:m
  %+  poll  10
  =/  n  (strand ,?)
  ;<  anns-a=anns  bind:n  (read-announcements ship-a)
  ;<  anns-b=anns  bind:n  (read-announcements ship-b)
  %-  pure:n
  ?&  (heard-announcement anns-a ship-b 'announcement from ship b')
      (heard-announcement anns-b ship-a 'announcement from ship a')
  ==
?:  ok
  ~&  >  %both-ships-heard-announcements
  ;<  ~  bind:m  (teardown %chorus-announcement)
  (pure:m arg)
~&  >>>  %announcements-not-heard
;<  ~  bind:m  (teardown %chorus-announcement)
(pure:m arg)
