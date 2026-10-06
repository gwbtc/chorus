::
::  Shared helpers for Chorus end-to-end tests over Aqua virtual ships.
::
/-  spider, *chorus
/+  *ph-io, ph-util
=,  strand=strand:spider
|%
+$  want
  $%  [%bio txt=cord]
      [%announcement txt=cord]
      [%mcp-tool name=@t]
      [%mcp-prompt name=@t]
      [%mcp-resource name=@t]
      [%mcp-resource-template name=@t]
      [%slip pax=path txt=cord]
  ==
+$  expectation
  [who=ship id=@uv from=ship =want]
::
::  Typed compatibility adapters for this Groundwire ph-io revision.
::  Its generic +poke-app accepts data as *, losing atom auras before
::  formatting the Dojo command.  Keep each payload typed instead.
++  poke-publish
  |=  [=ship act=publish]
  =/  m  (strand ,~)
  ^-  form:m
  =/  command=tape  ":chorus &chorus-publish {<act>}"
  ?.  public.act
    (send-events (dojo:ph-util ship command))
  (dojo-publish ship command)
::
::  run a dojo command that publishes, and wait until the
::  publish settles: until then a ship that holds our last
::  pointer answers a poll with it
++  dojo-publish
  |=  [=ship command=tape]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  now=@da  bind:m  get-time
  =/  =wire  /aqua/watch/published/(scot %da now)
  =/  =task:gall
    [%deal [ship ship /] %chorus %watch /published]
  ;<  ~  bind:m  (send-events [%event ship [%g wire] task]~)
  ;<  ~  bind:m  (send-events (dojo:ph-util ship command))
  |-
  ;<  [her=^ship =unix-effect]  bind:m  take-unix-effect
  ?.  ?&  =(her ship)
          =(wire p.unix-effect)
          ?=([%unto %raw-fact *] q.unix-effect)
          =(%chorus-update mark.unto.q.unix-effect)
      ==
    $
  =/  got=(unit update)  ((soft update) noun.unto.q.unix-effect)
  ?.  ?=([~ %chorus-published *] got)
    $
  ?:  done.u.got
    (pure:m ~)
  (strand-fail %chorus-publish-failed ~[>[who=ship topic=topic.u.got]<])
::
++  poke-list
  |=  [=ship act=list-action]
  =/  m  (strand ,~)
  ^-  form:m
  (send-events (dojo:ph-util ship ":chorus &chorus-list {<act>}"))
::
++  wait-for-probe
  |=  [=ship id=@uv]
  =/  m  (strand ,~)
  =/  yes=tape  "[{(scow %uv id)} %.y]"
  =/  no=tape   "[{(scow %uv id)} %.n]"
  ^-  form:m
  |-
  =*  loop  $
  ;<  [her=^ship =unix-effect]  bind:m  take-unix-effect
  ?:  (is-dojo-output:ph-util ship her unix-effect yes)
    (pure:m ~)
  ?:  (is-dojo-output:ph-util ship her unix-effect no)
    (strand-fail %chorus-probe-failed ~[>[who=ship id=id]<])
  loop
::
++  send-events-wait-probe
  |=  [=ship id=@uv events=(list aqua-event)]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  our=@p  bind:m  get-our
  =/  =card:agent:gall
    [%pass /poke %agent [our %aqua] %poke %aqua-events !>(events)]
  |=  tin=strand-input:strand
  :-  [card ~]
  [%cont (wait-for-probe ship id)]
::
::  two fake galaxies: aqua routes them to each other without
::  sponsors, and each holds the other's keys from birth
++  ship-a  ~bud
++  ship-b  ~wes
::
::  add .peer to the ships .who polls. chorus polls a ship as
::  it is added, so adding it again polls it again: tests use
::  this in place of waiting out the poll interval
++  poll
  |=  [who=ship peer=ship]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-list who [%add %ship peer])
::
++  unlist
  |=  [who=ship peer=ship]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-list who [%remove %ship peer])
::
++  update-bio
  |=  [who=ship bio=cord]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-publish who [& %bio bio])
::
++  make-announcement
  |=  [who=ship announcement=cord]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-publish who [& %announcement announcement])
::
::  a private announcement: grown on .who, never published
++  make-private-announcement
  |=  [who=ship announcement=cord]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-publish who [| %announcement announcement])
::
++  publish-slip
  |=  [who=ship pax=path txt=cord]
  =/  m  (strand ,~)
  ^-  form:m
  (poke-publish who [& %slip pax txt])
::
::  publish a cabinet that breaks the rules, past chorus and
::  straight through the content store: it lists a slip that
::  another ship wrote. chorus hears the result as it does its
::  own publishes
++  publish-bad-cabinet
  |=  who=ship
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m
    %-  send-events
    %+  dojo:ph-util  who
    ;:  weld
      ":chorus &content-store-command "
      "[%observe 0v99 %chorus /put/0v99/chorus/cabinet]"
    ==
  %+  dojo-publish  who
  ;:  weld
    ":chorus &content-store-command [%put 0v99 [%chorus-index "
    "(~(put of *(axal [@p @da path @uv])) /notes/foo "
    "[~zod ~2026.1.1 /bad 0v0])] "
    "[`[%chorus /chorus/cabinet [%auto ~] ~] ~] ~]"
  ==
::
++  publish-mcp
  |=  $:  who=ship
          kind=?(%tool %prompt %resource %resource-template)
          =desk
          pax=path
      ==
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke-publish  who
  ?-  kind
    %tool               [& %mcp-tool desk pax]
    %prompt             [& %mcp-prompt desk pax]
    %resource           [& %mcp-resource desk pax]
    %resource-template  [& %mcp-resource-template desk pax]
  ==
::
++  probe-want
  |=  [who=ship id=@uv from=ship =want]
  =/  m  (strand ,~)
  ^-  form:m
  =/  kind=term  -.want
  =/  [value=@t pax=path]
    ?-  -.want
      %bio                    [txt.want /]
      %announcement           [txt.want /]
      %mcp-tool               [name.want /]
      %mcp-prompt             [name.want /]
      %mcp-resource           [name.want /]
      %mcp-resource-template  [name.want /]
      %slip                   [txt.want pax.want]
    ==
  =/  command=tape
    "+chorus!ph/chorus-probe {(scow %uv id)} {(scow %p from)} {<kind>} {<value>} {<pax>}"
  %:  send-events-wait-probe
    who
    id
    (dojo:ph-util who command)
  ==
::
++  update-wire
  |=  id=@uv
  ^-  wire
  /aqua/watch/chorus/(scot %uv id)
::
::  Open a local Aqua watch before triggering the remote operation.
::  Chorus gives a fact on /updates for each listing that changes on
::  a shelf it holds.
++  expect-update
  |=  [who=ship id=@uv]
  =/  m  (strand ,~)
  ^-  form:m
  =/  =task:gall
    [%deal [who who /] %chorus %watch /updates]
  (send-events [%event who /g/aqua/watch/chorus/(scot %uv id) task]~)
::
++  matches-want
  |=  [from=ship =want val=noun]
  ^-  ?
  ::  %raw-fact deliberately carries an untyped noun, not a vase
  =/  got=(unit update)  ((soft update) val)
  ?~  got  |
  =*  upd  u.got
  ?-  -.want
    %bio
      ?.  ?=(%chorus-bio-updated -.upd)  |
      &(=(from ship.upd) =(txt.want txt.upd))
    %announcement
      ?.  ?=(%chorus-announcement -.upd)  |
      &(=(from ship.upd) =(txt.want txt.upd))
    %mcp-tool
      ?.  ?=(%mcp-tool-listed -.upd)  |
      &(=(from ship.upd) =(name.want name.meta.upd))
    %mcp-prompt
      ?.  ?=(%mcp-prompt-listed -.upd)  |
      &(=(from ship.upd) =(name.want name.meta.upd))
    %mcp-resource
      ?.  ?=(%mcp-resource-listed -.upd)  |
      &(=(from ship.upd) =(name.want name.meta.upd))
    %mcp-resource-template
      ?.  ?=(%mcp-resource-template-listed -.upd)  |
      &(=(from ship.upd) =(name.want name.meta.upd))
    %slip
      ?.  ?=(%chorus-slip -.upd)  |
      ?&  =(from ship.slip.upd)
          =(pax.want path.upd)
          =(txt.want txt.slip.upd)
      ==
  ==
::
++  observed
  |=  [her=ship =unix-effect exp=expectation]
  ^-  ?
  ?&  =(her who.exp)
      =((update-wire id.exp) p.unix-effect)
      ?=([%unto %raw-fact *] q.unix-effect)
      =(%chorus-update mark.unto.q.unix-effect)
      (matches-want from.exp want.exp noun.unto.q.unix-effect)
  ==
::
::  did .who.exp just hear that .from.exp lists the slip we want?
++  listed
  |=  [her=ship =unix-effect exp=expectation]
  ^-  ?
  ?.  ?&  =(her who.exp)
          =((update-wire id.exp) p.unix-effect)
          ?=([%unto %raw-fact *] q.unix-effect)
          =(%chorus-update mark.unto.q.unix-effect)
          ?=(%slip -.want.exp)
      ==
    |
  =/  got=(unit update)  ((soft update) noun.unto.q.unix-effect)
  ?.  ?=([~ %chorus-slip-listed *] got)
    |
  &(=(from.exp ship.stub.u.got) =(pax.want.exp path.u.got))
::
::  fetch the page of every slip .who hears of and lacks
++  fetch-pages
  |=  who=ship
  =/  m  (strand ,~)
  ^-  form:m
  (send-events (dojo:ph-util who ":chorus &chorus-fetch [/ ~]"))
::
::  wait for the fact, then check the ship's own scries agree.
::  a ship hears of another's slip before it holds the text: when
::  the listing lands, fetch, and wait for the slip itself
++  await-update
  |=  exp=expectation
  =/  m  (strand ,~)
  ^-  form:m
  ?:  =(who.exp from.exp)
    (probe-want exp)
  |-
  ;<  [her=^ship =unix-effect]  bind:m  take-unix-effect
  ?:  (listed her unix-effect exp)
    ;<  ~  bind:m  (fetch-pages who.exp)
    $
  ?.  (observed her unix-effect exp)  $
  (probe-want exp)
::
::  wait until .who holds nothing from .from under a name
++  await-unheard
  |=  [who=ship from=ship name=path]
  =/  m  (strand ,~)
  ^-  form:m
  |-
  ;<  =bowl:strand  bind:m  get-bowl
  =/  got=(unit (unit (cask)))
    %+  scry-aqua:util  (unit (unit (cask)))
    :+  our.bowl  now.bowl
    (scry-path who now.bowl (weld /heard/(scot %p from) name))
  ?:  =([~ ~] got)
    (pure:m ~)
  ;<  ~  bind:m  (sleep ~s2)
  $
::
::  the chorus test fleet
::
++  message-fleet
  ^-  (list ship)
  ~[ship-a ship-b]
::
++  setup-message-fleet
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (init-ship ship-a &)
  (init-ship ship-b &)
::
::  Setup for the two-ship message tests: handshake the pair. A poll
::  asks for nine topics through one poke gate per peer, and takes
::  about thirty seconds between aqua ships, so tests poll no more
::  than they must.
++  prepare-pair
  =/  m  (strand ,~)
  ^-  form:m
  (send-hi ship-b ship-a)
::
++  scry-path
  |=  [who=ship now=@da pax=path]
  ^-  path
  ;:  welp
    /i/(scot %p who)/gx/(scot %p who)/chorus/(scot %da now)
    pax
    /noun/noun
  ==
::
++  read-rolodex
  |=  who=ship
  =/  m  (strand (set listing:bio))
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  %-  pure:m
  %-  need
  %+  scry-aqua:util  (unit (set listing:bio))
  [our.bowl now.bowl (scry-path who now.bowl /topic/rolodex)]
::
+$  anns  (set listing:announcement)
::
++  read-announcements
  |=  who=ship
  =/  m  (strand anns)
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  %-  pure:m
  %-  need
  %+  scry-aqua:util  (unit anns)
  [our.bowl now.bowl (scry-path who now.bowl /topic/announcements)]
::
++  heard-announcement
  |=  [heard=anns from=ship text=cord]
  ^-  ?
  %-  ~(any in heard)
  |=  listing:announcement
  &(=(from ship) =(text txt))
--
