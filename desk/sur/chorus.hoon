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
  +$  meta
    $+  chorus-desk-metadata
    [=^desk =desc]
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
::  agent skills standard,
::  per https://agentskills.io
++  skill
  =<  skill
  |%
  ::
  +$  listing
    $+  chorus-agent-skill-listing
    [=meta =wick]
  ::
  +$  meta
    $+  chorus-agent-skill-metadata
    [name=@t description=@t compatibility=@t]
  ::
  +$  frontmatter
    $+  chorus-agent-skill-frontmatter
    $:  name=@t
        description=@t
        license=(unit $@(cord path))
        compatibility=(unit cord)
        metadata=(unit (map cord cord))
        allowed-tools=(unit cord)
    ==
  ::
  ::  a skill is a directory of files,
  ::  referenced by signed wicks
  +$  skill
    $+  chorus-agent-skill
    $:  =frontmatter
        body=wick
        references=(list wick)
        scripts=(list wick)
        assets=(list wick)
    ==
  --
::
::  shared wiki
+$  cabinet  (axal [=slip =wick])
+$  slip     [=ship =time txt=@t]
::
::  state
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
      ::  agent skills
      skills=(map ship (set listing:skill))
      ::  wiki
      =cabinet
      ::
      ::  signatures for old bullas, lets us replay
      ::  messages to heard subscribers, and when we
      ::  heard each, for the since scry
      sigs=(map wick [=ship sig=@ux when=@da])
  ==
::
::  client-to-ship pokes
+$  action
  $+  chorus-action
  $%  [%publish crowd=(unit crowd:gossip) =body]
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
      [%agent-skill =skill]
      [%slip =path =slip]
  ==
::
::  ship-to-ship gossip
::
::  signed container for a missive
+$  bulla
  $+  chorus-bulla
  $:  %chorus-bulla
      =ship
      sig=@ux
      msg=missive
  ==
::
::  contents of a bulla: metadata for some content,
::  and a wick we can call to find out more
+$  missive
  $+  chorus-missive
  $%  [%chorus-bio txt=cord =wick]
      ::  [%chorus-disavow =missive]  ::  XX not implemented
      [%chorus-slip =slip =wick]
      [%chorus-announcement txt=cord =wick]
      [%chorus-desk =meta:desk =wick]
      [%mcp-tool =meta:tool:mcp =wick]
      [%mcp-resource =meta:resource:mcp =wick]
      [%mcp-resource-template =meta:template:resource:mcp =wick]
      [%mcp-prompt =meta:prompt:mcp =wick]
      [%agent-skill =meta:skill =wick]
      ::  XX %a2a-agent-card =meta:card:a2a =wick
      ::  XX %a2a-agent-skill =meta:skill:a2a =wick
  ==
::
::  ship-to-client facts
+$  update
  $+  chorus-update
  $%  [%chorus-bio-updated txt=cord wire=@t]
      [%chorus-announcement =time txt=cord wire=@t]
      [%chorus-desk-published =^desk =desc:desk wire=@t]
      [%mcp-tool-listed =meta:tool:mcp wire=@t]
      [%mcp-prompt-listed =meta:prompt:mcp wire=@t]
      [%mcp-resource-listed =meta:resource:mcp wire=@t]
      [%mcp-resource-template-listed =meta:template:resource:mcp wire=@t]
      [%agent-skill-listed =meta:skill wire=@t]
      [%chorus-slip =path =nym =slip wire=@t]
      [%chorus-slip-discarded =path wire=@t]
  ==
--
