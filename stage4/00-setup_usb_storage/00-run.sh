#!/bin/bash -e

on_chroot << EOF
	/usr/local/share/templog/_sbin/setup_usb_storage.sh
EOF
