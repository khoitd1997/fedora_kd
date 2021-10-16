#!/bin/bash

root_mount_dir="/tmp/btrfs_root_mount"

snapshots_dir="${root_mount_dir}/snapshots"
rootfs_snapshot="${snapshots_dir}/root"
home_snapshot="${snapshots_dir}/home"

function btrfs_mount_root_subvolume {
    btrfs_get_partition
    mkdir -p ${root_mount_dir}
    sudo mount -t btrfs ${btrfs_partition} ${root_mount_dir}
}

function brtfs_create_snapshot_subvolume {
    btrfs_mount_root_subvolume

    if [ -d ${snapshots_dir} ]; then
        echo "snapshot volume already created"
        return
    else
        btrfs subvolume create ${snapshots_dir}
    fi
}

function btrfs_get_partition {
    export btrfs_partition=$(mount -l | grep "on /home type btrfs" |  awk '{ print $1 }')
}

function btrfs_create_back_up {
    btrfs subvolume delete ${rootfs_snapshot} || true
    btrfs subvolume delete ${home_snapshot} || true
    # local timestamp=$(date "+%Y_%m_%d-%H_%M_%S")
    btrfs subvolume snapshot -r / ${rootfs_snapshot}
    btrfs subvolume snapshot -r /home ${home_snapshot}
}

function btrfs_mount_snapshot_subvolume {
    btrfs_get_partition
    mkdir -p ${snapshots_dir}
    sudo mount -t btrfs -o subvol=snapshots ${btrfs_partition} ${snapshots_dir}
}

# TODO: Make this safer
function btrfs_cleanup {
    umount ${root_mount_dir}
    umount ${snapshots_dir}
    rm -rf ${root_mount_dir}
}
