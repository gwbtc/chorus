::  MCP tool metadata delivery over %chorus-message.
/-  spider
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|%
++  ph-test-message-mcp-tool
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (prepare-pair %message-mcp-tool)
  ;<  ~  bind:m  (expect-bulla ship-b 0v40)
  ;<  ~  bind:m
    (publish-mcp ship-a %tool %chorus /fil/mcp/tools/update-bio/hoon)
  (await-bulla ship-b 0v40 ship-a [%mcp-tool 'chorus/update-bio'])
--
