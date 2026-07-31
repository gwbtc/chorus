/-  mcp, chorus, *wick
/+  *wick
|%
::
::  replay heard, signed bullas to new subscribers
::
::  XX does this replay bullas in the order
::     they were received? does it matter?
::     not if we add dates to missives
::
++  sing
  |=  sat=state-0:chorus
  ^-  (list bulla:chorus)
  %+  murn
    ^-  (list missive:chorus)
    %-  zing
    ^-  (list (list missive:chorus))
    :~  %+  turn  ~(tap by rolodex.sat)
        |=  [* lit=listing:bio:chorus]
        ^-  missive:chorus
        [%chorus-bio txt.lit wick.lit]
      ::
        %-  zing
        %+  turn  ~(tap by announcements.sat)
        |=  [* liz=(set listing:announcement:chorus)]
        ^-  (list missive:chorus)
        %+  turn  ~(tap in liz)
        |=  lit=listing:announcement:chorus
        ^-  missive:chorus
        [%chorus-announcement txt.lit wick.lit]
      ::
        %-  zing
        %+  turn  ~(tap by mcp-tools.sat)
        |=  [* liz=(set listing:tool:mcp:chorus)]
        ^-  (list missive:chorus)
        %+  turn  ~(tap in liz)
        |=  lit=listing:tool:mcp:chorus
        ^-  missive:chorus
        [%mcp-tool meta.lit wick.lit]
      ::
        %-  zing
        %+  turn  ~(tap by mcp-prompts.sat)
        |=  [* liz=(set listing:prompt:mcp:chorus)]
        ^-  (list missive:chorus)
        %+  turn  ~(tap in liz)
        |=  lit=listing:prompt:mcp:chorus
        ^-  missive:chorus
        [%mcp-prompt meta.lit wick.lit]
      ::
        %-  zing
        %+  turn  ~(tap by mcp-resources.sat)
        |=  [* liz=(set listing:resource:mcp:chorus)]
        ^-  (list missive:chorus)
        %+  turn  ~(tap in liz)
        |=  lit=listing:resource:mcp:chorus
        ^-  missive:chorus
        [%mcp-resource meta.lit wick.lit]
      ::
        %-  zing
        %+  turn  ~(tap by mcp-resource-templates.sat)
        |=  [* liz=(set listing:template:resource:mcp:chorus)]
        ^-  (list missive:chorus)
        %+  turn  ~(tap in liz)
        |=  lit=listing:template:resource:mcp:chorus
        ^-  missive:chorus
        [%mcp-resource-template meta.lit wick.lit]
    ==
  |=  msg=missive:chorus
  ^-  (unit bulla:chorus)
  =/  gis  (~(get by sigs.sat) wick.msg)
  ?~  gis
    ~
  `[%chorus-bulla ship.u.gis sig.u.gis msg]
::
::  fold a heard bulla into state,
::  keyed to the ship that signed the wick
++  hear
  |=  [sat=state-0:chorus =bulla:chorus]
  ^-  state-0:chorus
  =/  msg  msg.bulla
  =/  =wick  wick.msg
  =*  who  ship.id.wick
  =.  sigs.sat  (~(put by sigs.sat) wick [ship.bulla sig.bulla])
  ?-    -.msg
      %chorus-bio
    sat(rolodex (~(put by rolodex.sat) who [txt.msg wick]))
  ::
      %chorus-announcement
    ::  a grow path ends with the moment it was grown
    =/  =time  (slav %da (rear path.wick))
    %=  sat
      announcements  %-  ~(put by announcements.sat)
                     :-  who
                     %-  ~(put in (~(gut by announcements.sat) who ~))
                     [time txt.msg wick]
    ==
  ::
      %mcp-tool
    %=  sat
      mcp-tools  %-  ~(put by mcp-tools.sat)
                 :-  who
                 %-  ~(put in (~(gut by mcp-tools.sat) who ~))
                 [meta.msg wick]
    ==
  ::
      %mcp-prompt
    %=  sat
      mcp-prompts  %-  ~(put by mcp-prompts.sat)
                   :-  who
                   %-  ~(put in (~(gut by mcp-prompts.sat) who ~))
                   [meta.msg wick]
    ==
  ::
      %mcp-resource
    %=  sat
      mcp-resources  %-  ~(put by mcp-resources.sat)
                     :-  who
                     %-  ~(put in (~(gut by mcp-resources.sat) who ~))
                     [meta.msg wick]
    ==
  ::
      %mcp-resource-template
    %=  sat
      mcp-resource-templates
      %-  ~(put by mcp-resource-templates.sat)
      :-  who
      %-  ~(put in (~(gut by mcp-resource-templates.sat) who ~))
      [meta.msg wick]
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
::
::  seal a missive in a bulla: .sig signs (jam msg) with the
::  same networking key that signed the wick, so a hearer can
::  check the metadata without fetching the content
++  sign-bulla
  |=  [=bowl:gall msg=missive:chorus]
  ^-  bulla:chorus
  =/  =seed:jael  (feed-to-seed bowl)
  =/  keys  (nol:nu:cric:crypto key.seed)
  ?>  ?=(^ sek.+<.keys)
  =/  jammed=@  (jam msg)
  :*  %chorus-bulla
      our.bowl
      `@ux`(sign-octs-raw:ed:crypto [(met 3 jammed) jammed] [sgn.pub sgn.sek]:+<:keys)
      msg
  ==
::
::  check a heard bulla: the outer signature must match
::  (jam msg) under the key .ship holds in jael at the wick's
::  rotation, and the wick id must name the sending ship under
::  the same nym rules we apply ourselves
++  verify-bulla
  |=  [=bowl:gall =bulla:chorus]
  ^-  ?
  =/  who=tape  (scow %p ship.bulla)
  =/  =wick  wick.msg.bulla
  ?:  =(0x0 sig.bulla)
    %-  (slog [leaf+"chorus: no signature on bulla from {who}"]~)
    |
  ::  we expect every ship to hold a pubkey in jael
  =/  key=(unit (unit [crypto-suite=@ud =pass]))
    %-  mole
    |.
    .^  (unit [crypto-suite=@ud =pass])
        %j
        /(scot %p our.bowl)/puby/(scot %da now.bowl)/(scot %p ship.bulla)/(scot %ud rot.wick)
    ==
  ?~  key
    %-  (slog [leaf+"chorus: could not look up a key for {who}"]~)
    |
  ?~  u.key
    %-  (slog [leaf+"chorus: jael has no key for {who} at life {<rot.wick>}"]~)
    |
  =/  jammed=@  (jam msg.bulla)
  ?.  %^    veri-octs:ed:crypto
          sig.bulla
        [(met 3 jammed) jammed]
      sgn:ded:ex:(com:nu:cric:crypto pass.u.u.key)
    %-  (slog [leaf+"chorus: {who} did not sign the bulla"]~)
    |
  ::  only comets have nyms, so a non-comet sender must be
  ::  named in its wick by its cometized form: the fingerprint
  ::  of the key it signed with. planets registering with the
  ::  groundwire pki as comets may change this someday, but for
  ::  now we expect the nym untweaked
  =/  paw=(unit @pH)
    ?:  =(%pawn (clan:title ship.bulla))
      `ship.bulla
    (mole |.((cometize:mu bowl ship.bulla)))
  ?~  paw
    %-  (slog [leaf+"chorus: could not cometize {who}"]~)
    |
  ?.  =(u.paw ship.id.wick)
    %-  (slog [leaf+"chorus: the wick from {who} names another ship"]~)
    |
  ::  XX all nyms are two-dot unverified nyms until we settle
  ::     the tweak data the pki accepts; see +verified-nym
  =/  gib
    ?:  (verified-nym our.bowl now.bowl ship.bulla rot.wick)
      me
    mu
  ?.  =((name:gib u.paw) nym.id.wick)
    %-  (slog [leaf+"chorus: the wick from {who} carries the wrong nym"]~)
    |
  &
--
