/-  chorus, mcp, spider
/+  io=strandio
^-  tool:mcp
:*  'chorus/discard-slip'
    '''
    Remove one of our slips from this ship's cabinet. Takes
    the slip's cabinet path. Peers drop their copies when
    they next poll us.
    '''
    %-  my
    :~  :-  'path'
        :-  %string
        '''
        The cabinet path of the slip, beginning with a /,
        e.g. /projects/chorus/kademlia.
        '''
    ==
    ~['path']
    ^-  thread-builder:tool:mcp
    |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
    ^-  shed:khan
    =/  m  (strand:spider ,vase)
    ^-  form:m
    =/  pat  (~(get by args) 'path')
    ?~  pat
      (pure:m !>([%error %missing-path ~]))
    ?>  ?=([%string @t] u.pat)
    =/  pax=(unit path)  (rush p.u.pat stap)
    ?~  pax
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error 'could not parse the path; it must look like /drawer/slug' ~]
    ;<  our=ship  bind:m  get-our:io
    ;<  =cabinet:chorus  bind:m
      %+  scry:io  cabinet:chorus
      (weld /gx/chorus/cabinet/drawer (snoc u.pax %noun))
    ?~  fil.cabinet
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%error (crip "no slip at {(trip p.u.pat)}") ~]
    ?.  =(our ship.u.fil.cabinet)
      %-  pure:m
      !>  ^-  response:tool:mcp
      :+  %error
        (crip "the slip at {(trip p.u.pat)} belongs to {<ship.u.fil.cabinet>}")
      ~
    ;<  ~  bind:m
      %-  send-raw-card:io
      :*  %pass   /discard-slip
          %agent  [our %chorus]
          %poke   %chorus-retract
          !>(`retract:chorus`[%slip u.pax])
      ==
    ;<  ~  bind:m  (take-poke-ack:io /discard-slip)
    %-  pure:m
    !>  ^-  response:tool:mcp
    :-  %result
    :-  %structured
    (frond:enjs:format %discarded s+p.u.pat)
==
