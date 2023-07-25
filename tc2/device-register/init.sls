device-register-pkg:
  cacophony.pkg_installed_from_github:
    - name: device-register
    - version: "1.4.1"

/etc/systemd/system/device-register.service.d:
  file.directory

/etc/systemd/system/device-register.service.d/device-register-overwrite.service:
  file.managed:
    - source: salt://tc2/device-register/device-register-overwrite.service

device-register-service:
  service.enabled:
    - name: device-register
    - onchanges:
      - device-register-pkg

