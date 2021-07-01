/etc/cacophony:
  file.directory

cacophony-config-pkg:
  cacophony.pkg_installed_from_github:
    - name: go-config
    - version: "1.6.4"
    - pkg_name: cacophony-config

# Archive old config files

/etc/cacophony/archive:
  file.directory

/etc/cacophony/archive/attiny.yaml:
    file.rename:
      - source: /etc/cacophony/attiny.yaml

/etc/cacophony/archive/modemd.yaml:
    file.rename:
      - source: /etc/cacophony/modemd.yaml

/etc/cacophony/archive/leptond.yaml:
    file.rename:
      - source: /etc/leptond.yaml

/etc/cacophony/archive/thermal-recorder.yaml:
    file.rename:
      - source: /etc/thermal-recorder.yaml

/etc/cacophony/archive/location.yaml:
    file.rename:
      - source: /etc/cacophony/location.yaml

/etc/cacophony/archive/device.yaml:
    file.rename:
      - source: /etc/cacophony/device.yaml

/etc/cacophony/archive/device-priv.yaml:
    file.rename:
      - source: /etc/cacophony/device-priv.yaml

/etc/cacophony/archive/managementd.yaml:
    file.rename:
      - source: /etc/cacophony/managementd.yaml

/etc/cacophony/archive/audiobait.yaml:
    file.rename:
      - source: /etc/audiobait.yaml
