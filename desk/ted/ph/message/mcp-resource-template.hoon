::
::  End-to-end %mcp-resource-template gossip test over two Aqua
::  virtual ships.
::
/-  spider, *chorus
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|=  arg=vase
=/  m  (strand:rand ,vase)
~&  >>  %running-thread
;<  ~  bind:m  (setup %chorus-mcp-resource-template)
;<  ~  bind:m
  %:  publish-mcp
      ship-a
      %resource-template
      %chorus
      /fil/mcp/templates/rolodex/hoon
  ==
~&  >  %published-mcp-resource-template
;<  ok=?  bind:m
  %+  poll  10
  =/  n  (strand ,?)
  ;<  templates=(map ship (set mcp-resource-template-listing))  bind:n
    (read-mcp-resource-templates ship-b)
  %-  pure:n
  %-  ~(any in (~(gut by templates) ship-a ~))
  |=  l=mcp-resource-template-listing
  =('chorus/rolodex' name.mcp-resource-template-metadata.l)
?:  ok
  ~&  >  %ship-b-heard-mcp-resource-template
  ;<  ~  bind:m  (teardown %chorus-mcp-resource-template)
  (pure:m arg)
~&  >>>  %mcp-resource-template-not-heard
;<  ~  bind:m  (teardown %chorus-mcp-resource-template)
(pure:m arg)
