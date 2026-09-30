/-  mcp
^-  template:resource:mcp
:*  'scry://gx/chorus/topic/skills{/ship}/json'
    'chorus/skills'
    `'List Chorus agent skills'
    %-  some
    '''
    Read the agent skills listed by this ship and every ship it
    polls, each with the digest of its manifest.
    The URI MAY end with a ship, such as ~sampel-palnet,
    to read only what that ship published.
    '''
    `'application/json'
    ~
    `[~ ~ ~]
==
