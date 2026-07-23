::
::  End-to-end %bio gossip test over two Aqua virtual ships.
::
/-  spider, *chorus
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|=  arg=vase
=/  m  (strand:rand ,vase)
~&  >>  %running-thread
;<  ~  bind:m  (setup %chorus-bio)
;<  ~  bind:m  (update-bio ship-a 'new bio from ship a')
;<  ~  bind:m  (update-bio ship-b 'new bio from ship b')
~&  >  %updated-bios
;<  ok=?  bind:m
  %+  poll  10
  =/  n  (strand ,?)
  ;<  rolodex-a=(map ship cord)  bind:n  (read-rolodex ship-a)
  ;<  rolodex-b=(map ship cord)  bind:n  (read-rolodex ship-b)
  %-  pure:n
  ?&  =((some 'new bio from ship b') (~(get by rolodex-a) ship-b))
      =((some 'new bio from ship a') (~(get by rolodex-b) ship-a))
  ==
?:  ok
  ~&  >  %both-ships-heard-bios
  ;<  ~  bind:m  (teardown %chorus-bio)
  (pure:m arg)
~&  >>>  %bios-not-heard
;<  ~  bind:m  (teardown %chorus-bio)
(pure:m arg)
