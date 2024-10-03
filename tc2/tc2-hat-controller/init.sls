tc2-hat-controller-pkg:
  cacophony.pkg_installed_from_github:
    - name: tc2-hat-controller
    - version: "0.13.1"
    - architecture: "arm64"
    - branch: "main"

tc2-hat-attiny-service:
  service.running:
    - name: tc2-hat-attiny
    - enable: True

tc2-hat-i2c-service:
  service.running:
    - name: tc2-hat-i2c
    - enable: True

tc2-hat-temp-service:
  service.running:
    - name: tc2-hat-temp
    - enable: True

tc2-hat-rtc-service:
  service.running:
    - name: tc2-hat-rtc
    - enable: True

tc2-hat-comms-service:
  service.running:
    - name: tc2-hat-comms
    - enable: True
