audiobait-pkg:
  cacophony.pkg_installed_from_github:
    - name: audiobait
    - version: "2.2.0"

/var/lib/audiobait:
  file.directory

audiobait-service:
  service.running:
    - name: audiobait
    - enable: True
    - watch:
      - audiobait-pkg
