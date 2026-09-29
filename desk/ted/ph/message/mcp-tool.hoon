::  MCP tool listing delivery.
/-  spider
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|%
++  ph-test-message-mcp-tool
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  prepare-pair
  ;<  ~  bind:m
    (publish-mcp ship-a %tool %chorus /fil/mcp/tools/update-bio/hoon)
  ;<  ~  bind:m  (expect-update ship-b 0v40)
  ;<  ~  bind:m  (poll ship-b ship-a)
  (await-update ship-b 0v40 ship-a [%mcp-tool 'chorus/update-bio'])
--
