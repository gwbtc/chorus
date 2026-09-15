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
