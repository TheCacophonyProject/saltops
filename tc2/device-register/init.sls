device-register-pkg:
  cacophony.pkg_installed_from_github:
    - name: device-register
    - version: "1.5.2"

/etc/systemd/system/device-register.service.d:
  file.directory

# This will set the prefix to tc2 instead of the default pi
/etc/systemd/system/device-register.service.d/overwrite.conf:
  file.managed:
    - source: salt://tc2/device-register/overwrite.conf

device-register-service:
  service.enabled:
    - name: device-register
    - onchanges:
      - device-register-pkg

