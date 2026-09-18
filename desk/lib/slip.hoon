::
::  slip: pure helpers for cabinet slips, shared by the
::  agent, lib/chorus, the marks and the tests
/-  chorus, *wick, mds=markdown
/+  *wick, mdl=markdown
|%
::
::  the most characters a slip may hold
++  max-chars  2.048
::
::  the fully qualified slip path: the grow path of one
::  revision of a slip, as a peer would request it, e.g.
::  /~zod/g/x/3/chorus//1/cabinet/notes/foo. a wick over
::  it carries the /fine tag in front; see +wick-fqsp
++  fqsp
  |=  [host=ship rev=@ud pax=path]
  ^-  path
  %+  welp
    /(scot %p host)/g/x/(scot %ud rev)/chorus//1/cabinet
  pax
::
++  parse-fqsp
  |=  pax=path
  ^-  (unit [host=ship rev=@ud pax=path])
  ?.  ?=([@ %g %x @ %chorus %$ @ %cabinet ^] pax)
    ~
  =/  segs=path  pax
  ?.  =('1' (snag 6 segs))
    ~
  =/  host=(unit @p)   (slaw %p (snag 0 segs))
  =/  rev=(unit @ud)   (slaw %ud (snag 3 segs))
  ?:  |(?=(~ host) ?=(~ rev))
    ~
  `[u.host u.rev (slag 8 segs)]
::
::  the fqsp a wick signs, if its path is a /fine tag
::  over one
++  wick-fqsp
  |=  pax=path
  ^-  (unit [host=ship rev=@ud pax=path])
  ?.  ?=([%fine ^] pax)  ~
  (parse-fqsp t.pax)
::
::  a cabinet path: non-empty segments of lowercase
::  letters, numbers and hyphens, short enough that a
::  wick over the fqsp fits its 256 bytes for this host
::  at any revision we will ever grow to
++  vet-path
  |=  [host=ship pax=path]
  ^-  (unit @t)
  ?~  pax
    `'path must not be empty'
  ?.  %+  levy  `path`pax
      |=  seg=@ta
      =/  tap=tape  (trip seg)
      ?~  tap  |
      %+  levy  `tape`tap
      |=  c=@t
      ?|  &((gte c 'a') (lte c 'z'))
          &((gte c '0') (lte c '9'))
          =('-' c)
      ==
    `'path segments may only contain lowercase letters, numbers, and hyphens'
  ?.  (lte (met 3 (spat [%fine (fqsp host 999.999.999 pax)])) 256)
    `'path is too long'
  ~
::
::  every [[...]] target in the text that is an fqsp
++  links
  |=  txt=@t
  ^-  (list @t)
  =/  tap=tape  (trip txt)
  =|  out=(list @t)
  |-  ^-  (list @t)
  =/  ope=(unit @ud)  (find "[[" tap)
  ?~  ope
    (flop out)
  =/  rest=tape  (slag (add 2 u.ope) tap)
  =/  clo=(unit @ud)  (find "]]" rest)
  ?~  clo
    (flop out)
  =/  tar=@t  (crip (scag u.clo rest))
  =/  ok=?
    =/  pax=(unit path)  (rush tar stap)
    ?~  pax  |
    ?=(^ (parse-fqsp u.pax))
  %=  $
    tap  (slag (add 2 u.clo) rest)
    out  ?.(ok out [tar out])
  ==
::
::  does a parsed markdown document hold any html,
::  block or inline?
++  has-html
  |=  doc=markdown:mds
  ^-  ?
  %+  lien  doc
  |=  nod=node:markdown:mds
  ?~  nod  |
  ?-    -.nod
      %leaf
    ?~  +.nod  |
    ?-  -.+.nod
      %html                 &
      %heading              (inline-html contents.+.nod)
      %paragraph            (inline-html contents.+.nod)
      %table                ?|  (lien head.+.nod inline-html)
                                %+  lien  rows.+.nod
                                |=  r=(list contents:inline:mds)
                                (lien r inline-html)
                            ==
      %break                |
      %indent-codeblock     |
      %fenced-codeblock     |
      %link-ref-definition  |
      %blank-line           |
    ==
  ::
      %container
    ?~  +.nod  |
    ?-  -.+.nod
      %block-quote  ^$(doc markdown.+.nod)
      %ol           (lien contents.+.nod |=(m=markdown:mds ^^$(doc m)))
      %ul           (lien contents.+.nod |=(m=markdown:mds ^^$(doc m)))
      %tl           (lien contents.+.nod |=([? m=markdown:mds] ^^$(doc m)))
    ==
  ==
::
++  inline-html
  |=  con=contents:inline:mds
  ^-  ?
  %+  lien  con
  |=  ele=element:inline:mds
  ?~  ele  |
  ?+  -.ele  |
    %html        &
    %emphasis    ^$(con contents.ele)
    %strong      ^$(con contents.ele)
    %strikethru  ^$(con contents.ele)
    %link        ^$(con contents.ele)
    %image       ^$(con contents.ele)
  ==
::
::  check a slip before it goes in the cabinet: its path,
::  its size, that it parses as markdown, and that it
::  carries no html
++  vet-slip
  |=  [host=ship pax=path txt=@t]
  ^-  (unit @t)
  =/  bad  (vet-path host pax)
  ?^  bad  bad
  =/  len  (lent (tuba (trip txt)))
  ?:  =(0 len)
    `'slip must not be empty'
  ?:  (gth len max-chars)
    `'slip must be 2048 characters or fewer'
  =/  doc=(unit markdown:mds)  (de:mdl txt)
  ?~  doc
    `'slip failed to parse as markdown'
  ?:  (has-html u.doc)
    `'slip must not contain html'
  ~
::
::  a slip as json, shared by the slip, cabinet and
::  update marks
++  enjs
  |=  [=slip:chorus =wick]
  ^-  json
  %-  pairs:enjs:format
  :~  ['author' s+(scot %p ship.slip)]
      ['created' s+(scot %da time.slip)]
      ['fqsp' s+(spat (slag 1 `path`path.wick))]
      ['wire' s+(wick-to-wire wick)]
      ['links' a+(turn (links txt.slip) |=(l=@t s+l))]
      ['text' s+txt.slip]
  ==
--
