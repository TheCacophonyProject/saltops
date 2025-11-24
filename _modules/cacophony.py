import glob
import os
import re


def continuous_recording(on):
    args = ["cacophony-config", "--write"]
    if on:
        args.extend(
            [
                "thermal-throttler.activate=false",
                "thermal-motion.dynamic-threshold=false",
                "thermal-motion.temp-thresh=0",
                "thermal-motion.delta-thresh=0",
                "thermal-motion.count-thresh=0",
            ]
        )
    else:
        args.extend(
            [
                "thermal-throttler.activate=true",
                "thermal-motion.dynamic-threshold=true",
                "thermal-motion.temp-thresh=2900",
                "thermal-motion.delta-thresh=50",
                "thermal-motion.count-thresh=3",
            ]
        )

    output = __salt__["cmd.run"](" ".join(args), raise_err=True)
    __salt__["service.restart"]("thermal-recorder")
    return output


def has_usb_device(device_ids):
    """Return True when a matching USB vendor:product ID is present."""

    if not device_ids:
        return False

    if isinstance(device_ids, str):
        targets = {device_ids.lower()}
    else:
        try:
            targets = {item.lower() for item in device_ids if isinstance(item, str)}
        except TypeError:
            targets = set()

    if not targets:
        return False

    for path in glob.glob("/sys/bus/usb/devices/*"):
        if ":" in os.path.basename(path):
            continue

        try:
            with open(os.path.join(path, "idVendor"), encoding="utf-8") as vendor_file:
                vendor = vendor_file.read().strip().lower()
            with open(os.path.join(path, "idProduct"), encoding="utf-8") as product_file:
                product = product_file.read().strip().lower()
        except FileNotFoundError:
            continue

        if not vendor or not product:
            continue

        if f"{vendor}:{product}" in targets:
            return True

    return False
