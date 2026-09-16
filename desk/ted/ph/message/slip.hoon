::  Slip delivery over %chorus-message: a heard slip lands at its
::  own cabinet path, the author's newer revision replaces it, and
::  two authors at one path split it on the ship that holds both.
/-  spider
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|%
++  ph-test-message-slip
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (prepare-pair %message-slip)
  ;<  ~  bind:m  (expect-bulla ship-b 0v60)
  ;<  ~  bind:m  (publish-slip ship-a /notes/foo '# foo\0a\0afirst from ship a')
  ;<  ~  bind:m  (await-bulla ship-b 0v60 ship-a [%slip /notes/foo '# foo\0a\0afirst from ship a'])
  ;<  ~  bind:m  (expect-bulla ship-b 0v61)
  ;<  ~  bind:m  (publish-slip ship-a /notes/foo '# foo\0a\0asecond from ship a')
  (await-bulla ship-b 0v61 ship-a [%slip /notes/foo '# foo\0a\0asecond from ship a'])
::
::  ship-b hears ship-a's slip at /notes/foo, then publishes its own
::  there: on ship-b its own slip overwrites the heard one, and on
::  ship-a the heard slip lands under its author at /notes/foo/~b
++  ph-test-message-slip-split
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (prepare-pair %message-slip-split)
  ;<  ~  bind:m  (expect-bulla ship-b 0v62)
  ;<  ~  bind:m  (publish-slip ship-a /notes/foo 'from ship a')
  ;<  ~  bind:m  (await-bulla ship-b 0v62 ship-a [%slip /notes/foo 'from ship a'])
  ;<  ~  bind:m  (expect-bulla ship-a 0v63)
  ;<  ~  bind:m  (publish-slip ship-b /notes/foo 'from ship b')
  ;<  ~  bind:m  (await-bulla ship-a 0v63 ship-b [%slip /notes/foo/(scot %p ship-b) 'from ship b'])
  ;<  ~  bind:m  (probe-want ship-a 0v64 ship-a [%slip /notes/foo 'from ship a'])
  (probe-want ship-b 0v65 ship-b [%slip /notes/foo 'from ship b'])
--
