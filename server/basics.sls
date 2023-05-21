htop:
  pkg.installed

python.packages:
  pkg.installed:
    - pkgs:
      - python3-venv
      - python3-wheel

docker.io:
  pkg.installed

unused.packages:
  pkg.removed:
    - pkgs:
      - bc
      - byobu
      - command-not-found-data
      - cryptsetup
      - dh-python
      - fonts-ubuntu-console
      - fonts-ubuntu-font-family-console
      - fonts-noto-mono
      - fonts-dejavu-core
      - fonts-droid-fallback
      - ghostscript
      - libcups2
      - ntfs-3g
      - manpages-dev
      - ruby

/etc/logrotate.d/rsyslog:
  file.managed:
    - source: salt://server/rsyslog
