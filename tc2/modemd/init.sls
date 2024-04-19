dnsutils:
  pkg.installed: []

# debian package that manages modems, we are using our own package so disabling this will probably help.
stop_modem_manager:
  service.dead:
    - name: ModemManager
    - enable: False

modemd-pkg:
  cacophony.pkg_installed_from_github:
    - name: modemd
    - version: "1.7.11-tc2"

modemd:
  service.running:
    - enable: True
    - watch:
      - modemd-pkg
