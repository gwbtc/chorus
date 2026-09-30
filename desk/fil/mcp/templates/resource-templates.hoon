/-  mcp
^-  template:resource:mcp
:*  'scry://gx/chorus/topic/mcp/resources/templates{/ship}/json'
    'chorus/mcp-resource-templates'
    `'List Chorus MCP resource templates'
    %-  some
    '''
    Read the MCP resource templates listed by this ship and every
    ship it polls, each with the digest of its source.
    The URI MAY end with a ship, such as ~sampel-palnet,
    to read only what that ship published.
    '''
    `'application/json'
    ~
    `[~ ~ ~]
==
