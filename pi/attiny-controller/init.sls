attiny-controller-pkg:
  cacophony.pkg_installed_from_github:
    - name: attiny-controller
    - version: "3.4.0"

attiny-controller-service:
  service.running:
    - name: attiny-controller
    - enable: True
    - watch:
      - attiny-controller-pkg
