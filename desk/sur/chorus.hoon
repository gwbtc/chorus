/-  mcp
|%
::
+$  bio   @t
+$  desc  @t
::
+$  state-0
  $:  %0
      ::  our description
      =bio
      ::  peers' descriptions
      rolodex=(map ship bio)
      ::  heard messages
      announcements=(set announcement)
      ::  known app listings
      apps=(map ship (set (pair desk desc)))
      ::  known tool listings
      tool-catalog=(map ship (set tool-listing))
  ==
::
::  signed jammed noun
+$  broadcast
  $:  =ship
      sig=@
      data=@
  ==
::
::  256-character message for the network
+$  announcement
  $:  =ship
      =time
      text=@t
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
+$  chorus-action
  $%  ::  update our self-description (local only)
      [%set-description text=@t]
      ::  announce something to pals and pals-of-pals
      [%announce text=@t]
      ::  publish a Gall app to the network
      [%publish-app =desk =desc]
      ::  publish an MCP tool to the network
      [%publish-tool =tool-listing]
  ==
--
