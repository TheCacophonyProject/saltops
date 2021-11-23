device-register-pkg:
  cacophony.pkg_installed_from_github:
    - name: device-register
    - version: "1.4.1"

device-register-service:
  service.enabled:
    - name: device-register
    - onchanges:
      - device-register-pkg
