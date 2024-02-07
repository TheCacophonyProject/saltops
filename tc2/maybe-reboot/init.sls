reboot_after_boot_changes:
  module.run:
    - name: system.reboot
    - at_time: 1
    - onchanges:
      - /boot/firmware/config.txt
      - /boot/firmware/cmdline.txt

reboot_for_config_import:
  module.run:
    - name: system.reboot
    - at_time: 1
    - unless: test -f /etc/cacophony/config.toml
