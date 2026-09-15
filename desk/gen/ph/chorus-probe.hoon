::
::  Test-only guest probe for Chorus Aqua tests.  Keep the typed scry and
::  comparison inside the virtual ship; only [id success] crosses Dill.
::
/-  *chorus
:-  %say
|=  $:  [now=@da eny=@uvJ bec=beak]
        $:  id=@uv
            from=ship
            kind=?(%bio %announcement %mcp-tool %mcp-prompt %mcp-resource %mcp-resource-template)
            value=@t
            ~
        ==
        ~
    ==
=/  pre=path  /(scot %p p.bec)/chorus/(scot %da now)
=/  ok=?
  ?-  kind
    %bio
      =/  listings=(set listing:bio)
        .^((set listing:bio) %gx (weld pre /rolodex/noun))
      (~(any in listings) |=(lit=listing:bio &(=(from ship.id.wick.lit) =(value txt.lit))))
    %announcement
      =/  listings=(set listing:announcement)
        .^((set listing:announcement) %gx (weld pre /announcements/noun))
      (~(any in listings) |=(lit=listing:announcement &(=(from ship.id.wick.lit) =(value txt.lit))))
    %mcp-tool
      =/  listings=(set listing:tool:mcp)
        .^((set listing:tool:mcp) %gx (weld pre /mcp-tools/noun))
      (~(any in listings) |=(lit=listing:tool:mcp &(=(from ship.id.wick.lit) =(value name.meta.lit))))
    %mcp-prompt
      =/  listings=(set listing:prompt:mcp)
        .^((set listing:prompt:mcp) %gx (weld pre /mcp-prompts/noun))
      (~(any in listings) |=(lit=listing:prompt:mcp &(=(from ship.id.wick.lit) =(value name.meta.lit))))
    %mcp-resource
      =/  listings=(set listing:resource:mcp)
        .^((set listing:resource:mcp) %gx (weld pre /mcp-resources/noun))
      (~(any in listings) |=(lit=listing:resource:mcp &(=(from ship.id.wick.lit) =(value name.meta.lit))))
    %mcp-resource-template
      =/  listings=(set listing:template:resource:mcp)
        .^((set listing:template:resource:mcp) %gx (weld pre /mcp-resource-templates/noun))
      (~(any in listings) |=(lit=listing:template:resource:mcp &(=(from ship.id.wick.lit) =(value name.meta.lit))))
  ==
[%noun [id ok]]
