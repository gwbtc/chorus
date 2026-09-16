::  MCP resource-template metadata delivery over %chorus-message.
/-  spider
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|%
++  ph-test-message-mcp-resource-template
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (prepare-pair %message-mcp-resource-template)
  ;<  ~  bind:m  (expect-bulla ship-b 0v50)
  ;<  ~  bind:m
    %:  publish-mcp
        ship-a
        %resource-template
        %chorus
        /fil/mcp/templates/rolodex/hoon
    ==
  (await-bulla ship-b 0v50 ship-a [%mcp-resource-template 'chorus/rolodex'])
--
