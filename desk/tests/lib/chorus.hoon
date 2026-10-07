/-  chorus
/+  *test, cho=chorus, slp=slip
=>
|%
++  our  ~zod
++  sam  ~sampel-palnet
++  pal  ~palnet-sampel
++  wen  ~2026.9.1
::
::  the nym we credit ~sampel-palnet with
++  nym  '..sampel.palnet'
::
::  a slip whose fqsp names /notes/foo
++  slip
  |=  [who=ship txt=@t]
  ^-  slip:chorus
  [who wen (fqsp:slp who 1 /notes/foo) txt]
::
::  what its author lists of that slip
++  stub
  |=  [who=ship txt=@t]
  ^-  stub:chorus
  (stub-of:slp /notes/foo (slip who txt))
::
++  dex
  |=  stubs=(list [path stub:chorus])
  ^-  index:chorus
  (~(gas of *index:chorus) stubs)
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
    [%cabinet (dex ~[[/a (stub our 'a')] [/b/c (stub our 'c')]])]
  ;:  weld
    %+  expect-eq
      !>  `shelf:chorus`[%cabinet (dex ~[[/a (stub our 'a')]])]
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
    (expect-eq !>(~) !>((vet-shelf:cho sam %cabinet %chorus-index good)))
    ::  not a shelf at all
    (expect-eq !>(~) !>((vet-shelf:cho sam %rolodex %chorus-rolodex 'junk')))
    (expect-eq !>(~) !>((vet-shelf:cho sam %rolodex %chorus-rolodex long)))
    (expect-eq !>(~) !>((vet-shelf:cho sam %rolodex %chorus-rolodex many)))
  ==
::
++  test-vet-shelf-cabinet
  =/  good=index:chorus  (dex ~[[/notes/foo (stub sam 'hi')]])
  =/  fake=index:chorus  (dex ~[[/notes/foo (stub pal 'hi')]])
  =/  path=index:chorus  (dex ~[[/notes/'Foo' (stub sam 'hi')]])
  ::  an fqsp that names another path, and one that names
  ::  another host
  =/  away=index:chorus  (dex ~[[/notes/bar (stub sam 'hi')]])
  =/  host=index:chorus
    (dex ~[[/notes/foo [sam wen (fqsp:slp pal 1 /notes/foo) 0v1]]])
  ;:  weld
    %+  expect-eq
      !>  `(unit shelf:chorus)``[%cabinet good]
    !>  (vet-shelf:cho sam %cabinet %chorus-index good)
    (expect-eq !>(~) !>((vet-shelf:cho sam %cabinet %chorus-index fake)))
    (expect-eq !>(~) !>((vet-shelf:cho sam %cabinet %chorus-index path)))
    (expect-eq !>(~) !>((vet-shelf:cho sam %cabinet %chorus-index away)))
    (expect-eq !>(~) !>((vet-shelf:cho sam %cabinet %chorus-index host)))
    ::  a shelf of whole slips, as ships published before slips
    ::  left the shelf: its mark is a page's
    %+  expect-eq  !>(~)
    !>  %:  vet-shelf:cho  sam  %cabinet  %chorus-cabinet
            (~(put of *cabinet:chorus) /notes/foo (slip sam 'hi'))
        ==
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
  =/  all=(list [ship index:chorus])
    :~  [our (dex ~[[/a (stub our 'ours')] [/b (stub our 'b')]])]
        [sam (dex ~[[/a (stub sam 'sam')] [/c (stub sam 'c')] [/d (stub sam 'd')]])]
        [pal (dex ~[[/a (stub pal 'pal')] [/d (stub pal 'd')]])]
    ==
  ;:  weld
    %+  expect-eq
      !>  %-  dex
          :~  [/a (stub our 'ours')]
              [/a/~sampel-palnet (stub sam 'sam')]
              [/a/~palnet-sampel (stub pal 'pal')]
              [/b (stub our 'b')]
              [/c (stub sam 'c')]
              [/d/~sampel-palnet (stub sam 'd')]
              [/d/~palnet-sampel (stub pal 'd')]
          ==
    !>  (shuffle:cho our all)
    (expect-eq !>(`path`/a) !>((spot:cho our all our /a)))
    (expect-eq !>(`path`/a/~sampel-palnet) !>((spot:cho our all sam /a)))
    (expect-eq !>(`path`/c) !>((spot:cho our all sam /c)))
  ==
::
++  test-updates-of-cabinet
  =/  old=shelf:chorus
    [%cabinet (dex ~[[/a (stub sam 'a')] [/b (stub sam 'b')] [/c (stub sam 'c')]])]
  =/  new=shelf:chorus
    [%cabinet (dex ~[[/a (stub sam 'a')] [/b (stub sam 'new')] [/d (stub sam 'd')]])]
  %+  expect-eq
    !>  ^-  (set update:chorus)
    %-  sy
    :~  [%chorus-slip-discarded /c]
        [%chorus-slip-listed /b nym (stub sam 'new')]
        [%chorus-slip-listed /d nym (stub sam 'd')]
    ==
  !>  (sy (updates-of:cho nym old new))
::
++  test-updates-of-set
  =/  old=shelf:chorus  [%mcp-tools (sy (tool sam 'a' 'a') ~)]
  =/  new=shelf:chorus
    [%mcp-tools (sy (tool sam 'a' 'a') (tool sam 'b' 'b') ~)]
  %+  expect-eq
    !>  `(list update:chorus)`[%mcp-tool-listed nym +:(tool sam 'b' 'b')]~
  !>  (updates-of:cho nym old new)
--
