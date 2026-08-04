/-  chorus, *wick
/+  *wick
|_  val=skill:chorus
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ::
  ::  json gives the frontmatter fields and the wires for
  ::  every skill file, each of which a client can hand
  ::  back to chorus/fetch-wire
  ++  json
    ^-  ^json
    =*  fm  frontmatter.val
    %-  pairs:enjs:format
    :~  ['name' s+name.fm]
        ['description' s+description.fm]
        :-  'compatibility'
        ?~(compatibility.fm ~ s+u.compatibility.fm)
        ['skill' s+(wick-to-wire body.val)]
        ['references' a+(turn references.val |=(w=wick s+(wick-to-wire w)))]
        ['scripts' a+(turn scripts.val |=(w=wick s+(wick-to-wire w)))]
        ['assets' a+(turn assets.val |=(w=wick s+(wick-to-wire w)))]
    ==
  ::
  ::  mime gives the manifest as a yaml file: the
  ::  frontmatter, and a wire for every skill file
  ++  mime
    ^-  ^mime
    :-  /text/yaml
    %-  as-octs:mimes:html
    =*  fm  frontmatter.val
    %-  of-wain:format
    ;:  welp
      :~  (cat 3 'name: ' name.fm)
          (cat 3 'description: ' description.fm)
      ==
    ::
      ?~  license.fm  ~
      [(cat 3 'license: ' ?@(u.license.fm u.license.fm (crip (spud u.license.fm))))]~
    ::
      ?~  compatibility.fm  ~
      [(cat 3 'compatibility: ' u.compatibility.fm)]~
    ::
      ?~  metadata.fm  ~
      :-  'metadata:'
      %+  turn  ~(tap by u.metadata.fm)
      |=([k=@t v=@t] (rap 3 '  ' k ': ' v ~))
    ::
      ?~  allowed-tools.fm  ~
      [(cat 3 'allowed-tools: ' u.allowed-tools.fm)]~
    ::
      [(cat 3 'skill: ' (wick-to-wire body.val))]~
    ::
      ?:  =(~ references.val)  ~
      :-  'references:'
      %+  turn  references.val
      |=(w=wick (cat 3 '  - ' (wick-to-wire w)))
    ::
      ?:  =(~ scripts.val)  ~
      :-  'scripts:'
      %+  turn  scripts.val
      |=(w=wick (cat 3 '  - ' (wick-to-wire w)))
    ::
      ?:  =(~ assets.val)  ~
      :-  'assets:'
      %+  turn  assets.val
      |=(w=wick (cat 3 '  - ' (wick-to-wire w)))
    ==
  --
++  grab
  |%
  ++  noun  ,skill:chorus
  --
--
