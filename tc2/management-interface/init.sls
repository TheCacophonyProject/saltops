management-interface-pkg:
  cacophony.pkg_installed_from_github:
    - name: management-interface
    - version: "1.27.0-tc2"
    - branch: tc2

managementd-service:
  service.running:
    - name: managementd
    - enable: True
    - watch:
      - management-interface-pkg
