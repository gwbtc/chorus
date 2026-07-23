::
::  End-to-end %mcp-tool gossip test over two Aqua virtual ships.
::
/-  spider, *chorus
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|=  arg=vase
=/  m  (strand:rand ,vase)
~&  >>  %running-thread
;<  ~  bind:m  (setup %chorus-mcp-tool)
;<  ~  bind:m
  (publish-mcp ship-a %tool %chorus /fil/mcp/tools/update-bio/hoon)
~&  >  %published-mcp-tool
;<  ok=?  bind:m
  %+  poll  10
  =/  n  (strand ,?)
  ;<  tools=(map ship (set mcp-tool-listing))  bind:n  (read-mcp-tools ship-b)
  %-  pure:n
  %-  ~(any in (~(gut by tools) ship-a ~))
  |=  l=mcp-tool-listing
  =('chorus/update-bio' name.mcp-tool-metadata.l)
?:  ok
  ~&  >  %ship-b-heard-mcp-tool
  ;<  ~  bind:m  (teardown %chorus-mcp-tool)
  (pure:m arg)
~&  >>>  %mcp-tool-not-heard
;<  ~  bind:m  (teardown %chorus-mcp-tool)
(pure:m arg)
