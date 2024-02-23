/boot/firmware/config.txt:
   file.managed:
     - source: salt://tc2/basics/config.txt

/etc/modules-load.d/i2c-module:
   file.managed:
     - source: salt://tc2/basics/i2c-module


/etc/systemd/journald.conf:
   file.managed:
     - source: salt://tc2/basics/journald.conf

/boot/firmware/cmdline.txt:
   file.replace:
      - pattern: "^(.(?!.*spidev.bufsiz).*)"
      - repl: "\\1 spidev.bufsiz=65536"

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
