#!/bin/bash

# cd to the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

echo 'Installing dotnet...'
sudo mkdir -p /usr/bin/dotnet && sudo tar zxf dotnet-sdk-*.tar.gz -C /usr/bin/dotnet
echo "rpi dotnet install status: $?"
[ ! -f /etc/profile.d/dotnet-exports.sh ] && sudo cp dotnet-exports.sh /etc/profile.d

echo 'Installing debugger (vsdbg)...'
[ ! -d /usr/bin/vsdbg/ ] && curl -sSL https://aka.ms/getvsdbgsh | sudo /bin/sh /dev/stdin -v latest -l /usr/bin/vsdbg
echo "rpi vsdbg install status: $?"
