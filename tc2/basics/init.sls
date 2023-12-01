/boot/config.txt:
   file.managed:
     - source: salt://tc2/basics/config.txt

/etc/modules:
   file.managed:
     - source: salt://tc2/basics/modules

/etc/rsyslog.conf:
   file.managed:
     - source: salt://tc2/basics/rsyslog.conf

/etc/logrotate.d/rsyslog:
  file.managed:
    - source: salt://tc2/basics/rsyslog

/boot/cmdline.txt:
   file.replace:
      - pattern: "^(.(?!.*spidev.bufsiz).*)"
      - repl: "\\1 spidev.bufsiz=65536"

## Remove console output to serial so it can be used instead for programming the ATtiny
remove_console_from_cmdline:
  file.replace:
    - name: /boot/cmdline.txt
    - pattern: "console=serial0,115200"
    - repl: ""

i2c-tools:
  pkg.installed: []

/etc/sysctl.d/97-cacophony.conf:
  file.managed:
    - source: salt://tc2/basics/97-cacophony.conf
    -  mode: 644

/usr/bin/new-image-tidy.sh:
  file.managed:
    - source: salt://tc2/basics/new-image-tidy.sh
    - mode: 755
    - user: root
    - group: root

## Remove program-rp2040 when tc2-agent handels the programming of the chip properly.
/usr/bin/program-rp2040.sh:
  file.managed:
    - source: salt://tc2/basics/program-rp2040.sh
    - mode: 755
    - user: root
    - group: root

/etc/systemd/system/program-rp2040.service:
  file.managed:
    - source: salt://tc2/basics/program-rp2040.service
    - user: root
    - group: root
    - mode: 644

## TODO Remove all packages that are not needed.

## Disable automatic updates.
disable_apt_daily_timer:
  service.dead:
    - name: apt-daily.timer
    - enable: False

disable_apt_daily_upgrade_timer:
  service.dead:
    - name: apt-daily-upgrade.timer
    - enable: False
