# mnt-usb: Automates the process of unlocking and mounting two specific LUKS-encrypted USB drives.
# It prompts for the passphrase once, checks for the device UUIDs, opens the LUKS containers,
# ensures mount points exist, and performs the mount operation.
mnt-usb() {
    # LUKS UUIDs
    local UUID1="14abf108-deae-4c15-a526-538a9aaef18a"
    local UUID2="ba803164-7da1-40cb-a344-3e95cb7091c1"

    # Mapper names
    local MAP1="sda_crypt"
    local MAP2="sdb_crypt"

    # Mount points
    local MNT1="/mnt/01-120GB-ext4"
    local MNT2="/mnt/02-120GB-ext4"

    # Ask for passphrase only once
    echo -n "Enter LUKS passphrase: "
    read -s PASS
    echo

    # Internal helper function
    _open_and_mount() {
        local UUID="$1"
        local MAP="$2"
        local MNT="$3"

        local DEV="/dev/disk/by-uuid/$UUID"

        # Check if the device exists
        if [ ! -e "$DEV" ]; then
            echo "WARNING: Device with UUID $UUID not found. Skipping."
            return 1
        fi

        # Resolve the symlink to actual device
        DEV=$(readlink -f "$DEV")
        echo "Device found: $DEV"

        # Open LUKS if not already open
        if [ ! -e "/dev/mapper/$MAP" ]; then
            # use printf instead of echo there as does not add a newline like echo.
            printf "%s" "$PASS" | sudo cryptsetup open "$DEV" "$MAP" --key-file -
        else
            echo "$MAP already open."
        fi

        # Ensure mount point exists
        if [ ! -d "$MNT" ]; then
            sudo mkdir -p "$MNT"
        fi

        # Mount if not already mounted
        if [ -e "/dev/mapper/$MAP" ]; then
            if ! mountpoint -q "$MNT"; then
                sudo mount "/dev/mapper/$MAP" "$MNT"
                echo "$MNT mounted."
            else
                echo "$MNT already mounted."
            fi
        else
            echo "Skipping mount for $MAP because LUKS open failed."
        fi
    }

    _open_and_mount "$UUID1" "$MAP1" "$MNT1"
    _open_and_mount "$UUID2" "$MAP2" "$MNT2"

    echo "End mount LUKS usb function."
}


# umnt-usb: Safely unmounts and closes the two specific LUKS-encrypted USB drives.
# It first unmounts the file systems and then closes the LUKS containers using cryptsetup.
umnt-usb() {
    # Mapper names
    local MAP1="sda_crypt"
    local MAP2="sdb_crypt"

    # Mount points
    local MNT1="/mnt/01-120GB-ext4"
    local MNT2="/mnt/02-120GB-ext4"

    _umount_and_close() {
        local MAP="$1"
        local MNT="$2"

        # Unmount if mounted
        if mountpoint -q "$MNT"; then
            echo "Unmounting $MNT..."
            sudo umount "$MNT"
        else
            echo "$MNT not mounted."
        fi

        # Close LUKS if open
        if [ -e "/dev/mapper/$MAP" ]; then
            echo "Closing $MAP..."
            sudo cryptsetup close "$MAP"
        else
            echo "$MAP is not open."
        fi
    }

    _umount_and_close "$MAP1" "$MNT1"
    _umount_and_close "$MAP2" "$MNT2"

    echo "All encrypted USB disks unmounted and closed."
}