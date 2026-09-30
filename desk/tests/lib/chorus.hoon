/-  chorus
/+  *test, cho=chorus, slp=slip
=>
|%
++  our  ~zod
++  sam  ~sampel-palnet
++  pal  ~palnet-sampel
++  wen  ~2026.9.1
::
::  a slip whose fqsp names /notes/foo
++  slip
  |=  [who=ship txt=@t]
  ^-  slip:chorus
  [who wen (fqsp:slp who 1 /notes/foo) txt]
::
++  cab
  |=  slips=(list [path slip:chorus])
  ^-  cabinet:chorus
  (~(gas of *cabinet:chorus) slips)
::
++  tool
  |=  [who=ship name=@t desc=@t]
  ^-  listing:tool:mcp:chorus
  [who [name desc ~ ~] 0v1]
--
|%
++  test-topics-roundtrip
  %+  expect-eq
    !>  (turn topics:cho |=(=topic:chorus `(unit topic:chorus)``topic))
  !>  (turn topics:cho |=(=topic:chorus (path-topic:cho (topic-path:cho topic))))
::
++  test-path-topic-rejects
  ;:  weld
    (expect-eq !>(~) !>((path-topic:cho /chorus)))
    (expect-eq !>(~) !>((path-topic:cho /chorus/links)))
    (expect-eq !>(~) !>((path-topic:cho /rolodex)))
  ==
::
++  test-stock-replaces-the-same-thing
  =/  one=shelf:chorus
    (stock:cho (bare:cho %mcp-tools) [%mcp-tools (tool our 'a' 'first')])
  =/  two=shelf:chorus
    (stock:cho one [%mcp-tools (tool our 'a' 'second')])
  =/  six=shelf:chorus
    (stock:cho two [%mcp-tools (tool our 'b' 'other')])
  ;:  weld
    (expect-eq !>(1) !>((count:cho two)))
    (expect-eq !>(2) !>((count:cho six)))
    %+  expect-eq
      !>  `shelf:chorus`[%mcp-tools (sy (tool our 'a' 'second') ~)]
    !>  two
  ==
::
++  test-stock-keeps-one-bio
  =/  one=shelf:chorus
    (stock:cho (bare:cho %rolodex) [%rolodex our 'first'])
  %+  expect-eq
    !>  `shelf:chorus`[%rolodex (sy [our 'second'] ~)]
  !>  (stock:cho one [%rolodex our 'second'])
::
++  test-strip
  =/  full=shelf:chorus
    [%cabinet (cab ~[[/a (slip our 'a')] [/b/c (slip our 'c')]])]
  ;:  weld
    %+  expect-eq
      !>  `shelf:chorus`[%cabinet (cab ~[[/a (slip our 'a')]])]
    !>  (strip:cho full [%slip /b/c])
    (expect-eq !>(full) !>((strip:cho full [%slip /nope])))
  ==
::
++  test-vet-shelf-types-and-owners
  =/  good=(set listing:bio:chorus)  (sy [sam 'hello'] ~)
  =/  long=(set listing:bio:chorus)  (sy [sam (crip (reap 257 'a'))] ~)
  =/  many=(set listing:bio:chorus)  (sy [sam 'a'] [sam 'b'] ~)
  ;:  weld
    %+  expect-eq
      !>  `(unit shelf:chorus)``[%rolodex good]
    !>  (vet-shelf:cho sam %rolodex %chorus-rolodex good)
    ::  another ship's listing
    (expect-eq !>(~) !>((vet-shelf:cho pal %rolodex %chorus-rolodex good)))
    ::  the wrong mark
    (expect-eq !>(~) !>((vet-shelf:cho sam %rolodex %chorus-desks good)))
    ::  the wrong topic for the noun
    (expect-eq !>(~) !>((vet-shelf:cho sam %cabinet %chorus-cabinet good)))
    ::  not a shelf at all
    (expect-eq !>(~) !>((vet-shelf:cho sam %rolodex %chorus-rolodex 'junk')))
    (expect-eq !>(~) !>((vet-shelf:cho sam %rolodex %chorus-rolodex long)))
    (expect-eq !>(~) !>((vet-shelf:cho sam %rolodex %chorus-rolodex many)))
  ==
::
++  test-vet-shelf-cabinet
  =/  good=cabinet:chorus  (cab ~[[/notes/foo (slip sam 'hi')]])
  =/  fake=cabinet:chorus  (cab ~[[/notes/foo (slip pal 'hi')]])
  =/  html=cabinet:chorus  (cab ~[[/notes/foo (slip sam '<div>hi</div>')]])
  =/  path=cabinet:chorus  (cab ~[[/notes/'Foo' (slip sam 'hi')]])
  ::  an fqsp that names another path, and one that names
  ::  another host
  =/  away=cabinet:chorus  (cab ~[[/notes/bar (slip sam 'hi')]])
  =/  host=cabinet:chorus
    (cab ~[[/notes/foo [sam wen (fqsp:slp pal 1 /notes/foo) 'hi']]])
  ;:  weld
    %+  expect-eq
      !>  `(unit shelf:chorus)``[%cabinet good]
    !>  (vet-shelf:cho sam %cabinet %chorus-cabinet good)
    (expect-eq !>(~) !>((vet-shelf:cho sam %cabinet %chorus-cabinet fake)))
    (expect-eq !>(~) !>((vet-shelf:cho sam %cabinet %chorus-cabinet html)))
    (expect-eq !>(~) !>((vet-shelf:cho sam %cabinet %chorus-cabinet path)))
    (expect-eq !>(~) !>((vet-shelf:cho sam %cabinet %chorus-cabinet away)))
    (expect-eq !>(~) !>((vet-shelf:cho sam %cabinet %chorus-cabinet host)))
  ==
::
++  test-blend-joins-sets
  =/  all=(list [ship shelf:chorus])
    :~  [our %mcp-tools (sy (tool our 'a' 'ours') ~)]
        [sam %mcp-tools (sy (tool sam 'a' 'theirs') ~)]
    ==
  %+  expect-eq
    !>  ^-  shelf:chorus
    [%mcp-tools (sy (tool our 'a' 'ours') (tool sam 'a' 'theirs') ~)]
  !>  (blend:cho our %mcp-tools all)
::
++  test-shuffle-splits-shared-paths
  =/  all=(list [ship cabinet:chorus])
    :~  [our (cab ~[[/a (slip our 'ours')] [/b (slip our 'b')]])]
        [sam (cab ~[[/a (slip sam 'sam')] [/c (slip sam 'c')] [/d (slip sam 'd')]])]
        [pal (cab ~[[/a (slip pal 'pal')] [/d (slip pal 'd')]])]
    ==
  ;:  weld
    %+  expect-eq
      !>  %-  cab
          :~  [/a (slip our 'ours')]
              [/a/~sampel-palnet (slip sam 'sam')]
              [/a/~palnet-sampel (slip pal 'pal')]
              [/b (slip our 'b')]
              [/c (slip sam 'c')]
              [/d/~sampel-palnet (slip sam 'd')]
              [/d/~palnet-sampel (slip pal 'd')]
          ==
    !>  (shuffle:cho our all)
    (expect-eq !>(`path`/a) !>((spot:cho our all our /a)))
    (expect-eq !>(`path`/a/~sampel-palnet) !>((spot:cho our all sam /a)))
    (expect-eq !>(`path`/c) !>((spot:cho our all sam /c)))
  ==
::
++  test-updates-of-cabinet
  =/  old=shelf:chorus
    [%cabinet (cab ~[[/a (slip sam 'a')] [/b (slip sam 'b')] [/c (slip sam 'c')]])]
  =/  new=shelf:chorus
    [%cabinet (cab ~[[/a (slip sam 'a')] [/b (slip sam 'new')] [/d (slip sam 'd')]])]
  %+  expect-eq
    !>  ^-  (set update:chorus)
    %-  sy
    :~  [%chorus-slip-discarded /c]
        [%chorus-slip /b (slip sam 'new')]
        [%chorus-slip /d (slip sam 'd')]
    ==
  !>  (sy (updates-of:cho old new))
::
++  test-updates-of-set
  =/  old=shelf:chorus  [%mcp-tools (sy (tool sam 'a' 'a') ~)]
  =/  new=shelf:chorus
    [%mcp-tools (sy (tool sam 'a' 'a') (tool sam 'b' 'b') ~)]
  %+  expect-eq
    !>  `(list update:chorus)`[%mcp-tool-listed (tool sam 'b' 'b')]~
  !>  (updates-of:cho old new)
--
