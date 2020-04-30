#!/bin/bash

function runCmd() {
    # Sometimes the commands fail the first time - so this function runs them again if necessary
    for i in {0..1}; do
      $1 $2 $3
      [ $? -eq 0 ] && break
    done
}

echo "Executing command with params: $1 $2 $3 $4 $5"

if [ $# -ne 2 ]; then
  echo "Wrong number of arguments, got $# expected 2"
  echo ''
  echo 'Usage:  publish.sh <projectName> <piName>'
  echo ''
  echo 'Example 1: publish.sh testApp myPi1'
else
  pushd "./DotnetProjects/$1/bin/Debug/netcoreapp3.1"

  runCmd ssh pi@$2 "mkdir ~/RemoteDebug/$1 -p"
  echo "mkdir ssh status: $?"
  runCmd scp "-r ./*" pi@$2:RemoteDebug/$1
  echo "dll scp status: $?"

  popd
fi
