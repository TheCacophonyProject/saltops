#!/bin/bash

set -e
set -o pipefail

echo "Running new-image-tidy.sh"

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "Removing old files in /var/spool/cptv"
rm -rf /var/spool/cptv/*

echo "Removing log files"
rm -rf /var/log/*
journalctl --vacuum-size=1

echo "Removing bash history"
rm -f /home/pi/.bash_history

echo "Removing NetworkManager connections apart from bushnet"
find /etc/NetworkManager/system-connections/ -maxdepth 1 -type f ! -name 'bushnet.nmconnection' -exec rm {} +

echo "Deleting events database"
systemctl stop event-reporter
rm -f /var/lib/event-reporter.db

echo "Setting up salt for a fresh install"
# Stop service from running
systemctl stop salt-minion
# Remove salt files that are copied when doing local updates
rm -rf /srv/salt/
# Remove salt pki files so a new key will ge generated
rm -rf /etc/salt/pki/
# Remove salt minion id so a new id will be generated
rm -f /etc/salt/minion_id
# Remove salt grains and set to default
rm -f /etc/salt/grains
echo "environment: tc2-prod" > /etc/salt/grains

echo "Cleaning up files in /etc/cacophony"
FILES_TO_KEEP=(
  "salt-states-count"
  "attiny-firmware.hex"
  "rp2040-firmware.elf"
  "salt-nodegroup"
  "raspberrypi-swd.cfg"
)

# Create an associative array for quick lookup
declare -A KEEP_FILES_MAP
for file in "${FILES_TO_KEEP[@]}"; do
    KEEP_FILES_MAP["$file"]=1
done

# Iterate over all files in the target directory
for file in /etc/cacophony/*; do
    filename=$(basename "$file")
    
    # Check if the file is in the keep list
    if [[ ! ${KEEP_FILES_MAP[$filename]+_} ]]; then
        echo "Deleting: $file"
        rm -f "$file"
    fi
done

echo "Creating config.toml"
touch /etc/cacophony/config.toml

echo "Setting location to Chch, New Zealand"
cacophony-config -w location.latitude=-43.5333 location.longitude=172.6333

echo "Making /etc/cacophony/program_rp2040"
# Stop tc2-agent from running so it won't reprogram the RP2040
systemctl stop tc2-agent
touch /etc/cacophony/program_rp2040

echo "Setting hostname to tc2-image"
hostnamectl set-hostname tc2-image

datetime=$(date +"%Y-%m-%d %H:%M:%S")
echo "Setting image-datetime to $datetime"
echo $datetime > /etc/cacophony/image-datetime

echo "new-image-tidy.sh finished!"
echo "Power off camera, put SD card in computer and run 'image-finalise.sh'"
