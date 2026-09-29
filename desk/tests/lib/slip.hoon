/-  chorus
/+  *test, slp=slip
=>
|%
++  host  ~sampel-palnet
::
++  fixture-path
  ^-  path
  /notes/foo
::
++  fixture-address
  ^-  path
  /~sampel-palnet/notes/foo
::
::  a body of exactly n characters, using a non-ascii
::  character so bytes and characters differ
++  chars
  |=  n=@ud
  ^-  @t
  (rap 3 (reap n 'é'))
--
|%
++  test-address-roundtrip
  %+  expect-eq
    !>  `[host=ship pax=path]`[host fixture-path]
  !>  (need (parse-address:slp (address:slp host fixture-path)))
::
++  test-address-literal
  %+  expect-eq
    !>  fixture-address
  !>  (address:slp host fixture-path)
::
++  test-parse-address-rejects
  ;:  weld
    (expect-eq !>(~) !>((parse-address:slp /notes/foo)))
    (expect-eq !>(~) !>((parse-address:slp /~sampel-palnet)))
    (expect-eq !>(~) !>((parse-address:slp /~sampel-palnet/notes/'Foo')))
    (expect-eq !>(~) !>((parse-address:slp /~sampel-palnet/g/x/3/chorus//1/cabinet/foo)))
  ==
::
++  test-home
  =/  =slip:chorus  [host ~2026.9.1 'hi']
  ;:  weld
    (expect-eq !>(`path`/notes/foo) !>((home:slp /notes/foo slip)))
    (expect-eq !>(`path`/notes/foo) !>((home:slp /notes/foo/~sampel-palnet slip)))
    (expect-eq !>(`path`/notes/foo/~zod) !>((home:slp /notes/foo/~zod slip)))
  ==
::
++  test-vet-path-ok
  %+  expect-eq
    !>  ~
  !>  (vet-path:slp /notes/foo-bar-2026)
::
++  test-vet-path-charset
  ;:  weld
    (expect-eq !>(&) !>(?=(^ (vet-path:slp `path`~['notes' 'Foo']))))
    (expect-eq !>(&) !>(?=(^ (vet-path:slp `path`~['notes' 'foo.bar']))))
    (expect-eq !>(&) !>(?=(^ (vet-path:slp `path`~['~sampel' 'foo']))))
    (expect-eq !>(&) !>(?=(^ (vet-path:slp `path`~['notes' '' 'foo']))))
    (expect-eq !>(&) !>(?=(^ (vet-path:slp ~))))
  ==
::
++  test-vet-path-length
  =/  seg=@ta  (crip (reap 100 'a'))
  ;:  weld
    (expect-eq !>(~) !>((vet-path:slp /[seg]/[seg])))
    (expect-eq !>(&) !>(?=(^ (vet-path:slp /[seg]/[seg]/[seg]))))
  ==
::
++  test-vet-slip-size
  ;:  weld
    (expect-eq !>(~) !>((vet-slip:slp fixture-path (chars 2.048))))
    (expect-eq !>(`'slip must be 2048 characters or fewer') !>((vet-slip:slp fixture-path (chars 2.049))))
    (expect-eq !>(`'slip must not be empty') !>((vet-slip:slp fixture-path '')))
  ==
::
++  test-vet-slip-html
  ;:  weld
    (expect-eq !>(`'slip must not contain html') !>((vet-slip:slp fixture-path '<div>hi</div>')))
    (expect-eq !>(`'slip must not contain html') !>((vet-slip:slp fixture-path 'some <b>bold</b> text')))
    (expect-eq !>(`'slip must not contain html') !>((vet-slip:slp fixture-path '- item <i>x</i>')))
    (expect-eq !>(~) !>((vet-slip:slp fixture-path '# hi\0a\0asome *bold* text')))
  ==
::
++  test-links
  =/  txt=@t
    %-  crip
    ;:  welp
      "see [[/~sampel-palnet/notes/foo]] and "
      "[[foo bar]] and [not] and [[/notes/foo]] "
      "and [[/~sampel-palnet/g/x/3/chorus//1/cabinet/notes/foo]] "
      "and [[wire://nonsense]]"
    ==
  %+  expect-eq
    !>  ^-  (list @t)
    ~['/~sampel-palnet/notes/foo']
  !>  (links:slp txt)
--
