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
