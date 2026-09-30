::  MCP resource-template listing delivery.
/-  spider
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|%
++  ph-test-message-mcp-resource-template
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  prepare-pair
  ;<  ~  bind:m
    (publish-mcp ship-a %resource-template %chorus /fil/mcp/templates/rolodex/hoon)
  ;<  ~  bind:m  (expect-update ship-b 0v43)
  ;<  ~  bind:m  (poll ship-b ship-a)
  (await-update ship-b 0v43 ship-a [%mcp-resource-template 'chorus/rolodex'])
--
