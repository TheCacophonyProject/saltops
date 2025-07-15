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
    - version: "1.14.1-tc2"
    - architecture: "arm64"
    - branch: "tc2"

modemd:
  service.running:
    - enable: True

# This will trigger a restart of modemd 60 seconds after it is run (should be the last thing to run in a salt update)
# Should hopefully prevent modemd restart during a salt update, preventing the internet dropping out.
delayed_restart_modemd:
  cmd.run:
    - name: >
        systemd-run --unit=delayed-modemd-restart.service
        --on-active=60s
        /bin/systemctl restart modemd
    - shell: /bin/bash
    - onchanges:
      - cacophony: modemd-pkg
    - order: last

/etc/modprobe.d/usbserial.conf:
   file.managed:
     - source: salt://tc2/modemd/usbserial.modprobe.conf
