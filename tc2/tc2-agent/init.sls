tc2-agent-pkg:
  cacophony.pkg_installed_from_github:
    - name: tc2-agent
    - version: "0.2.4"
    - architecture: "armhf"
    - branch: "main"

tc2-agnet-service:
  service.running:
    - name: tc2-agent
    - enable: True
