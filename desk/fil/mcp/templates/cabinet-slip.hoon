/-  mcp
^-  template:resource:mcp
:*  'scry://gx/chorus/cabinet/slip/{+path}/json'
    'chorus/cabinet-slip'
    `'Read Chorus slip'
    %-  some
    '''
    Read one slip from the Chorus cabinet. The path is
    the cabinet path of the slip, such as projects/chorus/notes.
    Returns the slip body with its ship, creation time,
    FQSP, and links. Finds nothing for another ship's slip
    until chorus/fetch-slips has fetched its text.
    '''
    `'application/json'
    ~
    `[~ ~ ~]
==
