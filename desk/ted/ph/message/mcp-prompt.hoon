::  MCP prompt listing delivery.
/-  spider
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|%
++  ph-test-message-mcp-prompt
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  prepare-pair
  ;<  ~  bind:m
    (publish-mcp ship-a %prompt %chorus /fil/mcp/prompts/example/hoon)
  ;<  ~  bind:m  (expect-update ship-b 0v41)
  ;<  ~  bind:m  (poll ship-b ship-a)
  (await-update ship-b 0v41 ship-a [%mcp-prompt 'chorus/example-prompt'])
--
