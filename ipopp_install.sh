#!/bin/bash

# =============================
# IPOPP Install
# =============================

	export SOURCE_DIR=/datadrive
	export INSTALL_DIR=/datadrive/IPOPP
	export IPOPP_TAR_GZ_FILENAME='DRL-IPOPP_4.1.tar.gz'
	export PATCH_FILE_NAME='DRL-IPOPP_4.1_PATCH_1.tar.gz'

#	Prepare IPOPP Source for install
	cd $SOURCE_DIR
	tar -C $SOURCE_DIR -xzf $IPOPP_TAR_GZ_FILENAME
	chmod -R 755 IPOPP
	 ./IPOPP/install_ipopp.sh -installdir $INSTALL_DIR/drl -datadir $INSTALL_DIR/data  -ingestdir $INSTALL_DIR/data/ingest

#	runuser -u adminuser -- ./IPOPP/install_ipopp.sh -installdir $INSTALL_DIR/drl -datadir $INSTALL_DIR/data  -ingestdir $INSTALL_DIR/data/ingest

# 	Add SQL Path for Patch Installation DB Check
#	export PATH=$PATH:/home/adminuser/drl/standalone/mariadb-10.1.8-linux-x86_64/bin:/home/adminuser/drl/standalone/jdk1.8.0_45/bin
#	export PATH=$PATH:/datadrive/ipopp/drl/standalone/mariadb-10.1.8-linux-x86_64/bin:/datadrive/ipopp/drl/standalone/jdk1.8.0_45/bin

# Install IPOPP Patch #1
#	cp $SOURCE_DIR/DRL-IPOPP_4.1_PATCH_1.tar.gz $INSTALL_DIR/drl
#	runuser -u adminuser -- /datadrive/IPOPP/drl/tools/install_patch.sh DRL-IPOPP_4.1_PATCH_1.tar.gz

# Install IPOPP Patch #2
#	cp $SOURCE_DIR/DRL-IPOPP_4.1_PATCH_2.tar.gz $INSTALL_DIR/drl
#	su -c "/datadrive/ipopp/drl/tools/install_patch.sh DRL-IPOPP_4.1_PATCH_2.tar.gz" -s /bin/bash adminuser

# Start Services
#	su -c "${INSTALL_DIR}/drl/tools/services.sh start" -s /bin/bash adminuser

# Create .netrc file for MODIS Sensor geolocation module requires access to additional ephemeris and attitude ancillary files during processing. These files will be automatically retrieved using EarthData portal login credentials.

## Verify
#	/$INSTALL_DIR/drl/tools/services.sh status > status.log
#	/$INSTALL_DIR/drl/tools/spa_services.sh status >> status.log

# cp $HOME/drl/SPA/modisl1db/algorithm/DRLshellscripts/sample.netrc $HOME/.netrc
# Next edit the $HOME/.netrc file to replace “yourlogin” and “yourpassword” with your EarthData portal credentials.

fi
