/-  *chorus
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
  ::  {"drawer": "/projects", "ships": ["~sampel-palnet"]}
  ++  json
    |=  jon=^json
    ^-  fetch
    =,  dejs:format
    %.  jon
    (ot ~[drawer+pa ships+(as (se %p))])
  --
--
