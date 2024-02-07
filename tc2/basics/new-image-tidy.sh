#!/bin/bash

# Script to tidy up the SD card to make it ready for making a new SD card image.

rm -r /var/spool/cptv/*

rm /etc/cacophony/config.toml
touch /etc/cacophony/config.toml

rm -r /var/log/*
journalctl --vacuum-size=1

rm /home/pi/.bash_history

#cp /etc/wpa_supplicant/wpa_supplicant{_default,}.conf

systemctl stop event-reporter
rm /var/lib/event-reporter.db

hostnamectl set-hostname tc2-image

systemctl enable program-rp2040

systemctl stop salt-minion
rm -r /srv/salt/
rm -r /etc/salt/pki/
rm /etc/salt/minion_id
