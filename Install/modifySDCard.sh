#!/bin/bash

echo "Executing command with params: $1 $2 $3 $4 $5"

if [ $# -ne 3 ]; then
  echo "Wrong number of arguments, got $# expected 3"
  echo ''
  echo 'Usage:  modifySDCard.sh <drive> <ssid> <passkey>'
  echo ''
  echo 'Example 1: modifySDCard.sh /d BT1234 wifikey'
  echo 'Example 2: modifySDCard.sh /mnt/d "My router" wifikey'
else
  if [ -f $1/bootcode.bin ] && [ ! -f $1/ssh ] && [ ! -f $1/wpa_supplicant.conf ] && ls $1/*rpi*.* 1> /dev/null 2>&1; then
    touch $1/ssh
    sed -e "s/your-ssid/$2/g" -e "s/your-psk/$3/g" <PiFiles/wpa_supplicant-template.conf >$1/wpa_supplicant.conf
    echo 'Success. Unmount (or eject) the SD card'
    echo 'Insert card into Raspberry Pi and power up. Wait for the Pi to start and then run sshConfigure'
    echo 'Note: Before running sshConfigure, create a settings.json file with your router ssid and psk'
  else
    echo "Failed. Could not find a Pi image in drive $Drv or card is already modified"
    echo "If the card has just been written it may have been unmounted by the imaging program - try reinserting it"
  fi
fi
