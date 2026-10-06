::  Slip delivery: a ship hears of a slip at its own cabinet path
::  and fetches its page, the author's newer slip replaces it, and
::  two authors at one path split it on the ship that holds both.
/-  spider
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|%
++  ph-test-message-slip
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  prepare-pair
  ;<  ~  bind:m  (publish-slip ship-a /notes/foo '# foo\0a\0afirst from ship a')
  ;<  ~  bind:m  (expect-update ship-b 0v60)
  ;<  ~  bind:m  (poll ship-b ship-a)
  ;<  ~  bind:m
    %:  await-update
      ship-b  0v60  ship-a
      [%slip /notes/foo '# foo\0a\0afirst from ship a']
    ==
  ;<  ~  bind:m  (publish-slip ship-a /notes/foo '# foo\0a\0asecond from ship a')
  ;<  ~  bind:m  (expect-update ship-b 0v61)
  ;<  ~  bind:m  (poll ship-b ship-a)
  %:  await-update
    ship-b  0v61  ship-a
    [%slip /notes/foo '# foo\0a\0asecond from ship a']
  ==
::
::  both ships keep a slip at /notes/foo. each holds its own there,
::  and the other's under it at a segment naming its author
++  ph-test-message-slip-split
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  prepare-pair
  ;<  ~  bind:m  (publish-slip ship-a /notes/foo 'from ship a')
  ;<  ~  bind:m  (publish-slip ship-b /notes/foo 'from ship b')
  ;<  ~  bind:m  (expect-update ship-a 0v63)
  ;<  ~  bind:m  (poll ship-a ship-b)
  ;<  ~  bind:m
    %:  await-update
      ship-a  0v63  ship-b
      [%slip /notes/foo/(scot %p ship-b) 'from ship b']
    ==
  ;<  ~  bind:m  (probe-want ship-a 0v64 ship-a [%slip /notes/foo 'from ship a'])
  (probe-want ship-b 0v65 ship-b [%slip /notes/foo 'from ship b'])
::
::  a cabinet that breaks the rules is dropped as it comes in,
::  and with it what the poller held from its author
++  ph-test-message-slip-rejected
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  prepare-pair
  ;<  ~  bind:m  (publish-slip ship-a /notes/foo 'from ship a')
  ;<  ~  bind:m  (expect-update ship-b 0v66)
  ;<  ~  bind:m  (poll ship-b ship-a)
  ;<  ~  bind:m
    (await-update ship-b 0v66 ship-a [%slip /notes/foo 'from ship a'])
  ;<  ~  bind:m  (publish-bad-cabinet ship-a)
  ;<  ~  bind:m  (poll ship-b ship-a)
  (await-unheard ship-b ship-a /chorus/cabinet)
--
