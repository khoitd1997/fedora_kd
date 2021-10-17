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
    btrfs_partition_search="/home"
    # the server stores the snapshot at a different location
    if [ $(hostname) = "kd-server" ]; then
        btrfs_partition_search="/bulk-storage"
    fi
    export btrfs_partition=$(mount -l | grep "on ${btrfs_partition_search} type btrfs" |  awk '{ print $1 }')
}

function btrfs_get_partition_disk_uuid {
    btrfs_get_partition
    export btrfs_partition_uuid=$(ls -l /dev/disk/by-uuid | grep "${btrfs_partition}" | awk '{ print $9 }')
}

function btrfs_create_back_up {
    new_rootfs="${rootfs_snapshot}-new"
    new_home="${home_snapshot}-new"
    btrfs subvolume snapshot -r / ${new_rootfs}
    btrfs subvolume snapshot -r /home ${new_home}

    if [ -d ${rootfs_snapshot} ]; then
        btrfs subvolume delete ${rootfs_snapshot}
        btrfs subvolume delete ${home_snapshot}
    fi

    mv ${new_rootfs} ${rootfs_snapshot}
    mv ${new_home} ${home_snapshot}

    sync

    # local timestamp=$(date "+%Y_%m_%d-%H_%M_%S")
}

function btrfs_mount_snapshot_subvolume {
    btrfs_get_partition
    mkdir -p ${snapshots_dir}
    sudo mount -t btrfs -o subvol=snapshots ${btrfs_partition} ${snapshots_dir}
}

# TODO: Make this safer
function btrfs_cleanup {
    umount ${root_mount_dir} || true
    umount ${snapshots_dir} || true
}
