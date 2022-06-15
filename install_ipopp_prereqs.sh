#!/bin/bash

# =============================
# IPOPP Install
# =============================

#	Check that /datadrive is mounted
if [ ! -d "/datadrive" ]; then
	export NOW=$(date '+%Y%m%d-%H:%M:%S')
	echo "$NOW	/datadrive does not exist. Run mount_drive.sh"
else
	export NOW=$(date '+%Y%m%d-%H:%M:%S')
	echo "$NOW	IPOPP Prerequisites"

# Get Container destination for software or hard code later on.
#echo 'Enter Container URI for IPOPP Software:'
#read CONTAINER

# Get SAS Token for Container
#echo 'Enter SAS Token for Container:'
#read SAS_TOKEN

#   Install az copy
	cd ~
	curl "https://azcopyvnext.azureedge.net/release20220315/azcopy_linux_amd64_10.14.1.tar.gz" > azcopy_linux_amd64_10.14.1.tar.gz
	tar -xvf azcopy_linux_amd64_10.14.1.tar.gz
	sudo cp ./azcopy_linux_amd64_*/azcopy /usr/bin/
	sudo chmod 755 /usr/bin/azcopy

#	Apply Udates
	sudo yum upgrade -y 
	
# 	Install XRDP Server
	sudo yum install -y epel-release
	sudo yum groupinstall -y "Server with GUI"
	sudo yum groupinstall -y "Gnome Desktop"
	sudo yum install -y tigervnc-server xrdp	
	sudo systemctl enable xrdp.service
	sudo systemctl start xrdp.service
	sudo systemctl set-default graphical.target

# Ensure mount_drive.sh is run first
#sudo mkdir -p /nfsdata
#sudo yum install nfs-utils # [CentOS]
# sudo apt install nfs-common # [Debian]
#sudo mount -o sec=sys,vers=3,nolock,proto=tcp saorbital.blob.core.windows.net:/saorbital/ipopp  /nfsdata
#sudo chown -R `whoami` /nfsdata

#   Download IPOPP Software and Patch. Hard coded Containers and SAS Token
	export CONTAINER='https://samrw.blob.core.windows.net/ipopp/'
	export SAS_TOKEN='?sp=rl&st=2022-06-06T18:11:57Z&se=2023-06-07T02:11:57Z&spr=https&sv=2021-06-08&sr=c&sig=xPb9nAWP8Om2ony57uySwlfsmWxNCO7boKEtWYC8qqs%3D'
	export SOURCE_DIR=/datadrive
	export INSTALL_DIR=/datadrive/IPOPP
	export IPOPP_TAR_GZ_FILENAME='DRL-IPOPP_4.1.tar.gz'
	export PATCH_FILE_NAME='DRL-IPOPP_4.1_PATCH_1.tar.gz'

	azcopy cp "${CONTAINER}DRL-IPOPP_4.1.tar.gz${SAS_TOKEN}" "$SOURCE_DIR"
	azcopy cp "${CONTAINER}DRL-IPOPP_4.1_PATCH_1.tar.gz${SAS_TOKEN}" "$SOURCE_DIR"
	azcopy cp "${CONTAINER}DRL-IPOPP_4.1_PATCH_2.tar.gz${SAS_TOKEN}" "$SOURCE_DIR"

 	cp /var/lib/waagent/custom_script/download/0/* /datadrive
	sudo chown -R adminuser /datadrive
	sudo chgrp -R adminuser /datadrive

fi
