::
::  End-to-end %mcp-prompt gossip test over two Aqua virtual ships.
::
::  The chorus desk ships no prompt files, so this thread writes a
::  mock prompt into ship a's %chorus desk before publishing it.
::
/-  spider, *chorus
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
=/  mock-prompt=@t
  '''
  /-  mcp
  ^-  prompt:mcp
  :*  'chorus/example-prompt'
      'Example prompt'
      'A mock prompt for testing Chorus publishes.'
      ~[['topic' 'What to write about.' &]]
      ~
      |=  args=(map name:argument:prompt:mcp @t)
      ^-  (list message:prompt:mcp)
      [%user %text `(~(gut by args) 'topic' 'nothing')]~
  ==
  '''
|=  arg=vase
=/  m  (strand:rand ,vase)
~&  >>  %running-thread
;<  ~  bind:m  (setup %chorus-mcp-prompt)
;<  ~  bind:m  (insert-file ship-a /fil/mcp/prompts/example/hoon mock-prompt)
;<  ~  bind:m
  (publish-mcp ship-a %prompt %chorus /fil/mcp/prompts/example/hoon)
~&  >  %published-mcp-prompt
;<  ok=?  bind:m
  %+  poll  10
  =/  n  (strand ,?)
  ;<  prompts=(map ship (set mcp-prompt-listing))  bind:n
    (read-mcp-prompts ship-b)
  %-  pure:n
  %-  ~(any in (~(gut by prompts) ship-a ~))
  |=  l=mcp-prompt-listing
  =('chorus/example-prompt' name.mcp-prompt-metadata.l)
?:  ok
  ~&  >  %ship-b-heard-mcp-prompt
  ;<  ~  bind:m  (teardown %chorus-mcp-prompt)
  (pure:m arg)
~&  >>>  %mcp-prompt-not-heard
;<  ~  bind:m  (teardown %chorus-mcp-prompt)
(pure:m arg)
