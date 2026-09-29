::
::  slip: pure helpers for cabinet slips, shared by the
::  agent, lib/chorus, the marks and the tests
/-  chorus, mds=markdown
/+  mdl=markdown
|%
::
::  the most characters a slip may hold
++  max-chars  2.048
::
::  the address of a slip: its author, then the path its
::  author keeps it at, e.g. /~zod/notes/foo. slips link to
::  each other by address
++  address
  |=  [host=ship pax=path]
  ^-  path
  [(scot %p host) pax]
::
++  parse-address
  |=  pax=path
  ^-  (unit [host=ship pax=path])
  ?.  ?=([@ ^] pax)  ~
  =/  host=(unit @p)  (slaw %p i.pax)
  ?~  host  ~
  ?^  (vet-path t.pax)  ~
  `[u.host t.pax]
::
::  the path a slip's author keeps it at, given the path it
::  sits at in a merged cabinet; see +shuffle in lib/chorus
++  home
  |=  [pax=path =slip:chorus]
  ^-  path
  ?~  pax  pax
  ?.  =((rear pax) (scot %p ship.slip))
    pax
  (snip `path`pax)
::
::  a cabinet path: non-empty segments of lowercase
::  letters, numbers and hyphens, at most 256 bytes long
++  vet-path
  |=  pax=path
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
  ?.  (lte (met 3 (spat pax)) 256)
    `'path is too long'
  ~
::
::  every [[...]] target in the text that is a slip address
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
    ?=(^ (parse-address u.pax))
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
  |=  [pax=path txt=@t]
  ^-  (unit @t)
  =/  bad  (vet-path pax)
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
::  a slip as json pairs, shared by the slip and cabinet marks
::  and by updates. .pax is where the slip sits in a cabinet
++  slip-pairs
  |=  [pax=path =slip:chorus]
  ^-  (list [@t json])
  :~  ['ship' s+(scot %p ship.slip)]
      ['created' s+(scot %da time.slip)]
      ['address' s+(spat (address ship.slip (home pax slip)))]
      ['links' a+(turn (links txt.slip) |=(l=@t s+l))]
      ['text' s+txt.slip]
  ==
::
++  enjs
  |=  [pax=path =slip:chorus]
  ^-  json
  (pairs:enjs:format (slip-pairs pax slip))
--
