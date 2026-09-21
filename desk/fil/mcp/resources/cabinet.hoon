/-  mcp
^-  resource:mcp
:*  'scry://gx/chorus/cabinet/drawer/json'
    'chorus/cabinet'
    `'Read Chorus cabinet'
    %-  some
    '''
    Read every slip in the Chorus cabinet, bodies included,
    as a nested object mirroring the tree: the slip at each
    node, if any, and its children by path segment.
    '''
    `'application/json'
    ~
    ~
==
