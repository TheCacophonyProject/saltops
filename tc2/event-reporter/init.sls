event-reporter-pkg:
  cacophony.pkg_installed_from_github:
    - name: event-reporter
    - version: "3.7.0"
    - branch: "master"

event-reporter-service:
  service.running:
    - name: event-reporter
    - enable: True
    - watch:
      - event-reporter-pkg
