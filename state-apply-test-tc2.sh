#!/bin/bash
# This is to help testing salt changes on a Raspberry Pi
# Usage: state-apply-test.sh [devicename] [state.apply params]
# If you need to make changes to rpi-top.sls make the changes in `salt/top.sls` This is what is used when testing

set -e

# Function to display help text
show_help() {
	cat <<EOF
Usage: ${0##*/} [--skip-modules] <device> [salt-params]

This script is to help testing salt changes on a Raspberry Pi for the TC2 camera.

Options:
  --update-modules  Update salt modules. Use this if modifying files in the _modules folder.
  -h, --help        Display this help and exit.
EOF
}

update_modules=0

# Process all options starting with '--'
while [[ "$1" == --* ]]; do
	case "$1" in
	--update-modules)
		update_modules=1
		;;
	-h | --help)
		show_help
		exit 0
		;;
	*)
		echo "Unknown option: $1" >&2
		exit 1
		;;
	esac
	shift # Move to next argument
done

device=$1
params=$2

if [[ -z $device ]]; then
	echo "No device name provided"
	show_help
	exit 1
fi

echo "Running salt update on $device"

if [[ -e salt ]]; then
	rm -r salt
fi
mkdir salt

# copy files to local folder
cp -r basics.sls _modules/ tc2/ _states/ salt-migration/ timezone.sls salt/
cp tc2-top.sls salt/top.sls

ssh pi@$device "sudo rm -rf salt /srv/salt"

# copy onto device
echo "copying files to device.."
scp -rq salt pi@$device:
echo "done"

echo "Deleting old salt files.."
ssh pi@$device "sudo rm -r /srv/salt 2>/dev/null || true"

echo "moving files to /srv"
ssh pi@$device "sudo cp -r salt /srv/"
echo "done"

if [[ $update_modules -eq 1 ]]; then
	echo "Syncing salt modules.."
	ssh pi@$device "sudo salt-call --local saltutil.sync_all"
fi

cmd="ssh -t pi@$device \"sudo salt-call --local state.apply $params --state-output=changes\""
echo "running $cmd"
eval $cmd
