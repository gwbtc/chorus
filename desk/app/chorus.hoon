::
::  chorus: peer-to-peer multiplayer agent harness
::
::    chorus keeps almost no state. what we publish, and what we
::    hear from the ships we poll, lives in the content store
::    wrapped around this agent; chorus types it on the way out
::    and on the way in, under the reserved topics in /sur/chorus.
::
/-  mcp, chorus, *content-routing, *content-store
/-  ka=kademlia-agent, bp=bounded-poke
/+  dbug, verb, cho=chorus, default-agent, slp=slip
/+  kad=kademlia, cr=content-routing, client=content-store-client
/+  kademlia-agent, content-routing-agent, content-discovery-agent
/+  content-store-agent, csl=content-store-agent-logic
::
|%
+$  card  card:agent:gall
::
::  how often we poll, and how often we renew our own listings;
::  the content store's records last a day
++  poll-every   ~m10
++  renew-every  ~h12
--
::
=|  state-0:chorus
=*  state  -
::
=<
%-  agent:content-store-agent
%-  agent:content-discovery-agent
%-  agent:content-routing-agent
%-  agent:kademlia-agent
%-  agent:dbug
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    hc    ~(. ^hc bowl)
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
++  on-agent  on-agent:def
++  on-save   !>(state)
++  on-init   [tick:hc this]
::
++  on-load
  |=  old=vase
  ^-  (quip card _this)
  =/  saved  !<(versioned-state:chorus old)
  ?-  -.saved
    %0  [tick:hc this(state saved)]
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole
      (on-peek:def pole)
  ::
  ::  .^((list tool:mcp) %gx /=/chorus/=/mcp/tools/noun)
      [%x %mcp %tools ~]
    %-  some
    %-  some
    :-  %mcp-tools
    !>  ^-  (list tool:mcp)
    %+  turn
      .^  (list path)
          %ct
          (welp dek:hc /fil/mcp/tools)
      ==
    |=  pax=path
    !<(tool:mcp .^(vase %ca (welp dek:hc pax)))
  ::
  ::  .^((list resource:mcp) %gx /=/chorus/=/mcp/resources/noun)
      [%x %mcp %resources ~]
    %-  some
    %-  some
    :-  %mcp-resources
    !>  ^-  (list resource:mcp)
    %+  turn
      .^  (list path)
          %ct
          (welp dek:hc /fil/mcp/resources)
      ==
    |=  pax=path
    !<(resource:mcp .^(vase %ca (welp dek:hc pax)))
  ::
  ::  .^((list template:resource:mcp) %gx /=/chorus/=/mcp/templates/noun)
      [%x %mcp %templates ~]
    %-  some
    %-  some
    :-  %mcp-templates
    !>  ^-  (list template:resource:mcp)
    %+  turn
      .^  (list path)
          %ct
          (welp dek:hc /fil/mcp/templates)
      ==
    |=  pax=path
    !<(template:resource:mcp .^(vase %ca (welp dek:hc pax)))
  ::
  ::  a reserved topic, from us and every ship we poll, or from
  ::  one ship: the path may end with a @p
  ::  .^((set listing:bio) %gx /=/chorus/=/topic/rolodex/noun)
  ::  .^((set listing:tool:mcp) %gx /=/chorus/=/topic/mcp/tools/~zod/noun)
      [%x %topic rest=*]
    =/  pax=path  ;;(path rest.pole)
    ?~  pax
      [~ ~]
    =/  who=(unit ship)  (slaw %p (rear pax))
    =/  topic=(unit topic:chorus)
      (path-topic:cho [%chorus ?~(who pax (snip `path`pax))])
    ?~  topic
      [~ ~]
    ``(shelf-cage:hc (folded:hc u.topic who))
  ::
  ::  what a ship published at any topic, reserved or not
  ::  .^((unit (cask)) %gx /=/chorus/=/heard/~zod/some/topic/noun)
      [%x %heard who=@ name=*]
    ``noun+!>((heard:hc (slav %p who.pole) ;;(path name.pole)))
  ::
  ::  the ships we poll
  ::  .^(json %gx /=/chorus/=/polled/json)
      [%x %polled ~]
    :^  ~  ~  %json
    !>  ^-  json
    a+(turn ~(tap in polled) |=(who=ship s+(scot %p who)))
  ::
  ::  the nym to credit a ship with, or null for a ship that
  ::  has none; see +author-nym
  ::  .^(json %gx /=/chorus/=/nym/(scot %p who)/json)
      [%x %nym who=@ ~]
    =/  nym  (author-nym:cho bowl (slav %p who.pole))
    ``json+!>(`json`?~(nym ~ s+u.nym))
  ::
  ::  .^([path slip] %gx /=/chorus/=/cabinet/slip/notes/foo/noun)
      [%x %cabinet %slip pax=*]
    =/  pax=path  ;;(path pax.pole)
    =/  lef  (~(get of cabinet:hc) pax)
    ?~  lef
      [~ ~]
    ``chorus-slip+!>(`[path slip:chorus]`[pax u.lef])
  ::
  ::  .^(cabinet %gx /=/chorus/=/cabinet/drawer/noun)
  ::  .^(cabinet %gx /=/chorus/=/cabinet/drawer/notes/noun)
      [%x %cabinet %drawer pax=*]
    ``chorus-cabinet+!>((~(dip of cabinet:hc) ;;(path pax.pole)))
  ::
  ::  the same tree with every body blanked, for listing
  ::  .^(cabinet %gx /=/chorus/=/cabinet/paths/noun)
      [%x %cabinet %paths pax=*]
    :^    ~
        ~
      %chorus-cabinet
    !>  ^-  cabinet:chorus
    =/  fat  (~(dip of cabinet:hc) ;;(path pax.pole))
    |-
    ^-  cabinet:chorus
    :-  ?~(fil.fat ~ `u.fil.fat(txt ''))
    (~(run by dir.fat) |=(kid=cabinet:chorus ^$(fat kid)))
  ::
  ::  kademlia's diagnostics, as json
  ::  .^(json %gx /=/chorus/=/kademlia/summary/json)
      [%x %kademlia %summary ~]
    :^  ~  ~  %json
    !>  %-  en-summary:hc
    .^(summary:ka %gx (weld pyk:hc /~/kademlia/summary/noun))
  ::
      [%x %kademlia %settings ~]
    =/  set
      .^(settings:ka %gx (weld pyk:hc /~/kademlia/settings/noun))
    :^  ~  ~  %json
    !>  ^-  json
    %-  pairs:enjs:format
    :~  ['requestTimeout' s+(scot %dr request-timeout.set)]
        ['refreshInterval' s+(scot %dr refresh-interval.set)]
    ==
  ::
      [%x %kademlia %seeds ~]
    :^  ~  ~  %json
    !>  ^-  json
    :-  %a
    %+  turn
      .^((list @ux) %gx (weld pyk:hc /~/kademlia/seeds/noun))
    |=  id=@ux
    s+(scot %p (~(node-to-ship kad kad-cfg:csl) id))
  ::
      [%x %kademlia %delivery ~]
    :^  ~  ~  %json
    !>  %-  en-delivery:hc
    .^  delivery-summary:bp
        %gx
        (weld pyk:hc /~/kademlia/delivery/noun)
    ==
  ==
::
++  on-watch
  |=  =(pole knot)
  ^-  (quip card _this)
  ?+  pole
    (on-watch:def pole)
  ::
  ::  every listing that changes on any shelf we hold
      [%updates ~]
    `this
  ::
  ::  every slip that lands in the cabinet
      [%cabinet ~]
    `this
  ::
  ::  slips that land in the cabinet except ours
      [%heard ~]
    `this
  ::
  ::  each of our publishes, as it settles
      [%published ~]
    `this
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(src our):bowl
  ?+    mark  (on-poke:def mark vase)
      %chorus-list
    =/  act  !<(list-action:chorus vase)
    =/  who=ship
      ?-  -.who.act
        %ship  ship.who.act
        %nym   (nym-ship:cho nym.who.act)
      ==
    ?:  =(our.bowl who)
      `this
    ?-    -.act
        %add
      =.  polled  (~(put in polled) who)
      [[seed:hc (poll-ship:hc who)] this]
    ::
    ::  what we heard from the ship stays in the content
    ::  store, out of sight
        %remove
      =.  polled  (~(del in polled) who)
      [[seed:hc]~ this]
    ==
  ::
      %chorus-publish
    =/  act  !<(publish:chorus vase)
    =/  made  (make:hc resource.act)
    =/  =item:cho  item.made
    =/  old=shelf:chorus  (ours:hc -.item)
    =/  one=shelf:chorus  (stock:cho (bare:cho -.item) item)
    =/  pax=path  (grow-path:hc (item-key:cho item))
    :_  this
    ^-  (list card)
    %-  zing
    ^-  (list (list card))
    :~  ::  a private listing grows, and so does every slip, so
        ::  that its fqsp resolves. a public listing covers one
        ::  we grew before it
        ?:  |(!public.act ?=(%cabinet -.item))
          [%pass /grow %grow pax (topic-mark:cho -.one) p.one]~
        ?.  (grew:hc pax)
          ~
        [%pass /grow %grow pax (topic-mark:cho -.item) p:(bare:cho -.item)]~
      ::
        ?:  public.act
          (zing (turn casks.made stow:hc))
        %+  turn  casks.made
        |=  cask=(cask)
        ^-  card
        [%pass /grow %grow (snoc pax (scot %uv (digest-cask:cr cask))) cask]
      ::
        ?.  public.act
          ~
        (put-shelf:hc (stock:cho (public:hc -.item) item))
      ::
        (tell:hc our.bowl old (stock:cho old item))
    ==
  ::
      %chorus-retract
    =/  act  !<(retract:chorus vase)
    =/  =topic:chorus  (retract-topic:cho act)
    =/  old=shelf:chorus  (ours:hc topic)
    =/  new=shelf:chorus  (strip:cho old act)
    ?:  =(old new)
      `this
    =/  pub=shelf:chorus  (public:hc topic)
    =/  cut=shelf:chorus  (strip:cho pub act)
    =/  pax=path  (grow-path:hc act)
    :_  this
    ^-  (list card)
    %-  zing
    ^-  (list (list card))
    :~  ?:  =(pub cut)
          ~
        (put-shelf:hc cut)
      ::
      ::  an empty shelf covers what we grew. the revisions
      ::  under it stay, so a slip's fqsp still resolves
        ?.  (grew:hc pax)
          ~
        [%pass /grow %grow pax (topic-mark:cho topic) p:(bare:cho topic)]~
      ::
        (tell:hc our.bowl old new)
    ==
  ::
      %chorus-seek
    =/  act  !<(seek:chorus vase)
    [(get:hc who.act topic.act) this]
  ::
      %content-store-result
    =/  notice  !<(content-store-notice vase)
    =*  result  result.notice
    ?+    reply-path.notice  `this
        [%stow @ ~]
      =/  ignored
        %+  warn:hc  ?=(%failed -.result)
        "could not store a cask: {<result>}"
      [(forget:hc i.t.reply-path.notice) this]
    ::
    ::  a publish settles once its records reach their replicas.
    ::  until then a ship that holds our last pointer answers a
    ::  poll with it
        [%put @ *]
      =/  ignored
        %+  warn:hc  ?=(%failed -.result)
        "could not publish {<`path`t.t.reply-path.notice>}: {<result>}"
      :_  this
      :_  (forget:hc i.t.reply-path.notice)
      :*  %give  %fact  ~[/published]  %chorus-update
          !>  ^-  update:chorus
          [%chorus-published t.t.reply-path.notice ?=(%put -.result)]
      ==
    ::
    ::  what a polled ship holds under a name. under a reserved
    ::  topic a cask that fails its type is never shown, and a
    ::  ship we no longer poll is not heard
        [%get @ @ *]
      :_  this
      %+  weld  (forget:hc i.t.reply-path.notice)
      ^-  (list card)
      ?.  ?=(%get -.result)
        ~
      =/  who=ship  (slav %p i.t.t.reply-path.notice)
      =/  topic=(unit topic:chorus)
        (path-topic:cho t.t.t.reply-path.notice)
      ?~  topic
        ~
      ?.  (~(has in polled) who)
        ~
      =/  new=(unit shelf:chorus)
        (vet-shelf:cho who u.topic value.value.result)
      ?~  new
        (warn:hc & "{<who>} published a bad {<u.topic>}")
      ::  the content store still shows us the last event's
      ::  names, so what we held is what we hold there now
      %^  tell:hc  who
        (fall (held:hc who u.topic) (bare:cho u.topic))
      u.new
    ==
  ==
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?.  ?=([%poll @ ~] wire)
    (on-arvo:def wire sign-arvo)
  ?.  ?=([%behn %wake *] sign-arvo)
    (on-arvo:def wire sign-arvo)
  :_  this
  ^-  (list card)
  %-  zing
  ^-  (list (list card))
  :~  tick:hc
      poll:hc
      ?.  =(0 (mod (slav %da i.t.wire) renew-every))
        ~
      renew:hc
  ==
--
::
|%
++  hc
  |_  =bowl:gall
  ::
  ::  the head of a scry into this agent
  ++  pyk
    ^-  path
    /(scot %p our.bowl)/[dap.bowl]/(scot %da now.bowl)
  ::
  ::  the head of a read from our desk
  ++  dek
    ^-  path
    /(scot %p our.bowl)/[q.byk.bowl]/(scot %da now.bowl)
  ::
  ::  the head of a scry into our own %grow namespace
  ++  fam
    ^-  path
    (weld pyk `path`[%$ ~.1 ~])
  ::
  ::  an operation id for the content store, fresh for each
  ::  thing we ask of it in one event
  ++  new-id
    |=  salt=path
    ^-  content-store-id
    (end 6 (shax (jam [eny.bowl salt])))
  ::
  ::  the digest each name last settled on, as the content
  ::  store holds them
  ++  names
    ^-  (map publisher-name digest)
    .^  (map publisher-name digest)
        %gx
        (weld pyk /~/content-store/names/noun)
    ==
  ::
  ::  the cask a ship last published under a name, if we hold it
  ++  heard
    |=  [who=ship name=path]
    ^-  (unit (cask))
    =/  content=(unit digest)  (~(get by names) [who %chorus name])
    ?~  content
      ~
    %-  mole
    |.  .^  (cask)
            %gx
            (weld pyk /~/content-store/cask/(scot %uv u.content)/noun)
        ==
  ::
  ::  a ship's shelf under a topic, if we hold one that passes.
  ::  the content store keeps a cask before we see it and we
  ::  keep no record of which passed, so we vet another ship's
  ::  shelf each time we read it. our own we made, and only type
  ++  held
    |=  [who=ship =topic:chorus]
    ^-  (unit shelf:chorus)
    =/  got=(unit (cask))  (heard who (topic-path:cho topic))
    ?~  got
      ~
    ?:  =(our.bowl who)
      (type-shelf:cho topic u.got)
    (vet-shelf:cho who topic u.got)
  ::
  ::  every path under /chorus in our own %grow namespace
  ++  farm
    ^-  (list path)
    .^((list path) %gt (weld fam /chorus))
  ::
  ++  grew
    |=  pax=path
    ^-  ?
    (lien farm |=(had=path =(had pax)))
  ::
  ::  the revision the next %grow at a path will land at. a %w
  ::  scry on a path never grown blocks, so ask +grew first
  ++  next-rev
    |=  pax=path
    ^-  @ud
    ?.  (grew pax)
      1
    =/  las  .^(case %gw (weld fam pax))
    ?>  ?=(%ud -.las)
    +(p.las)
  ::
  ::  what we grew under a topic, read back from our own %grow
  ::  namespace: one shelf for each listing, empty if we took
  ::  the listing back. a listing grows one segment below its
  ::  topic, a slip at any depth, our bio at the topic itself
  ++  grown
    |=  =topic:chorus
    ^-  (list shelf:chorus)
    =/  top=path  (topic-path:cho topic)
    %+  murn  farm
    |=  pax=path
    ^-  (unit shelf:chorus)
    ?.  ?+  topic     =(top (snip pax))
          %rolodex    =(top pax)
          %cabinet    &(!=(top pax) =(top (scag (lent top) pax)))
        ==
      ~
    %+  type-shelf:cho  topic
    [(topic-mark:cho topic) .^(* %gx (weld fam pax))]
  ::
  ::  our shelf under a topic as the content store holds it:
  ::  what we published to everyone
  ++  public
    |=  =topic:chorus
    ^-  shelf:chorus
    (fall (held our.bowl topic) (bare:cho topic))
  ::
  ::  our whole shelf under a topic: what we published, and
  ::  over it what we grew
  ++  ours
    |=  =topic:chorus
    ^-  shelf:chorus
    %+  roll  `(list item:cho)`(zing (turn (grown topic) items:cho))
    |:  [item=*item:cho all=(public topic)]
    (stock:cho all item)
  ::
  ::  every shelf we hold under a topic, ours first, from one
  ::  ship or from us and every ship we poll
  ++  shelves
    |=  [=topic:chorus who=(unit ship)]
    ^-  (list [ship shelf:chorus])
    %+  murn
      ?^  who
        [u.who]~
      [our.bowl ~(tap in (~(del in polled) our.bowl))]
    |=  him=ship
    ^-  (unit [ship shelf:chorus])
    ?:  =(our.bowl him)
      `[him (ours topic)]
    =/  got=(unit shelf:chorus)  (held him topic)
    ?~  got
      ~
    `[him u.got]
  ::
  ::  what the old state held under a topic
  ++  folded
    |=  [=topic:chorus who=(unit ship)]
    ^-  shelf:chorus
    (blend:cho our.bowl topic (shelves topic who))
  ::
  ++  cabinet
    ^-  cabinet:chorus
    =/  all=shelf:chorus  (folded %cabinet ~)
    ?>  ?=(%cabinet -.all)
    p.all
  ::
  ++  cabinets
    ^-  (list [ship cabinet:chorus])
    %+  turn  (shelves %cabinet ~)
    |=  [who=ship =shelf:chorus]
    ?>  ?=(%cabinet -.shelf)
    [who p.shelf]
  ::
  ++  shelf-cage
    |=  =shelf:chorus
    ^-  cage
    ::  each case gives the vase its own type. without the
    ::  switch the vase holds the union of every shelf, which no
    ::  mark's sample takes, and the scry crashes in the tube
    :-  (topic-mark:cho -.shelf)
    ?-  -.shelf
      %desks                   !>(p.shelf)
      %rolodex                 !>(p.shelf)
      %announcements           !>(p.shelf)
      %cabinet                 !>(p.shelf)
      %skills                  !>(p.shelf)
      %mcp-tools               !>(p.shelf)
      %mcp-prompts             !>(p.shelf)
      %mcp-resources           !>(p.shelf)
      %mcp-resource-templates  !>(p.shelf)
    ==
  ::
  ::  publish a cask under a name and topic. the result comes
  ::  back to +on-poke at the reply path
  ++  put
    |=  [name=path cask=(cask) entries=@ud reply=path]
    ^-  (list card)
    =/  id  (new-id [%put name])
    %:  start:client
        our.bowl
        dap.bowl
        id
        dap.bowl
        [%put (scot %uv id) reply]
        %:  put:client
            id
            cask
            :-  `[%chorus name [%auto ~] ~]
            `[(turn name |=(a=@ta `@tas`a)) p.cask entries `@ud`now.bowl]
            ~
        ==
    ==
  ::
  ::  publish a cask by its digest alone
  ++  stow
    |=  cask=(cask)
    ^-  (list card)
    =/  id  (new-id /stow/(scot %uv (digest-cask:cr cask)))
    %:  start:client
        our.bowl
        dap.bowl
        id
        dap.bowl
        /stow/(scot %uv id)
        (put:client id cask unnamed:client ~)
    ==
  ::
  ++  put-shelf
    |=  =shelf:chorus
    ^-  (list card)
    %:  put
        (topic-path:cho -.shelf)
        [(topic-mark:cho -.shelf) p.shelf]
        (count:cho shelf)
        (topic-path:cho -.shelf)
    ==
  ::
  ::  ask for what a ship published under a name
  ++  get
    |=  [who=ship name=path]
    ^-  (list card)
    =/  id  (new-id [%get (scot %p who) name])
    %:  start:client
        our.bowl
        dap.bowl
        id
        dap.bowl
        [%get (scot %uv id) (scot %p who) name]
        (get-name:client id who %chorus name)
    ==
  ::
  ++  poll-ship
    |=  who=ship
    ^-  (list card)
    %-  zing
    %+  turn  topics:cho
    |=(=topic:chorus (get who (topic-path:cho topic)))
  ::
  ++  poll
    ^-  (list card)
    (zing (turn ~(tap in (~(del in polled) our.bowl)) poll-ship))
  ::
  ::  publish each of our shelves again, before its records lapse
  ++  renew
    ^-  (list card)
    %-  zing
    %+  turn
      (murn topics:cho |=(=topic:chorus (held our.bowl topic)))
    put-shelf
  ::
  ::  one timer, at the next multiple of the poll interval, so
  ::  that setting it again replaces it
  ++  tick
    ^-  (list card)
    =/  next=@da  (mul +((div now.bowl poll-every)) poll-every)
    =/  =wire  /poll/(scot %da next)
    :~  [%pass wire %arvo %b %rest next]
        [%pass wire %arvo %b %wait next]
    ==
  ::
  ++  seed
    ^-  card
    :*  %pass  /seed
        %agent  [our.bowl dap.bowl]
        %poke  %kademlia-command
        !>(`command:ka`[%set-seeds ~(tap in (~(del in polled) our.bowl))])
    ==
  ::
  ++  warn
    |=  [bad=? =tape]
    ^-  ~
    ?.  bad
      ~
    ((slog leaf+"{<dap.bowl>}: {tape}" ~) ~)
  ::
  ++  forget
    |=  id=@ta
    ^-  (list card)
    =/  got=(unit @uv)  (slaw %uv id)
    ?~  got
      ~
    [(poke:client our.bowl dap.bowl [%forget u.got] /forget/[id])]~
  ::
  ::  tell clients what changed on one ship's shelf. slips go
  ::  out at the paths they take in our merged cabinet
  ++  tell
    |=  [who=ship old=shelf:chorus new=shelf:chorus]
    ^-  (list card)
    =/  all=(list [ship cabinet:chorus])
      ?.  ?=(%cabinet -.new)
        ~
      :-  [who p.new]
      (skip cabinets |=([him=ship *] =(him who)))
    %+  turn  (updates-of:cho old new)
    |=  =update:chorus
    ^-  card
    =/  moved=(unit update:chorus)
      ?+    -.update  ~
          %chorus-slip
        `update(path (spot:cho our.bowl all who path.update))
      ::
          %chorus-slip-discarded
        `update(path (spot:cho our.bowl all who path.update))
      ==
    ?~  moved
      [%give %fact ~[/updates] %chorus-update !>(update)]
    :*  %give  %fact
        ?:  =(our.bowl who)
          ~[/updates /cabinet]
        ~[/updates /cabinet /heard]
        %chorus-update
        !>(u.moved)
    ==
  ::
  ::  where a private listing grows: its topic, then its key
  ++  grow-path
    |=  =retract:chorus
    ^-  path
    %+  weld  (topic-path:cho (retract-topic:cho retract))
    ^-  path
    ?-  -.retract
      %bio                    ~
      %announcement           /(scot %da time.retract)
      %desk                   /[desk.retract]
      %mcp-tool               /(scot %t name.retract)
      %mcp-prompt             /(scot %t name.retract)
      %mcp-resource           /(scot %t uri.retract)
      %mcp-resource-template  /(scot %t uri-template.retract)
      %agent-skill            /(scot %t name.retract)
      %slip                   path.retract
    ==
  ::
  ::  read a source file, as clay serves it and as text
  ++  source
    |=  [=desk pax=path]
    ^-  [=vase cask=(cask)]
    =/  bek=path  /(scot %p our.bowl)/[desk]/(scot %da now.bowl)
    :-  .^(vase %ca (welp bek pax))
    [%hoon .^(@t %cx (welp bek pax))]
  ::
  ::  turn a resource into the item we list, and the casks its
  ::  listing points at
  ++  make
    |=  =resource:chorus
    ^-  [=item:cho casks=(list (cask))]
    =*  our  our.bowl
    ?-    -.resource
        %bio
      ?.  (lte (lent (trip bio.resource)) 256)
        ~|  "{<dap.bowl>}: bio must be 256 characters or less"
        !!
      [[%rolodex our bio.resource] ~]
    ::
        %announcement
      ?.  (lte (lent (trip announcement.resource)) 256)
        ~|  "{<dap.bowl>}: announcement must be 256 characters or less"
        !!
      [[%announcements our now.bowl announcement.resource] ~]
    ::
        %desk
      ?.  (lte (lent (trip desc.resource)) 256)
        ~|  "{<dap.bowl>}: desk description must be 256 characters or less"
        !!
      :_  ~
      :*  %desks  our  desk.resource  desc.resource
          .^(@uvI %cz /(scot %p our)/[desk.resource]/(scot %da now.bowl))
      ==
    ::
        %mcp-tool
      =/  src  (source desk.resource path.resource)
      =/  =tool:mcp  !<(tool:mcp vase.src)
      :_  [cask.src]~
      :*  %mcp-tools  our
          [name.tool desc.tool parameters.tool required.tool]
          (digest-cask:cr cask.src)
      ==
    ::
        %mcp-prompt
      =/  src  (source desk.resource path.resource)
      =/  =prompt:mcp  !<(prompt:mcp vase.src)
      :_  [cask.src]~
      :*  %mcp-prompts  our
          [name.prompt title.prompt desc.prompt arguments.prompt]
          (digest-cask:cr cask.src)
      ==
    ::
        %mcp-resource
      =/  src  (source desk.resource path.resource)
      =/  res=resource:mcp  !<(resource:mcp vase.src)
      :_  [cask.src]~
      :*  %mcp-resources  our
          [uri.res name.res title.res desc.res]
          (digest-cask:cr cask.src)
      ==
    ::
        %mcp-resource-template
      =/  src  (source desk.resource path.resource)
      =/  tem=template:resource:mcp  !<(template:resource:mcp vase.src)
      :_  [cask.src]~
      :*  %mcp-resource-templates  our
          [uri-template.tem name.tem title.tem desc.tem]
          (digest-cask:cr cask.src)
      ==
    ::
        %agent-skill
      ::  '' stands in for no compatibility field
      =/  =meta:skill:chorus
        =*  fm  frontmatter.skill.resource
        [name.fm description.fm (fall compatibility.fm '')]
      =/  err  (vet-skill-meta:cho meta)
      ?^  err
        ~|  "{<dap.bowl>}: {(trip u.err)}"
        !!
      =/  cask=(cask)  [%chorus-skill skill.resource]
      [[%skills our meta (digest-cask:cr cask)] [cask]~]
    ::
        %slip
      =/  err  (vet-slip:slp path.resource txt.resource)
      ?^  err
        ~|  "{<dap.bowl>}: {(trip u.err)}"
        !!
      ::  we alone stamp a slip: its author, its time, and the
      ::  revision its fqsp names, which the %grow lands at
      :_  ~
      :*  %cabinet  path.resource  our  now.bowl
          %^  fqsp:slp  our
            (next-rev (weld (topic-path:cho %cabinet) path.resource))
          path.resource
          txt.resource
      ==
    ==
  ::
  ++  en-summary
    |=  sum=summary:ka
    ^-  json
    %-  pairs:enjs:format
    :~  ['self' s+(scot %ux self.sum)]
        ['seeds' (numb:enjs:format seeds.sum)]
        ['active' (numb:enjs:format active.sum)]
        ['pending' (numb:enjs:format pending.sum)]
        ['completed' (numb:enjs:format completed.sum)]
        ['refreshAt' ?~(refresh-at.sum ~ s+(scot %da u.refresh-at.sum))]
    ==
  ::
  ++  en-delivery
    |=  sum=delivery-summary:bp
    ^-  json
    %-  pairs:enjs:format
    :~  ['peers' (numb:enjs:format peers.sum)]
        ['active' (numb:enjs:format active.sum)]
        ['queuedResponses' (numb:enjs:format queued-responses.sum)]
        ['queuedRequests' (numb:enjs:format queued-requests.sum)]
        ['expired' (numb:enjs:format expired.sum)]
        ['overflowDropped' (numb:enjs:format overflow-dropped.sum)]
    ==
  --
--
