/etc/cacophony:
  file.directory

cacophony-config-pkg:
  fever.pkg_installed_from_github:
    - name: go-config
    - version: "1.3.1"
    - pkg_name: cacophony-config
    - cacophony_project: True


