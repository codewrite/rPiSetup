#!/bin/bash

function runCmd() {
    # Sometimes the commands fail the first time - so this function runs them again if necessary
    for i in {0..1}; do
      $1 $2 $3
      [ $? -eq 0 ] && break
    done
}

echo "Executing command with params: $1 $2 $3 $4 $5"

if [ $# -ne 1 ]; then
  echo "Wrong number of arguments, got $# expected 1"
  echo ''
  echo 'Usage:  dotnetInstall.sh <piName>'
  echo ''
  echo 'Example 1: dotnetInstall.sh myPi1'
else
  pushd PiFiles

  numDotnetFiles=$(ls -l dotnet-sdk-*.tar.gz | wc -l)
  if [ $numDotnetFiles -eq 0 ]; then
    echo 'There should be a file matching "dotnet-sdk-*.tar.gz" in the PiFiles folder'
    echo 'Download the latest from "https://dotnet.microsoft.com/download/dotnet-core" (the Linux ARM32 version)'
  elif [ $numDotnetFiles -ne 1 ]; then
    echo 'There should only be one file matching "dotnet-sdk-*.tar.gz" in the PiFiles folder'
    echo 'Please delete the others'
  else
    dos2unix *.sh *.conf
    runCmd ssh pi@$1 "mkdir -p dotnetSetup"
    echo "mkdir ssh status: $?"
    runCmd scp "piDotnetInstall.sh dotnet-sdk-*.tar.gz dotnet-exports.sh" pi@$1:dotnetSetup
    echo "scp status: $?"
    runCmd ssh pi@$1 "chmod +x dotnetSetup/piDotnetInstall.sh && dotnetSetup/piDotnetInstall.sh"
    echo "install dotnet ssh status: $?"
    runCmd ssh pi@$1 "rm dotnetSetup/* && rmdir dotnetSetup"
    echo "Setup Complete."
  fi

  popd
fi
