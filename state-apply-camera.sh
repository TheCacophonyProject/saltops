#!/bin/bash
# This is to help testing salt changes on a Raspberry Pi 

# Exit if any command fails
set -e
# Print commands as they are executed
#set -x

# Function to display help text
show_help() {
cat << EOF
Usage: ${0##*/} [--skip-modules] <device> [salt-params]

This script is to help testing salt changes on a Raspberry Pi for the 'tc2' and 'pi'(old) cameras.
The script will detect what type of device it is by checking its /etc/salt/minion_id file.

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
        -h|--help)
            show_help
            exit 0
            ;;
        *)  echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
    shift # Move to next argument
done

device=$1
user_device=pi@$device
params=$2

if [[ -z $device ]]; then
  echo "No device name provided"
  show_help
  exit 1
fi

if ! ping -c 1 "$device" > /dev/null 2>&1; then
    echo "Hostname '$device' cannot be resolved or host is unreachable. Exiting."
    exit 1
fi

if [[ -e salt ]]; then
  rm -r salt 
fi
mkdir salt

minion_file=/etc/salt/minion_id
if ssh "$user_device" grep -q "tc2" "$minion_file"; then
  echo "Setting up TC2 camera for a salt update"
  cp -r basics.sls _modules/ tc2/ _states/ salt-migration/ timezone.sls salt/
  cp tc2-top.sls salt/top.sls
elif ssh "$user_device" grep -q "pi" "$minion_file"; then
  echo "Setting up Pi camera for a salt update"
  cp -r basics.sls _modules/ pi/ _states/ salt-migration/ timezone.sls salt/
  cp rpi-top.sls salt/top.sls
else
  echo "Unknown device type"
  exit 1
fi

echo -n "Deleting old salt files ...      "
ssh pi@$device "sudo rm -rf salt /srv/salt"
echo "done"

temp_dir="/tmp/salt"

echo -n "Creating tmp directory on device ... "
ssh "$user_device" "mkdir -p $temp_dir"
echo "done"

# Copy and move needs to be done in two steps because of permissions.
echo -n "Copying salt files to device ... "
scp -rq salt pi@$device:$temp_dir
echo "done"

echo -n "Moving salt files from temporary directory to /srv/ ... "
ssh "$user_device" "sudo mv $temp_dir/* /srv/ && rmdir $temp_dir"
echo "done"

if [[ $update_modules -eq 1 ]]; then
  echo -n "Syncing salt modules ...         " 
  ssh pi@$device "sudo salt-call --local saltutil.sync_all"
  echo "done"
else
  echo "Skipping salt module sync. If you have updated anything in '_modules' or '_states' please re-run this script with '--update-modules'"
fi

salt_cmd="sudo salt-call --local state.apply $params --state-output=changes"
cmd="ssh -t pi@$device \"$salt_cmd\""
echo "running '$salt_cmd' on '$device'"
eval $cmd
