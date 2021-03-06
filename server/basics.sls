htop:
  pkg.installed

python.packages:
  pkg.installed:
    - pkgs:
      - python3-venv
      - python3-wheel

docker.io:
  pkg.installed

/etc/hosts:
  file.managed:
    - source: salt://server/hosts.jinja
    - template: jinja

unused.packages:
  pkg.removed:
    - pkgs:
      - bc
      - byobu
      - command-not-found-data
      - cryptsetup
      - dh-python
      - fonts-noto-mono
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
