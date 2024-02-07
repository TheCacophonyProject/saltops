management-interface-pkg:
  cacophony.pkg_installed_from_github:
    - name: management-interface
    - version: "1.22.2-tc2"

managementd-service:
  service.running:
    - name: managementd
    - enable: True
    - watch:
      - management-interface-pkg

# TODO, manage the bushnet wifi network file, something like /etc/NetworkManager/systemNetworks.d/bushnet

#dhcpcd5:
#  pkg.installed

#dnsmasq:
#  pkg.installed

#hostapd:
#  pkg.installed

#/etc/systemd/system/multi-user.target.wants/cacophonator-management.service:
#   file.absent

#sudo_rfkill_unblock_wlan:
#  cmd.run:
#    - name: sudo rfkill unblock wlan

#sudo_umask_hostapd:
#  cmd.run:
#    - name: sudo systemctl unmask hostapd
    
#/etc/default/hostapd:
#  file.append:
#    - text: 'DAEMON_CONF="/etc/hostapd/hostapd.conf"'
    
#/etc/network/interfaces:
#  file.append:
#    - text: 
#      - "auto wlan0"
#      - "iface wlan0 inet manual"
#      - "wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf"
