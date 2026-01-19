# install ntfs-3g if not already installed
sudo apt update
sudo apt install ntfs-3g

# mount the NTFS partition
lsblk -f
sudo ntfsfix /dev/sda1
sudo mount /dev/sda1 /mnt