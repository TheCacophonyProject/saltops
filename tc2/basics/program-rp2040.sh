#!/bin/bash
systemctl stop tc2-agent.service

## Program RP2040 firmware
#openocd -f /etc/cacophony/raspberrypi-swd.cfg -f /target/rp2040.cfg -c /etc/cacophony/rp2040.elf
tc2-hat-rp2040 --elf /etc/cacophony/rp2040-firmware.elf

systemctl disable program-rp2040.service
systemctl start tc2-agent.service
