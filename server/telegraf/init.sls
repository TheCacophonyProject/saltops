{% from "server/telegraf/map.jinja" import telegraf with context %}

telegraf_pkg:
  pkg.installed:
    - sources:
      - telegraf: https://dl.influxdata.com/telegraf/releases/telegraf_{{ telegraf.version }}_amd64.deb

/etc/telegraf/telegraf.conf:
  file.managed:
    - source: salt://server/telegraf/telegraf.conf.jinja
    - template: jinja

telegraf-daemon-reload:
  cmd.wait:
    - name: "systemctl daemon-reload"
    - watch:
       - telegraf_pkg

telegraf-service:
  service.running:
    - name: telegraf
    - enable: True
    - watch:
      - /etc/telegraf/telegraf.conf
      - telegraf-daemon-reload
