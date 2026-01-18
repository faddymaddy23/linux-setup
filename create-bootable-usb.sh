# Identify Your USB Drive
lsblk
# or
sudo fdisk -l

# Unmount the USB (if mounted) - Replace sdb with your drive name
sudo umount /dev/sdb*

# Delete All Partitions on USB
sudo wipefs -a /dev/sdb

# Optional: Secure wipe (takes longer)
sudo dd if=/dev/zero of=/dev/sdb bs=4M status=progress

# Write ParrotOS ISO to USB
cd ~/Downloads
sudo dd if=Your_File_name.iso of=/dev/sdb bs=4M status=progress conv=fsync
sync
sudo eject /dev/sdb
