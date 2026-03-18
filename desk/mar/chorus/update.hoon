/-  *chorus
|_  val=chorus-update
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json
    ^-  ^json
    ?-  -.val
        %set-description
      %-  pairs:enjs:format
      :~  ['type' s+'bio']
          ['bio' s+bio.val]
      ==
    ::
        %announce
      %-  pairs:enjs:format
      :~  ['type' s+'announce']
          ['ship' s+(scot %p ship.val)]
          ['time' s+(scot %da time.val)]
          ['text' s+text.val]
      ==
    ::
        %publish-app
      %-  pairs:enjs:format
      :~  ['type' s+'publish-app']
          ['ship' s+(scot %p ship.val)]
          ['desk' s+desk.val]
          ['desc' s+desc.val]
      ==
    ::
        %publish-tool
      =/  t  tool-listing.val
      %-  pairs:enjs:format
      :~  ['type' s+'publish-tool']
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
