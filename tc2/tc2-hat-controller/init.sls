tc2-hat-controller-pkg:
  cacophony.pkg_installed_from_github:
    - name: tc2-hat-controller
    - version: "0.5.2"
    - architecture: "arm64"

tc2-hat-attiny-service:
  service.running:
    - name: tc2-hat-attiny
    - enable: True

tc2-hat-temp-service:
  service.running:
    - name: tc2-hat-attiny
    - enable: True
