#!/bin/bash

# cd to the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

if [ ! -d /usr/bin/dotnet ]; then
  echo 'Installing dotnet...'
  sudo mkdir -p /usr/bin/dotnet && sudo tar zxf dotnet-sdk-*.tar.gz -C /usr/bin/dotnet
  echo "rpi dotnet install status: $?"
  [ ! -f /etc/profile.d/dotnet-exports.sh ] && sudo cp dotnet-exports.sh /etc/profile.d
else
  echo 'dotnet already installed'
  echo 'Note: if you want to install multiple (side by side) versions you will have to do this manually'
fi

if [ ! -d /usr/bin/vsdbg ]; then
  echo 'Installing debugger (vsdbg)...'
  [ ! -d /usr/bin/vsdbg/ ] && curl -sSL https://aka.ms/getvsdbgsh | sudo /bin/sh /dev/stdin -v latest -l /usr/bin/vsdbg
  echo "rpi vsdbg install status: $?"
else
  echo 'debugger already installed'
fi
