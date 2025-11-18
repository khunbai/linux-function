#!/bin/bash

################################################################################
# NFS Speed Test Script
#
# USAGE:
#   1. Make the script executable:
#        chmod +x nfs-speedtest.sh
#
#   2. Run the script and call the function:
#        ./nfs-speedtest.sh /path/to/mountpoint
#
#   3. Optionally specify file size (in MB):
#        ./nfs-speedtest.sh /path/to/mountpoint 500
#
#   EXAMPLES:
#        ./nfs-speedtest.sh /mnt/nfs
#        ./nfs-speedtest.sh /mnt/nfs 200
#
# NOTES:
#   - The script writes a temporary file "testfile.dd" to the mount point.
#   - The file is deleted after the test.
#   - Default test size is 100MB unless specified.
################################################################################

nfs-speedtest() {
    mountpoint="$1"
    testfile="$mountpoint/testfile.dd"
    size_mb="${2:-100}"   # default 100 MB

    echo "=== NFS Speed Test on $mountpoint ==="
    echo "File size: $size_mb MB"
    echo

    # --- Write Test ---
    echo "Running WRITE test..."
    write_output=$(dd if=/dev/zero of="$testfile" bs=1M count="$size_mb" oflag=direct 2>&1)
    write_speed=$(echo "$write_output" | grep -oP '\d+(\.\d+)?\s+MB\/s')

    # --- Read Test ---
    echo "Running READ test..."
    read_output=$(dd if="$testfile" of=/dev/null bs=1M iflag=direct 2>&1)
    read_speed=$(echo "$read_output" | grep -oP '\d+(\.\d+)?\s+MB\/s')

    # Cleanup
    rm -f "$testfile"

    echo
    echo "=== RESULT SUMMARY ==="
    echo "Write Speed : ${write_speed:-ERROR}"
    echo "Read  Speed : ${read_speed:-ERROR}"
    echo
    echo "=== Conclusion ==="

    write_value=$(echo "$write_speed" | awk '{print $1}')
    read_value=$(echo "$read_speed" | awk '{print $1}')

    echo "- Write speed is considered: $( [[ $write_value > 50 ]] && echo FAST || echo SLOW )"
    echo "- Read speed is considered : $( [[ $read_value > 50 ]] && echo FAST || echo SLOW )"
    echo
}

