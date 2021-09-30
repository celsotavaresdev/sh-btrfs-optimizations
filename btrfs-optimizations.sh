#!/bin/bash

# BTRFS Filesystem Optimizations (SSD or NVME)
# Based on Willi Mutschler guide: https://mutschler.eu/linux/install-guides/fedora-post-install/#btrfs-filesystem-optimizations

declare -A DISK_ATTRIBUTES+=( 
    ["commit"]=120
    ["compress"]=zstd:1
    ["discard"]=async
    ["x-systemd.device-timeout"]=0
    ["noatime"]=
    ["space_cache"]=
    ["ssd"]=
)
# ---------------------------------------------------------------------
for key in ${!DISK_ATTRIBUTES[@]}
do
    string_disk_attributes+=,${key}
    [ ! -z ${DISK_ATTRIBUTES[${key}]} ] && string_disk_attributes+="=${DISK_ATTRIBUTES[${key}]}"
done

sudo sed -r -i "s/^(UUID.*btrfs.*subvol=[[:alnum:]@]+).+([ ][0-9][ ][0-9])$/\1${string_disk_attributes}\2/" /etc/fstab
sudo systemctl enable fstrim.timer
