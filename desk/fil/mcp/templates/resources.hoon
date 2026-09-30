/-  mcp
^-  template:resource:mcp
:*  'scry://gx/chorus/topic/mcp/resources{/ship}/json'
    'chorus/mcp-resources'
    `'List Chorus MCP resources'
    %-  some
    '''
    Read the MCP resources listed by this ship and every ship it
    polls, each with the digest of its source.
    The URI MAY end with a ship, such as ~sampel-palnet,
    to read only what that ship published.
    '''
    `'application/json'
    ~
    `[~ ~ ~]
==
