/-  mcp
|%
::
+$  state-0
  $:  %0
      ::  our self-descripiton
      desc=@t
      ::  heard messages
      broadcasts=(set broadcast)
      ::  known tool listings
      catalog=(map ship (set tool-listing))
  ==
::
::  send signed noun to everyone
+$  broadcast
  $:  =ship
      noun=*
  ==
::
+$  tool-listing
  $:  =name:tool:mcp
      =desc:tool:mcp
      =parameters:tool:mcp
      =required:tool:mcp
  ==
::
::  pokes
+$  action
  $%  ::  update our self-description (local only)
      [%set-description text=@t]
      ::  manually broadcast our presence to the gossip network
      [%broadcast text=@t]
      ::  publish our MCP tool catalog to the network
      [%publish-tools tools=(list tool-listing)]
  ==
--
