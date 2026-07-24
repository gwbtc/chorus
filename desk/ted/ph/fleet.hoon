::
::  Boot the chorus aqua fleet, sync the %chorus desk into the
::  virtual ships, and take the snapshot that -chorus!ph-test
::  restores per test. Rerun after changing code that runs on
::  the virtual ships (app, sur, agent-side lib, mar, fil).
::
::  args: (unit [snap-id=(unit term) ~])
::  defaults: snap-id=%chorus-gossip
::
/-  spider
/+  *strandio, *ph-io, *ph-chorus, gw-io=ph-gw-io
=,  strand=strand:spider
^-  thread:spider
|=  args=vase
=/  m  (strand ,vase)
^-  form:m
=/  snap-id=term
  =+  !<(args=(unit [snap-id=(unit term) ~]) args)
  ?~  args  %chorus-gossip
  (fall snap-id.u.args %chorus-gossip)
=/  lab  %chorus-fleet
~&  >>  %running-thread
;<  ~  bind:m  start-simple
;<  ~  bind:m  (watch-our /effect/unto %aqua /effect/unto)
;<  ~  bind:m  (setup-fleet lab)
;<  ~  bind:m  (teardown lab)
;<  ~  bind:m  (send-events [%snap-ships snap-id chorus-fleet]~)
~&  >  [%chorus-fleet-snapped snap-id]
(pure:m !>(snap-id))
