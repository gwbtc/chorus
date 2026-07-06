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
+$  mcp-tool-listing
  $+  chorus-mcp-tool-listing
  $:  =name:tool:mcp
      =desc:tool:mcp
      =parameters:tool:mcp
      =required:tool:mcp
      =wick
  ==
::
+$  mcp-prompt-listing
  $+  chorus-mcp-prompt-listing
  $:  name=@t
      title=@t
      desc=@t
      arguments=(list argument:prompt:mcp)
      =wick
  ==
::
+$  mcp-resource-listing
  $+  chorus-mcp-resource-listing
  $:  uri=@t
      name=@t
      title=(unit @t)
      desc=(unit @t)
      =wick
  ==
::
+$  mcp-resource-template-listing
  $+  chorus-mcp-resource-template-listing
  $:  uri-template=@t
      name=@t
      title=(unit @t)
      desc=(unit @t)
      =wick
  ==
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
+$  message
  $+  chorus-message
  $:  %chorus-message
    $%  [%bio =wick]
        [%disavow =message]
        [%announcement =wick]
        [%mcp-tool =wick]
        [%mcp-resource =wick]
        [%mcp-resource-template =wick]
        [%mcp-prompt =wick]
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
