rpi-net-manager-pkg:
  cacophony.pkg_installed_from_github:
    - name: rpi-net-manager
    - version: "0.1.4"
    - architecture: "arm64"

rpi-net-manager-service:
  service.running:
    - name: rpi-net-manager
    - enable: True
