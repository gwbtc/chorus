/-  mcp
^-  template:resource:mcp
:*  'scry://gx/chorus/cabinet/paths/{+path}/json'
    'chorus/cabinet-paths'
    `'List Chorus cabinet drawer'
    %-  some
    '''
    List every slip under one path of the Chorus cabinet,
    ours and those the ships we poll list. The path is a
    cabinet path prefix, such as projects/chorus. Returns a
    nested object mirroring the tree: the slip at each node,
    if any, and its children by path segment. Each slip gives
    its author, time, FQSP and digest, and whether this ship
    holds its text.
    '''
    `'application/json'
    ~
    `[~ ~ ~]
==
