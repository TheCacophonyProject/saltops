#############################################################
# Ensure that salt-updater is installed, configured & running
#############################################################

update-updater-pkg:
  cacophony.pkg_installed_from_github:
    - name: salt-updater
    - version: "0.1.0"

salt-updater:
  service.running:
    - enable: True
    - watch:
      - modemd-pkg
