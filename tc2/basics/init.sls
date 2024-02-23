/boot/firmware/config.txt:
   file.managed:
     - source: salt://tc2/basics/config.txt
     - parallel: True

/etc/modules-load.d/i2c-module:
   file.managed:
     - source: salt://tc2/basics/i2c-module
     - parallel: True


/etc/systemd/journald.conf:
   file.managed:
     - source: salt://tc2/basics/journald.conf
     - parallel: True

#/etc/rsyslog.conf:
#   file.managed:
#     - source: salt://tc2/basics/rsyslog.conf
#     - parallel: True

#/etc/logrotate.d/rsyslog:
#  file.managed:
#    - source: salt://tc2/basics/rsyslog
#    - parallel: True

/boot/firmware/cmdline.txt:
   file.replace:
      - pattern: "^(.(?!.*spidev.bufsiz).*)"
      - repl: "\\1 spidev.bufsiz=65536"
      - parallel: True

i2c-tools:
  pkg.installed: []

/etc/sysctl.d/97-cacophony.conf:
  file.managed:
    - source: salt://tc2/basics/97-cacophony.conf
    -  mode: 644
    - parallel: True

/usr/bin/new-image-tidy.sh:
  file.managed:
    - source: salt://tc2/basics/new-image-tidy.sh
    - mode: 755
    - user: root
    - group: root
    - parallel: True

## TODO Remove all packages that are not needed.

## Disable automatic updates.
disable_apt_daily_timer:
  service.dead:
    - name: apt-daily.timer
    - enable: False
    - parallel: True

disable_apt_daily_upgrade_timer:
  service.dead:
    - name: apt-daily-upgrade.timer
    - enable: False
    - parallel: True
