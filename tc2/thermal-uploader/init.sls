thermal-uploader-pkg:
  cacophony.pkg_installed_from_github:
    - name: thermal-uploader
    - version: "2.5.4"
    - branch: master

thermal-uploader-service:
  service.running:
    - name: thermal-uploader
    - enable: True
    - watch:
      - thermal-uploader-pkg
