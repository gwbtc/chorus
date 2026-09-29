/-  mcp
^-  template:resource:mcp
:*  'scry://gx/chorus/chorus/mcp/tools{/ship}/json'
    'chorus/mcp-tools'
    `'List Chorus MCP tools'
    %-  some
    '''
    Read the MCP tools listed by this ship and every ship it
    polls, each with the digest of its source.
    The URI MAY end with a ship, such as ~sampel-palnet,
    to read only what that ship published.
    '''
    `'application/json'
    ~
    `[~ ~ ~]
==
