management-interface-pkg:
  cacophony.pkg_installed_from_github:
    - name: management-interface
    - version: "1.15.0"

managementd-service:
  service.running:
    - name: managementd
    - enable: True
    - watch:
      - management-interface-pkg
      
dhcpcd:
  pkg.installed

dnsmasq:
  pkg.installed

hostapd:
  pkg.installed

/etc/systemd/system/multi-user.target.wants/cacophonator-management.service:
   file.absent
