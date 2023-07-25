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
  file.managed:
    - source: salt://tc2/basics/cmdline.txt

i2c-tools:
  pkg.installed: []

/etc/sysctl.d/97-cacophony.conf:
  file.managed:
    - source: salt://tc2/basics/97-cacophony.conf
    -  mode: 644
