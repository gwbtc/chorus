/-  mcp
^-  template:resource:mcp
:*  'scry://gx/chorus/cabinet/paths/{+path}/json'
    'chorus/cabinet-paths'
    `'List Chorus cabinet drawer'
    %-  some
    '''
    List every slip under one path of the Chorus cabinet
    with its body blanked. The path is a cabinet path prefix,
    such as projects/chorus. Returns a nested object mirroring
    the tree: the slip at each node, if any, and its children
    by path segment.
    '''
    `'application/json'
    ~
    `[~ ~ ~]
==
