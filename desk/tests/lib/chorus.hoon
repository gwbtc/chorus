/-  chorus, *wick
/+  *test, *wick, cho=chorus, slp=slip
=>
|%
++  our  ~zod
++  sam  ~sampel
++  pal  ~palnet
::
::  a bulla as +hear sees it after the agent has checked
::  its signatures: the wick is unsigned, which +hear
::  does not mind
++  bulla
  |=  [who=ship rev=@ud pax=path txt=@t]
  ^-  bulla:chorus
  =/  =wick  [%7 ['..foo' who] 1 | [%fine (fqsp:slp who rev pax)] 0x0]
  [%chorus-bulla who 0x1 [%chorus-slip [who ~2026.1.1 txt] wick]]
::
++  hear
  |=  [sat=state-0:chorus b=bulla:chorus]
  (hear:cho sat our ~2026.1.2 b)
::
++  paths
  |=  sat=state-0:chorus
  ^-  (list path)
  (sort (turn ~(tap of cabinet.sat) |=([p=path *] p)) aor)
::
++  text-at
  |=  [sat=state-0:chorus pax=path]
  ^-  (unit @t)
  (bind (~(get of cabinet.sat) pax) |=([s=slip:chorus *] txt.s))
--
|%
::
::  one author alone keeps the bare path, and only a
::  newer revision of their own replaces it
++  test-hear-same-author
  =/  sat  (hear *state-0:chorus (bulla sam 1 /foo/bar 'one'))
  =.  sat  (hear sat (bulla sam 3 /foo/bar 'three'))
  =.  sat  (hear sat (bulla sam 2 /foo/bar 'two'))
  ;:  weld
    (expect-eq !>(~[/foo/bar]) !>((paths sat)))
    (expect-eq !>(`'three') !>((text-at sat /foo/bar)))
    (expect-eq !>(1) !>(~(wyt by sigs.sat)))
  ==
::
::  a second heard author at the same path splits it
++  test-hear-split
  =/  sat  (hear *state-0:chorus (bulla sam 1 /foo/bar 'sampel'))
  =.  sat  (hear sat (bulla pal 1 /foo/bar 'palnet'))
  =.  sat  (hear sat (bulla sam 2 /foo/bar 'sampel two'))
  =.  sat  (hear sat (bulla ~marzod 1 /foo/bar 'marzod'))
  ;:  weld
    %+  expect-eq
      !>  ~[/foo/bar/~marzod /foo/bar/~palnet /foo/bar/~sampel]
    !>  (paths sat)
    (expect-eq !>(`'sampel two') !>((text-at sat /foo/bar/~sampel)))
    (expect-eq !>(`'palnet') !>((text-at sat /foo/bar/~palnet)))
    (expect-eq !>(3) !>(~(wyt by sigs.sat)))
  ==
::
::  our own slip at a path stays put; a heard one there
::  lands under its author
++  test-hear-ours-stays
  =/  sat  *state-0:chorus
  =/  ours=[slip:chorus wick]
    :-  [our ~2026.1.1 'ours']
    [%7 ['..foo' our] 1 | [%fine (fqsp:slp our 1 /foo/bar)] 0x0]
  =.  cabinet.sat  (~(put of cabinet.sat) /foo/bar ours)
  =.  sat  (hear sat (bulla sam 1 /foo/bar 'sampel'))
  ;:  weld
    (expect-eq !>(~[/foo/bar /foo/bar/~sampel]) !>((paths sat)))
    (expect-eq !>(`'ours') !>((text-at sat /foo/bar)))
  ==
::
++  test-slip-path
  =/  sat  (hear *state-0:chorus (bulla sam 1 /foo/bar 'sampel'))
  =.  sat  (hear sat (bulla pal 1 /foo/bar 'palnet'))
  %+  expect-eq
    !>  `/foo/bar/~palnet
  !>  (slip-path:cho sat wick.msg:(bulla pal 1 /foo/bar 'palnet'))
--
