lsblk -o NAME,HCTL,SIZE,MOUNTPOINT | grep -i "sd"
sudo parted /dev/sdb --script mklabel gpt mkpart xfspart xfs 0% 100%  # making partions, do not run on re-attaching an existing drive
sudo mkfs.xfs /dev/sdb1
sudo partprobe /dev/sdb1 
sudo mkdir /datadrive # end making partions
sudo mount /dev/sdb1 /datadrive #not permanent use fstab
sudo apt install nfs-common
sudo fstrim /datadrive
sudo chown -R `whoami` /datadrive
