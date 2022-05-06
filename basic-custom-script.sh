#!/bin/sh
cd /home/adminuser
echo "this has been written via cloud-init" + $(date) >> ./myScript.txt
