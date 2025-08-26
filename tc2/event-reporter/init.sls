event-reporter-pkg:
  cacophony.pkg_installed_from_github:
    - name: event-reporter
    - version: "3.10.0"
    - architecture: "arm64"
    - branch: "master"

event-reporter-service:
  service.running:
    - name: event-reporter
    - enable: True
    - watch:
      - event-reporter-pkg
