/-  mcp, *content-routing
|%
::
::  a groundwire nym
+$  nym  @t
::
::  every listing names the ship that published it. a hearer
::  drops a listing that names any ship but its publisher
++  bio
  |%
  +$  listing
    $+  chorus-bio-listing
    [=ship txt=cord]
  --
::
++  announcement
  |%
  +$  listing
    $+  chorus-announcement-listing
    [=ship =time txt=cord]
  --
::
++  desk
  |%
  +$  desc  @t
  +$  meta
    $+  chorus-desk-metadata
    [=^desk =desc]
  ::
  ::  .hash is clay's %z hash of the desk when it was listed
  +$  listing
    $+  chorus-desk-listing
    [=ship =^desk =desc hash=@uvI]
  --
::
::  an mcp listing carries .hax, the digest of its source file,
::  which its publisher serves through the content store
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
      [=ship =meta hax=digest]
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
      [=ship =meta hax=digest]
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
      [=ship =meta hax=digest]
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
        [=ship =meta hax=digest]
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
  ::  .hax is the digest of the %chorus-skill manifest
  +$  listing
    $+  chorus-agent-skill-listing
    [=ship =meta hax=digest]
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
  ::  referenced by their digests
  +$  skill
    $+  chorus-agent-skill
    $:  =frontmatter
        body=digest
        references=(list digest)
        scripts=(list digest)
        assets=(list digest)
    ==
  --
::
::  shared wiki. .fqsp is the fully qualified slip path: the
::  remote scry path of this revision of the slip, e.g.
::  /~zod/g/x/3/chorus//1/chorus/cabinet/notes/foo
+$  cabinet  (axal slip)
+$  slip     [=ship =time fqsp=path txt=@t]
::
::  the reserved topics. under each a ship publishes one value,
::  named by the topic in the %chorus namespace; chorus checks its
::  type on the way out and on the way in. the types are those of
::  one ship's share of each part of the old $state-0
+$  topic
  $?  %desks
      %rolodex
      %announcements
      %cabinet
      %skills
      %mcp-tools
      %mcp-prompts
      %mcp-resources
      %mcp-resource-templates
  ==
::
+$  shelf
  $%  [%desks p=(set listing:desk)]
      [%rolodex p=(set listing:bio)]
      [%announcements p=(set listing:announcement)]
      [%cabinet p=cabinet]
      [%skills p=(set listing:skill)]
      [%mcp-tools p=(set listing:tool:mcp)]
      [%mcp-prompts p=(set listing:prompt:mcp)]
      [%mcp-resources p=(set listing:resource:mcp)]
      [%mcp-resource-templates p=(set listing:template:resource:mcp)]
  ==
::
::  state: the ships we seed kademlia with and poll for their
::  shelves. everything heard lives in the content store
+$  versioned-state
  $%  state-0
  ==
::
+$  state-0
  [%0 polled=(set ship)]
::
::  client-to-ship pokes, one mark each
::
::  %chorus-list: add or remove a ship we poll
+$  list-action
  $+  chorus-list
  [?(%add %remove) who=$%([%ship =ship] [%nym =nym])]
::
::  %chorus-publish: list a resource, to everyone or to nobody
+$  publish
  $+  chorus-publish
  [public=? =resource]
::
::  %chorus-retract: take one of our listings back
+$  retract
  $+  chorus-retract
  $%  [%bio ~]
      [%announcement =time]
      [%desk =^desk]
      [%mcp-tool name=@t]
      [%mcp-prompt name=@t]
      [%mcp-resource uri=@t]
      [%mcp-resource-template uri-template=@t]
      [%agent-skill name=@t]
      [%slip =path]
  ==
::
::  %chorus-seek: fetch what a ship published at any topic
+$  seek
  $+  chorus-seek
  [who=ship topic=path]
::
+$  resource
  $+  chorus-resource
  $%  [%bio bio=@t]
      [%announcement announcement=@t]
      [%desk =^desk desc=@t]
      [%mcp-tool =^desk =path]
      [%mcp-prompt =^desk =path]
      [%mcp-resource =^desk =path]
      [%mcp-resource-template =^desk =path]
      [%agent-skill =skill]
      [%slip =path txt=@t]
  ==
::
::  ship-to-client facts
+$  update
  $+  chorus-update
  $%  [%chorus-bio-updated =ship txt=cord]
      [%chorus-announcement =ship =time txt=cord]
      [%chorus-desk-published =ship =^desk =desc:desk hash=@uvI]
      [%mcp-tool-listed =ship =meta:tool:mcp hax=digest]
      [%mcp-prompt-listed =ship =meta:prompt:mcp hax=digest]
      [%mcp-resource-listed =ship =meta:resource:mcp hax=digest]
      [%mcp-resource-template-listed =ship =meta:template:resource:mcp hax=digest]
      [%agent-skill-listed =ship =meta:skill hax=digest]
      [%chorus-slip =path =slip]
      [%chorus-slip-discarded =path]
      ::  our publish at a topic reached its replicas, or failed to
      [%chorus-published topic=path done=?]
  ==
--
