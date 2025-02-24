#!/bin/bash

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Script to tidy up the SD card to make it ready for making a new SD card image.
rm -r /var/spool/cptv/*

# Remove log files
rm -r /var/log/*
journalctl --vacuum-size=1

# Remove bash history
rm /home/pi/.bash_history

# Remove all NM connections apart from bushnet
find /etc/NetworkManager/system-connections/ -maxdepth 1 -type f ! -name 'bushnet.nmconnection' -exec rm {} +

# Remove events from the database
systemctl stop event-reporter
rm /var/lib/event-reporter.db

# Set hostname to "tc2-image"
hostnamectl set-hostname tc2-image

# Remove local salt data
systemctl stop salt-minion
rm -r /srv/salt/
rm -r /etc/salt/pki/
rm /etc/salt/minion_id

# Set to default salt grains
echo "environment: tc2-prod" > /etc/salt/grains

##### Delete files in /etc/cacophony apart from the ones in FILES_TO_KEEP
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

# Create config file
touch /etc/cacophony/config.toml

# Set location to Chch, this is so tc2-agent can run.
cacophony-config -w location.latitude=-43.5333 location.longitude=172.6333

# Set image datetime
date +"%Y-%m-%d %H:%M:%S" > /etc/cacophony/image-datetime
