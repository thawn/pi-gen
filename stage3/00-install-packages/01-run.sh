#!/bin/bash -e
echo "ROOTFS_DIR: ${ROOTFS_DIR}"
current_dir=$(pwd)
git clone -b own-pi-gen-repo https://github.com/thawn/pitemplog.git
cd pitemplog
npm install
grunt
chmod a+x build/_bin/install.sh
cd "${current_dir}"
ls -la pitemplog/build/*

mkdir -p "${ROOTFS_DIR}/usr/local/share/templog"
cp -r pitemplog/build/* "${ROOTFS_DIR}/usr/local/share/templog/"
ls -l "${ROOTFS_DIR}/usr/local/share/templog/"

on_chroot <<- \EOF
	chmod a+x /usr/local/share/templog/_bin/*.sh
	chmod a+x /usr/local/share/templog/_bin/*.py
	chmod u+x /usr/local/share/templog/_sbin/*.sh
	/usr/local/share/templog/_bin/install.sh --no-restart-apache
	update-rc.d setup_timesyncd defaults
	cp /usr/local/share/templog/_sbin/setup_templog_db_once /etc/init.d/
	chmod u+x /etc/init.d/setup_templog_db_once
	update-rc.d setup_templog_db_once defaults
	raspi-config nonint do_memory_split 16
	raspi-config nonint do_onewire 1
EOF
