/-  chorus, mcp, spider
/+  io=strandio, slp=slip
^-  tool:mcp
:*  'chorus/fetch-slip'
    '''
    Fetch one revision of a slip by its FQSP, the target of a
    [[<fqsp>]] link: /~host/g/x/{revision-number}/chorus//1/chorus/cabinet/{+path}.
    Reads the slip from this ship if it already holds that
    revision, else asks the slip's host for it by remote scry,
    whether the host is this ship or another, and returns the
    slip as its author published it then. A later revision, or
    the slip's removal from the cabinet, does not change what
    an FQSP names.
    '''
    %-  my
    :~  :-  'fqsp'
        :-  %string
        'The FQSP of the slip revision, beginning with a /.'
    ==
    ~['fqsp']
    ^-  thread-builder:tool:mcp
    |=  args=(map name:parameter:tool:mcp argument:tool:mcp)
    ^-  shed:khan
    =/  m  (strand:spider ,vase)
    ^-  form:m
    =/  arg  (~(get by args) 'fqsp')
    ?~  arg
      (pure:m !>([%error %missing-fqsp ~]))
    ?>  ?=([%string @t] u.arg)
    =/  fin=(unit [host=ship rev=@ud pax=path])
      =/  pax=(unit path)  (rush p.u.arg stap)
      ?~  pax
        ~
      (parse-fqsp:slp u.pax)
    ?~  fin
      %-  pure:m
      !>  ^-  response:tool:mcp
      :+  %error
        '''
        could not parse the fqsp; it must look like
        /~host/g/x/3/chorus//1/chorus/cabinet/drawer/slug
        '''
      ~
    =/  fqsp=path  (fqsp:slp u.fin)
    ::  the cabinet lists the current revision of each slip.
    ::  if it lists ours, the page is in our farm or the content
    ::  store, or chorus can fetch it there through a %direct get
    ;<  fat=(axal listed:chorus)  bind:m
      %+  scry:io  (axal listed:chorus)
      `path`(snoc (weld /gx/chorus/cabinet/paths pax.u.fin) %noun)
    =/  listed=(unit listed:chorus)
      ?.  &(?=(^ fil.fat) =(fqsp fqsp.stub.u.fil.fat))
        ~
      fil.fat
    ?:  &(?=(^ listed) held.u.listed)
      ;<  got=[path =slip:chorus]  bind:m
        %+  scry:io  ,[path slip:chorus]
        `path`(snoc (weld /gx/chorus/cabinet/slip pax.u.fin) %noun)
      %-  pure:m
      !>  ^-  response:tool:mcp
      [%result %structured (enjs:slp slip.got)]
    ;<  our=ship  bind:m  get-our:io
    ;<  now=@da  bind:m  get-time:io
    =/  until=@da  (add now ~s30)
    ?^  listed
      ::  chorus asks the store for the page and tells /cabinet
      ::  when it lands. a page that fails its vet never lands,
      ::  so race the fact against a timer
      ;<  ~  bind:m  (watch:io /fetch-slip [our %chorus] /cabinet)
      ;<  ~  bind:m
        %+  poke:io  [our %chorus]
        :-  %chorus-fetch
        !>  ^-  fetch:chorus
        [pax.u.fin [host.u.fin ~ ~]]
      ;<  ~  bind:m  (send-wait:io until)
      ;<  got=(unit slip:chorus)  bind:m
        =/  n  (strand:spider ,(unit slip:chorus))
        ^-  form:n
        |=  tin=strand-input:strand:spider
        ?+    in.tin  `[%skip ~]
            ~
          `[%wait ~]
        ::
            [~ %sign [%wait @ ~] %behn %wake *]
          `[%done ~]
        ::
            [~ %agent [%watch %fetch-slip ~] %fact *]
          =/  upd  !<(update:chorus q.cage.sign.u.in.tin)
          ?.  &(?=(%chorus-slip -.upd) =(fqsp fqsp.slip.upd))
            `[%skip ~]
          `[%done `slip.upd]
        ==
      ;<  ~  bind:m  (leave:io /fetch-slip [our %chorus])
      ;<  ~  bind:m
        ?~  got
          (pure:(strand:spider ,~) ~)
        %-  send-raw-card:io
        [%pass /wait/(scot %da until) %arvo %b %rest until]
      %-  pure:m
      !>  ^-  response:tool:mcp
      ?~  got
        [%error (crip "{<host.u.fin>} did not answer, or served a bad page") ~]
      [%result %structured (enjs:slp u.got)]
    ::  an old revision, or a slip of a ship we do not poll: no
    ::  listing names its digest, so ask the host ourselves.
    ::  a host that is away never answers, so race the scry
    ::  against a timer and say which came first
    =/  =spar:ames  [host.u.fin (slag 1 fqsp)]
    ;<  ~  bind:m  (keen:io /fetch-slip spar ~)
    ;<  ~  bind:m  (send-wait:io until)
    ;<  got=(unit sage:mess:ames)  bind:m
      =/  n  (strand:spider ,(unit sage:mess:ames))
      ^-  form:n
      |=  tin=strand-input:strand:spider
      ?+    in.tin  `[%skip ~]
          ~
        `[%wait ~]
      ::
          [~ %sign [%wait @ ~] %behn %wake *]
        `[%done ~]
      ::
          [~ %sign [%fetch-slip ~] %ames %sage *]
        `[%done `sage.sign-arvo.u.in.tin]
      ==
    ;<  ~  bind:m
      ?~  got
        (yawn:io /fetch-slip spar)
      %-  send-raw-card:io
      [%pass /wait/(scot %da until) %arvo %b %rest until]
    %-  pure:m
    !>  ^-  response:tool:mcp
    ?~  got
      [%error (crip "{<host.u.fin>} did not answer") ~]
    ?~  q.u.got
      [%error (crip "{<host.u.fin>} serves nothing at that fqsp") ~]
    ::  the page is a cabinet holding the one slip. check it as
    ::  we check a shelf we hear: its author is its host, and it
    ::  is the revision we asked for
    =/  cab=(unit cabinet:chorus)
      (mole |.(;;(cabinet:chorus q.q.u.got)))
    =/  =slip:chorus
      (fall ?~(cab ~ (~(get of u.cab) pax.u.fin)) *slip:chorus)
    ?.  ?&  =(%chorus-cabinet p.q.u.got)
            =(host.u.fin ship.slip)
            =(fqsp fqsp.slip)
        ==
      [%error (crip "{<host.u.fin>} serves no slip at that fqsp") ~]
    [%result %structured (enjs:slp slip)]
==
