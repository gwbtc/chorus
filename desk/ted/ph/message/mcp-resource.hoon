::  MCP resource metadata delivery over %chorus-message.
/-  spider
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|%
++  ph-test-message-mcp-resource
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (prepare-pair %message-mcp-resource)
  ;<  ~  bind:m  (expect-bulla ship-b 0v70)
  ;<  ~  bind:m
    (publish-mcp ship-a %resource %chorus /fil/mcp/resources/example/hoon)
  (await-bulla ship-b 0v70 ship-a [%mcp-resource 'chorus/example-resource'])
--
