  #!/bin/bash

echo "Executing command with params: $1 $2 $3 $4 $5"

if [ $# -ne 1 ] && [ $# -ne 2 ]; then
  echo "Wrong number of arguments, got $# expected 1 or 2"
  echo ''
  echo 'Usage:  SetRaspberryPiSettings.sh <piName>'
  echo ''
  echo 'Example 1: SetRaspberryPiSettings.sh myRaspberryPi'
else
  if [ ! -f .vscode/settings.json ]; then
    cp .vscode/settings.json-example .vscode/settings.json
    sed -i "s@//.*@@g" .vscode/settings.json
  fi
  sed -i "s@\("'"'"rpi\.Name"'"'"[ \t]*:[ \t]*"'"'"\)[^\"]*\("'"'"\)@\1$1\2@g" .vscode/settings.json
  sed -i "s@\("'"'"rpi\.StaticIpAddress"'"'"[ \t]*:[ \t]*"'"'"\)[^\"]*\("'"'"\)@\1$2\2@g" .vscode/settings.json
fi
