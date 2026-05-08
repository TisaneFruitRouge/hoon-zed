::  hello.hoon - sample to verify Zed Hoon highlighting
::
::  comments use the runic '::' double colon
::
|=  [name=@t count=@ud]
^-  tape
=/  greeting=tape  "hello, "
%+  weld  greeting
%+  weld  (trip name)
?:  =(count 1)
  "!"
"!!"
