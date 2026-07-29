|%
+$  rumor
  $:  [kind=@ meta=*]
      data=(cask *)
  ==
+$  meta-0  hops=_0
::
+$  hash    @uv
::
::  gossip is for you (%0), friends (%1), and friends-of-friends
::  (%2). rumor metadata stays @ud since relays decrement it.
::
+$  hops    $~(%1 ?(%0 %1 %2))
::
+$  whos
  $?(%saxo %sein %kids %fief %city %wild)
::
::  a gossip audience. the empty crowd resolves to no ships;
::  as a per-datum override it means the datum stays put
::
+$  crowd
  $@  ~
  $%  [%whos who=whos]
      [%ships ships=(list ship)]
  ==
::
+$  config
  $:  =hops        ::  how many peers across whom gossip may travel
      hear=crowd   ::  who to subscribe to
      tell=crowd   ::  who to allow subscriptions from
      pass=?       ::  whether to (50/50) emit data through proxy
      domain=term  ::  Jael source used for city/fief/kids discovery
  ==
::
::  one-time config for a single datum; ~ fields (and a `~
::  audience) fall back to the standing config. no per-fact
::  hear (hear is standing access control) and no per-fact
::  domain (app-level only).
::
+$  once
  $:  hops=(unit hops)   ::  relay allowance for this datum
      tell=(unit crowd)  ::  audience for this datum
      pass=(unit ?)      ::  proxy preference for this datum
  ==
::
+$  action
  $%  [%config-hops =hops]
      [%config-hear =crowd]
      [%config-tell =crowd]
      [%config-pass pass=?]
      [%config-domain domain=term]
      [%subscribe who=ship]
      [%unsubscribe who=ship]
  ==
--
