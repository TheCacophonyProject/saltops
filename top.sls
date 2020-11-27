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
    - pi/removed
    - pi/maybe-reboot
    - pi/end

test:
  test-servers:
    - match: nodegroup
    - basics
    - timezone
    - salt-migration
    - server/basics
    - server/unattended-upgrades
    - server/salt
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
    - pi/removed
    - pi/maybe-reboot
    - pi/end

#-----------------------------------

prod:
  prod-servers:
    - match: nodegroup
    - basics
    - timezone
    - salt-migration
    - server/basics
    - server/unattended-upgrades
    - server/salt
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
    - pi/removed
    - pi/maybe-reboot
    - pi/end
