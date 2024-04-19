/usr/bin/stay-on:
  file.managed:
    - source: salt://tc2/start/stay-on
    - mode: 755

stay-on-service-file:
  file.managed:
    - name: /etc/systemd/system/stay-on.service
    - source: salt://tc2/start/stay-on.service
    - mode: 644

stay-on-service-reload:
  cmd.wait:
    - name: "systemctl daemon-reload"
    - watch:
      - stay-on-service-file

'systemctl restart stay-on':
  cmd.run

# Sometimes dpkg can get in a bad state, this should fix it.
'dpkg --configure -a':
  cmd.run

# Disable apt update and upgrade until apt sources are managed.
#'apt-get update':
#  cmd.run

#'apt-get upgrade -y':
#  cmd.run
