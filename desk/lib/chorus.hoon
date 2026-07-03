/-  mcp, *chorus, *wick
|%
++  list-mcp-tool
  |=  =tool:mcp
  ^-  mcp-tool-listing
  :*  name.tool
      desc.tool
      parameters.tool
      required.tool
      *wick
  ==
::
++  list-mcp-prompt
  |=  =prompt:mcp
  ^-  mcp-prompt-listing
  :*  name.prompt
      title.prompt
      desc.prompt
      arguments.prompt
      *wick
  ==
::
++  list-mcp-resource
  |=  =resource:mcp
  ^-  mcp-resource-listing
  :*  uri.resource
      name.resource
      title.resource
      desc.resource
      *wick
  ==
::
++  list-mcp-resource-template
  |=  =template:resource:mcp
  ^-  mcp-resource-template-listing
  :*  uri-template.template
      name.template
      title.template
      desc.template
      *wick
  ==
--
