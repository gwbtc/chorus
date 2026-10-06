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
++  fixture-fqsp
  ^-  path
  /~sampel-palnet/g/x/3/chorus//1/chorus/cabinet/notes/foo
::
::  a body of exactly n characters, using a non-ascii
::  character so bytes and characters differ
++  chars
  |=  n=@ud
  ^-  @t
  (rap 3 (reap n 'é'))
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
    (expect-eq !>(~) !>((parse-fqsp:slp /~sampel-palnet/g/x/3/chorus//1/chorus/skills/foo)))
    (expect-eq !>(~) !>((parse-fqsp:slp /~sampel-palnet/g/x/3/chorus//1/chorus/cabinet)))
    (expect-eq !>(~) !>((parse-fqsp:slp /~sampel-palnet/g/x/3/chorus//1/cabinet/foo)))
    (expect-eq !>(~) !>((parse-fqsp:slp /~sampel-palnet/c/x/3/chorus//1/chorus/cabinet/foo)))
    (expect-eq !>(~) !>((parse-fqsp:slp /~sampel-palnet/g/x/3/chorus//2/chorus/cabinet/foo)))
    (expect-eq !>(~) !>((parse-fqsp:slp /~sampel-palnet/g/x/three/chorus//1/chorus/cabinet/foo)))
    (expect-eq !>(~) !>((parse-fqsp:slp /fine/~sampel-palnet/g/x/3/chorus//1/chorus/cabinet/foo)))
    (expect-eq !>(~) !>((parse-fqsp:slp /~sampel-palnet/notes/foo)))
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
      "see [[/~sampel-palnet/g/x/3/chorus//1/chorus/cabinet/notes/foo]] and "
      "[[foo bar]] and [not] and [[/notes/foo]] "
      "and [[/~sampel-palnet/notes/foo]] "
      "and [[/~sampel-palnet/g/x/3/chorus//1/chorus/skills/foo]] "
      "and [[/fine/~sampel-palnet/g/x/3/chorus//1/chorus/cabinet/notes/foo]] "
      "and [[wire://nonsense]]"
    ==
  %+  expect-eq
    !>  ^-  (list @t)
    ~['/~sampel-palnet/g/x/3/chorus//1/chorus/cabinet/notes/foo']
  !>  (links:slp txt)
::
++  test-page-roundtrip
  =/  =slip:chorus  [host ~2026.9.1 fixture-fqsp 'hi']
  =/  page=(cask)  (page-of:slp fixture-path slip)
  =/  =stub:chorus  (stub-of:slp fixture-path slip)
  ;:  weld
    %+  expect-eq  !>(`stub:chorus`[host ~2026.9.1 fixture-fqsp hax.stub])
    !>  stub
    (expect-eq !>(`(unit slip:chorus)``slip) !>((read-page:slp fixture-fqsp page)))
    (expect-eq !>(`(unit slip:chorus)``slip) !>((vet-page:slp fixture-fqsp page)))
  ==
::
++  test-page-rejects
  =/  =slip:chorus  [host ~2026.9.1 fixture-fqsp 'hi']
  =/  html=slip:chorus  slip(txt '<div>hi</div>')
  =/  page=(cask)  (page-of:slp fixture-path slip)
  ;:  weld
    ::  another revision's page, and another host's
    %+  expect-eq  !>(~)
    !>  (read-page:slp (fqsp:slp host 4 fixture-path) page)
    %+  expect-eq  !>(~)
    !>  %+  read-page:slp  (fqsp:slp ~palnet-sampel 3 fixture-path)
        (page-of:slp fixture-path slip(ship ~palnet-sampel))
    ::  the slip sits at another path, the wrong mark, no cabinet
    %+  expect-eq  !>(~)
    !>  (read-page:slp fixture-fqsp (page-of:slp /notes/bar slip))
    (expect-eq !>(~) !>((read-page:slp fixture-fqsp [%noun q.page])))
    (expect-eq !>(~) !>((read-page:slp fixture-fqsp [%chorus-cabinet 'junk'])))
    ::  a page reads whatever its text, and is vetted for it
    %+  expect-eq  !>(`(unit slip:chorus)``html)
    !>  (read-page:slp fixture-fqsp (page-of:slp fixture-path html))
    %+  expect-eq  !>(~)
    !>  (vet-page:slp fixture-fqsp (page-of:slp fixture-path html))
  ==
--
