/-  *chorus
|_  val=(list mail)
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    :-  %a
    %+  turn  val
    |=  =mail
    :-  %o
    %-  ~(gas by *(map @t ^json))
    :~  ['id' s+(scot %uv id.mail)]
        ['from' s+(scot %p from.mail)]
        ['to' ?~(to.mail ~ [%s (scot %p u.to.mail)])]
        ['subject' s+subject.mail]
        ['body' s+body.mail]
        ['time' s+(scot %da time.mail)]
    ==
  --
++  grab
  |%
  ++  noun  ,(list mail)
  --
--
