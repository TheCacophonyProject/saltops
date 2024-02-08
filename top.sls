dev:
  dev-pis:
    - match: nodegroup
    - pi/start
    - basics
    - salt-migration
    - timezone
    - pi/config
    - pi/basics
    - pi/auth
    - pi/salt-minion
    - pi/wpa
    - pi/rtc
    - pi/watchdog
    - pi/modemd
    - pi/attiny-controller
    - pi/audio
    - pi/event-reporter
    - pi/audiobait
    - pi/thermal-recorder
    - pi/thermal-uploader
    - pi/management-interface
    - pi/device-register
    - pi/energy-savings
    - pi/dev-pis
    - pi/salt-updater
    - pi/removed
    - pi/maybe-reboot
    - pi/end

  tc2-dev:
    - match: nodegroup
    - tc2/start
    - tc2/dev
    - timezone
    - tc2/config
    - tc2/basics
    - tc2/auth
    - tc2/salt-minion
    - tc2/network-manager
    - tc2/watchdog
    - tc2/event-reporter
    - tc2/thermal-uploader
    - tc2/thermal-recorder-py
    - tc2/rpi-net-manager
    - tc2/management-interface
    - tc2/device-register
    - tc2/salt-updater
    - tc2/modemd
    - tc2/energy-savings
    - tc2/tc2-agent
    - tc2/tc2-hat-controller
    - tc2/maybe-reboot
    - tc2/end

test:
  test-servers:
    - match: nodegroup
    - basics
    - timezone
    - salt-migration
    - server/basics
    - server/unattended-upgrades
    - server/users
    - server/sshd
    - server/telegraf
    - server/mail-relay

  server-test-api:
    - server/influxdb
    - server/grafana
    - server/tools/mc
    - server/tools/minio
    - server/node

  'server-test-processing*':
    - server/tools/ffmpeg

  test-pis:
    - match: nodegroup
    - pi/start
    - basics
    - salt-migration
    - timezone
    - pi/config
    - pi/basics
    - pi/auth
    - pi/salt-minion
    - pi/wpa
    - pi/rtc
    - pi/watchdog
    - pi/modemd
    - pi/attiny-controller
    - pi/audio
    - pi/event-reporter
    - pi/audiobait
    - pi/thermal-recorder
    - pi/thermal-uploader
    - pi/management-interface
    - pi/device-register
    - pi/energy-savings
    - pi/test-pis
    - pi/salt-updater
    - pi/removed
    - pi/maybe-reboot
    - pi/end

  tc2-test:
    - match: nodegroup
    - tc2/start
    - tc2/test
    - timezone
    - tc2/config
    - tc2/basics
    - tc2/auth
    - tc2/salt-minion
    - tc2/network-manager
    - tc2/watchdog
    - tc2/event-reporter
    - tc2/thermal-uploader
    - tc2/thermal-recorder-py
    - tc2/rpi-net-manager
    - tc2/management-interface
    - tc2/device-register
    - tc2/salt-updater
    - tc2/modemd
    - tc2/energy-savings
    - tc2/tc2-agent
    - tc2/tc2-hat-controller
    - tc2/maybe-reboot
    - tc2/end

#-----------------------------------

prod:
  prod-servers:
    - match: nodegroup
    - basics
    - timezone
    - salt-migration
    - server/basics
    - server/unattended-upgrades
    - server/users
    - server/sshd
    - server/telegraf
    - server/mail-relay

  server-prod-salt:
    - server/influxdb
    - server/tools/mc
    - server/grafana

  server-prod-api:
    - server/tools/mc
    - server/tools/minio
    - server/node

  server-prod-db:
    - server/tools/mc

  'server-prod-processing*':
    - server/tools/ffmpeg

  prod-pis:
    - match: nodegroup
    - pi/start
    - basics
    - timezone
    - salt-migration
    - pi/config
    - pi/basics
    - pi/auth
    - pi/salt-minion
    - pi/wpa
    - pi/rtc
    - pi/watchdog
    - pi/modemd
    - pi/attiny-controller
    - pi/audio
    - pi/event-reporter
    - pi/audiobait
    - pi/thermal-recorder
    - pi/thermal-uploader
    - pi/management-interface
    - pi/device-register
    - pi/energy-savings
    - pi/prod-pis
    - pi/salt-updater
    - pi/removed
    - pi/maybe-reboot
    - pi/end

  tc2-prod:
    - match: nodegroup
    - tc2/start
    - tc2/prod
    - timezone
    - tc2/config
    - tc2/basics
    - tc2/auth
    - tc2/salt-minion
    - tc2/network-manager
    - tc2/watchdog
    - tc2/event-reporter
    - tc2/thermal-uploader
    - tc2/thermal-recorder-py
    - tc2/rpi-net-manager
    - tc2/management-interface
    - tc2/device-register
    - tc2/salt-updater
    - tc2/modemd
    - tc2/energy-savings
    - tc2/tc2-agent
    - tc2/tc2-hat-controller
    - tc2/maybe-reboot
    - tc2/end
