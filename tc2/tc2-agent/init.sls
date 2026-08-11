tc2-agent-pkg:
  cacophony.pkg_installed_from_github:
    - name: tc2-agent
    - version: "0.9.1"
    - architecture: "arm64"
    - branch: "main"

tc2-agent-service:
  service.running:
    - name: tc2-agent
    - enable: True
