/-  mcp
^-  template:resource:mcp
:*  'scry://gx/chorus/topic/announcements{/ship}/json'
    'chorus/announcements'
    `'Read Chorus announcements'
    %-  some
    '''
    Read the announcements of this ship and every ship it polls.
    The URI MAY end with a ship, such as ~sampel-palnet,
    to read only what that ship published.
    '''
    `'application/json'
    ~
    `[~ ~ ~]
==
