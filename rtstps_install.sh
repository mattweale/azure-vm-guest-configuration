#!/bin/sh

#	=============================
#	RT-STPS Install
#	=============================

#   Install az copy
cd ~
curl "https://azcopyvnext.azureedge.net/release20220315/azcopy_linux_amd64_10.14.1.tar.gz" > azcopy_linux_amd64_10.14.1.tar.gz
tar -xvf azcopy_linux_amd64_10.14.1.tar.gz
sudo cp ./azcopy_linux_amd64_*/azcopy /usr/bin/

#	Check if RT-STPS is installed already
if [ -d "/root/rt-stps" ]; then
	export NOW=$(date '+%Y%m%d-%H:%M:%S')
	echo "$NOW	RT-STPS already installed, skipping installation"
else
	export NOW=$(date '+%Y%m%d-%H:%M:%S')
	echo "$NOW	RT-STPS Prerequisites"
	
	sudo yum upgrade -y 
	sudo yum install -y java-11-openjdk-devel

	#   Set JAVA Environment Variables
	export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
	export PATH=$PATH:$JAVA_HOME/bin

	#   Download RT_STPS Software and Test Data
	export CONTAINER='https://samrw.blob.core.windows.net/sharing/NASA%20DRL/RT-STPS/'
	export SAS_TOKEN='?sp=r&st=2022-03-29T15:53:35Z&se=2023-03-29T23:53:35Z&spr=https&sv=2020-08-04&sr=c&sig=lxDbvzZCZ2DUkbrFEw%2B1nXPegTB9IMe5NDFDu1kmlMs%3D'
		
	curl "${CONTAINER}RT-STPS_6.0.tar.gz${SAS_TOKEN}" > "RT-STPS_6.0.tar.gz"
	curl "${CONTAINER}RT-STPS_6.0_PATCH_1.tar.gz${SAS_TOKEN}" > "RT-STPS_6.0_PATCH_1.tar.gz"
	curl "${CONTAINER}RT-STPS_6.0_PATCH_2.tar.gz${SAS_TOKEN}" > "RT-STPS_6.0_PATCH_2.tar.gz"
	curl "${CONTAINER}RT-STPS_6.0_PATCH_3.tar.gz${SAS_TOKEN}" > "RT-STPS_6.0_PATCH_3.tar.gz"
	curl "${CONTAINER}RT-STPS_6.0_testdata.tar.gz${SAS_TOKEN}" > "RT-STPS_6.0_testdata.tar.gz"
	
	cd ~
	mkdir data
	cd data
	curl "${CONTAINER}test2.bin${SAS_TOKEN}" > "test2.bin"

	#   Install RT_STPS Software  
	export NOW=$(date '+%Y%m%d-%H:%M:%S')
	echo "$NOW	Installing RT-STPS..."
	cd ~
	# Extract main package
	tar xzf RT-STPS_6.0.tar.gz
	# Apply patch 2 - This patch supersedes Patch 1
	cp ~/rt-stps/config/jpss1.xml ~/rt-stps/config/jpss1.xml.old
	tar xzf RT-STPS_6.0_PATCH_2.tar.gz
	# Apply patch 3
	tar xzf RT-STPS_6.0_PATCH_3.tar.gz
	# Extract test data
	tar xzf RT-STPS_6.0_testdata.tar.gz
	# Install
	cd rt-stps
	./install.sh

	# Update leadsec file
	cd ~
	cd ~/rt-stps
	./bin/internal/update_leapsec.sh

fi

# Install XRDP Server
sudo yum install -y epel-release
sudo yum groupinstall -y "Server with GUI"
sudo yum groupinstall -y "Xfce"
sudo yum install -y tigervnc-server xrdp
sudo systemctl enable xrdp.service
sudo systemctl start xrdp.service
sudo systemctl set-default graphical.target

# Echo how to start RT-STPS, Viewer and Sender
echo 'Start RT-STPS Server with: ./rt-stps/jsw/bin/rt-stps-server.sh start'
echo 'Start Viewer with: ./rt-stps/bin/viewer.sh &'
echo 'Start Sender with: ./rt-stps/bin/sender.sh &'

# Shutdown
echo "Finished. Shutting down"
shutdown -h now
