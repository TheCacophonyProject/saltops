/etc/cacophony:
  file.directory

cacophony-config-pkg:
  cacophony.pkg_installed_from_github:
    - name: go-config
    - version: "1.8.1"
    - pkg_name: cacophony-config
