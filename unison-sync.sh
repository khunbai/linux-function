# Function: unison-sync
# Purpose: Safely sync two LUKS-mounted volumes using Unison
# Usage: Call `unison-sync` after mounting LUKS devices
unison-sync() {
    # Mount points
    local MNT1="/mnt/01-120GB-ext4"
    local MNT2="/mnt/02-120GB-ext4"

    # Check if both mount points are active
    if mountpoint -q "$MNT1" && mountpoint -q "$MNT2"; then
        echo "Both volumes mounted. Running Unison sync..."
        unison luks-sync
    else
        echo "Error: One or both LUKS volumes are not mounted. Aborting sync."
        echo "Please run 'mnt-usb' to mount the encrypted USBs first."
        return 1
    fi
}