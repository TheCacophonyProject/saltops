/boot/config.txt:
   file.managed:
     - source: salt://pi/config.txt.jinja
     - template: jinja

/etc/modules:
   file.managed:
     - source: salt://pi/modules

/etc/rsyslog.conf:
   file.managed:
     - source: salt://pi/rsyslog.conf

/etc/logrotate.d/rsyslog:
  file.managed:
    - source: salt://pi/rsyslog

/boot/cmdline.txt:
   file.replace:
      - pattern: "^(.(?!.*spidev.bufsiz).*)"
      - repl: "\\1 spidev.bufsiz=65536"

i2c-tools:
  pkg.installed: []

{% if not salt["grains.get"]("cacophony:hw:rev") %}
default-hw-rev:
  grains.present:
    - name: cacophony:hw:rev
    - value: 2
{% endif %}

/etc/sysctl.d/97-cacophony.conf:
  file.absent: []
