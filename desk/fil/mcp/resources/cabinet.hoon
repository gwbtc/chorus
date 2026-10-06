/-  mcp
^-  resource:mcp
:*  'scry://gx/chorus/cabinet/drawer/json'
    'chorus/cabinet'
    `'Read Chorus cabinet'
    %-  some
    '''
    Read every slip in the Chorus cabinet whose text this
    ship holds: ours, and those fetched with
    chorus/fetch-slips. Returns a nested object mirroring the
    tree: the slip at each node, if any, and its children by
    path segment.
    '''
    `'application/json'
    ~
    ~
==
