set_wifi_country:
  file.replace:
    - name: /etc/wpa_supplicant/wpa_supplicant.conf
    - pattern: "^country=.+"
    - repl: "country=NZ"

ensure_bushnet_ssid:
  file.replace:
    - name: /etc/wpa_supplicant/wpa_supplicant.conf
    - pattern: 'network={\n*\s*ssid="bushnet"\n*\s*psk="feathers"\n*\s*priority=2\n*\s*}\n'
    - repl: |
        network={
            ssid="bushnet"
            psk="feathers"
            priority=2
        }
    - append_if_not_found: true

ensure_bushnet_ssid_with_cap:
  file.replace:
    - name: /etc/wpa_supplicant/wpa_supplicant.conf
    - pattern: 'network={\n*\s*ssid="Bushnet"\n*\s*psk="feathers"\n*\s*priority=2\n*\s*}\n'
    - repl: |
        network={
            ssid="Bushnet"
            psk="feathers"
            priority=2
        }
    - append_if_not_found: true
