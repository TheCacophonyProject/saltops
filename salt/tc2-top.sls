base:
  '*':
    - tc2/start
    - timezone
    - tc2/config
    - tc2/basics
    - tc2/auth
    - tc2/salt-minion
    - tc2/wpa
    - tc2/watchdog
    - tc2/event-reporter
    - tc2/thermal-recorder
    - tc2/thermal-uploader
    - tc2/management-interface
    - tc2/device-register
    - tc2/salt-updater
    - tc2/maybe-reboot
    #- tc2/modemd
    - tc2/energy-savings
    - tc2/tc2-agent
    - tc2/tc2-hat-controller
    - tc2/end
