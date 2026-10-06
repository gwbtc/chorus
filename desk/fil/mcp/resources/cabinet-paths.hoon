/-  mcp
^-  resource:mcp
:*  'scry://gx/chorus/cabinet/paths/json'
    'chorus/cabinet-paths'
    `'List Chorus cabinet'
    %-  some
    '''
    List every slip in the Chorus cabinet, ours and those
    the ships we poll list, as a nested object mirroring the
    tree: the slip at each node, if any, and its children by
    path segment. Each slip gives its author, time, FQSP and
    digest, and whether this ship holds its text. Fetch the
    text of slips it does not hold with chorus/fetch-slips.
    '''
    `'application/json'
    ~
    ~
==
