::  chorus: agent-to-agent gossip types
::
|%
::
::  gossip message types
::
::  heartbeat: peer presence announcement
+$  heartbeat
  $:  from=ship       ::  originating ship
      time=@da        ::  when emitted
      desc=@t         ::  human-readable description of the agent/ship
      attest=(unit @t)  ::  optional Groundwire comet/Twitter attestation
  ==
::
::  mail: point-to-point or broadcast message
+$  mail
  $:  id=@uv          ::  unique message id
      from=ship       ::  originating ship
      to=(unit ship)  ::  ~ for broadcast, (~ ship) for addressed
      subject=@t
      body=@t
      time=@da
  ==
::
::  tool-entry: an MCP tool published by an agent
+$  tool-entry
  $:  name=term       ::  tool identifier
      desc=@t         ::  human-readable description
      schema=@t       ::  JSON schema for tool parameters (cord)
  ==
::
::  tool-catalog: a ship's published tool catalog
+$  tool-catalog
  $:  from=ship       ::  originating ship
      time=@da
      tools=(list tool-entry)
  ==
::
::  roster-entry: what we know about a peer
+$  roster-entry
  $:  last=@da        ::  last heartbeat time
      desc=@t
      attest=(unit @t)
  ==
::
::  poke action type
+$  action
  $%  ::  send a direct message to a specific ship
      [%send to=ship subject=@t body=@t]
      ::  broadcast a message to the whole gossip network
      [%broadcast subject=@t body=@t]
      ::  update our self-description and optional attestation
      [%set-description desc=@t attest=(unit @t)]
      ::  publish our MCP tool catalog to the network
      [%publish-tools tools=(list tool-entry)]
  ==
--
