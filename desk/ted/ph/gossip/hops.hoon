::
::  Gossip hops config over an Aqua virtual ship: %0, %1, and %2
::  are accepted, anything larger nacks and leaves config alone.
::
/-  spider
/+  *ph-io, *ph-chorus, gossip
=,  strand=strand:spider
|=  arg=vase
=/  m  (strand:rand ,vase)
=/  expect-hops
  |=  want=@ud
  =/  n  (strand ,?)
  ^-  form:n
  ;<  cfg=(unit config:gossip)  bind:n  (read-gossip-config ship-a)
  ?:  &(?=(^ cfg) =(want hops.u.cfg))
    (pure:n &)
  ~&  >>>  [%wrong-hops want=want have=cfg]
  (pure:n |)
~&  >>  %running-thread
;<  ~  bind:m  (setup %gossip-hops)
;<  ok=?  bind:m
  =/  n  (strand ,?)
  ^-  form:n
  ::  chorus initializes gossip with two hops
  ::
  ;<  ok=?  bind:n  (expect-hops 2)
  ?.  ok  (pure:n |)
  ;<  ok=?  bind:n  (set-hops ship-a %0)
  ?.  ok
    ~&  >>>  %set-hops-0-nacked
    (pure:n |)
  ;<  ok=?  bind:n  (expect-hops 0)
  ?.  ok  (pure:n |)
  ;<  ok=?  bind:n  (set-hops ship-a %1)
  ?.  ok
    ~&  >>>  %set-hops-1-nacked
    (pure:n |)
  ;<  ok=?  bind:n  (expect-hops 1)
  ?.  ok  (pure:n |)
  ::  out-of-range hops must nack and leave config unchanged
  ::
  ;<  ok=?  bind:n  (poke-chorus-soft ship-a gossip-action+!>([%config-hops 3]))
  ?:  ok
    ~&  >>>  %out-of-range-hops-acked
    (pure:n |)
  (expect-hops 1)
?:  ok
  ~&  >  %gossip-hops-ok
  ;<  ~  bind:m  (teardown %gossip-hops)
  (pure:m arg)
~&  >>>  %gossip-hops-failed
;<  ~  bind:m  (teardown %gossip-hops)
(pure:m arg)
