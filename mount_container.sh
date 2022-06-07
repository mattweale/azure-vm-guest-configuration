#!/bin/sh

#	=============================
#	NFS Mount Container
#	=============================

#	Check Linux Distro for nfs utils install
    source /etc/os-release
    if [ echo $NAME = "CentOS Linux" ]; then
	    echo "Found RHEL Distro installing using yum"
        sudo yum install nfs-utils
    else [ echo $NAME = "Ubuntu" ]; then
	    echo "echo Found Ubuntu Distro installing using apt"
        sudo apt install nfs-common
    fi

    sudo mkdir -p /nfsdata
    sudo mount -o sec=sys,vers=3,nolock,proto=tcp saorbital.blob.core.windows.net:/saorbital/data  /nfsdata
    sudo chmod -R 777 /nfsdata
