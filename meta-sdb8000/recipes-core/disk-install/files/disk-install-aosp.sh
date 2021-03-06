#!/bin/bash

die() {
	echo $1
	exit 1
}

if [ "$#" -lt "1" ]; then
	die "Usage: $0 DIR"
fi

DIR="$1"
DEVICE="/dev/mmcblk2"
LOG="/tmp/disk-install-aosp.yaml"

read -r -d '' config <<- EOM
images:
   - name: table
     type: raw.bz2
     target: device
     reload_partitions: true
   - name: boot
     type: raw.bz2
     target: label:boot_a
   - name: dtbo
     type: raw.bz2
     target: label:dtbo_a
   - name: vbmeta
     type: raw.bz2
     target: label:vbmeta_a
   - name: vendor_boot
     type: raw.bz2
     target: label:vendor_boot_a
   - name: super
     type: android-sparse
     target: label:super
EOM

printf '%s\n' "$config"
if printf '%s\n' "$config" | image-install --force-unmount --wipefs --device "$DEVICE" --log "$LOG" --config - \
	table="${DIR}/partition-table.img.bz2" \
	super="${DIR}/super.img" \
	boot="${DIR}/boot.img.bz2" \
	dtbo="${DIR}/dtbo-imx8mm.img.bz2" \
	vbmeta="${DIR}/vbmeta-imx8mm.img.bz2" \
	vendor_boot="${DIR}/vendor_boot.img.bz2"; then
		echo "Success!"
		exit 0
fi

echo "Image installation failed"
exit 1

