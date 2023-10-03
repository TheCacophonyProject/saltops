/usr/bin/energy-savings:
  file.managed:
    - source: salt://tc2/energy-savings/energy-savings
    - mode: 755

energy-savings-service-file:
  file.managed:
    - name: /etc/systemd/system/energy-savings.service
    - source: salt://tc2/energy-savings/energy-savings.service
    - mode: 644

energy-savings-daemon-reload:
  cmd.wait:
    - name: "systemctl daemon-reload"
    - watch:
      - energy-savings-service-file

energy-savings-service:
  service.enabled:
    - name: energy-savings
    - watch:
      - energy-savings-daemon-reload

/etc/systemd/system/basic.target.wants/hdmi-off.service:
   file.absent

/etc/systemd/system/hdmi-off.service:
   file.absent
