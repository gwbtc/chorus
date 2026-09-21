::
::  a slip and the wick that signed it, with renderers
::  for the formats a client might want it in
/-  chorus, *wick, mds=markdown
/+  *wick, mdl=markdown, slp=slip
=>
|%
::
::  render inline elements as plain text, or as udon
++  inline
  |=  [udon=? con=contents:inline:mds]
  ^-  tape
  %-  zing
  %+  turn  con
  |=  ele=element:inline:mds
  ^-  tape
  ?~  ele  ""
  ?-    -.ele
      %escape           (trip char.ele)
      %entity           (trip code.ele)
      %code-span        ?.(udon (trip text.ele) "`{(trip text.ele)}`")
      %line-break       " "
      %soft-line-break  " "
      %text             (trip text.ele)
      %emphasis         ?.(udon (inline udon contents.ele) "_{(inline udon contents.ele)}_")
      %strong           ?.(udon (inline udon contents.ele) "*{(inline udon contents.ele)}*")
      %strikethru       (inline udon contents.ele)
      %image            (inline udon contents.ele)
      %autolink         (trip text.target.ele)
      %task-checkbox    ?:(is-checked.ele "[x] " "[ ] ")
      %html             (trip text.ele)
      %link
    =/  txt  (inline udon contents.ele)
    ?.  &(udon ?=(%direct -.target.ele))
      txt
    "[{txt}]({(trip text.url.urlt.target.ele)})"
  ==
::
::  render a document as lines of plain text, or of udon
++  blocks
  |=  [udon=? doc=markdown:mds]
  ^-  (list tape)
  %-  zing
  %+  turn  doc
  |=  nod=node:markdown:mds
  ^-  (list tape)
  ?~  nod  ~
  ?-    -.nod
      %leaf
    ?~  +.nod  ~
    ?-    -.+.nod
        %heading
      =/  txt=tape  (inline udon contents.+.nod)
      ^-  (list tape)
      :_  [""]~
      ?.  udon  txt
      ^-  tape
      (weld `tape`(zing (reap level.+.nod "#")) `tape`[' ' txt])
    ::
        %break
      ?.(udon [""]~ ~["---" ""])
    ::
        %indent-codeblock
      =/  lines  (turn (to-wain:format text.+.nod) trip)
      ?.  udon  (snoc lines "")
      :(welp ["```"]~ lines ~["```" ""])
    ::
        %fenced-codeblock
      =/  lines  (turn (to-wain:format text.+.nod) trip)
      ?.  udon  (snoc lines "")
      :(welp ["```"]~ lines ~["```" ""])
    ::
        %html
      (snoc (turn (to-wain:format text.+.nod) trip) "")
    ::
        %link-ref-definition
      ~
    ::
        %paragraph
      ~[(inline udon contents.+.nod) ""]
    ::
        %blank-line
      ~
    ::
    ::  tables flatten to one row per line
        %table
      %-  snoc
      :_  ""
      :-  (row udon head.+.nod)
      (turn rows.+.nod |=(r=(list contents:inline:mds) (row udon r)))
    ==
  ::
      %container
    ?~  +.nod  ~
    ?-    -.+.nod
        %block-quote
      %-  snoc
      :_  ""
      %+  turn  (trim (blocks udon markdown.+.nod))
      |=(l=tape ?.(udon l (welp "> " l)))
    ::
        %ol
      %-  snoc
      :_  ""
      =/  n  start-num.+.nod
      =/  items  contents.+.nod
      |-  ^-  (list tape)
      ?~  items  ~
      %+  welp
        (item "{<n>}. " (trim (blocks udon i.items)))
      $(n +(n), items t.items)
    ::
        %ul
      %-  snoc
      :_  ""
      =/  items  contents.+.nod
      |-  ^-  (list tape)
      ?~  items  ~
      %+  welp
        (item "- " (trim (blocks udon i.items)))
      $(items t.items)
    ::
        %tl
      %-  snoc
      :_  ""
      =/  items  contents.+.nod
      |-  ^-  (list tape)
      ?~  items  ~
      %+  welp
        (item ?:(is-checked.i.items "- [x] " "- [ ] ") (trim (blocks udon markdown.i.items)))
      $(items t.items)
    ==
  ==
::
++  row
  |=  [udon=? cells=(list contents:inline:mds)]
  ^-  tape
  %-  zing
  %+  join  " | "
  (turn cells |=(c=contents:inline:mds (inline udon c)))
::
::  prefix the first line of a list item with its marker
::  and indent the rest under it
++  item
  |=  [mark=tape lines=(list tape)]
  ^-  (list tape)
  ?~  lines  [mark]~
  :-  (welp mark i.lines)
  (turn t.lines |=(l=tape (welp (reap (lent mark) ' ') l)))
::
::  drop trailing blank lines
++  trim
  |=  lines=(list tape)
  ^-  (list tape)
  =/  back=(list tape)  (flop lines)
  |-  ^-  (list tape)
  ?~  back  ~
  ?~  i.back  $(back t.back)
  (flop `(list tape)`back)
--
|_  val=[=slip:chorus =wick]
++  grad  %noun
++  grow
  |%
  ++  noun  val
  ++  json  (enjs:slp val)
  ::
  ::  the body under yaml frontmatter
  ++  md
    ^-  @t
    %-  of-wain:format
    ;:  welp
      :~  '---'
          (cat 3 'author: ' nym.id.wick.val)
          (cat 3 'ship: ' (scot %p ship.slip.val))
          (cat 3 'created: ' (scot %da time.slip.val))
          (cat 3 'fqsp: ' (spat (slag 1 `path`path.wick.val)))
          (cat 3 'wire: ' (wick-to-wire wick.val))
      ==
    ::
      =/  links  (links:slp txt.slip.val)
      ?~  links  ['links: []']~
      ['links:' (turn links |=(l=@t (cat 3 '  - ' l)))]
    ::
      ['---' txt.slip.val ~]
    ==
  ::
  ::  plain text with the markup stripped
  ++  txt
    ^-  wain
    =/  doc  (fall (de:mdl txt.slip.val) ~)
    (turn (trim (blocks | doc)) crip)
  ::
  ++  udon
    ^-  @t
    =/  doc  (fall (de:mdl txt.slip.val) ~)
    (of-wain:format (turn (trim (blocks & doc)) crip))
  ::
  ++  xml
    ^-  @t
    %-  crip
    %-  en-xml:html
    ^-  manx
    :-  :-  %slip
        :~  [%author (trip nym.id.wick.val)]
            [%ship (scow %p ship.slip.val)]
            [%created (scow %da time.slip.val)]
            [%fqsp (spud (slag 1 `path`path.wick.val))]
            [%wire (trip (wick-to-wire wick.val))]
        ==
    :~  :-  [%links ~]
        %+  turn  (links:slp txt.slip.val)
        |=  l=@t
        ^-  manx
        [[%link ~] [[%$ [%$ (trip l)]~] ~]~]
      ::
        [[%body ~] [[%$ [%$ (trip txt.slip.val)]~] ~]~]
    ==
  ::
  ++  mime
    ^-  ^mime
    [/text/markdown (as-octs:mimes:html txt.slip.val)]
  --
++  grab
  |%
  ++  noun  ,[=slip:chorus =wick]
  --
--
