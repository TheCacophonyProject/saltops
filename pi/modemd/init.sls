########################################################
# Ensure that old 3g-watchdog bits are removed
########################################################
3g-watchdog:
  service.dead:
    - enable: False

/usr/local/bin/3g-watchdog:
  file.absent

/etc/cacophony/3g-watchdog.yaml:
  file.absent

/etc/systemd/system/3g-watchdog.service:
  file.absent

########################################################
# Ensure that modemd is installed, configured & running
########################################################

modemd-pkg:
  cacophony.pkg_installed_from_github:
    - name: modemd
    - version: "1.2.2"

modemd:
  service.running:
    - enable: True
    - watch:
      - modemd-pkg
