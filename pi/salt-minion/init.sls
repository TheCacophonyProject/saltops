salt_pkgrepo:
  pkgrepo.managed:
    - humanname: SaltStack
    - name: deb http://repo.saltstack.com/py3/debian/10/armhf/latest buster main
    - key_url: https://repo.saltstack.com/py3/debian/10/armhf/latest/SALTSTACK-GPG-KEY.pub
    - file: /etc/apt/sources.list.d/saltstack.list
    - clean_file: True
    - refresh: False

# If this changes we need to manually restart the salt minion afterwards
/etc/salt/minion:
  file.managed:
    - source: salt://pi/salt-minion/minion

/etc/systemd/system/salt-minion.service.d/override.conf:
   file.managed:
     - makedirs: True
     - source: salt://pi/salt-minion/override.conf

/usr/local/bin/check-salt-keys:
  file.managed:
    - source: salt://pi/salt-minion/check-salt-keys
    - mode: 755

/etc/cron.hourly/check-salt-keys:
  file.managed:
    - source: salt://pi/salt-minion/check-salt-keys.cron
    - mode: 755
