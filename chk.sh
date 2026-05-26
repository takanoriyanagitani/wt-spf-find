#!/bin/sh

header2spf(){
  cat /dev/stdin |
    node ./find.mjs
}

echo none:
echo 'Authentication-Results: dummy.example.com
  spf=none 
' | header2spf

echo neutral:
echo 'Authentication-Results: dummy.example.com
  SPF=none 
  spf=neutral
' | header2spf

echo pass:
echo 'Authentication-Results: dummy.example.com
  SPF=none 
  spf=pass
' | header2spf

echo temperror:
echo 'Authentication-Results: dummy.example.com
  SPF=none 
  spf=temperror
' | header2spf
