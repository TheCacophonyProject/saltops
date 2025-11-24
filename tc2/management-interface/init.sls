management-interface-pkg:
  cacophony.pkg_installed_from_github:
    - name: management-interface
    - version: "1.45.1"
    - architecture: "arm64"
    - branch: tc2

managementd-service:
  service.running:
    - name: managementd
    - enable: True
    - watch:
      - management-interface-pkg

# This will trigger a restart of managementd 30 seconds after the end of a salt update if needed.
delayed_restart_managementd:
  cmd.run:
    - name: >
        systemd-run --unit=delayed-managementd-restart.service
        --on-active=30s
        /bin/systemctl restart managementd
    - shell: /bin/bash
    - onchanges:
      - cacophony: tc2-agent-pkg
      - cacophony: management-interface-pkg
    - order: last
