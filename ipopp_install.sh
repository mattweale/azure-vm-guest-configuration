#!/bin/sh

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
	export CONTAINER='https://samrw.blob.core.windows.net/sharing/nasa_drl/IPOPP/'
	export SAS_TOKEN='?sp=r&st=2022-03-29T15:53:35Z&se=2023-03-29T23:53:35Z&spr=https&sv=2020-08-04&sr=c&sig=lxDbvzZCZ2DUkbrFEw%2B1nXPegTB9IMe5NDFDu1kmlMs%3D'
	export SOURCE_DIR=/datadrive
	
	azcopy cp "${CONTAINER}DRL-IPOPP_4.1.tar.gz${SAS_TOKEN}" "$SOURCE_DIR"
	azcopy cp "${CONTAINER}DRL-IPOPP_4.1_PATCH_1.tar.gz${SAS_TOKEN}" "$SOURCE_DIR"

#	Could use this but need to tidy up Container
#	azcopy $RTSTPS_SOURCE $RTSTPS_DIR --recursive --overwrite --log-level=error

# 	Install ipopp
	export HOME=/datadrive
	cd $INSTALL_DIR
	su -c 'tar -C $INSTALL_DIR -xzf $IPOPP_TAR_GZ_FILENAME' adminuser
	./IPOPP/install_ipopp.sh -installdir $INSTALL_DIR/drl -datadir $INSTALL_DIR/data  -ingestdir $INSTALL_DIR/data/ingest

# 	Add SQL Path for Patch Installation DB Check
	export PATH=$PATH:/home/adminuser/drl/standalone/mariadb-10.1.8-linux-x86_64/bin:/home/adminuser/drl/standalone/jdk1.8.0_45/bin

# Install IPOPP Patch
	sudo $INSTALL_DIR/drl/tools/install_patch.sh $PATCH_FILE_NAME

# Start Services
	/${INSTALL_DIR}/drl/tools/services.sh start

# Create .netrc file for MODIS Sensor geolocation module requires access to additional ephemeris and attitude ancillary files during processing. These files will be automatically retrieved using EarthData portal login credentials.

## Verify
	./$INSTALL_DIR/drl/tools/services.sh status > status.log
	./$INSTALL_DIR/drl/tools/spa_services.sh status >> status.log

# cp $HOME/drl/SPA/modisl1db/algorithm/DRLshellscripts/sample.netrc $HOME/.netrc
# Next edit the $HOME/.netrc file to replace “yourlogin” and “yourpassword” with your EarthData portal credentials.

fi
