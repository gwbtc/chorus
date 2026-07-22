::
::  End-to-end %announcement gossip test over two Aqua virtual ships.
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
++  make-announcement
  |=  [who=ship =announcement]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-chorus who chorus-action+!>([%make-announcement | announcement]))
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
+$  anns  (map ship (set (pair time announcement)))
::
++  read-announcements
  |=  who=ship
  =/  m  (strand anns)
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  =/  out=(unit anns)
    %+  scry-aqua:util  (unit anns)
    :*  our.bowl
        now.bowl
        /i/(scot %p who)/gx/(scot %p who)/chorus/(scot %da now.bowl)/announcements/noun/noun
    ==
  (pure:m (need out))
::
++  heard-announcement
  |=  [heard=anns from=ship text=cord]
  ^-  ?
  %-  ~(any in (~(gut by heard) from ~))
  |=  (pair time announcement)
  =(text q)
--
|=  arg=vase
=/  m  (strand:rand ,vase)
=/  io  ~(. gw-io %.y %chorus-announcement)
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
;<  ~  bind:m  (make-announcement ship-a 'announcement from ship a')
;<  ~  bind:m  (make-announcement ship-b 'announcement from ship b')
~&  >  %made-announcements
=/  tries=@ud  10
|-  ^-  form:m
;<  ~  bind:m  (sleep ~s3)
;<  anns-a=anns  bind:m  (read-announcements ship-a)
;<  anns-b=anns  bind:m  (read-announcements ship-b)
=/  a-heard-b  (heard-announcement anns-a ship-b 'announcement from ship b')
=/  b-heard-a  (heard-announcement anns-b ship-a 'announcement from ship a')
?:  &(a-heard-b b-heard-a)
  ~&  >  :*  ship-a-heard-b=(~(get by anns-a) ship-b)
             ship-b-heard-a=(~(get by anns-b) ship-a)
         ==
  ~&  >  %both-ships-heard-announcements
  ;<  ~  bind:m  (leave-our /effect/unto %aqua)
  ;<  ~  bind:m  end:io
  (pure:m arg)
?.  =(0 tries)
  ~&  >  [%announcements-pending tries=tries a=a-heard-b b=b-heard-a]
  $(tries (dec tries))
~&  >>>  [%announcements-not-heard a-heard-b=a-heard-b b-heard-a=b-heard-a]
;<  ~  bind:m  (leave-our /effect/unto %aqua)
;<  ~  bind:m  end:io
(pure:m arg)
