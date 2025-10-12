rpi-net-manager-pkg:
  cacophony.pkg_installed_from_github:
    - name: rpi-net-manager
    - version: "0.7.0"
    - architecture: "arm64"

rpi-net-manager-service:
  service.running:
    - name: rpi-net-manager
    - enable: True

hostapd:
  pkg.installed

