/-  chorus, mcp, spider
/+  io=strandio, slp=slip
^-  tool:mcp
:*  'chorus/fetch-slip'
    '''
    Fetch one revision of a slip by its FQSP, the target of a
    [[<fqsp>]] link: /~host/g/x/{revision-number}/chorus//1/chorus/cabinet/{+path}.
    Asks the slip's host for that revision by remote scry, whether
    the host is this ship or another, and returns the slip as its
    author published it then. A later revision, or the slip's
    removal from the cabinet, does not change what an FQSP names.
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
    ::  a host that is away never answers, so race the scry
    ::  against a timer and say which came first
    =/  =spar:ames  [host.u.fin (slag 1 (fqsp:slp u.fin))]
    ;<  now=@da  bind:m  get-time:io
    =/  until=@da  (add now ~s30)
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
            =((fqsp:slp u.fin) fqsp.slip)
        ==
      [%error (crip "{<host.u.fin>} serves no slip at that fqsp") ~]
    [%result %structured (enjs:slp slip)]
==
