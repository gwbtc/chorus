/-  mcp, *wick, gossip
|%
::
++  bio
  |%
  +$  listing
    $+  chorus-bio-listing
    [txt=cord =wick]
  --
::
++  announcement
  |%
  +$  listing
    $+  chorus-announcement-listing
    [=time txt=cord =wick]
  --
::
++  desk
  |%
  +$  desc  @t
  +$  listing
    $+  chorus-desk-listing
    [=^desk =desc =wick]
  --
::
++  mcp
  |%
  ++  tool
    |%
    +$  meta
      $+  chorus-mcp-tool-metadata
      $:  =name:tool:^mcp
          =desc:tool:^mcp
          =parameters:tool:^mcp
          =required:tool:^mcp
      ==
    ::
    +$  listing
      $+  chorus-mcp-tool-listing
      [=meta =wick]
    --
  ::
  ++  prompt
    |%
    +$  meta
      $+  chorus-mcp-prompt-metadata
      $:  name=@t
          title=@t
          desc=@t
          arguments=(list argument:prompt:^mcp)
      ==
    +$  listing
      $+  chorus-mcp-prompt-listing
      [=meta =wick]
    --
  ::
  ++  resource
    |%
    +$  meta
      $+  chorus-mcp-resource-metadata
      $:  uri=@t
          name=@t
          title=(unit @t)
          desc=(unit @t)
      ==
    +$  listing
      $+  chorus-mcp-resource-listing
      [=meta =wick]
    ::
    ++  template
      |%
      +$  meta
        $+  chorus-mcp-resource-template-metadata
        $:  uri-template=@t
            name=@t
            title=(unit @t)
            desc=(unit @t)
        ==
      +$  listing
        $+  chorus-mcp-resource-template-listing
        [=meta =wick]
      --
    --
  --
::
+$  versioned-state
  $%  state-0
  ==
::
+$  state-0
  $:  %0
      :: agent descriptions
      rolodex=(map ship listing:bio)
      ::  heard messages
      announcements=(map ship (set listing:announcement))
      ::  known desk listings
      desks=(map ship (set listing:desk))
      ::  mcp features
      mcp-tools=(map ship (set listing:tool:mcp))
      mcp-prompts=(map ship (set listing:prompt:mcp))
      mcp-resources=(map ship (set listing:resource:mcp))
      mcp-resource-templates=(map ship (set listing:template:resource:mcp))
  ==
::
::  client-to-ship pokes
+$  action
  $+  chorus-action
  $%  [%publish crowd=(unit crowd:gossip) =body]
      [%verify target=$@(ship [=ship =wick])]
      [%delete target=$@(ship [=ship =wick])]
      ::  XX %tombstone =path
  ==
::
+$  body
  $+  chorus-action-body
  $%  [%bio bio=@t]
      [%announcement announcement=@t]
      [%desk =^desk desc=@t]
      [%mcp-tool =^desk =path]
      [%mcp-prompt =^desk =path]
      [%mcp-resource =^desk =path]
      [%mcp-resource-template =^desk =path]
  ==
::
::  ship-to-ship gossip
::
::  every kind is [unsigned metadata, wick]: the wick names the
::  ship that signed it and the path its content lives at, and
::  the metadata is what a listener needs to hold the entry
::  without fetching that content
+$  message
  $+  chorus-message
  $:  %chorus-message
    $%  [%chorus-bio txt=cord =wick]
        ::  [%chorus-disavow =message]  ::  XX not implemented
        [%chorus-announcement txt=cord =wick]
        [%mcp-tool =meta:tool:mcp =wick]
        [%mcp-resource =meta:resource:mcp =wick]
        [%mcp-resource-template =meta:template:resource:mcp =wick]
        [%mcp-prompt =meta:prompt:mcp =wick]
        ::  XX %agent-skill =meta:skill =wick
        ::  XX %a2a-agent-card =meta:card:a2a =wick
        ::  XX %a2a-agent-skill =meta:skill:a2a =wick
    ==
  ==
::
::  ship-to-client facts
+$  update
  $+  chorus-update
  $%  [%chorus-bio-updated =ship =listing:bio]
      [%chorus-announcement =ship =listing:announcement]
      [%chorus-desk-published =ship =listing:desk]
      [%mcp-tool-listed =ship =listing:tool:mcp]
      [%mcp-prompt-listed =ship =listing:prompt:mcp]
      [%mcp-resource-listed =ship =listing:resource:mcp]
      [%mcp-resource-template-listed =ship =listing:template:resource:mcp]
  ==
--
