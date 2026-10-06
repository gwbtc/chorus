/-  mcp
^-  template:resource:mcp
:*  'scry://gx/chorus/cabinet/drawer/{+path}/json'
    'chorus/cabinet-drawer'
    `'Read Chorus cabinet drawer'
    %-  some
    '''
    Read every slip under one path of the Chorus cabinet
    whose text this ship holds: ours, and those fetched
    with chorus/fetch-slips. The path is a cabinet path
    prefix, such as projects/chorus. Returns a nested object
    mirroring the tree: the slip at each node, if any,
    and its children by path segment.
    '''
    `'application/json'
    ~
    `[~ ~ ~]
==
