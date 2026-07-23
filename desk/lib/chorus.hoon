/-  mcp, *chorus, *wick
|%
++  tool-meta
  |=  =tool:mcp
  ^-  mcp-tool-metadata
  :*  name.tool
      desc.tool
      parameters.tool
      required.tool
  ==
::
++  prompt-meta
  |=  =prompt:mcp
  ^-  mcp-prompt-metadata
  :*  name.prompt
      title.prompt
      desc.prompt
      arguments.prompt
  ==
::
++  resource-meta
  |=  =resource:mcp
  ^-  mcp-resource-metadata
  :*  uri.resource
      name.resource
      title.resource
      desc.resource
  ==
::
++  resource-template-meta
  |=  =template:resource:mcp
  ^-  mcp-resource-template-metadata
  :*  uri-template.template
      name.template
      title.template
      desc.template
  ==
--
