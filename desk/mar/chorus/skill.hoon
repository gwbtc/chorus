/-  chorus, *content-routing
|_  val=skill:chorus
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ::
  ::  json gives the frontmatter fields and the digest of
  ::  every skill file
  ++  json
    ^-  ^json
    =*  fm  frontmatter.val
    %-  pairs:enjs:format
    :~  ['name' s+name.fm]
        ['description' s+description.fm]
        :-  'compatibility'
        ?~(compatibility.fm ~ s+u.compatibility.fm)
        ['skill' s+(scot %uv body.val)]
        ['references' a+(turn references.val |=(d=digest s+(scot %uv d)))]
        ['scripts' a+(turn scripts.val |=(d=digest s+(scot %uv d)))]
        ['assets' a+(turn assets.val |=(d=digest s+(scot %uv d)))]
    ==
  ::
  ::  mime gives the manifest as a yaml file: the
  ::  frontmatter, and a digest for every skill file
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
      [(cat 3 'skill: ' (scot %uv body.val))]~
    ::
      ?:  =(~ references.val)  ~
      :-  'references:'
      %+  turn  references.val
      |=(d=digest (cat 3 '  - ' (scot %uv d)))
    ::
      ?:  =(~ scripts.val)  ~
      :-  'scripts:'
      %+  turn  scripts.val
      |=(d=digest (cat 3 '  - ' (scot %uv d)))
    ::
      ?:  =(~ assets.val)  ~
      :-  'assets:'
      %+  turn  assets.val
      |=(d=digest (cat 3 '  - ' (scot %uv d)))
    ==
  --
++  grab
  |%
  ++  noun  ,skill:chorus
  --
--
