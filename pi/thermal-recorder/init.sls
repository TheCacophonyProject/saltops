thermal-recorder-pkg:
  cacophony.pkg_installed_from_github:
    - name: thermal-recorder
    - version: "2.9.2"

# Install support for exFAT & NTFS filesystems (for USB drives)
extra-filesystems:
  pkg.installed:
    - pkgs:
      - exfat-fuse
      - exfat-utils
      - ntfs-3g

# Mount point for USB drives to write CPTV files to
cp-volume-mount:
  file.append:
    - name: "/etc/fstab"
    - text:
      - "LABEL=cp /media/cp auto auto,nofail,noexec,nodev,noatime,nodiratime 0 2"

thermal-recorder-service:
  service.running:
    - name: thermal-recorder
    - enable: True
    - watch:
      - thermal-recorder-pkg

leptond-service:
  service.running:
    - name: leptond
    - enable: True
    - watch:
      - thermal-recorder-pkg

set-thermal-recorder-output:
  service.enabled: []

# Remove files from old thermal-recorder versions
/opt/cacophony/thermal-recorder:
  file.absent: []
