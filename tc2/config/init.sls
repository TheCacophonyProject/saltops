/etc/cacophony:
  file.directory

cacophony-config-pkg:
  cacophony.pkg_installed_from_github:
    - name: go-config
    - version: "1.9.4"
    - pkg_name: cacophony-config
    - branch: master
