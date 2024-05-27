#!/bin/bash
# This is to help testing salt changes on a Server
# Usage: state-apply-test-server.sh [server]
# If you need to make changes to server-top.sls make the changes in `salt/top.sls` This is what is used when testing

set -e

server=$1

if [[ -z $server ]]; then
  echo "please provide server name. Usage \`state-apply-test-server.sh [server]\`"
  exit 1
fi

echo "Making local copy of salt folder"
cp -r basics.sls _modules/ server/ _states/ salt-migration/ timezone.sls salt/
cp salt/server-top.sls salt/top.sls

echo "Deleting salt copy in home directory on '$server'"
ssh $server "rm -rf salt"

echo "Copying salt folder onto '$server'"
scp -rq salt $server:

echo "SSH onto '$server' and then run"
echo "sudo rm -rf /srv/salt"
echo "sudo cp -r salt /srv/"
echo "You can then run your salt command. Something like"
echo "sudo salt-call --local state.apply --state-output=changes"
