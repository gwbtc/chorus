::
::  Peek a virtual ship's gall grow (farm) namespace through
::  %aqua: +chorus!scry-farm ~fasteg... /announcements ~2026...
::
::  The farm serves care %x, case ud+1, at the vane route
::  [%$ '1' spur da], mirroring /fine/<ship>/g/x/1/<dap>//1/...
::
:-  %say
|=  [[now=@da @ bec=beak] [who=ship care=?(%w %x) spur=path wen=@da ~] ~]
:-  %noun
?:  =(%w care)
  ?:  =(who p.bec)
    =/  pax=path
      ;:  weld
        /(scot %p p.bec)/chorus/(scot %da now)
        `path`[%$ ~.1 ~]
        spur
      ==
    [pax .^(* %gw pax)]
  ::  aqua's +peek stamps the case segment with the pier's own
  ::  last event time, which is what care %w wants anyway
  ::
  =/  pax=path
    ;:  weld
      /(scot %p p.bec)/aqua/(scot %da now)
      /i/(scot %p who)/gw/(scot %p who)/chorus/(scot %da now)
      `path`[%$ ~.1 ~]
      spur
    ==
  [pax .^(* %gx pax)]
=/  pax=path
  ?:  =(who p.bec)
    ;:  weld
      /(scot %p p.bec)/chorus/1
      `path`[%$ ~.1 ~]
      spur
      /(scot %da wen)
    ==
  ;:  weld
    /(scot %p p.bec)/aqua/(scot %da now)
    /i/(scot %p who)/gx/(scot %p who)/chorus/1
    `path`[%$ ~.1 ~]
    spur
    /(scot %da wen)
  ==
[pax .^(* %gx pax)]
