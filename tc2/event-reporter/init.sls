event-reporter-pkg:
  cacophony.pkg_installed_from_github:
    - name: event-reporter
    - version: "3.8.1" # Uncommend the architecture line next version update.
    #- architecture: "arm64"
    - branch: "master"

event-reporter-service:
  service.running:
    - name: event-reporter
    - enable: True
    - watch:
      - event-reporter-pkg
