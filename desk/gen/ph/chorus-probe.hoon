::
::  Test-only guest probe for Chorus Aqua tests.  Keep the typed scry and
::  comparison inside the virtual ship; only [id success] crosses Dill.
::
/-  *chorus
:-  %say
|=  $:  [now=@da eny=@uvJ bec=beak]
        $:  id=@uv
            from=ship
            $=  kind
            $?  %bio
                %announcement
                %mcp-tool
                %mcp-prompt
                %mcp-resource
                %mcp-resource-template
                %slip
            ==
            value=@t
            pax=path
            ~
        ==
        ~
    ==
=/  pre=path  /(scot %p p.bec)/chorus/(scot %da now)
=/  ok=?
  ?-  kind
    %bio
      %-  ~(any in .^((set listing:bio) %gx (weld pre /chorus/rolodex/noun)))
      |=(lit=listing:bio &(=(from ship.lit) =(value txt.lit)))
    %announcement
      %-  %~  any  in
          .^  (set listing:announcement)
              %gx
              (weld pre /chorus/announcements/noun)
          ==
      |=(lit=listing:announcement &(=(from ship.lit) =(value txt.lit)))
    %mcp-tool
      %-  %~  any  in
          .^((set listing:tool:mcp) %gx (weld pre /chorus/mcp/tools/noun))
      |=(lit=listing:tool:mcp &(=(from ship.lit) =(value name.meta.lit)))
    %mcp-prompt
      %-  %~  any  in
          .^((set listing:prompt:mcp) %gx (weld pre /chorus/mcp/prompts/noun))
      |=(lit=listing:prompt:mcp &(=(from ship.lit) =(value name.meta.lit)))
    %mcp-resource
      %-  %~  any  in
          .^  (set listing:resource:mcp)
              %gx
              (weld pre /chorus/mcp/resources/noun)
          ==
      |=(lit=listing:resource:mcp &(=(from ship.lit) =(value name.meta.lit)))
    %mcp-resource-template
      %-  %~  any  in
          .^  (set listing:template:resource:mcp)
              %gx
              (weld pre /chorus/mcp/resources/templates/noun)
          ==
      |=  lit=listing:template:resource:mcp
      &(=(from ship.lit) =(value name.meta.lit))
    %slip
      =/  got=(unit slip)
        (~(get of .^(cabinet %gx (weld pre /cabinet/drawer/noun))) pax)
      ?~  got  |
      &(=(from ship.u.got) =(value txt.u.got))
  ==
[%noun [id ok]]
