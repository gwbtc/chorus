/-  mcp, *wick
|%
::
::  biography
+$  bio   @t
::  desk description
+$  desc  @t
::  256-character message for the network
+$  announcement  @t
::
+$  state-0
  $:  %0
      ::  XX remove, just put our bio in rolodex
      =bio
      :: agent descriptions
      rolodex=(map ship bio)
      ::  heard messages
      announcements=(map ship (set [=time =announcement]))
      ::  known desk listings
      desks=(map ship (set [=desk =desc]))
      ::  mcp features
      mcp-tools=(map ship (set mcp-tool-listing))
      mcp-prompts=(map ship (set mcp-prompt-listing))
      mcp-resources=(map ship (set mcp-resource-listing))
      mcp-resource-templates=(map ship (set mcp-resource-template-listing))
  ==
::
::  signed jammed noun
::  +$  broadcast
  ::  $:  =ship
      ::  sig=@
      ::  data=@
  ::  ==
::
::  the data half of each mcp listing: what a publisher grows
::  and signs, and what a listener stores next to the wick
+$  mcp-tool-metadata
  $+  chorus-mcp-tool-metadata
  $:  =name:tool:mcp
      =desc:tool:mcp
      =parameters:tool:mcp
      =required:tool:mcp
  ==
::
+$  mcp-prompt-metadata
  $+  chorus-mcp-prompt-metadata
  $:  name=@t
      title=@t
      desc=@t
      arguments=(list argument:prompt:mcp)
  ==
::
+$  mcp-resource-metadata
  $+  chorus-mcp-resource-metadata
  $:  uri=@t
      name=@t
      title=(unit @t)
      desc=(unit @t)
  ==
::
+$  mcp-resource-template-metadata
  $+  chorus-mcp-resource-template-metadata
  $:  uri-template=@t
      name=@t
      title=(unit @t)
      desc=(unit @t)
  ==
::
+$  mcp-tool-listing
  $+  chorus-mcp-tool-listing
  [=mcp-tool-metadata =wick]
::
+$  mcp-prompt-listing
  $+  chorus-mcp-prompt-listing
  [=mcp-prompt-metadata =wick]
::
+$  mcp-resource-listing
  $+  chorus-mcp-resource-listing
  [=mcp-resource-metadata =wick]
::
+$  mcp-resource-template-listing
  $+  chorus-mcp-resource-template-listing
  [=mcp-resource-template-metadata =wick]
::
::  client-to-server actions
+$  action
  $+  chorus-action
  $%  [%update-bio local=? =bio]
      [%make-announcement local=? =announcement]
      [%publish-desk local=? =desk =desc]
      [%publish-mcp-tool local=? =desk =path]
      [%publish-mcp-prompt local=? =desk =path]
      [%publish-mcp-resource local=? =desk =path]
      [%publish-mcp-resource-template local=? =desk =path]
  ==
::
::  ship-to-ship messages
::
::  mcp wicks sign the fine response for the source file in
::  the publisher's clay; the metadata rides along unsigned,
::  as a plaintext syndication of what the signed source says
+$  message
  $+  chorus-message
  $:  %chorus-message
    $%  [%bio =wick]
        [%disavow =message]
        [%announcement =wick]
        [%mcp-tool meta=mcp-tool-metadata =wick]
        [%mcp-resource meta=mcp-resource-metadata =wick]
        [%mcp-resource-template meta=mcp-resource-template-metadata =wick]
        [%mcp-prompt meta=mcp-prompt-metadata =wick]
        ::  XX %agent-skill =wick
        ::  XX %a2a-agent-card =wick
        ::  XX %a2a-agent-skill =wick
    ==
  ==
::
::  facts sent to subscribers
+$  update
  $+  chorus-update
  $%  [%updated-bio =ship =bio]
      [%announcement =ship =time text=@t]
      [%desk-published =ship =desk =desc]
      [%mcp-tool-listed =ship =mcp-tool-listing]
      [%mcp-prompt-listed =ship =mcp-prompt-listing]
      [%mcp-resource-listed =ship =mcp-resource-listing]
      [%mcp-resource-template-listed =ship =mcp-resource-template-listing]
  ==
--
