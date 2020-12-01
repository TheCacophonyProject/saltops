'date --iso-8601=seconds > /etc/cacophony/last-salt-update':
  cmd.run

'version-reporter':
  cmd.run

'systemctl stop stay-on':
  cmd.run
