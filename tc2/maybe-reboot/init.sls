reboot_after_boot_changes:
  module.run:
    - name: system.reboot
    - at_time: 1
    - onchanges:
      - /boot/firmware/config.txt
      - /boot/firmware/cmdline.txt
