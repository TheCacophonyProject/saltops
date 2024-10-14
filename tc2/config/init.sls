/etc/cacophony:
  file.directory

cacophony-config-pkg:
  cacophony.pkg_installed_from_github:
    - name: go-config
    - version: "1.23.0"
    - architecture: "arm64"
    - pkg_name: cacophony-config
    - branch: master

cacophony-config-sync-service:
  service.running:
    - name: cacophony-config-sync
    - enable: True
    - watch:
        - cacophony-config-pkg
