/-  *wick
|%
++  make-wick
  |=  [=flag =beak =path sec=ring]
  ^-  wick
  =/  who=@pH  p.beak
  =/  pat=@t  (spat path)
  =/  dig=@uvI  (sha-256l:sha (met 3 pat) pat)
  ::  XX placeholder: use the Groundwire HD wallet's secp256k1 scalar here
  ::  once that key is exposed, instead of deriving one from Jael's ring.
  =/  prv=@uvI  (shax sec)
  =+  (ecdsa-raw-sign:secp256k1:secp:crypto dig prv)
  =/  sig=@uxI
    %+  can  3
    :~  [1 v]
        [32 r]
        [32 s]
    ==
  [%7 who flag path sig]
--
