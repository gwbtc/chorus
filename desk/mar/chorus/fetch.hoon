/-  *chorus
/+  cho=chorus
|_  act=fetch
++  grad  %noun
++  grow
  |%
  ++  noun  act
  --
++  grab
  |%
  ++  noun  ,fetch
  ::
  ::  a ship as a @p or as its nym: we poll comets alone, and a
  ::  comet's nym names its address
  ::  {"drawer": "/projects", "ships": ["~sampel-palnet", "..abet.baboon"]}
  ++  json
    |=  jon=^json
    ^-  fetch
    =,  dejs:format
    %.  jon
    %-  ot
    :~  drawer+pa
        :-  %ships
        %-  as
        %+  cu
          |=  txt=@t
          ^-  ship
          ?:  =('~' (end 3 txt))
            (slav %p txt)
          (nym-ship:cho txt)
        so
    ==
  --
--
