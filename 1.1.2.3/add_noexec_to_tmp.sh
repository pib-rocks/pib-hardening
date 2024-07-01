# Copyright (c) 2023 FB Pro GmbH
# All rights reserved.

#!/bin/bash

# Define the fstab file location
FSTAB_FILE="/etc/fstab"

# Check if /etc/fstab exists
if [[ ! -f "$FSTAB_FILE" ]]; then
    echo "Error: $FSTAB_FILE does not exist."
    exit 1
fi

# Make a backup of fstab before modifying
cp "$FSTAB_FILE" "${FSTAB_FILE}.bak"

# Use awk to process the file
awk -v OFS='\t' '
    # Search for lines that contain "/tmp" and not commented out
    $2 == "/tmp" && !/^#/ {
        # Split the fourth column by comma to get the options
        split($4, opts, ",")
        found = 0
        # Check if "noexec" is among the options
        for (i in opts) {
            if (opts[i] == "noexec") {
                found = 1
                break
            }
        }
        # If "noexec" was not found, add it
        if (!found) {
            $4 = $4 ",noexec"
            print "#noexec added for /tmp in fstab by hardening."
        }
    }
    { print }
' "$FSTAB_FILE" > /tmp/fstab.new

# Check if changes were made and move the new file into place
if cmp -s "$FSTAB_FILE" /tmp/fstab.new; then
    echo "No changes needed for /tmp in fstab."
    rm /tmp/fstab.new
else
    mv /tmp/fstab.new "$FSTAB_FILE"
    echo "Updated fstab with noexec for /tmp."
fi
