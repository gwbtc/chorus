/-  mcp
^-  template:resource:mcp
:*  'scry://gx/chorus/chorus/mcp/prompts{/ship}/json'
    'chorus/mcp-prompts'
    `'List Chorus MCP prompts'
    %-  some
    '''
    Read the MCP prompts listed by this ship and every ship it
    polls, each with the digest of its source.
    The URI MAY end with a ship, such as ~sampel-palnet,
    to read only what that ship published.
    '''
    `'application/json'
    ~
    `[~ ~ ~]
==
