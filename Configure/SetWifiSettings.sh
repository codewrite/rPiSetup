  #!/bin/bash

echo "Executing command with params: $1 $2 $3 $4 $5"

if [ $# -ne 2 ]; then
  echo "Wrong number of arguments, got $# expected 2"
  echo ''
  echo 'Usage:  SetWifiSettings.sh <ssid> <psk>'
  echo ''
  echo 'Example 1: SetWifiSettings.sh myRaspberryPi'
else
  sed -i "s@\("'"'"wifi\.Ssid"'"'"[ \t]*:[ \t]*"'"'"\)[^\"]*\("'"'"\)@\1$1\2@g" .vscode/settings.json
  sed -i "s@\("'"'"wifi\.Psk"'"'"[ \t]*:[ \t]*"'"'"\)[^\"]*\("'"'"\)@\1$2\2@g" .vscode/settings.json
fi
