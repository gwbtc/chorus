/-  *chorus
|_  val=(map ship roster-entry)
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %o
    %-  ~(gas by *(map @t ^json))
    %+  turn  ~(tap by val)
    |=  [=ship =roster-entry]
    :-  (scot %p ship)
    :-  %o
    %-  ~(gas by *(map @t ^json))
    :~  ['last' s+(scot %da last.roster-entry)]
        ['desc' s+desc.roster-entry]
        ['attest' ?~(attest.roster-entry ~ [%s u.attest.roster-entry])]
    ==
  --
++  grab
  |%
  ++  noun  ,(map ship roster-entry)
  --
--
