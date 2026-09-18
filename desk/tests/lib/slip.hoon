/-  chorus, *wick
/+  *test, *wick, slp=slip
=>
|%
++  host  ~sampel-palnet
::
++  fixture-path
  ^-  path
  /notes/foo
::
++  fixture-fqsp
  ^-  path
  /~sampel-palnet/g/x/3/chorus//1/cabinet/notes/foo
::
::  a body of exactly n characters, using a non-ascii
::  character so bytes and characters differ
++  chars
  |=  n=@ud
  ^-  @t
  (rap 3 (reap n 'é'))
::
::  an unsigned wire over the fixture fqsp, under the same
::  nym the wick tests use; links must skip it
++  fixture-wire
  ^-  @t
  =/  =nym
    '..obstruct.adapts.galore.unite.despite.descale.behold.forego.remakes.devoid.refute.comprise'
  (wick-to-wire [%7 [nym host] 1 & [%fine fixture-fqsp] 0x0])
--
|%
++  test-fqsp-roundtrip
  %+  expect-eq
    !>  `[host=ship rev=@ud pax=path]`[host 3 fixture-path]
  !>  (need (parse-fqsp:slp (fqsp:slp host 3 fixture-path)))
::
++  test-fqsp-literal
  %+  expect-eq
    !>  fixture-fqsp
  !>  (fqsp:slp host 3 fixture-path)
::
++  test-parse-fqsp-rejects
  ;:  weld
    (expect-eq !>(~) !>((parse-fqsp:slp /~sampel-palnet/g/x/3/chorus//1/skills/foo)))
    (expect-eq !>(~) !>((parse-fqsp:slp /~sampel-palnet/g/x/3/chorus//1/cabinet)))
    (expect-eq !>(~) !>((parse-fqsp:slp /~sampel-palnet/c/x/3/chorus//1/cabinet/foo)))
    (expect-eq !>(~) !>((parse-fqsp:slp /~sampel-palnet/g/x/3/chorus//2/cabinet/foo)))
    (expect-eq !>(~) !>((parse-fqsp:slp /fine/~sampel-palnet/g/x/3/chorus//1/cabinet/foo)))
    (expect-eq !>(~) !>((wick-fqsp:slp /~sampel-palnet/g/x/3/chorus//1/cabinet/foo)))
    (expect-eq !>(`[host 3 /foo]) !>((wick-fqsp:slp /fine/~sampel-palnet/g/x/3/chorus//1/cabinet/foo)))
  ==
::
++  test-vet-path-ok
  %+  expect-eq
    !>  ~
  !>  (vet-path:slp host /notes/foo-bar-2026)
::
++  test-vet-path-charset
  ;:  weld
    (expect-eq !>(&) !>(?=(^ (vet-path:slp host `path`~['notes' 'Foo']))))
    (expect-eq !>(&) !>(?=(^ (vet-path:slp host `path`~['notes' 'foo.bar']))))
    (expect-eq !>(&) !>(?=(^ (vet-path:slp host `path`~['~sampel' 'foo']))))
    (expect-eq !>(&) !>(?=(^ (vet-path:slp host `path`~['notes' '' 'foo']))))
    (expect-eq !>(&) !>(?=(^ (vet-path:slp host ~))))
  ==
::
++  test-vet-path-length
  =/  seg=@ta  (crip (reap 100 'a'))
  ;:  weld
    (expect-eq !>(~) !>((vet-path:slp host /[seg]/[seg])))
    (expect-eq !>(&) !>(?=(^ (vet-path:slp host /[seg]/[seg]/[seg]))))
  ==
::
++  test-vet-slip-size
  ;:  weld
    (expect-eq !>(~) !>((vet-slip:slp host fixture-path (chars 2.048))))
    (expect-eq !>(`'slip must be 2048 characters or fewer') !>((vet-slip:slp host fixture-path (chars 2.049))))
    (expect-eq !>(`'slip must not be empty') !>((vet-slip:slp host fixture-path '')))
  ==
::
++  test-vet-slip-html
  ;:  weld
    (expect-eq !>(`'slip must not contain html') !>((vet-slip:slp host fixture-path '<div>hi</div>')))
    (expect-eq !>(`'slip must not contain html') !>((vet-slip:slp host fixture-path 'some <b>bold</b> text')))
    (expect-eq !>(`'slip must not contain html') !>((vet-slip:slp host fixture-path '- item <i>x</i>')))
    (expect-eq !>(~) !>((vet-slip:slp host fixture-path '# hi\0a\0asome *bold* text')))
  ==
::
++  test-links
  =/  txt=@t
    %-  crip
    ;:  welp
      "see [[/~sampel-palnet/g/x/3/chorus//1/cabinet/notes/foo]] and "
      "[[foo bar]] and [not] and [[/~sampel-palnet/g/x/1/chorus//1/skills/foo]] "
      "and [[/fine/~sampel-palnet/g/x/3/chorus//1/cabinet/notes/foo]] "
      "and [[{(trip fixture-wire)}]] and [[wire://nonsense]]"
    ==
  %+  expect-eq
    !>  ^-  (list @t)
    ~['/~sampel-palnet/g/x/3/chorus//1/cabinet/notes/foo']
  !>  (links:slp txt)
--
