::  MCP resource listing delivery.
/-  spider
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|%
++  ph-test-message-mcp-resource
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  prepare-pair
  ;<  ~  bind:m
    (publish-mcp ship-a %resource %chorus /fil/mcp/resources/example/hoon)
  ;<  ~  bind:m  (expect-update ship-b 0v42)
  ;<  ~  bind:m  (poll ship-b ship-a)
  (await-update ship-b 0v42 ship-a [%mcp-resource 'chorus/example-resource'])
--
