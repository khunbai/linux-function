# Configuration: change these variables to customize the mount
# Example: edit MOUNT_POINT to change where the export is mounted.
NFS_SERVER="100.107.51.20"
NFS_EXPORT="/home/khunbai/6-mnt/acasis_ext4"
MOUNT_POINT="/mnt/acasis"
NFS_OPTIONS="rw,async,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev"

nfs-mount() {
    sudo mount -t nfs4 \
        -o "$NFS_OPTIONS" \
        "$NFS_SERVER:$NFS_EXPORT" \
        "$MOUNT_POINT"
}

nfs-umount() {
    sudo umount "$MOUNT_POINT"
}
