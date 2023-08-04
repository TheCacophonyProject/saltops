thermal-recorder-pkg:
  cacophony.pkg_installed_from_github:
    - name: thermal-recorder
    - version: "2.18.2-tc2"

thermal-recorder-service:
  service.running:
    - name: thermal-recorder
    - enable: True
    - watch:
      - thermal-recorder-pkg

