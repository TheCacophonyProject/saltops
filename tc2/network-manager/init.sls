/etc/NetworkManager/system-connections/bushnet.nmconnection:
  file.managed:
    - source: salt://tc2/network-manager/bushnet.nmconnection
    -  mode: 600

# For debugging you can disable the modemd service and then connect direclty to the RPi ethernet from your laptop.
/etc/network/interfaces.d/eth0:
  file.managed:
    - makedirs: True
    - source: salt://tc2/network-manager/eth0
    -  mode: 644
