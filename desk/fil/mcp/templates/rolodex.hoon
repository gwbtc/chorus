/-  mcp
^-  template:resource:mcp
:*  'scry://gx/chorus/chorus/rolodex{/ship}/json'
    'chorus/rolodex'
    `'Read Chorus rolodex'
    %-  some
    '''
    Read the bios of this ship and every ship it polls.
    The URI MAY end with a ship, such as ~sampel-palnet,
    to read only what that ship published.
    '''
    `'application/json'
    ~
    `[~ ~ ~]
==
