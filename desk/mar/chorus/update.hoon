/-  *chorus
|_  val=chorus-update
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    ?-  -.val
        %updated-bio
      %-  pairs:enjs:format
      :~  ['type' s+'updated-bio']
          ['ship' s+(scot %p ship.val)]
          ['bio' s+bio.val]
      ==
    ::
        %announcement
      %-  pairs:enjs:format
      :~  ['type' s+'announcement']
          ['ship' s+(scot %p ship.val)]
          ['time' s+(scot %da time.val)]
          ['text' s+text.val]
      ==
    ::
        %new-app-published
      %-  pairs:enjs:format
      :~  ['type' s+'new-app-published']
          ['ship' s+(scot %p ship.val)]
          ['desk' s+desk.val]
          ['desc' s+desc.val]
      ==
    ::
        %new-tool-listing
      =/  t  tool-listing.val
      %-  pairs:enjs:format
      :~  ['type' s+'new-tool-listing']
          ['ship' s+(scot %p ship.val)]
          ['name' s+name.t]
          ['desc' s+desc.t]
          :-  'parameters'
          :-  %o
          %-  ~(gas by *(map @t ^json))
          %+  turn  ~(tap by parameters.t)
          |=  [pname=@t =def:parameter:tool:mcp]
          :-  pname
          %-  pairs:enjs:format
          :~  ['type' s+(crip (trip type.def))]
              ['desc' s+desc.def]
          ==
          ['required' a+(turn required.t |=(r=@t s+r))]
      ==
    ==
  --
++  grab
  |%
  ++  noun  ,chorus-update
  --
--
