::
::  End-to-end %bio gossip test over two Aqua virtual ships.
::
/-  spider, *chorus
/+  *ph-io, gw-io=ph-gw-io
=,  strand=strand:spider
=>
|%
++  ship-a  ~fasteg-dinhet-malrum-ransub--hocduc-digtev-radsut-marbud
++  ship-b  ~molpyx-novtyc-wortyc-noswyd--taltyv-loplev-dabwen-mardev
::
++  take-effect
  |=  =wire
  =/  m  (strand aqua-effect)
  ^-  form:m
  ;<  res=^cage  bind:m  (take-fact wire)
  ?>  ?=(%aqua-effect p.res)
  (pure:m !<(=aqua-effect q.res))
::
++  take-poke-ack
  |=  who=ship
  =/  m  (strand ,~)
  ^-  form:m
  |-
  ;<  =aqua-effect  bind:m  (take-effect /effect/unto)
  ?.  =(who who.aqua-effect)  $(who who)
  ?.  ?=([%unto %poke-ack *] q.ufs.aqua-effect)  $(who who)
  =/  sign=sign:agent:gall  +.q.ufs.aqua-effect
  ?>  ?=(%poke-ack -.sign)
  ?^  p.sign
    (strand-fail %poke-ack u.p.sign)
  (pure:m ~)
::
++  poke-chorus
  |=  [who=ship =cage]
  =/  m  (strand ,~)
  ^-  form:m
  =/  =task:gall
    [%deal [who who /aqua] %chorus %poke cage]
  ;<  ~  bind:m  (send-events [%event who /g/aqua/deal task]~)
  (take-poke-ack who)
::
++  subscribe
  |=  [who=ship peer=ship]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-chorus who gossip-action+!>([%subscribe peer]))
::
++  update-bio
  |=  [who=ship bio=cord]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-chorus who chorus-action+!>([%update-bio | bio]))
::
++  set-domain
  |=  [who=ship domain=term]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-chorus who gossip-action+!>([%config-domain domain]))
::
++  set-tell-wild
  |=  who=ship
  =/  m  (strand ,~)
  ^-  form:m
  (poke-chorus who gossip-action+!>([%config-tell %whos %wild]))
::
++  read-rolodex
  |=  who=ship
  =/  m  (strand (map ship cord))
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  =/  out=(unit (map ship cord))
    %+  scry-aqua:util  (unit (map ship cord))
    :*  our.bowl
        now.bowl
        /i/(scot %p who)/gx/(scot %p who)/chorus/(scot %da now.bowl)/rolodex/noun/noun
    ==
  (pure:m (need out))
--
|=  arg=vase
=/  m  (strand:rand ,vase)
=/  io  ~(. gw-io %.y %chorus-bio)
=/  =onchain:io
  :~  [ship-a 1 0 ~ %if]
      [ship-b 1 0 ~ %if]
  ==
~&  >>  %running-thread
;<  ~  bind:m  start-simple:io
;<  ~  bind:m  (watch-our /effect/unto %aqua /effect/unto)
;<  ~  bind:m  (start-gw-comet:io ship-a %mesa onchain)
;<  ~  bind:m  (start-gw-comet:io ship-b %mesa onchain)
;<  ~  bind:m  (sleep ~s5)
~&  >  %started-comets
;<  ~  bind:m  (send-hi:io ship-a ship-b)
;<  ~  bind:m  (send-hi:io ship-b ship-a)
~&  >  %sent-his
;<  ~  bind:m  (set-domain ship-a %gw)
;<  ~  bind:m  (set-domain ship-b %gw)
;<  ~  bind:m  (set-tell-wild ship-a)
;<  ~  bind:m  (set-tell-wild ship-b)
~&  >  %set-domains
;<  ~  bind:m  (subscribe ship-a ship-b)
;<  ~  bind:m  (subscribe ship-b ship-a)
;<  ~  bind:m  (sleep ~s2)
~&  >  %set-subscriptions
;<  ~  bind:m  (update-bio ship-a 'new bio from ship a')
;<  ~  bind:m  (update-bio ship-b 'new bio from ship b')
;<  ~  bind:m  (sleep ~s2)
~&  >  %updated-bios
;<  rolodex-a=(map ship cord)  bind:m  (read-rolodex ship-a)
;<  rolodex-b=(map ship cord)  bind:m  (read-rolodex ship-b)
~&  >  :*  ship-a-heard-b=(~(get by rolodex-a) ship-b)
           ship-b-heard-a=(~(get by rolodex-b) ship-a)
      ==
?.  =((some 'new bio from ship b') (~(get by rolodex-a) ship-b))
  ~&  >>>  %ship-a-did-not-hear-ship-b
  ;<  ~  bind:m  (leave-our /effect/unto %aqua)
  ;<  ~  bind:m  end:io
  (pure:m arg)
?.  =((some 'new bio from ship a') (~(get by rolodex-b) ship-a))
  ~&  >>>  %ship-b-did-not-hear-ship-a
  ;<  ~  bind:m  (leave-our /effect/unto %aqua)
  ;<  ~  bind:m  end:io
  (pure:m arg)
~&  >  %both-ships-heard-bios
;<  ~  bind:m  (leave-our /effect/unto %aqua)
;<  ~  bind:m  end:io
(pure:m arg)
