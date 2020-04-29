#!/bin/bash

echo "Executing command with params: $1 $2 $3 $4 $5"

function runCmd() {
    # Sometimes the commands fail the first time - so this function runs them again if necessary
    for i in {0..1}; do
      if [ "$3" == '' ]; then
        $1 $2
      else
        $1 $2 $3
      fi
      [ $? -eq 0 ] && break
    done
}

if [ $# -ne 2 ] && [ $# -ne 3 ]; then
  echo 'Wrong number of arguments, got $# expected 2 or 3'
  echo ''
  echo 'Usage:  sshConfigure.sh <initialHostName> <newHostName> [<static ip address>]'
  echo ''
  echo 'Example 1: sshConfigure.sh raspberrypi myPi1'
  echo 'Example 2: sshConfigure.sh 192.168.1.23 myPi1 192.168.1.100'
else
  echo 'Answer "yes" to the next question (authenticity of host can'"'"'t be establihed).'
  echo 'When asked for a password, the default raspberrypi password is "raspberry"'
  runCmd ssh-copy-id pi@$1
  if [ "$?" != '0' ]; then
    echo "Failed. Things to try:"
    echo "1. Connect using ip address for initialHostName"
  else
    remotePwd=$(runCmd ssh "pi@$1 -o NumberOfPasswordPrompts=0" "pwd")
    if [ "$remotePwd" != '/home/pi' ]; then
      echo "remotePwd = $remotePwd"
      echo "Failed. Things to try:"
      echo "1. Connect using ip address for initialHostName"
    else
      if [[ "$1" =~ ([0-9]+\.){3}[0-9]+ ]]; then
        hostname="raspberrypi"
      else
        hostname="$1"
      fi
      # This will disable login with a password. It is also recommended to change the password on the pi with the "passwd" command
      runCmd ssh pi@$1 "sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config"
      echo "disable password ssh status: $?"
      if [ "$3" != '' ]; then
        inform=$(runCmd ssh pi@$1 'cat /etc/dhcpcd.conf | grep "^inform[ \t]+\([0-9]\+\.\)\{3\}\([0-9]\+\)\{3\}"')    
        if [ "$inform" == '' ]; then
          runCmd ssh pi@$1 "echo -e "'"'"\ninform $3"'"'" >> /etc/dhcpcd.conf"
          echo "static ip ssh status: $?"
          echo "Don't forget to add $2 to your hosts file"
        fi
      fi
      echo  'Ignore any errors that say things like "unable to resolve host '"$hostname"'"'
      runCmd ssh pi@$1 "sudo sed -i 's/$hostname/$2/g' /etc/hostname && sudo sed -i 's/$hostname/$2/g' /etc/hosts && sudo reboot now"
      echo "rename pi ssh status: $?"
      sed -i "s/^$1/$2/g" ~/.ssh/known_hosts
      echo 'Success. You now need to wait for the Raspberry Pi to reboot. After it has rebooted you should be able to login with "ssh pi@'"$2"'"'
    fi
  fi
fi
