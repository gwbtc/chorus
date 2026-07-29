/-  mcp, chorus, *wick
/+  *wick
|%
::
::  replay the log of messages that constructed our state;
::  used to send subscribers our state using existing machinery
::
::  XX does this replay messages in the order they were received?
++  sing
  |=  sat=state-0:chorus
  ^-  (list message:chorus)
  %-  zing
  ^-  (list (list message:chorus))
  :~  %+  turn  ~(tap by rolodex.sat)
      |=  [* lit=listing:bio:chorus]
      ^-  message:chorus
      [%chorus-message %chorus-bio txt.lit wick.lit]
    ::
      %-  zing
      %+  turn  ~(tap by announcements.sat)
      |=  [* liz=(set listing:announcement:chorus)]
      ^-  (list message:chorus)
      %+  turn  ~(tap in liz)
      |=  lit=listing:announcement:chorus
      ^-  message:chorus
      [%chorus-message %chorus-announcement txt.lit wick.lit]
    ::
      %-  zing
      %+  turn  ~(tap by mcp-tools.sat)
      |=  [* liz=(set listing:tool:mcp:chorus)]
      ^-  (list message:chorus)
      %+  turn  ~(tap in liz)
      |=  lit=listing:tool:mcp:chorus
      ^-  message:chorus
      [%chorus-message %mcp-tool meta.lit wick.lit]
    ::
      %-  zing
      %+  turn  ~(tap by mcp-prompts.sat)
      |=  [* liz=(set listing:prompt:mcp:chorus)]
      ^-  (list message:chorus)
      %+  turn  ~(tap in liz)
      |=  lit=listing:prompt:mcp:chorus
      ^-  message:chorus
      [%chorus-message %mcp-prompt meta.lit wick.lit]
    ::
      %-  zing
      %+  turn  ~(tap by mcp-resources.sat)
      |=  [* liz=(set listing:resource:mcp:chorus)]
      ^-  (list message:chorus)
      %+  turn  ~(tap in liz)
      |=  lit=listing:resource:mcp:chorus
      ^-  message:chorus
      [%chorus-message %mcp-resource meta.lit wick.lit]
    ::
      %-  zing
      %+  turn  ~(tap by mcp-resource-templates.sat)
      |=  [* liz=(set listing:template:resource:mcp:chorus)]
      ^-  (list message:chorus)
      %+  turn  ~(tap in liz)
      |=  lit=listing:template:resource:mcp:chorus
      ^-  message:chorus
      [%chorus-message %mcp-resource-template meta.lit wick.lit]
  ==
::
::  fold a heard message into state,
::  keyed to the ship that signed the wick
++  hear
  |=  [sat=state-0:chorus =message:chorus]
  ^-  state-0:chorus
  =/  =wick  wick.message
  =*  who  ship.wick
  ?-    -.+.message
      %chorus-bio
    sat(rolodex (~(put by rolodex.sat) who [txt.+.message wick]))
  ::
      %chorus-announcement
    ::  a grow path ends with the moment it was grown
    =/  =time  (slav %da (rear path.wick))
    %=  sat
      announcements  %-  ~(put by announcements.sat)
                     :-  who
                     %-  ~(put in (~(gut by announcements.sat) who ~))
                     [time txt.+.message wick]
    ==
  ::
      %mcp-tool
    %=  sat
      mcp-tools  %-  ~(put by mcp-tools.sat)
                 :-  who
                 %-  ~(put in (~(gut by mcp-tools.sat) who ~))
                 [meta.+.message wick]
    ==
  ::
      %mcp-prompt
    %=  sat
      mcp-prompts  %-  ~(put by mcp-prompts.sat)
                   :-  who
                   %-  ~(put in (~(gut by mcp-prompts.sat) who ~))
                   [meta.+.message wick]
    ==
  ::
      %mcp-resource
    %=  sat
      mcp-resources  %-  ~(put by mcp-resources.sat)
                     :-  who
                     %-  ~(put in (~(gut by mcp-resources.sat) who ~))
                     [meta.+.message wick]
    ==
  ::
      %mcp-resource-template
    %=  sat
      mcp-resource-templates
      %-  ~(put by mcp-resource-templates.sat)
      :-  who
      %-  ~(put in (~(gut by mcp-resource-templates.sat) who ~))
      [meta.+.message wick]
    ==
  ==
::
++  feed-to-seed
  |=  =bowl:gall
  ^-  seed:jael
  =/  =feed:jael
    ;;  feed:jael
    (cue .^(@ %j /(scot %p our.bowl)/vile/(scot %da now.bowl)))
  ?>  ?=([%2 ~] -.feed)
  ?~  kyz.feed
    ~|(%chorus-vile-without-keys !!)
  [who.feed lyf.i.kyz.feed key.i.kyz.feed ~]
::
::  sign a contentful wick over a grown path and the full
::  sage:mess:ames the requester will receive in +on-arvo
::  XX will eventually have to handle non-/fine paths = no pages
++  make-grow-wick
  |=  [=bowl:gall seg=path =page]
  ^-  wick
  =/  pax=path
    :(welp /fine/(scot %p our.bowl)/g/x/1/chorus//1 seg /(scot %da now.bowl))
  (make-wick | (feed-to-seed bowl) pax `(fine-octs [[our.bowl (slag 2 pax)] page]))
::
::  sign a contentful wick over the clay fine path for a source
::  file and the full sage:mess:ames a remote scry will receive
++  make-clay-wick
  |=  [=bowl:gall =desk pax=path]
  ^-  wick
  =/  bek=path  /(scot %p our.bowl)/[desk]/(scot %da now.bowl)
  =/  cas=cass:clay  .^(cass:clay %cw bek)
  =/  fyn=path
    :(welp /fine/(scot %p our.bowl)/c/x/(scot %ud ud.cas)/[desk] pax)
  =/  =page  [(slav %tas (rear pax)) .^(* %cx (welp bek pax))]
  (make-wick | (feed-to-seed bowl) fyn `(fine-octs [[our.bowl (slag 2 fyn)] page]))
--
