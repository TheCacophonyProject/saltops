#!/bin/bash

# Script to tidy up the SD card to make it ready for making a new SD card image.

sudo rm -r /var/spool/cptv/*

sudo rm /etc/cacophony/config.toml
sudo touch /etc/cacophony/config.toml

sudo rm -r /var/log/*
sudo journalctl --vacuum-size=1

sudo rm /home/pi/.bash_history

## TODO clean WIFI networks from the SD card

sudo hostnamectl set-hostname tc2-image

sudo systemctl enable program-rp2040

sudo systemctl disable salt-minion
sudo -r /srv/salt/
sudo rm -r /etc/salt/pki/
sudo rm /etc/salt/minion_id
