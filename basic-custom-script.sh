#!/bin/sh
cd ~
echo "this has been written via cloud-init" + $(date) >> ./myScript.txt
