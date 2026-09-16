::
::  Build the two Chorus Aqua snapshots restored by -chorus!ph-test:
::  a two-fief message fleet and the complete four-ship PKI fleet.
::  Rerun after changing code that runs on the virtual ships.
::
::  args: (unit [message-snap=(unit term) topology-snap=(unit term)])
::  defaults: [%chorus-message %chorus-gossip]
::
/-  spider
/+  *strandio, *ph-io, *ph-chorus, gw-io=ph-gw-io
=,  strand=strand:spider
^-  thread:spider
|=  args=vase
=/  m  (strand ,vase)
^-  form:m
=/  [message-snap=term topology-snap=term]
  =+  !<(args=(unit [message-snap=(unit term) topology-snap=(unit term)]) args)
  ?~  args  [%chorus-message %chorus-gossip]
  :-  (fall message-snap.u.args %chorus-message)
  (fall topology-snap.u.args %chorus-gossip)
~&  >>  %running-thread
;<  ~  bind:m  start-simple
;<  ~  bind:m  (watch-our /effect/unto %aqua /effect/unto)
;<  ~  bind:m  (setup-message-fleet %chorus-message-fleet)
;<  ~  bind:m  (send-events [%snap-ships message-snap message-fleet]~)
~&  >  [%chorus-message-fleet-snapped message-snap]
::  %snap-ships clears Aqua's live fleet, so construct the complete
::  topology independently rather than extending the snapped piers.
;<  ~  bind:m  (setup-fleet %chorus-topology-fleet)
;<  ~  bind:m  (teardown %chorus-topology-fleet)
;<  ~  bind:m  (send-events [%snap-ships topology-snap chorus-fleet]~)
~&  >  [%chorus-topology-fleet-snapped topology-snap]
;<  ~  bind:m  end
(pure:m !>([message-snap topology-snap]))
