#!/bin/bash

# Script to tidy up the SD card to make it ready for making a new SD card image.

rm -r /var/spool/cptv/*

rm /etc/cacophony/config.toml
touch /etc/cacophony/config.toml

# Set location to Chch, this is so tc2-agent can run.
sudo cacophony-config -w location.latitude=-43.5333 location.longitude=172.6333

rm -r /var/log/*
journalctl --vacuum-size=1

rm /home/pi/.bash_history

# Remove all NM connections apart from bushnet
find /etc/NetworkManager/system-connections/ -maxdepth 1 -type f ! -name 'bushnet.nmconnection' -exec rm {} +

systemctl stop event-reporter
rm /var/lib/event-reporter.db

hostnamectl set-hostname tc2-image

systemctl stop salt-minion
rm -r /srv/salt/
rm -r /etc/salt/pki/
rm /etc/salt/minion_id
