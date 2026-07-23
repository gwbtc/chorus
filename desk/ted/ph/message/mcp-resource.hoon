::
::  End-to-end %mcp-resource gossip test over two Aqua virtual ships.
::
::  The chorus desk ships no resource files, so this thread writes a
::  mock resource into ship a's %chorus desk before publishing it.
::
/-  spider, *chorus
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
=/  mock-resource=@t
  '''
  /-  mcp
  ^-  resource:mcp
  :*  'scry://gx/chorus/rolodex/json'
      'chorus/example-resource'
      `'Example resource'
      `'A mock resource for testing Chorus publishes.'
      `'application/json'
      ~
      ~
  ==
  '''
|=  arg=vase
=/  m  (strand:rand ,vase)
~&  >>  %running-thread
;<  ~  bind:m  (setup %chorus-mcp-resource)
;<  ~  bind:m  (insert-file ship-a /fil/mcp/resources/example/hoon mock-resource)
;<  ~  bind:m
  (publish-mcp ship-a %resource %chorus /fil/mcp/resources/example/hoon)
~&  >  %published-mcp-resource
;<  ok=?  bind:m
  %+  poll  10
  =/  n  (strand ,?)
  ;<  resources=(map ship (set mcp-resource-listing))  bind:n
    (read-mcp-resources ship-b)
  %-  pure:n
  %-  ~(any in (~(gut by resources) ship-a ~))
  |=  l=mcp-resource-listing
  =('chorus/example-resource' name.mcp-resource-metadata.l)
?:  ok
  ~&  >  %ship-b-heard-mcp-resource
  ;<  ~  bind:m  (teardown %chorus-mcp-resource)
  (pure:m arg)
~&  >>>  %mcp-resource-not-heard
;<  ~  bind:m  (teardown %chorus-mcp-resource)
(pure:m arg)
