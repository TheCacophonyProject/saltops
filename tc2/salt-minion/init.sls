/etc/salt/pki/minion/:
  file.directory:
    - mode: 700
    - makedirs: True

/etc/salt/pki/minion/minion_master.pub:
  file.managed:
    - source: salt://tc2/salt-minion/master.pub
    - mode: 644

# If this changes we need to manually restart the salt minion afterwards
/etc/salt/minion:
  file.managed:
    - source: salt://tc2/salt-minion/minion

/etc/systemd/system/salt-minion.service.d/override.conf:
   file.managed:
     - makedirs: True
     - source: salt://tc2/salt-minion/override.conf

/usr/local/bin/check-salt-keys:
  file.managed:
    - source: salt://tc2/salt-minion/check-salt-keys
    - mode: 755

/etc/cron.hourly/check-salt-keys:
  file.managed:
    - source: salt://tc2/salt-minion/check-salt-keys.cron
    - mode: 755

salt-minion:
  service.running:
    - enable: True
