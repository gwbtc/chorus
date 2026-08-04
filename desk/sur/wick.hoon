|%
+$  nym  @t
::
::  hoon representation of a wire://, with a nym
::  that has either been verified or unverified
+$  wick
  $%  [%7 id=[=nym =ship] rot=@ud =flag =path sig=@uxJ]
  ==
::
::  intermediate wick, neither verified nor
::  unverified, just living in the moment
+$  wook
  $%  [%7 =ship rot=@ud =flag =path sig=@uxJ]
  ==
::
::  outcomes of checking a wick; %unknown is
::  not a bad wick, just unverifiable
+$  verdict
  $%  [%verified ~]
      [%unknown err=@t]
      [%failed err=@t]
  ==
::
::  wick handlers return a haul: the verification status
::  of the wick, and maybe also the content at that wick
+$  haul
  $:  =verdict
      content=(unit cage)
  ==
--
