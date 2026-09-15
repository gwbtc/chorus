::  MCP prompt metadata delivery over %chorus-message.
/-  spider
/+  *ph-io, *ph-chorus
=,  strand=strand:spider
|%
++  ph-test-message-mcp-prompt
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (prepare-pair %message-mcp-prompt)
  ;<  ~  bind:m  (expect-bulla ship-b 0v60)
  ;<  ~  bind:m
    (publish-mcp ship-a %prompt %chorus /fil/mcp/prompts/example/hoon)
  (await-bulla ship-b 0v60 ship-a [%mcp-prompt 'chorus/example-prompt'])
--
