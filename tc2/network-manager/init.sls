/etc/NetworkManager/system-connections/bushnet.nmconnection:
  file.managed:
    - source: salt://tc2/network-manager/bushnet.nmconnection
    -  mode: 644
