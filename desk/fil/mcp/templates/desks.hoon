/-  mcp
^-  template:resource:mcp
:*  'scry://gx/chorus/topic/desks{/ship}/json'
    'chorus/desks'
    `'List Chorus desks'
    %-  some
    '''
    Read the desks listed by this ship and every ship it polls,
    each with the hash of the desk when it was listed.
    The URI MAY end with a ship, such as ~sampel-palnet,
    to read only what that ship published.
    '''
    `'application/json'
    ~
    `[~ ~ ~]
==
